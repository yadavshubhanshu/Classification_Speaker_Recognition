function [ alpha,mu1,mu2,sigma1,sigma2 ] = gaussian_classification( X,Y )
  class1 = X(Y == 1,:);%music class
  class2 = X(Y == 0,:);%speech class
  [N,D] = size(X);
  N1 = size(class1,1);
  N2 = size(class2,1);
  alpha = N1/N;
  mu1 = sum(class1)/N1;
  mu2 = sum(class2)/N2;
  sigma1 = zeros(D);
  sigma2 = zeros(D);
  for i =1:N1
      sigma1 = sigma1 + ((class1(i,:) - mu1)'*(class1(i,:) - mu1));
  end
  sigma1 = sigma1/N1;
  for i = 1:N2
      sigma2 = sigma2 + ((class2(i,:) - mu2)'*(class2(i,:) - mu2));
  end
  sigma2 = sigma2/N2;

  sigma1 = sigma1+1e-5*eye(D);
  sigma2 = sigma2+1e-5*eye(D);
end