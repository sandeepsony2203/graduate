function [mm,net,MSE]=TimeS_Pre_net_DTW(x0,lk)
%��������Ԥ��ʱ������
%[x1,net,MSE]=TimeS_Pre_net(x0,lk)
%  ����          x0:   ����ѵ���������ʱ�����У�������
%                lk:   ��lk������Ԥ����һ������,�൱��ARģ�͵Ľ״�
%  ���          x1��   ��ԭ��������x0�󲿼�����lk��Ԥ������
%                net:   ѵ���õ�������
%                MSE:   ����Ԥ������ָ��
%���ӣ�
%   clc
%   clear all;
%   x0=xlsread('1X����.xls');
%   lk=input('�ö��ٸ�����Ԥ����һ�����ݣ�');
%   [x1,net,MSE]=TimeS_Pre_net(x0,lk);
%   lkk=input('��Ҫ���ж��ٲ�Ԥ�⣿');
%   [x,minx,maxx] = premnmx(x0);
%   n=length(x);
%   figure(2);
%   for ii=1:lkk
%       inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
%       x(n+ii)=sim(net,inputp);
%   end
%   x2 = postmnmx(x,minx,maxx);  %����һ��
%   plot(x2)
%   hold on
%   plot(x0,'r')

%��һ��
[x,minx,maxx] = premnmx(x0);

n=length(x);
n1=n-lk-1;    %ѵ��������
H=x(n-n1:n)';
MI=zeros(lk,1);
for ii=1:lk
    n2=n-n1-ii;
    n3=n-ii;
    Z(ii,1:n1+1)=x(n2:n3)';
end


for a=1:lk
%     MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
    MI(a)=mi(Z(a,:)',H'); %���ú������MIֵ
end


M=[]; %��ʼ��{}�����Ԫ��
% s0=s;
d=9;
d0=9;
temp=zeros(d0,n1+1);%���ڴ洢ѡ������Ĳ���ѵ�����ж�Ӧ�����,�����ܴ���q
% % MI��������ÿ����һ��ZiҪ��ô����֪�����s��z����
tem=zeros(d0,1);%���ڴ洢ÿ��ѡ����������ж�Ӧ��ʱ�̵�
Z0=Z;
while(d>0)
    for j=1:d0
    [maxx,maxi]=max(MI);
    tem(j)=maxi;
%     temp(j,:)=Z(maxi,:);
    M=[M Z(maxi,:)']; %ÿ�ν�ѡ��õ�Z���мӽ�����ҲҪ�������ѵ����������ȡ
    Z(maxi,:)=zeros(1,n1+1);%��ȥѡ�е���һ��....����ֵ
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


%��������
net=newff(minmax(temp),[2*d0,1],{'tansig','purelin'},'trainlm');

%����ѵ������
net.trainParam.epochs=1000;%�ظ�ѵ������
net.trainParam.goal=1e-30;%ѵ����ֹĿ��
net.trainParam.lr=0.01;%ѧϰЧ��
net.trainParam.show=20;%������ʾ���ѵ������
net.trainParam.min_grad=1e-30;
net.trainParam.mu_max=1e12;

%ѵ������
net=train(net,input,output);

%����
for ii=1:lk
out_test=sim(net,Z);

%�������
E(ii,:)=output-out_test;%ii��Ԥ�����
MSE(ii)=mse(E(ii,:));

input1(1,:)=out_test(1:end);
input1(2:lk,:)=Z(1:lk-1,:);
Z=input1;
end



%===============Ԥ��===========
for ii=1:lk
inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
x(n+ii)=sim(net,inputp);
end
x1 = postmnmx(x,minx,maxx);  %����һ��
mm=x1(end-lk+1);