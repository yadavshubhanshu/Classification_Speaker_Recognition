function segments = bic(x,fs,mfc,nC)

	d = (32768*x);
	Y = mfc;
	start = 1;
	% Set initial parameters
	a=start; % window D start
	b=start + 400 -1; % window D end
	min_window = 200; %minimum window size of D1, D2 in frames
	inc = 100; % window increment in frames
	max_window = 800; % max window size of D (8 sec)
	changes = []; %save change points
	% If original BIC method used
	%deltaK = nC+nC*(nC+1)/2; %for full cov-matrices
	%lambda = 1.4;
	%array containing likelihoods of window D1
	y1 = zeros(1,length(Y));
	%array containing all BIC values used for automatic threshold
	all_delta = zeros(1,length(Y));
	while b < length(Y(1,:)) % while b < number of frames in Y
		disp('b');
		disp(b);
		D = Y(:,a:b)'; % Window D
		% 2 mixture gaussian model remove v if diagonal cov matrix
		[m,v,w,g,f,pp,gg]=gaussmix(D,[],[],2,'hfv');
		y =sum(pp); % log likelihood
		% initializing arrays
		deltaL = zeros(1,b-a-2*min_window + 2); %BIC values
		times = zeros(1,b-a-2*min_window + 2); %time points
		counter = 0;
		% all t in window D that assures a minimum length of D1 and D2
		for t=(a+min_window-1):(b-min_window)
		counter = counter + 1; %count bic measures
		% left window. Calculate if not exists
		if y1(t) == 0
		D1 = Y(:,a:t)';
		mu1 = mean(D1,1); % mean
		sigma1 = cov(D1,1);% full covariance matrix
		% Calculate log likelihoods
		tmp = 0;
		invers1 = inv(sigma1);
		for i=1:size(D1,1)
			tmp = tmp +(D1(i,:)-mu1)*invers1*(D1(i,:)-mu1)';
		end
		y1(t) = -0.5*(tmp + size(D1,1)*log(det(sigma1))+...
		size(D1,1)*nC*log(2*pi));% nC=dim of MFCCs
		end

		% right window. Calculate for each shift
		D2 = Y(:,(t+1):b)';
		mu2 = mean(D2,1);
		sigma2 = cov(D2,1);
		% Calculate log likelihoods
		y2 = 0;
		invers = inv(sigma2);
		for i=1:size(D2,1)
			y2 = y2 +(D2(i,:)-mu2)*invers*(D2(i,:)-mu2)';
		end
		y2 = -0.5*(y2 + size(D2,1)* log(det(sigma2))+ ...
		size(D2,1)*nC*log(2*pi));
		deltaL(counter) = y1(t) + y2 - y; % modified BIC measure
		all_delta(t) = y1(t) + y2 - y;
		times(counter) = t;
		end %for
		[v, i] = max(deltaL); %best candidate per window
		thresh = 0; %threshold
		if v <= thresh % if no change points
			b = b + inc; % increment the window length
		else
			t = times(i) % print proposed change points
			changes = [changes t]; %save change points
			a = t+1; % move window boudaries
			b= a + min_window*2 -1; % move window boudaries
		end
		if (b-a) > max_window % if window size exeeds maximum
			a = b-max_window;
		end
	end %while
	%print change points to file
	disp(changes);
	initial = 1
	segments = cell(length(changes),1);
	for i=1:length(changes)
		final = fs*(changes(i)/100);
		segments{i,1} = x(initial:final);
		%pause
		%wavplay(x(initial:final),fs)
		initial = final;
	end
	final = length(x);
	if (initial~=final)
		segments{length(changes)+1,1} = x(initial:final)
	end
