clear all;
clc;

txt= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\11\data\austres.txt');
TXT=[];

for i=1:size(txt,1)
    TXT=[TXT;txt(i,2:end)'];
end
[TXT,T1]=mapminmax(TXT',0,1);
TXT=TXT';

C=4;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(80+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((81+jia):84);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=10;
q=3; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(80+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mm-2*s-q+1;
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
dd1=NHs(S,Q);

%���ٽ�����
SS=zeros(k,qq);%����ڵ�k������
K=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%��¼��Ӧ����
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

%����2q+3��Z����&&������
Z=zeros(qq,k);

for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-1;
    Z(n,nn)=X(mnn);%��ʽ��7��
%     Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(k,1);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s);
end


%ģ���Ƶ�������
%���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
%�ڶ��μ����Ͼ���
mediann=median(H); %��ȡ����ά����λֵ
mn=size(H,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=H(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
% cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(k,1);%��ű����ڶ�����������
cjy=zeros(k,1);%����������
cjy1=NHs(SS,Q);
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(H(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+1*cjy2(f)));
end


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

%tunel ����
[gam,sig2] = tunelssvm({SS,H,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SS,H,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
% [alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
% prediction(jia) = predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
prediction(jia) = predictknn({SS,H,'f',gam,sig2,'RBF_kernel'},Q,cjy,1);

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
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
