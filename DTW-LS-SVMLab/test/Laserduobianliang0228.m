clear all;
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT0=[TXT;TXT1];

prediction=zeros(95,1);
for jia=1:95
TXT=0.01*TXT0(3001:(5604+jia));
TYT=TXT0(3001:(5604+jia));
q=9; %ʱ��
qq=q+1;


Q1=zeros(qq,1);
Q2=zeros(qq,1);
Q=zeros(2*qq,1);
for i=1:qq
Q1(qq-i+1)=TXT(end-i+1);
Q2(qq-i+1)=TYT(end-i+1);
end
for i=1:qq
Q(2*i-1)=Q1(i);
Q(2*i)=Q2(i);
end
Q=Q';


k=150;
s=5;

X=TXT;
Y=TYT;
mmm=size(X,1);
aa=size(X,1);

z=aa-s-q+1;
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
Z=zeros(2*qq,k);
% t=zeros(k,1);%����ѡ����ٽ������±�
% t=K;
% for m=1:k
%     t(m)=K(m)-q;
% end
for n=1:qq
    for nn=1:k
    mnn=K(nn)+n-1;
    Z(2*n-1,nn)=X(mnn);%��ʽ��7��
    Z(2*n,nn)=Y(mnn);%��ʽ��7��
%     nn=nn+1;
    end
%     n=n+1;
end   %�ܰ�~~

H=zeros(1,k);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for tt=1:k
    H(tt)=Y(K(tt)+q+s);
end
for a=1:2*qq
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=8;
d0=8;
temp=zeros(d0,k);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
%     if j<d0
%         if mod(maxi,2)==0
%             maxii=maxi-1;
%         end
%     end             %Ԥ������ѡȡ����һ�ֿ���
    tem(j)=maxi;
    temp(j,:)=Z(maxi,:);
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
end

% for i=1:d
% SSQ(2*i-1)=X(end);
% end



% C0=C-d0;
% SSQQ=zeros(1,qq);
SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)
% for i=1:qq
% SSQQ(i)=Q(i);
% end

for i=1:d0
    SSQ(i)=Q(tem(i));%ȡ��Ӧʱ�̵�ֵ
end

%ģ���Ƶ�������
%���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
%�ڶ��μ����Ͼ���
mediann=median(X); %��ȡ����ѵ����������λֵ
mn=size(X,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=X(ff)-mediann;
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
end




[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});
%train
[alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel

%predict
prediction(jia) = predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
% C0=C0-1;

end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction);
hold on;
% plot(Xt((s+1):end),'r')
plot(Xt,'r');
xlabel('time');

ylabel('Values of Laser database');
title('the example 1 of KNN');


mn=size(prediction,1);
w=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
end
mae=w/mn;