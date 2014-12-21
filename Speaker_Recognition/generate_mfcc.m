function [mfc,aspectrum] = generate_mfcc(input_matrix,fs)

x = (32768*input_matrix);

%Parameters
ceplifter = -22;
cepcoeffs = 13;
bands = 26;

[mfc,aspectrum,pspectrum] = melfcc(x, fs, 'lifterexp', ceplifter, 'nbands', bands, ...
     'numcep', cepcoeffs, 'dcttype', 3, 'maxfreq',8000, 'fbtype', 'htkmel', 'sumpower', 1);
mfc = mfc';
aspectrum = aspectrum';