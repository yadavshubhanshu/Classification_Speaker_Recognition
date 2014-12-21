function cepsAll = extractMFCC(audiofile, f)
%EXTRACTMFCC    Extract Mel Frequency Cepstral Coefficients from a file
%   or an audio vector. This function extracts MFCCs using mfcc.m by
%   reading frames of audio data from the file or audio vector.
%
%   Severalconstants are declared and can be changed:
%       windowSize = 256 (audio samples per frame resulting in one MFCC
%       feature vector)
%       rangeRead = 4000 * windowSize (amount of audio samples read from
%       file at one time)
%
%   CEPS = EXTRACTMFCC(audiofile) for a wave audio file
%
%   CEPS = EXTRACTMFCC(audioVector, samplingFrequency) for an audio vector
%   If samplingFrequency is not passed, a warning is printed and a default
%   frequency of 48kHz is used.

error(nargchk(1,2,nargin));

start=1;
windowSize=256;
rangeRead=4000*windowSize;

if (~isnumeric(audiofile))
    [audio,f] = wavread(audiofile, [1 10]);
else
    if (nargin < 2)
        disp('Warning: When passing audio contents in a vector, sampling rate must be specified as second parameter');
        disp('         Using default value of 48000');
        f=48000;
    end
end

cont=1;
readCount = 0;

i = 0;

cepsAll=[];
while (cont == 1)
    if (isnumeric(audiofile))
        e = start + rangeRead;
        if (e > length(audiofile))
            e = length(audiofile);
            cont = 0;
        end
        disp(sprintf('%d - %d', start, e));
        audio = audiofile(start:e);
    else
        try
            audio = wavread(audiofile, [start (start + rangeRead)]);
            readCount = readCount + 1;
        catch
            remaining = wavread(audiofile, 'size');
            remaining = remaining(1) - (readCount * rangeRead) - 1;
            audio = wavread(audiofile, [start (start + remaining)]);
            cont = 0;
        end
        disp(sprintf('%d - %d', start, start + length(audio)));
    end
    start = start + rangeRead;
    cepsAll=[cepsAll, mfcc(audio(:,1), f, f/windowSize)];
    i = i + 1;
end
