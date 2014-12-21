function [mu,sigma,w] = generateubc(varargin)
	X=[];
	disp('Creating Universal Background Model');
	musicfilepath = 'Speaker_Recognition/music-speech/wavfile/train/';
	fileList = getAllFiles(musicfilepath);

	for fileIndex = 1:length(fileList)
		file = fileList{fileIndex};
    	fprintf('Processing %s\n', file);
    	%[silence_removed, fs] = remove_silence(file);
		[x,fs] = preprocess(file);
		feature_vector = generate_features(x,fs,varargin{:});
		X = vertcat(X,feature_vector);
	end

	[mu,sigma,w] = gaussmix(X,[],[],1,'vhp');
	save('ubm.mat','mu','sigma','w');

end

