

clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\10\R data\co2.txt');
txt=TXT.data;
TXT=[];
for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end

C=60;%��ǰԤ����ٸ�������
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;

for jia=1:C
    
X=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X;Xt];



q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��

mm=size(TXT(1:(h0+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);


z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %д�úܰ�����

Q=Xtt(1:qq)';
H=X(s+qq:end);
% for j=1:size(S,1)
%     temp=mean(S(j,:));
%     S(j,:)=S(j,:)-temp;
%     H(j)=H(j)-temp;
% end
% Xs=Q;
% Q=Q-mean(Xs);


mediann=median(H); %��ȡ����ά����λֵ
mn=size(H,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=H(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
% cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(z,1);%��ű����ڶ�����������
cjy=zeros(z,1);%����������
cjy1=NHDTWnew1219(S,Q);
for f=1:z
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(H(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
%     if (cjy1(f)==0||cjy2(f)==0)
%         cjy(f)=(1/2)*(exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f)));
%     else
%         namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
%         cjy(f)=(1/2)*(exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f)));
%     end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end

%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

%tunel ����
[gam,sig2] = tunelssvm({S,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%train
% [alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
% prediction(jia) = predict({S,H,'f',gam,sig2,'RBF_kernel'},Q,1);
prediction(jia) = predictknn({S,H,'f',gam,sig2,'RBF_kernel'},Q,cjy,1);
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);
% prediction(jia) =prediction(jia) +mean(Xs);

% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');

ylabel('Values of co2 database');
title('DTW:mae= ,rmse= ');

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