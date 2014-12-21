function getapd = average_pitch_density(all_frames)
	getapd = [];
	N = length(all_frames);
	segment_length = 100;
	startindex = 1;
	endindex = 100;
	for i=1:N
		if endindex<=N
			frames = all_frames(startindex:endindex);
			getapd = [getapd,calculate_apd(frames)];
			startindex = endindex;
			endindex = endindex+segment_length;
		else
			frames = all_frames(startindex:end);
			getapd = [getapd,calculate_apd(frames)];
			break;
        end
    end



function apd = calculate_apd(frames)
	N = length(frames);
	pd = zeros(N,1);
	for i=1:N
		pd(i,1) = pitch_density(frames(i));
	end
	apd = sum(pd)/N;



function pd = pitch_density(frame)
	len_coeffs = length(frame);
	l = round(len_coeffs/2);
	abs_frame = abs(frame);
	pd = sum(abs_frame(l:len_coeffs))/(l+1);

