

clear all;
clc;

TXT=importdata('C:\Documents and Settings\Administrator\����\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');


C=16;
prediction=zeros(C,1);
zis=1;
h1=size(TXT,1);
h0=h1-C;
while(zis<C+1)
q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��

X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+zis):h1);
XXt=[X;Xt];

mm=size(TXT(1:(h0+zis-1)),1);

z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Xmean=zeros(1,qq);
for i=1:qq
    Xmean(i)=mean(Xtra(:,i));
end
Ytra=X(s+qq:end);
Ymean=mean(Ytra);
for j=1:z
    Xtra(j,:)=Xtra(j,:)-Xmean;
    Ytra(j)=Ytra(j)-Ymean;
end

Xs=XXt((200-s-q+zis):(200+zis-s))'-Xmean;
% d=3;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
prediction(zis) =prediction(zis) +Ymean;
zis=zis+1;
end
% ticks=cumsum(ones(216,1));


plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-*r');
xlabel('time');
ylabel('Values of Sales database');
title('SVM(RBF_kernel) (Sales):mae=1.5741,rmse=1.7757,mape=3.5218');


Xt=TXT(h0+1:h1);

mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;

