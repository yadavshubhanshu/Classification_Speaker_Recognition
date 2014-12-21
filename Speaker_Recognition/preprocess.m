function [x,fs] = preprocess(wavfilename)
	[x,fs] = wavread(wavfilename);
	if (size(x, 2)==2)
		x = mean(x')';
	end

end