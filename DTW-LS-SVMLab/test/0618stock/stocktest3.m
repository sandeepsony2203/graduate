
clear all;
clc;

TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2016\6\data\main\true\zxzq.txt');
TXT=(TXT.textdata(500:end,5))';% end:2015-03~06:2864-2933  %+2000
TXT=str2double(TXT);
[TXT,T1]=mapminmax(TXT);
TXT=TXT(1:end)';
% TXT=(TXT.data(:,2));

ww=500;
prediction=zeros(ww,1);
zis=1;
h1=size(TXT,1);
% TT=zeros(h1,1);
% for t=1:h1
%     TT(t)=TXT(t+1)-TXT(t);
% end
h0=h1-ww;
k=200;
while(zis<ww+1)
q=15; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
X=TXT(1:h0+zis-1);
% Q=TXT(5591:5600)';
Xt=TXT((h0+1+zis-1):h1);
XXt=[X;Xt];

mm=size(TXT(1:(h0-1+zis)),1);

z=mm-s-qq+1;
S=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Ytra=X(s+qq:end);
Xs=XXt((h0-s-q+zis):(h0+zis-s));
% d=3;

dd1=NHDTW(S,Xs,qq/2);
%���ٽ�����
SS=zeros(k,qq);%����ڵ�k������
K=zeros(k,1);
dd=zeros(k,1);
[maxn maxi]=max(dd1);%�����滻�����ֵ
mmm=size(X,1);

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=(mmm-q-s)
    K(jjj)=mini;%��¼��Ӧ����
    dd(jjj)=minn;%��¼��Ӧ�����ֵ
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

% H=zeros(k,1);
% for aa=1:k
% %     H(aa)=X(K(aa)+s);
%     H(aa)=X(K(aa)+q+s);
% end

kc=size(SS,1);
%����2q+3��Z����&&������
Z=zeros(qq,kc);
% t=zeros(k,1);%����ѡ����ٽ������±�
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:kc
    Z(n,nn)=SS(nn,n);%��ʽ��7��
%     Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(1,kc);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
YT=zeros(qq,1);
%���㻥��ϢMI�Ĵ�С
for aa=1:kc
%     H(aa)=X(K(aa)+s);
for m=1:qq
    YT(m)=TXT(K(aa)+m);
end
% H(aa)=(TXT(K(aa)+q+s)-mean(YT))/TXT(K(aa)+q+s-1);
H(aa)=(TXT(K(aa)+q+s)-TXT(K(aa)+q+s-1))/mean(YT);
%     H(aa)=(TXT(K(aa)+q+s)-TXT(K(aa)+q+s-1))/TXT(K(aa)+q+s-1);
end
for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=11;
d0=11;
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


SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)

for i=1:d0
    SSQ(i)=Xs(tem(i));%ȡ��Ӧʱ�̵�ֵ
end


[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({SSS,SSY,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(zis) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);

zis=zis+1;
end
% ticks=cumsum(ones(216,1));

% for t=1:(h1-h0)
%     prediction(t)=prediction(t)*TXT(h0+t-1)+TXT(h0+t-1);
% end

for t=1:(h1-h0)
    for n=1:qq
    YT=TXT(h0-qq+n);
    end
    prediction(t)=prediction(t)*mean(YT)+TXT(h0+t-1);
end


plot(prediction(1:end),'-b+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(h0+1:h1),'-r*');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of stockdata');
title('stock data test');


Xt=TXT(h0+1:h1);
% mn=size(prediction,1);
% w=zeros(mn,1);
% W=zeros(mn,1);
% for i=1:mn
%     w(i)=(prediction(i)-Xt(i))^2;
%     W(i)=(mean(Xt)-Xt(i))^2;
% end
% nmse = mean(w)/mean(W);
prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);

