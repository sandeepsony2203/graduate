clear all;
clc;

% TXT= importdata('data\KNN\Load1997.txt');
[NUMERIC,TX,RAW] = xlsread('data\KNN\Temperature1997.xls');
[NUMERIC1,TX1,RAW1] = xlsread('data\KNN\Temperature1998.xls');
TXT=NUMERIC;
TXT1=NUMERIC1;
TXT=[TXT;TXT1];

[NUMERICY,TY,RAWY] = xlsread('data\KNN\Load1997.xls');
[NUMERICY1,TY1,RAWY1] = xlsread('data\KNN\Load1998.xls');
TYT=NUMERICY(2:366,4:51);
TYT1=NUMERICY1(2:366,4:51);
TYT=[TYT;TYT1];

q=35; %ʱ��
qq=q+1;

aa=size(TXT,1);
% aaa=aa-qq;
bb=size(TXT,2);
X=zeros(aa,1);
Y=zeros(aa,1);
for i=1:aa
    X(i)=TXT(i);
    Y(i)=max(TYT(i,:));%ȡÿһ������ֵ
end

Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q1(qq-i+1)=TXT(end-i+1);
Q2(qq-i+1)=max(TYT(end-i+1,:));
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';

% k=2*round((mm/2)^(1/2));
k=200;
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=aa;
mmm=1/2*aa;

z=mm-q;
S=zeros(z,2*qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ

for i=1:z
    for j=1:qq
    if h+j<=aa
    S(i,2*j-1)=X(h+j);
    S(i,2*j)=Y(h+j);
    end
    end
    h=h+1;
end   %д�úܰ�����

% Q=Xt;

%��һ�μ����Ͼ���
dd1=NH(S,Q,qq);

%���ٽ�����
SS=zeros(k,2*qq);%����ڵ�k������
K=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ

s=31;  %Ԥ�ⴰ��
prediction=zeros(s,1);
for c=1:s
jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-s)
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
Z=zeros(2*qq,k);
% t=zeros(k,1);%����ѡ����ٽ������±�
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-qq;
    Z(2*n-1,nn)=X(mnn);%��ʽ��7��
    Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(1,k);
MI=zeros(2*qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for aa=1:k
    H(aa)=Y(K(aa)+s);
end
for a=1:2*qq
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=12;
d0=12;
temp=zeros(d0,k);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
while(d>0)
    [maxx,maxi]=max(MI);
    for j=1:d0
    temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
    Z(maxi,:)=[];%��ȥѡ�е���һ��
    zz=size(Z,1);
    MI=zeros(zz,1);
    for i=1:zz
    M=[M Z(i,:)'];
    MI(i)=mi(M,H');
%     if MI(i)<0
%         break;  %��ֹ����
%     end
    M(:,2)=[];
%     i=i+1;
    end
    d=d-1;
    end
end

% d=s-s0; %̰���㷨�õ������յ�ʱ��
SSS=zeros(k,d0);%kΪ��Ӧ��ԭ��Z��������ÿ�����еĳ���
SSY=zeros(k,1);
% temp=[1,2]';
%�õ�s��z���У�Ҳ�Ϳ��Եõ���Ӧ��Ԥ������
for b=1:k
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %ÿ�����ж�Ӧ��Ԥ��ֵ
%     bb=bb+1; 
    end
%     b=b+1;%ѭ��һ�εõ�һ��Ŀ������
end
tempp=zeros(k,1);

%��ô���Ƿ����أ�����
for i=1:d0/2
    tempp=SSS(:,2*i);
    SSS(:,2*i)=SSS(:,2*i-1);
    SSS(:,2*i-1)=tempp;
end
% for i=1:d
% SSQ(2*i-1)=X(end);
% end
SSQ=zeros(1,d0);
SQ=zeros(1,d0);
for i=1:d0/2
SQ(2*i-1)=X(end-s-d0/2+i);
SQ(2*i)=Y(end-s-d0/2+i);
end
for i=1:d0
SSQ(d0-i+1)=SQ(i);
end

for i=1:d0/2
    tempm=SSQ(1,2*i);
    SSQ(1,2*i)=SSQ(1,2*i-1);
    SSQ(1,2*i-1)=tempm;
end

%ģ���Ƶ�������
%���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
%�ڶ��μ����Ͼ���
mediann=median(Y); %��ȡ����ѵ����������λֵ
mn=size(Y,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=Y(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(k,1);%��ű����ڶ�����������
cjy=zeros(k,1);%����������
for f=1:k
    cjy1(f)=NH(SSS(f,:),SSQ,d0/2);
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
    k=k+1;
end


gam=400;
sig2=40;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
prediction(c) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
end


ticks=cumsum(ones(396,1));
plot(prediction);
xlabel('time');
% x=[1920*ones(1,12) 1921*ones(1,12) 1922*ones(1,12) 1923*ones(1,12) 1924*ones(1,12) 1925*ones(1,12) 1926*ones(1,12) 1927*ones(1,12) 1928*ones(1,12) 1929*ones(1,12) 1930*ones(1,12) 1931*ones(1,12) 1932*ones(1,12) 1933*ones(1,12) 1934*ones(1,12) 1935*ones(1,12) 1936*ones(1,12) 1937*ones(1,12)];
% m=[(1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12) (1:12)];
% % s=[prediction Xt];
% bar(datenum(y,m,1),[X;Xt]);
% t=linspace(1920,1937,216);
% dt=t(2)-t(1);
% Y=fft(OliveOil_train);
% mag=abs(Y);
% f=(0:215)/(dt*18);
% plot(t,mag);
ts=1700;
tf=1987;
t=linspace(ts,tf,396);
axis([1,400,660,820]);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt]);
% datetick('x','yyyy','keepticks');
% ylabel('average air temperatures at Nottinghan Castle');
title('the example 1 of forcasting of time series datasets');

% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
mn=size(prediction,1);
w=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
end
mae=w/mn;