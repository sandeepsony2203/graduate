
clear all;
clc;

[TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');

C=76;
prediction=zeros(C,1);
h1=size(TXT,1);
h0=h1-C;
k=150;
zis=1;
while(zis<77)
q=11; %ʱ��
qq=q+1;
s=1; 
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

Ytra=X(s+qq:end);
Xs=XXt((h0-s-q+zis):(h0+zis-s))';
% d=3;
dd1=NHDTWnew1219(Xtra,Xs);% NHEH0306 CosineDistance    

%���ٽ�����
SS=zeros(k,qq);%����ڵ�k������
H=zeros(k,1);
K=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(size(X,1)-q-s)
    K(jjj)=mini;%��¼��Ӧ����
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=Xtra(K(iii),:);
    H(iii)=Ytra(K(iii));
end

[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

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

