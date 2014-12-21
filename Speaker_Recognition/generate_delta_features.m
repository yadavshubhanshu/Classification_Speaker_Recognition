function deltafeatures = generate_delta_features(mfc)
	del = deltas(mfc);
	ddel = deltas(deltas(mfc));
	dce = sum(del.^2,2);%delta cepstral energy
	deltafeatures = [del,ddel,dce];