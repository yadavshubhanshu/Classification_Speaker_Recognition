function features = generate_features(x,fs,varargin)
	mfc = [];
	aspec = [];
	deltafeatures = [];
	psdev = [];
	cep1 = [];
	sep1 = [];
	apd = [];
	features = [];

	if strmatch('mfcc',varargin)
		[mfc,aspec] = generate_mfcc(x,fs);
		features = [features,mfc];
	end
	if strmatch('delta',varargin)
		if isempty(mfc)
			[mfc,aspec] = generate_mfcc(x,fs);
		end
		deltafeatures = generate_delta_features(mfc);
		features = [features,deltafeatures];
	end
	if strmatch('apd',varargin)
		if isempty(mfc)
			[mfc,aspec] = generate_mfcc(x,fs);
		end
		apd = average_pitch_density(mfc);
		features = [features,apd];
	end
	if strmatch('psdev',varargin)
		if isempty(aspec)
			[mfc,aspec] = generate_mfcc(x,fs);
		end
		psdev = power_spec_dev(aspec);
		features = [features,psdev];
	end
	if strmatch('rasta',varargin)
		[cep1, spec1] = rastaplp(x, fs);
		features = [features,cep1'];
	end

	%features = [mfc,deltafeatures,psdev,cep1'];