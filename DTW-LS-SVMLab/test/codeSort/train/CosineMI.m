function [SSS,SSY,cjy,SSQ]=CosineMI(H0,S,SS,Q,K,k,k0,th,qq)
a=1;
s=1;
K0=zeros(k0,1);
Q0=Q';
A=K(1);
SS0=S;
KS=K;
while(any(K==A)&&size(S,1)>0)
% ��һ�μ����Ͼ���
jjk=1;
% MIN=[];

dd2=NHDTWnewest(S,Q0,qq/2);
%���ٽ�����
KK=zeros(k0,1);
[maxn maxi]=max(dd2);%�����滻�����ֵ

while (jjk<=k0)
%     jjj=1;%��ֵ
    [minn mini]=min(dd2);%�ҵ�һ����Сֵ
    KK(jjk)=mini;%��¼��Ӧ����
%     MIN=[MIN,minn]; %��¼��Ӧ�ľ���ֵ
    dd2(mini)=maxn;
    jjk=jjk+1;
end
KCC=[];
SSK=zeros(k0,qq);
for iii=1:k0
    SSK(iii,:)=S(KK(iii),:);
end
csum=cosinecjy(SSK,Q0,'lin_kernel',k0);
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
if K0(a)<=size(S,1)
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

kc=size(KS,1);
Z=zeros(qq,kc);

for n=1:qq
    for nn=1:kc
    Z(n,nn)=SS0(KS(nn),n);%��ʽ��7��
    end
end   %�ܰ�~~

H=zeros(1,kc);
MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for aa=1:kc
%     H(aa)=X(K(aa)+s);
    H(aa)=H0(KS(aa));
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

SSQQ=zeros(1,qq);
SSQ=zeros(1,d0);
% Xtt=[X((end-s+2):end);Xt];
% while(C0>0)
for i=1:qq
SSQQ(i)=Q0(i);
end

for i=1:d0
    SSQ(i)=SSQQ(tem(i));%ȡ��Ӧʱ�̵�ֵ
end


% ģ���Ƶ�������
% ���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
% �ڶ��μ����Ͼ���
mediann=median(SSY); %��ȡ����ά����λֵ
mn=size(SSY,1);
ymedian=zeros(mn,1);
for ff=1:mn
    ymedian(ff)=SSY(ff)-mediann;
%     ff=ff+1;
end
ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
cjy1=zeros(k,1);%��ű�����һ����������
cjy2=zeros(k,1);%��ű����ڶ�����������
cjy=zeros(k,1);%����������
for f=1:k
%     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
    cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
    cjy2(f)=abs(SSY(f)-mediann)/ymediann;
    cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
end