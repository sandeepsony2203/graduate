clear all;  %ѡ��һ������ɾ��һ������
clc;

TXT= importdata('data\KNN\Laser.txt');
TXT1= importdata('data\KNN\Lasercon.txt');
TXT=[TXT;TXT1];

C=95;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(5605+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((5605+jia):5700);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
% k0=6; %KNN����С�ܶȾ����kֵ
% 
% th=5.2; %cosine sum����ֵ
k0=2; %KNN����С�ܶȾ����kֵ

th=1.2; %cosine sum����ֵ
numE=2;
% th=2; %cosine sum����ֵ
% kernel_type=RBF_kernel;
q=11; %ʱ��
qq=q+1;
s=5;  %Ԥ�ⴰ��
kmin=120;
% k=190;
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(5605+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-2*s));
mmm=size(X,1);


z=mmm-s-q+1;
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
a=1;
K0=zeros(k0,1);
Q0=Q;


SS0=S;
% KS=K;
entropy=0;
Eth=6;
pos=[];
TME=[];
Entropy=ones(Eth+1,1)*(-100);
% Entropy(1)=Entropy(1)*(-1/100);
% zis=1;
% differnce=1;
% differnce1=0;
KS=[];
kc=1;
diffkc=0;
dd1=NHDTW1(S,Q0,qq/2);
[min1,min1i]=min(dd1);
P=S(min1i,:);
KC=P;
KK=min1i;

S0=S;
S(min1i,:)=[];
csum=zeros(z-1,1);
for i=1:(z-1)
    SSK=[P;S(i,:)];
    csum(i)=cosinecjy(SSK,Q0,'lin_kernel',2);
end
% csum0=csum;

result0=0;
diffrence=0;
while(result0~=Eth)
%||diffrence~=1

result=zeros(Eth,1);
result0=0;

[summer,summerc]=max(csum);
PI=S(summerc,:);
csum(summerc)=[];
KC=[KC;PI];
KK=[KK;summerc];

KC=unique(KC,'rows'); %ȥ���ظ�Ԫ��
if diffkc>(numE)&&kc>kmin
   entropy=kentropy(KC,'lin_kernel',0); %�����أ����Ժ�
   for ie=1:(Eth)
    Entropy(end-ie+1)=Entropy(end-ie);
   end
    Entropy(1)=entropy;
else 
    entropy=Entropy(1);
end
for pe=1:2
if Entropy(end-pe)>Entropy(end-pe+1);%get the difference
   result(pe)=1;
else
    result(pe)=0;
end
end

for je=3:Eth
if Entropy(end-je)<Entropy(end-je+1);%get the difference
   result(je)=1;
else
   result(je)=0;
end
end

for qe=1:Eth
result0=result0+result(qe);
end

% diffrence1=(Entropy(2)-Entropy(1))-(Entropy(3)-Entropy(2));
% % diffrence2=(Entropy(3)-Entropy(2))-(Entropy(end)-Entropy(end-1));
% % if diffrence1>0&&diffrence2>0
% if diffrence1>0
%     diffrence=1;
% else
%     diffrence=0;
% end
  %ѡ������Ҫ�������
KS=unique(KK,'rows');
% SS1=unique(pos,'rows');

tempkc=kc;
kc=size(KS,1);
difkc=kc-tempkc;
if diffkc<(numE+1)
   diffkc=diffkc+difkc;
else
    diffkc=0;
end
end


SS=zeros(kc,qq);%����ڵ�k������
for iii=1:kc
    SS(iii,:)=S(KS(iii),:);
end

% A=KS(1);
cn=floor(kc/k0);
SS0=SS;
KW=KS;
KK=zeros(k0,1);
while(cn>0)
% ��һ�μ����Ͼ���
 SSK=P;
 for i=1:k0
 kb=randi(kc,1);
 SSK=[SSK;SS0(kb,:)];
 KK(i)=KS(kb);
 end

csum2=cosinecjy(SSK,Q0,'lin_kernel',k0);
% KCC=[SSK;Q];%С��������м�
% entropy=kentropy(KCC,'lin_kernel',0); %�����أ����Ժ�
% [maxkc,maxk]=min(MIN);
if(csum2<th)
    for a=1:k0
         pos=[];
        if(any(KS==KK(a)))
            temp1=find(KS==KK(a));
            temp2=S0(KS(temp1),:); %S
            for c=1:size(SS,1)
                if(isequal(SS(c,:),temp2))
                    pos=[pos;c];
                end
            end
            SS(pos,:)=[];
            KW(pos,:)=[];
        end
    end
end   %ɾȥ������Ҫ�������

cn=cn-1;
% A=KK(1);

end




kc=size(KW,1);
Z=zeros(qq,kc);

for n=1:qq
    for nn=1:kc
    mnn=KW(nn)+n-1;
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
    H(aa)=X(KW(aa)+q+s);
end
for a=1:qq
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=7;
d0=7;
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

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end));
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(5606:5700),'r');
xlabel('time');
% ts=datenum('1972-01');
% tf=datenum('2010-10');
% t=linspace(ts,tf,70);
% plot(t(1:size(X(end-68:end))),X(end-68:end));
% hold on;
% plot(t(size(X(end-68:end))+1:size(ticks)),[prediction SSQ(1)]);
% datetick('x','yyyy','keepticks');
ylabel('Values of Laser database');
title('the example 1 of KNN');

Xt=TXT(5606:5700);
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
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
