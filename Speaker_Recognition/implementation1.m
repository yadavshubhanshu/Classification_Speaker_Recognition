
%run create_vectors.m
%[ alpha,mu1,mu2,sigma1,sigma2 ] = gaussian_classification( X,Y );
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
    %[silence_removed, fs] = remove_silence(filepath);
    [x,fs] = preprocess(filepath);
    feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
	[y_inta,y_probab] = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
	[timestamp,y_int] = movingaverage(y_probab,fs,x);
	fName = 'ubc_mfcc_delta_rasta_nosilence_speech.dat';
	fid = fopen(['results/speech/',file.name,'.dat'],'a');
	if fid ~= -1
  		fprintf(fid,'%s\r\n',file.name);       
  		fclose(fid);                     
	end
	dlmwrite(['results/speech/',file.name,'.dat'], timestamp,'-append');
	
	cl1 = find(y_int==1);
	cl2 = find(y_int==2);
	
	music_fraction = length(cl1)/length(y_int);
	speech_fraction = length(cl2)/length(y_int);
	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
fid = fopen(['results/speech/','percentage','.dat'],'a');
if fid ~= -1
  	fprintf(fid,'%s\r\n','Music percentage,Speech percentage');       
  	fclose(fid);                     
end
dlmwrite(['results/speech/','percentage','.dat'], result,'-append');


disp('Testing Music files with no vocals');
speechfilepath = 'Speaker_Recognition/music-speech/wavfile/test/music/novocals/';
filelist = dir('Speaker_Recognition/music-speech/wavfile/test/music/novocals/*.wav');
result = zeros(length(filelist),2);
for fileIndex = 1:length(filelist)
	file = filelist(fileIndex);
	filepath = fullfile(speechfilepath,file.name);
    fprintf('Processing %s\n', filepath);
    %[silence_removed, fs] = remove_silence(filepath);
    [x,fs] = preprocess(filepath);
    feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
	[y_inta,y_probab] = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
	[timestamp,y_int] = movingaverage(y_probab,fs,x);
	fName = 'ubc_mfcc_delta_rasta_nosilence_music_novocals.dat';
	fid = fopen(['results/music_novocals/',file.name,'.dat'],'a');
	if fid ~= -1
  		fprintf(fid,'%s\r\n',file.name);       
  		fclose(fid);                     
	end
	dlmwrite(['results/music_novocals/',file.name,'.dat'], timestamp,'-append');
	
	cl1 = find(y_int==1);
	cl2 = find(y_int==2);
	
	music_fraction = length(cl1)/length(y_int);
	speech_fraction = length(cl2)/length(y_int);
	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
fid = fopen(['results/music_novocals/','percentage','.dat'],'a');
if fid ~= -1
  	fprintf(fid,'%s\r\n','Music percentage,Speech percentage');       
  	fclose(fid);                     
end
dlmwrite(['results/music_novocals/','percentage','.dat'], result,'-append');

disp('Testing Music files with vocals');
speechfilepath = 'Speaker_Recognition/music-speech/wavfile/test/music/vocals/';
filelist = dir('Speaker_Recognition/music-speech/wavfile/test/music/vocals/*.wav');
result = zeros(length(filelist),2);
for fileIndex = 1:length(filelist)
	file = filelist(fileIndex);
	filepath = fullfile(speechfilepath,file.name);
    fprintf('Processing %s\n', filepath);
    %[silence_removed, fs] = remove_silence(filepath);
    [x,fs] = preprocess(filepath);
    feature_vector = generate_features(x,fs,'mfcc','delta','rasta');
	[y_inta,y_probab] = predict(feature_vector,music_model.mu,speech_model.mu,music_model.sigma,speech_model.sigma);
	[timestamp,y_int] = movingaverage(y_probab,fs,x);
	fName = 'ubc_mfcc_delta_rasta_nosilence_music_vocals.dat';
	fid = fopen(fName,'a');
	if fid ~= -1
  		fprintf(fid,'%s\r\n',file.name);       
  		fclose(fid);                     
	end
	dlmwrite(fName, timestamp,'-append');
	
	cl1 = find(y_int==1);
	cl2 = find(y_int==2);
	
	music_fraction = length(cl1)/length(y_int);
	speech_fraction = length(cl2)/length(y_int);
	result(fileIndex,1) = music_fraction*100;
	result(fileIndex,2) = speech_fraction*100;
	fprintf('Music percentage is %f\n',music_fraction*100);
	fprintf('Speech percentage is %f\n',speech_fraction*100);
end
fid = fopen(['results/music_vocals/','percentage','.dat'],'a');
if fid ~= -1
  	fprintf(fid,'%s\r\n','Music percentage,Speech percentage');       
  	fclose(fid);                     
end
dlmwrite(['results/music_vocals/','percentage','.dat'], result,'-append');