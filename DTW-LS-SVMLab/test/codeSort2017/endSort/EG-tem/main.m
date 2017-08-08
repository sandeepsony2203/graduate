clear all;
clc;

[TXT,TX,RAW] = xlsread('data\KNN\EGtemperature.xlsx');
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end);

C=76;%��ǰԤ����ٸ�������
prediction=zeros(C,1);

h1=size(TXT,1);
h0=h1-C;
t=3;
for jia=1:C
% jia=21; 
X0=TXT(1:(h0+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((h0+jia):h1);
XXt=[X0;Xt];


q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��

mm=size(TXT(1:(h0+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X0(1:(mm+1-s));
X=X0(1:(mm+1-s));
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
Ytra=X0(qq+s:end);

% dd0=NHEH0306(S,Q);%NHDTWnew0
dd1=NHEH0306(S,Q);

% Ym=median(Ytra);
% [k]=FuzzyEntropyY(dd1,Ytra',Ym,t);
[k]=FuzzyEntropyD(dd1);

% k=150;
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

p=ceil(size(SS,1)*rand(1,1));

pivor=1;
SA=SS;
if rem(qq,2)==0
    width=qq;
else
    width=round(qq+1);
end
while(isempty(SS)==0)
    index=K(p);
    temp=zeros(width,qq);
    if index<width/2
        temp(1:index-1,:)=S(1:index-1,:);
        temp(index:width,:)=S(index+1:width-index+2,:);
    elseif index>z-width/2
        temp(1:round(width/2),:)=S((index-round(width/2)):(index-1),:);
        temp(round(width/2)+1:round(width/2)+z-index+1,:)=S(index:end,:);
    else
        if index>round(width/2)
            temp(1:round(width/2),:)=S((index-round(width/2)):(index-1),:);
        else
            temp(1:round(width/2)-1,:)=S((index-round(width/2))+1:(index-1),:);
        end
        temp(round(width/2)+1:width,:)=S(index+1:index+round(width/2),:);% ++if end
    end
    TM=intersect(SS,temp,'rows');
    if size(TM,1)>0
        TM=[TM;SA(p,:)];
        for j=1:size(TM,1)
            for i=1:size(SS,1)
                if all(SS(i,:)==TM(j,:))==1
                    SS(i,:)=zeros(1,qq);
                end
            end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
%         dtemp=NHEHDTW(TM,Q); %NHDTWnew1219  NHEH0306
        dtemp=NHEH0306(TM,Q);
        [mtemp mitemp]=min(dtemp);
        p=find(ismember(SA,TM(mitemp,:),'rows'));
        if ismember(pivor,p,'rows')==0
            pivor=[pivor;p];
        end
    else
        for i=1:size(SS,1)
               if all(SS(i,:)==SA(p,:))==1
                   SS(i,:)=zeros(1,qq);
               end
        end
        SS(ismember(SS,zeros(1,qq),'rows')==1,:)=[];
    end
    p=ceil(size(SA,1)*rand(1,1));
end

SSA=zeros(size(pivor,1),qq);%����ڵ�k������
for iii=1:size(pivor,1)
    SSA(iii,:)=SA(pivor(iii),:);
end

k=size(pivor,1);
H=zeros(1,k);
for aa=1:k
%     H(aa)=X(K(aa)+q+s);
    H(aa)=Ytra(K(pivor(aa)));
end

Z=SSA';
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�

for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=9;
d0=9;
temp=zeros(d0,k);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
    Z(maxi,:)=zeros(1,k);%��ȥѡ�е���һ��....����ֵ
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

% C0=C-d0;
SSQQ=Q;
SSQ=zeros(1,d0);


for i=1:d0
    SSQ(i)=SSQQ(tem(i));%ȡ��Ӧʱ�̵�ֵ
end

[SSS,YA]=unique(SSS,'rows');

SSY=SSY(YA,:);

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
cjy1=NHEH0306(SSS,SSQ);%NHDTWnew1219  NHEHDTW
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);    
%     cjy1(f)=0;
    cjy2(f)=abs(SSY(f)-mediann)/ymediann;
%     cjy(f)=exp((-1/2)*(1*cjy1(f)+1*cjy2(f)));
    if (cjy1(f)==0||cjy2(f)==0)
        cjy(f)=(1/2)*(exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f)));
    else
        namda=log(cjy1(f)/cjy2(f))/(cjy1(f)/cjy2(f)+1);
        cjy(f)=(1/2)*(exp((-namda)*cjy1(f))+exp((-(1-namda))*cjy2(f)));
    end
%       cjy(f)=exp((-1/2)*cjy1(f))+exp((-1/2)*cjy2(f));
%     cjy(f)=(-1/2)*exp(cjy1(f))+(-1/2)*exp(cjy2(f));
end

resultT=zeros(t,1);
for i=1:t
    resultT(i)=EDLSSVM(SSS,SSY,SSQ,cjy);
end

% prediction(jia)=mean(resultT);

[kk]=FuzzyEntropyD(resultT);
resultT=sort(resultT);

if t-kk>kk
    prediction(jia)=mean(resultT(kk+1:end));
else
    prediction(jia)=mean(resultT(1:kk));
end
% C0=C0-1;
end
% end

%plot

plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
ylabel('Values of Laser database');
title('DTW:mae=2.2339,rmse=6.8317');

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
nrmse=rmse/std(TXT(1:h0));