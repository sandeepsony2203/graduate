clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2017\4\10\Sin(pi=11)main.txt');

% plot(TXT);
% grid on;

prediction=zeros(8,1);
jia=1;
while(jia<9)
    
X=TXT(1:(108+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((108+jia):116);
XXt=[X;Xt];

q=10; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
k=60;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(108+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);


z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %д�úܰ�����

Ytra=X(s+qq:end);
Xs=X(end-q:end);

dd1=NHDTWnew0(Xtra,Xs');%NHEH0306

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
% d=3;

[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam = 10;
% sig2 = 0.2;

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SS,H,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(jia) = predict({SS,H,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

jia=jia+1;
end



plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(109:116),'-*r');
xlabel('time');
ylabel('Values of Sin function');
title('SVM: mae= ,rmse=');


Xt=TXT(109:116);

prediction=prediction(1:end);
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
