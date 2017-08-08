X = linspace(-1,1,50)';
Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
X
Y
type = 'function estimation';% ��������
[gam,sig2] = tunelssvm({X,Y,type,[],[],'lin_kernel'},'simplex',...
'leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});

[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel','original'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});
% or can be switched on (by default):
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'});
plotlssvm({X,Y,type,gam,sig2,'lin_kernel'},{alpha,b});

Xt = rand(10,1).*sign(randn(10,1));
% simulated on the test data
Yt = simlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'},{alpha,b},Xt);
plotlssvm({X,Y,type,gam,sig2,'lin_kernel','preprocess'},{alpha,b});



type = 'function estimation';
Yp = lssvm(X,Y,type);


%��Ҷ˹�ƶϻع顣�������Һ���������
type = 'function approximation';
X = linspace(-2.2,2.2,250)';
Y = sinc(X) +normrnd(0,.1,size(X,1),1);
[Yp,alpha,b,gam,sig2] = lssvm(X,Y,type);

% using Bayesian inference�����������errorbars
sig2e = bay_errorbar({X,Y,type, gam, sig2},'figure');

%˵���Զ������ȷ���Ĺ���
X = normrnd(0,2,100,3);
Y = sinc(X(:,1)) + 0.05.*X(:,2) +normrnd(0,.1,size(X,1),1);

  % inputs = bay_lssvmARD({X,Y,type, 10,3});
  % [alpha,b] = trainlssvm({X(:,inputs),Y,type, 10,1});

% Using the object oriented model interfaceʹ����������ģ�ͽӿ�
type = 'function approximation';
X = normrnd(0,2,100,1);
Y = sinc(X) +normrnd(0,.1,size(X,1),1);
kernel = 'RBF_kernel';
gam = 10;
sig2 = 0.2;
model = initlssvm(X,Y,type,gam,sig2,kernel);
model
model = trainlssvm(model);
Xt = normrnd(0,2,150,1);
Yt = simlssvm(model,Xt);
plotlssvm(model);
%��Ҷ˹�������ĵڶ����ɱ������Ż��������򻯲���GAM���������¶���20��������������Nystrom��������Ϊ��
% model = bay_optimize(model,2,'eign', 50);
% model = bay_initlssvm(model);
% model = bay_optimize(model,3,'eign',50);

%�ع�����š�Ԥ������
% Confidence/Predition Intervals for Regression  Load data set X and Y
model = initlssvm(X,Y,'f',[],[], 'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'mse'});
% ci = cilssvm(model,alpha,'pointwise');%ƫ������������100��1-alpha��%

%������������
% ci = cilssvm(model,alpha,'imultaneous');
% pi = predlssvm(model,Xt,alpha,'pointwise');
% pi = predlssvm(model,Xt,alpha,'simultaneous');

X = linspace(-5,5,200)';
Y = sin(X)+sqrt(0.05*X.^2+0.01).*randn(200,1);
model = initlssvm(X,Y,'f',[],[], 'RBF_kernel');
model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'mae'});
Xt = linspace(-4.5,4.7,200)';




% % the Boston Housing data set ��ʿ�ٷ������ݼ�  338ѵ������  168�������ݵ�
% % load full data set X and Y
% sel = randperm(506);
% % Construct test data
% Xt = X(sel(1:168),:);
% Yt = Y(sel(1:168));
% % training data
% X = X(sel(169:end),:);
% Y = Y(sel(169:end));
% model = initlssvm(X,Y,'f',[],[],'RBF_kernel');
% model = tunelssvm(model,'simplex','crossvalidatelssvm',{10,'mse'});
% model = trainlssvm(model);
% Yhci = simlssvm(model,X);
% Yhpi = simlssvm(model,Xt);
% [Yhci,indci] = sort(Yhci,'descend');
% [Yhpi,indpi] = sort(Yhpi,'descend');
% % Simultaneous confidence intervals
% ci = cilssvm(model,0.05,'simultaneous'); ci = ci(indci,:);
% plot(Yhci); hold all, plot(ci(:,1),'g.'); plot(ci(:,2),'g.');
% % Simultaneous prediction intervals
% pi = predlssvm(model,Xt,0.05,'simultaneous'); pi = pi(indpi,:);
% plot(Yhpi); hold all, plot(pi(:,1),'g.'); plot(pi(:,2),'g.');




% Robust regression�Ƚ��ع�   ����15%�쳣ֵ���ɵ����ݼ�
X = (-5:.07:5)';
epsilon = 0.15;
sel = rand(length(X),1)>epsilon;
Y = sinc(X)+sel.*normrnd(0,.1,length(X),1)+(1-sel).*normrnd(0,2,length(X),1);
model = initlssvm(X,Y,'f',[],[],'RBF_kernel');%���ȵ���ʧ����ΪL1��mae��
L_fold = 10; %10 fold CV
model = tunelssvm(model,'simplex',...
'rcrossvalidatelssvm',{L_fold,'mae'},'whuber');
model = robustlssvm(model);
plotlssvm(model);

%�˴�����Ⱦ�ֲ�Ϊһ��������׼�����ֲ���q=0.3
X = (-5:.07:5)';
epsilon = 0.3;
sel = rand(length(X),1)>epsilon;
Y = sinc(X)+sel.*normrnd(0,.1,length(X),1)+(1-sel).*trnd(1,length(X),1).^3;
% The two parameters of the Hampel weight function are set to b1 = 2.5 and b2 = 3.
model = initlssvm(X,Y,'f',[],[],'RBF_kernel');
L_fold = 10; %10 fold CV
model = tunelssvm(model,'simplex',...
'rcrossvalidatelssvm',{L_fold,'mae'},'wmyriad');
model = robustlssvm(model);
plotlssvm(model);



% Multiple output regression
% load data in X, Xt and Y
% where size Y is N x 3
gam = 1;
sig2 = 1;
[alpha,b] = trainlssvm({X,Y,'classification',gam,sig2});
Yhs = simlssvm({X,Y,'classification',gam,sig2},{alpha,b},Xt);
%ʹ��ÿ������ߴ粻ͬ���ں˲���
gam = 1;
sigs = [1 2 1.5];
[alpha,b] = trainlssvm({X,Y,'classification',gam,sigs});
Yhs = simlssvm({X,Y,'classification',gam,sigs},{alpha,b},Xt);

% % tune the different parameters����ÿ������ߴ���ʵ��
% [gam,sigs] = tunelssvm({X,Y,'classification',[],[],'RBF_kernel'},'simplex',...
% 'crossvalidatelssvm',{10,'mse'});





% A time-series example: Santa Fe laser data prediction
% load time-series in X and Xt
lag = 50;
Xu = windowize(X,1:lag+1);
Xtra = Xu(1:end-lag,1:lag); %training set
Ytra = Xu(1:end-lag,end); %training set
Xs=X(end-lag+1:end,1); %starting point for iterative prediction

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,100);
plot([prediction Xt]);



