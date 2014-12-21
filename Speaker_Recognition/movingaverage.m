function [result,y_int] = movingaverage(y_probab,fs,x)
	result = [];
	xl = length(x);
	yl = length(y_probab);
	y_int = ones(length(y_probab),1);
	ll = xl/yl;
	i=5;
	samplestart=1;sampleend=5;
	tempstart = 1;tempend = 5;
	musicpoint = sum(y_probab(tempstart:tempend,1));
	speechpoint = sum(y_probab(tempstart:tempend,2));
	currentsample = 0;
	while i<length(y_probab)
		while (i<length(y_probab) & musicpoint>=speechpoint)
			musicpoint = sum(y_probab(tempstart:tempend,1));
			speechpoint = sum(y_probab(tempstart:tempend,2));
			sampleend = tempend;
			y_int(i) = 1;
			i=i+1;
			tempstart=tempstart+1;
			tempend = tempend+1;
		end
		if tempstart~=samplestart
			disp(musicpoint);
			disp(speechpoint);
			result = vertcat(result,[(samplestart-1)*ll/fs,(sampleend-samplestart)*ll/fs,1]);
			samplestart = sampleend;
		end
		while (i<length(y_probab) & speechpoint>=musicpoint)
			musicpoint = sum(y_probab(tempstart:tempend,1));
			speechpoint = sum(y_probab(tempstart:tempend,2));
			sampleend = tempend;
			y_int(i) = 2;
			i=i+1;
			tempstart=tempstart+1;
			tempend = tempend+1;
		end
		if tempstart~=samplestart
			disp(musicpoint);
			disp(speechpoint);
			result = vertcat(result,[(samplestart-1)*ll/fs,(sampleend-samplestart)*ll/fs,2]);
			samplestart = sampleend;
		end
	end
	if musicpoint>speechpoint
		y_int(samplestart:sampleend) = 1;
		result = vertcat(result,[(samplestart-1)*ll/fs,(sampleend-samplestart)*ll/fs,1]);
	else
		y_int(samplestart:sampleend) = 2;
		result = vertcat(result,[(samplestart-1)*ll/fs,(sampleend-samplestart)*ll/fs,2]);
	end
end