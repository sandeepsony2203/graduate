clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

% [TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');
% [TXT,T1]=mapminmax(TXT);
% TXT=TXT(1:end);

C=95;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(5605+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((5605+jia):5700);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=150;
q=9; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(5605+jia-1)),1);
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

% Q=Xt;

% ��һ�μ����Ͼ���
% dd0=NHDTWnew0(S,Q);
dd=zeros(z,1);
F1=zeros(z,qq);%�������1
F2=zeros(1,qq);%�������2

for i=1:z
     for jj=1:(qq-1)
        if qq-1==1
            F1=S(i,2)-S(i,1);
            F2=Q(2)-Q(1);
        else
%             F1(ii,jj)=S(ii,jj+1)-S(ii,1);
            F1(i,jj)=S(i,jj)-S(i,1);
            F2(jj)=Q(jj)-Q(1);

        end

    end
    dd(i)=Dtwdistance(F1(i,:),F2);
end

[dd,T1]=mapminmax(dd',0,1);
dd=dd';

%���ٽ�����

K=zeros(k,1);
[maxn maxi]=max(dd);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%��¼��Ӧ����
    dd(mini)=maxn;
    jjj=jjj+1;
    else
    dd(mini)=maxn;
    end   
%     jjj=jjj+1;
end
SS=zeros(k,qq);%����ڵ�k������
for iii=1:k
    SS(iii,:)=F1(K(iii),:);
end


H=zeros(1,k);
%���㻥��ϢMI�Ĵ�С
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s)-X(K(aa));
end


%ģ���Ƶ�������
%���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
%�ڶ��μ����Ͼ���
SSY=H';
mediann=median(SSY); %��ȡ����ά����λֵ
mn=size(SSY,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=SSY(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
% cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(k,1);%��ű����ڶ�����������
cjy=zeros(k,1);%����������
cjy1=NHDTWnew1219(SS,F2);
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(SSY(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
%     if (cjy1(f)==0||cjy2(f)==0)
%         cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     else
%         namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
%         cjy(f)=exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f));
%     end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

%tunel ����
[gam,sig2] = tunelssvm({SS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
% gam=2.4*10^7; poly_kernel lin_kernel RBF_kernel wav_kernel
% sig2=700;

%train
[alpha,b] = trainlssvmknn({SS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
% [alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
prediction(jia) = predict({SS,SSY,'f',gam,sig2,'RBF_kernel'},F2,1);
% prediction(jia) = predictknn({SS,SSY,'f',gam,sig2,'RBF_kernel'},F2,cjy,1);
prediction(jia)=prediction(jia)+Q(1); %TXT(5605+jia-qq);
% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(5606:5700),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(5606:5700);
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
