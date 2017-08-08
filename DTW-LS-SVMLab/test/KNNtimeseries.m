% TXT= importdata('data\Metal goods\13013-13599.txt');
% 
% X=TXT.data(92:517);
% Xt=TXT.data(518:547);
clear all��
clc;

%ע�⣡���������ﲢ���Ǳ����͸��ӱ����Ĺ�ϵ����������������Ĺ�ϵ
% Y=[1.073,1.062,0.963,0.874,1.048,1.078,1.084,1.106,1.104,1.002,0.897,1.099,1.137,1.136,1.130,1.097,0.990,0.870,1.066,1.114]';
% X=[1.118,1.116,1.005,0.903,1.099,1.131,0.969,1.093,1.125,1.091,0.943,1.138,1.149,1.155,1.158,1.161,1.065,0.944,1.140,1.174]';
% %QQ=[1.140,1.066,1.174,1.114];
% Q=[1.140,1.066,1.174,1.114];
% X=2.*rand(200,2)-1;

% Y=[1.073,1.062,0.963,0.874,1.048,1.078,1.084,1.106,1.104,1.002,0.897,1.099,1.137,1.136,1.130,1.097,0.990,0.870]';
% X=[1.118,1.116,1.005,0.903,1.099,1.131,0.969,1.093,1.125,1.091,0.943,1.138,1.149,1.155,1.158,1.161,1.065,0.944]';
% % %QQ=[1.140,1.066,1.174,1.114];
% Q=[1.140,1.066,1.174,1.114];
% X=[X;X];
% Y=[Y;Y];
% Q=[Q,Q];

% X=[40.6000,40.8000,44.4000,46.7000,54.1000,58.5000,57.7000,56.4000,54.3000,50.5000,42.9000,39.8000,44.2000,39.8000,45.1000,47.0000,54.1000,58.7000,66.3000,59.9000]';
% Y=[40.8000,44.4000,46.7000,54.1000,58.5000,57.7000,56.4000,54.3000,50.5000,42.9000,39.8000,44.2000,39.8000,45.1000,47.0000,54.1000,58.7000,66.3000,59.9000,57.0000]';
% Q=[57.0000,54.2000,54.2000,39.7000];

% % X=importdata('data\KNN\X.txt');
% % Y=importdata('data\KNN\Y.txt');
% % % XX=importdata('data\KNN\XX.txt');
% % % YY=importdata('data\KNN\YY.txt');
% % % ee=size(XX,1);
% % % Q=zeros(1,2*ee);
% % % for i=1:ee
% % %     Q(2*i-1)=XX(i);
% % %     Q(2*i)=YY(i);
% % % end
% % Q=importdata('data\KNN\Q.txt');


OliveOil_train=importdata('data\ARIMA.txt');
X=OliveOil_train(1:192);
Xt=OliveOil_train(193:216);
lag = 32;
Xu = windowize(X,1:lag+1);
X = Xu(1:end-lag,lag); %training set
Y = Xu(1:end-lag,end); %training set
Q=X(end-lag+1:end,1)';


cc=size(X,1);
XY=zeros(1,2*size(X));
for i=1:cc
    XY(2*i-1)=X(i);
    XY(2*i)=Y(i);
end

% X=[4,4,7,7,8,9,10,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,20,20,22,23]';
% Y=[2,10,4,22,16,10,18,26,34,17,28,14,20,24,28,26,34,34,46,26,36,60,80,20,26,54,32,40,32,40,50,42,56,76,84,36,46,68,32,48,52,56,64,66,54]';
% Q=[24,70,24,92,24,93,24,120,25,85];

mm=size(X,1)+(1/2)*size(Q,2)-1;
mmm=size(X,1);
% k=2*round((mm/2)^(1/2));
k=80;
q=15; %ʱ��
qq=q+1;
s=16;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
z=mm-s+1-q;
S=zeros(z,2*qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ

for i=1:z
    for j=1:qq
    if h+j<=mm
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
    H(aa)=X(K(aa)+s);
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

% for i=1:d
% SSQ(2*i-1)=X(end);
% end
SSQ=zeros(1,d0);
for i=1:d0
SSQ(i)=XY(end-d0+i);
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


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

% SST=Xt;%Ԥ������
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel ����
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'lin_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'lin_kernel'},cjy); %lin_kernel

%predict
prediction = predict({SSS,SSY,'f',gam,sig2,'lin_kernel'},SSQ,s);

%plot
ticks=cumsum(ones(144,1));
plot(prediction);
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('7');
t=linspace(ts,tf,144);
plot(t(1:size(X)),X);
hold on;
plot(t(size(X)+1:size(ticks)),[prediction Xt(1:16)]);
datetick('x','yyyy','keepticks');
ylabel('average air temperatures at Nottinghan Castle');
title('the example 1 of forcasting of time series datasets');
