clear all;
clc;

TXT= load('data\KNN\ElectricFixedTest.mat');
TXT1= load('data\KNN\ElectricFixed.mat');
TXT=[TXT1.learn;TXT.test];


C=100;%��ǰԤ����ٸ�������
prediction=zeros(C,1);
for jia=1:C
    
X=TXT(1:(1350+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((1350+jia):1450);
XXt=[X;Xt];


% k=2*round((mm/2)^(1/2));
k=100;
q=11; %ʱ��
qq=q+1;
s=1;  %Ԥ�ⴰ��
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(1350+jia-1)),1);
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
dd1=NHDTWnew(S,Q,qq/2);

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

% %����2q+3��Z����&&������
% Z=zeros(qq,k);
% % t=zeros(k,1);%����ѡ����ٽ������±�
% % t=K;
% % for m=1:k
% %     t(m)=K(m)-q;
% % end
% for n=1:qq
%     for nn=1:k
%     mnn=K(nn)+n-1;
%     Z(n,nn)=X(mnn);%��ʽ��7��
% %     Z(2*n,nn)=Y(mnn);%��ʽ��7��
% %     nn=nn+1;
%     end
% %     n=n+1;
% end   %�ܰ�~~

H=zeros(1,k);
% MI=zeros(qq,1);%�洢Z������H֮��Ļ���Ϣ��С�����ڱȽ�
%���㻥��ϢMI�Ĵ�С
for aa=1:k
%     H(aa)=X(K(aa)+s);
    H(aa)=X(K(aa)+q+s);
end
% for a=1:qq
% %     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
% end
% 
% 
% M=[]; %��ʼ��{}�����Ԫ��
% % s0=s;
% d=9;
% d0=9;
% temp=zeros(d0,k);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
% tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
% Z0=Z;
% while(d>0)
%     for j=1:d0
%     [maxx,maxi]=max(MI);
%     tem(j)=maxi;
% %     temp(j,:)=Z(maxi,:);
%     M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
%     Z(maxi,:)=zeros(1,k);%��ȥѡ�е���һ��....����ֵ
%     zz=size(Z,1);
% %     MI=zeros(zz,1);
%     for ii=1:zz
%         if MI(ii)==0
%             MI(ii)=0;
%         else
%             MI(ii)=1;
%         end
%     end
%     for i=1:zz
%         if i==tem(j)
%             MI(i)=0;
%         else
%             M=[M Z0(i,:)'];
% %             cheng=mi(M,H');
%             cheng=mi(M,H');
%             if MI(i)==1
%             MI(i)=cheng;
%             end
%              M(:,2)=[];
%         end 
% %     i=i+1;
%     end
%     d=d-1;
%     end
% end
% tem=paixu(tem);
% for i=1:d0
%     temp(i,:)=Z0(tem(i),:);
% end
% 
% % d=s-s0; %̰���㷨�õ������յ�ʱ��
% SSS=zeros(k,d0);%kΪ��Ӧ��ԭ��Z��������ÿ�����еĳ���
% SSY=zeros(k,1);
% % temp=[1,2]';
% %�õ�s��z���У�Ҳ�Ϳ��Եõ���Ӧ��Ԥ������
% for b=1:k
%     for bb=1:d0
%     SSS(b,bb)=temp(bb,b);
%     SSY(b)=H(b); %ÿ�����ж�Ӧ��Ԥ��ֵ
% %     bb=bb+1; 
%     end
% %     b=b+1;%ѭ��һ�εõ�һ��Ŀ������
% end
% 
% 
% 
% % C0=C-d0;
% SSQQ=zeros(1,qq);
% SSQ=zeros(1,d0);
% % Xtt=[X((end-s+2):end);Xt];
% % while(C0>0)
% for i=1:qq
% SSQQ(i)=Xtt(i);
% end
% 
% for i=1:d0
%     SSQ(i)=SSQQ(tem(i));%ȡ��Ӧʱ�̵�ֵ
% end

% %ģ���Ƶ�������
% %���ݹ�ʽ��10����ñ���sai��ֵ��������cjy��ʾ����
% %�ڶ��μ����Ͼ���
% mediann=median(X); %��ȡ����ѵ����������λֵ
% mn=size(X,1);
% ymedian=zeros(mn,1);
% for ff=1:mn
%     ymedian(ff)=X(ff)-mediann;
% %     ff=ff+1;
% end
% ymediann=max(abs(ymedian));%�ڶ����������ӵķ�ĸ
% cjy1=zeros(k,1);%��ű�����һ����������
% cjy2=zeros(k,1);%��ű����ڶ�����������
% cjy=zeros(k,1);%����������
% for f=1:k
% %     cjy1(f)=NH(SSS(f,:),SSQ,(d0-1)/2);
%     cjy1(f)=NHDTWnew(SSS(f,:),SSQ,(d0-1)/2);
%     cjy2(f)=abs(X(f)-mediann)/ymediann;
%     cjy(f)=exp((-1/2)*(cjy1(f)+cjy2(f)));
% end


%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

%tunel ����
[gam,sig2] = tunelssvm({SS,H','f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% gam=2.4*(10^7);
% sig2=700;
%train
% [alpha,b] = trainlssvmknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},cjy); %lin_kernel
[alpha,b] = trainlssvm({SS,H','f',gam,sig2,'RBF_kernel'}); %lin_kernel

%predict
prediction(jia) = predict({SS,H','f',gam,sig2,'RBF_kernel'},Q,1);
% C0=C0-1;
end
% end

%plot
% ticks=cumsum(ones(70,1));
plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(1351:1450),'-r*');
xlabel('time');
ylabel('Values of polandelectricity database');
title('DTW:mae=2.2339,rmse=6.8317');

Xt=TXT(1351:1450);
mn=size(prediction,1);
w=0;
W=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
