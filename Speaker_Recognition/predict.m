function [y_int,y_probab] = predict(X,mu1,mu2,sigma1,sigma2)
%load('model.mat');
%distribution1 = mvnpdf(X,mu1,sigma1);%music class
%distribution2 = mvnpdf(X,mu2,sigma2);%speech class
[distribution1,rp,kh,kp]=gaussmixp(X,mu1,sigma1,1);
[distribution2,rp,kh,kp]=gaussmixp(X,mu2,sigma2,1);
prob1 = zeros(size(X,1),1);
prob2 = zeros(size(X,1),1);
y_int = ones(size(X,1),1);
y_probab = [];
for i =1:size(X,1)
    prob1(i) = (distribution1(i))/(distribution2(i)+(distribution1(i)));
    prob2(i) = (distribution2(i))/(distribution1(i)+(distribution2(i)));
    if prob2(i)>prob1(i)
        y_int(i) = 2;
    end
    y_probab = vertcat(y_probab,[prob1(i) prob2(i)]);
end

end
