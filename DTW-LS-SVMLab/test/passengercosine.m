clear all;  %ѡ��һ������ɾ��һ������
clc;


[TXT,TX,RAW] = xlsread('data\KNN\passenger.xlsx');

C=16;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:200+jia-1);
% Q=TXT(5591:5600)';
Xt=TXT((201+jia-1):216);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k0=3; %KNN����С�ܶȾ����kֵ

th=2; %cosine sum����ֵ
% kernel_type=RBF_kernel;
q=12; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
k=150;
KC=[];
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(200+jia-1)),1);
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
csum=11;
a=1;
K0=zeros(k0,1);
Q0=Q;

dd1=NHDTW1(S,Q,qq/2);
% dd1=NH(S,Q,qq/2);
% % ����DTW�㷨
% dd1=zeros(z,1);
%  for a=1:z
%     test=S(a,:); 
%     dd1(a) = DTW(test, Q);  
% %  for i=1:qq     
% %     [d,j] = min(dist(i,:));     
% %  end
%  end
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

A=K(1);
SS0=SS;
KS=K;
while(any(K==A))
% ��һ�μ����Ͼ���
jjk=1;
% MIN=[];

dd2=NHDTW1(S,Q0,qq/2);
% dd1=NH(S,Q,qq/2);
% % ����DTW�㷨
% dd1=zeros(z,1);
%  for a=1:z
%     test=S(a,:); 
%     dd1(a) = DTW(test, Q);  
% %  for i=1:qq     
% %     [d,j] = min(dist(i,:));     
% %  end
%  end
%���ٽ�����
KK=zeros(k0,1);
[maxn maxi]=max(dd2);%�����滻�����ֵ

while (jjk<=k0)
%     jjj=1;%��ֵ
    [minn mini]=min(dd2);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-q-s)
    KK(jjk)=mini;%��¼��Ӧ����
%     MIN=[MIN,minn]; %��¼��Ӧ�ľ���ֵ
    dd2(mini)=maxn;
    jjk=jjk+1;
    else
    dd2(mini)=maxn;
    end   
%     jjj=jjj+1;
end
KCC=[];
SSK=zeros(k0,qq);
for iii=1:k0
    SSK(iii,:)=S(KK(iii),:);
end
csum=cosinecjy(SSK,Q0,'lin_kernel',k0);
% KCC=[SSK;Q];%С��������м�
% entropy=kentropy(KCC,'lin_kernel',0); %�����أ����Ժ�
% [maxkc,maxk]=min(MIN);
pos=[];
if(csum<th)
    for a=1:k0
        if(any(K==KK(a)))
            temp1=find(K==KK(a));
            temp2=S(K(temp1),:);
            for c=1:k
                if(isequal(SS(c,:),temp2))
                    pos=[pos,c];
                end
            end
            SS0(pos,:)=[];
            KS(pos,:)=[];
        end
    end
end   %ɾȥ������Ҫ�������

A=KK(end);

K1=K0;
if a==k0||a==1
    K0=KK;
    a=1;
else
    K0=K1; 
end
%�������ĵ�����ĵ��滻����
if K0(a)<size(S,1)
Q=S(K0(a),:); %�滻��������
S(K0(a),:)=[];
a=a+1;
else
    a=a+1;
end
%kc=size(KC,2);
%if kc>kmax
    %break;
%end
end


%KC=intersect(KC,KC); %ȥ���ظ�Ԫ��

% K=zeros(kc,1);

% for b=1:kc
% for c=1:(z-4)
%     if(isequal(S(c,:),SS(b,:)))
%                     K(b)=c;
%     end
% end
% end
kc=size(KS,1);
Z=zeros(qq,kc);

for n=1:qq
    for nn=1:kc
    mnn=KS(nn)+n-1;
    Z(n,nn)=X(mnn);%��ʽ��7��
%     Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(1,kc);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for aa=1:kc
%     H(aa)=X(K(aa)+s);
    H(aa)=X(KS(aa)+q+s);
end
for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=10;
d0=10;
temp=zeros(d0,kc);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
    Z(maxi,:)=zeros(1,kc);%��ȥѡ�е���һ��....����ֵ
    zz=size(Z,1);
%     MI=zeros(zz,1);
    for ii=1:zz
        if MI(ii)==0
            MI(ii)=0;
        else
            MI(ii)=1;
        end
    end
    for i=1:zz
        if i==tem(j)
            MI(i)=0;
        else
            M=[M Z0(i,:)'];
%             cheng=mi(M,H');
            cheng=mi(M,H');
            if MI(i)==1
            MI(i)=cheng;
            end
%     if MI(i)<0
%         break;  %��ֹ����
        
%     end
             M(:,2)=[];
        end 
%     i=i+1;
    end
    d=d-1;
    end
end
tem=paixu(tem);
for i=1:d0
    temp(i,:)=Z0(tem(i),:);
end

% d=s-s0; %̰���㷨�õ������յ�ʱ��
SSS=zeros(kc,d0);%kΪ��Ӧ��ԭ��Z��������ÿ�����еĳ���
SSY=zeros(kc,1);
% temp=[1,2]';
%�õ�s��z���У�Ҳ�Ϳ��Եõ���Ӧ��Ԥ������
for b=1:kc
    for bb=1:d0
    SSS(b,bb)=temp(bb,b);
    SSY(b)=H(b); %ÿ�����ж�Ӧ��Ԥ��ֵ
%     bb=bb+1; 
    end
%     b=b+1;%ѭ��һ�εõ�һ��Ŀ������
end

SSQQ=zeros(1,qq);
SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)
for i=1:qq
SSQQ(i)=Xtt(i);
end

for i=1:d0
    SSQ(i)=SSQQ(tem(i));%ȡ��Ӧʱ�̵�ֵ
end

%ȡ�����d����
% SSQ(d0)=MN(end);
% for i=1:(d0-1)
%     SSQ(d0-i)=MN(end-i);%ȡ��Ӧʱ�̵�ֵ
% end

% ģ���Ƶ�������
% ���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
% �ڶ��μ����Ͼ���
mediann=median(X); %��ȡ����ѵ����������λֵ
mn=size(X,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=X(ff)-mediann;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
cjy1=zeros(kc,1);%��ű�����һ����������
cjy2=zeros(kc,1);%��ű����ڶ�����������
cjy=zeros(kc,1);%����������
for f=1:kc
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
    cjy1(f)=NHDTW1(SSS(f,:),SSQ,(d0-1)/2);

% %����DTW�㷨
%      for a=1:k
%      test=S(a,:);
%      cjy1(a) = DTW(test, Q);  
%      end
    cjy2(f)=abs(X(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

% SST=Xt;%Ԥ������
% SSS=[SSS;SSS];
% SSY=[SSY;SSY];
%tunel ����
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
%[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
prediction(jia) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
% C0=C0-1;
end
% end

X1=TXT(1:200);
Xt=TXT(201:216);
ticks=cumsum(ones(216,1));
ts=datenum('1960-01');
tf=datenum('1977-12');
t=linspace(ts,tf,216);
plot(t(1:size(X1)),X1);
hold on;
plot(t(size(X1)+1:size(ticks)),[prediction Xt]);
ylabel('Values of passenger database');
title('the example 1 of KNN');

mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
