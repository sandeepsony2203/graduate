
clear all;
clc;

% [NUMERIC,TX,RAW] = xlsread('data\KNN\flows.xlsx');
% TXT=NUMERIC;
% 

TXT1=[1:300]';

TXT=random('Normal',0,1,1,300)'*8;

TXT=TXT+TXT1;
prediction=zeros(30,1);
zis=1;
while(zis<31)
q=9; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:270+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((271+zis-1):300);
XXt=[X;Xt];

mm=size(TXT(1:(269+zis)),1);

z=mm-s-q+1;
Xtra=zeros(z,q);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:q
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Ytra=X(s+q:end);
Xs=XXt((271-s-q+zis+1):(271+zis-s));
% d=3;

% lag = 100;
% Xu = windowize(X,1:lag+1);
% Xtra = Xu(1:end-lag,1:lag); %training set
% Ytra = Xu(1:end-lag,end); %training set
% Xs=X(end-lag+1:end,1); %starting point for iterative prediction���Ԥ������?
% % Xt = rand(10,1).*sign(randn(10,1));

[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

zis=zis+1;
end
% ticks=cumsum(ones(216,1));


% plot(prediction(1:end));
% hold on;
% % plot(Xt((s+1):end),'r')
% plot(TXT(271:300),'r');
% xlabel('time');


ticks=cumsum(ones(300,1));
Xt=TXT(271:300);
ts=datenum('2011-01');
tf=datenum('2016-04');
t=linspace(ts,tf,300);
X=TXT(1:270);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt]);

datetick('x','yyyy','keepticks');
xlabel('time');
ylabel('value');
title('Monotone acyclic data');


Xt=TXT(271:300);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);