% X,Y contains the dataset, svX is a subset of X
sig2 = 1;
features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
[W,b] = ridgeregress(features, Y, gam_optimal);
Yh = features*W+b;

%�������֧��������Ŀ
caps = [10 20 50 100 200]
sig2s = [.1 .2 .5 1 2 4 10]
nb = 10;
for i=1:length(caps),
for j=1:length(sig2s),
for t = 1:nb,
sel = randperm(size(X,1));
svX = X(sel(1:caps(i)));
features = AFEm(svX,'RBF_kernel',sig2s(j), X);
[Cl3, gam_opt] = bay_rr(features,Y,1,3);
[W,b] = ridgeregress(features, Y, gam_opt);
Yh = features*W+b;
performances(t) = mse(Y - Yh);
end
minimal_performances(i,j) = mean(performances);
end
end

[minp,ic] = min(minimal_performances,[],1);
[minminp,is] = min(minp);
capacity = caps(ic);
sig2 = sig2s(is);

% load data X and Y, ��capacity�� and the kernel parameter ��sig2��
sv = 1:capacity;
max_c = -inf;
for i=1:size(X,1),
replace = ceil(rand.*capacity);
subset = [sv([1:replace-1 replace+1:end]) i];
crit = kentropy(X(subset,:),'RBF_kernel',sig2);
if max_c <= crit, max_c = crit; sv = subset; end
end

features = AFEm(svX,'RBF_kernel',sig2, X);
[Cl3, gam_optimal] = bay_rr(features,Y,1,3);
[W,b, Yh] = ridgeregress(features, Y, gam_opt);

%The same idea can be used for learning a classifier from a huge data set.
% load the input and output of the trasining data in X and Y
cap = 25;
% initialise a subset of cap points: Xs
for i = 1:1000,
Xs_old = Xs;
% substitute a point of Xs by a new one
crit = kentropy(Xs, kernel, kernel_par);
% if crit is not larger then in the previous loop,
% substitute Xs by the old Xs_old
end

% the Fisher discriminant is obtained:
features = AFEm(Xs,kernel, sigma2,X);
[w,b] = ridgeregress(features,Y,gamma);
% New data points can be simulated as follows:
features_t = AFEm(Xs,kernel, sigma2,Xt);
Yht = sign(features_t*w+b);

