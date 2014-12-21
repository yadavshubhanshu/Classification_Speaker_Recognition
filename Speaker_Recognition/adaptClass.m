function gmm = adaptClass(adaptedclass,varargin)
	if strcmp(adaptedclass,'music')
		disp('Creating Adapted Model for music');
		filepath = 'Speaker_Recognition/music-speech/wavfile/train/music';
	elseif strcmp(adaptedclass,'speech')
		disp('Creating Adapted Model for speech');
		filepath = 'Speaker_Recognition/music-speech/wavfile/train/speech';
	end
	data = [];
	fileList = getAllFiles(filepath);
	for fileIndex = 1:length(fileList)
		file = fileList{fileIndex};
		fprintf('Processing %s\n', file);
		%[silence_removed, fs] = remove_silence(file);
		[x,fs] = preprocess(file);
		feature_vector = generate_features(x,fs,varargin{:});
		data = vertcat(data,feature_vector);
	end
	
	data = num2cell(data,2);

	if exist('ubm.mat', 'file')
		load('ubm.mat');
	else
		[mu,sigma,w] = generateubc(varargin{:});
	end

	%Create the ubm struct
	field1 = 'mu'; value1 = mu;
	field2 = 'sigma'; value2 = sigma;
	field3 = 'w'; value3 = w;
	ubm = struct(field1,value1,field2,value2,field3,value3);

	gmm = mapAdapt(data, ubm);

end