
%run create_vectors.m
%save('model.mat');
music_model = adaptClass('music','mfcc','delta','rasta');
speech_model = adaptClass('speech','mfcc','delta','rasta');

disp('Testing Speech files');
speechfilepath = 'Speaker_Recognition/music-speech/wavfile/test/speech/';
filelist = dir('Speaker_Recognition/music-speech/wavfile/test/speech/*.wav');
result = zeros(length(filelist),2);
for fileIndex = 1:length(filelist)
	file = filelist(fileIndex);
	filepath = fullfile(speechfilepath,file.name);
    fprintf('Processing %s\n', filepath);
    [x, fs] = preprocess(filepath);
    %do bic - generate segments
    %for each segment - do the below
	mfc = generate_mfcc(x,fs);
	segments = bic(x,fs,mfc',13);
	music = 0;
	speech = 0
	for i=1:length(segments)
		x = segments{i};
		feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
		y_int = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
		cl1 = find(y_int==1);
		cl2 = find(y_int==2);
		if (length(cl1)>length(cl2))
			music = music+1;
		else
			speech = speech+1;
		end
	end
	music_fraction = music/(music+speech);
	speech_fraction = speech/(music+speech);	
	%music_fraction = length(cl1)/length(y_int);
	%speech_fraction = length(cl2)/length(y_int);
	%till here

	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
dlmwrite('results/bic/speech.dat', result);


disp('Testing Music files with no vocals');
speechfilepath = 'Speaker_Recognition/music-speech/wavfile/test/music/novocals/';
filelist = dir('Speaker_Recognition/music-speech/wavfile/test/music/novocals/*.wav');
result = zeros(length(filelist),2);
for fileIndex = 1:length(filelist)
	file = filelist(fileIndex);
	filepath = fullfile(speechfilepath,file.name);
    fprintf('Processing %s\n', filepath);
    [x, fs] = preprocess(filepath);
    %do bic - generate segments
    %for each segment - do the below
	mfc = generate_mfcc(x,fs);
	segments = bic(x,fs,mfc',13);
	music = 0;
	speech = 0
	for i=1:length(segments)
		x = segments{i};
		feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
		y_int = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
		cl1 = find(y_int==1);
		cl2 = find(y_int==2);
		if (length(cl1)>length(cl2))
			music = music+1;
		else
			speech = speech+1;
		end
	end
	music_fraction = music/(music+speech);
	speech_fraction = speech/(music+speech);	
	%music_fraction = length(cl1)/length(y_int);
	%speech_fraction = length(cl2)/length(y_int);
	%till here

	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
dlmwrite('results/bic/music_novocals.dat', result);


disp('Testing Music files with vocals');
speechfilepath = 'Speaker_Recognition/music-speech/wavfile/test/music/vocals/';
filelist = dir('Speaker_Recognition/music-speech/wavfile/test/music/vocals/*.wav');
result = zeros(length(filelist),2);
for fileIndex = 1:length(filelist)
	file = filelist(fileIndex);
	filepath = fullfile(speechfilepath,file.name);
    fprintf('Processing %s\n', filepath);
    [x, fs] = preprocess(filepath);
    %do bic - generate segments
    %for each segment - do the below
	mfc = generate_mfcc(x,fs);
	segments = bic(x,fs,mfc',13);
	music = 0;
	speech = 0
	for i=1:length(segments)
		x = segments{i};
		feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
		y_int = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
		cl1 = find(y_int==1);
		cl2 = find(y_int==2);
		if (length(cl1)>length(cl2))
			music = music+1;
		else
			speech = speech+1;
		end
	end
	music_fraction = music/(music+speech);
	speech_fraction = speech/(music+speech);	
	%music_fraction = length(cl1)/length(y_int);
	%speech_fraction = length(cl2)/length(y_int);
	%till here

	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
dlmwrite('results/bic/music_vocals.dat', result);