function [x1,net,MSE]=TimeS_Pre_net(x0,lk)
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
output=x(n-n1:n)';
for ii=1:lk
    n2=n-n1-ii;
    n3=n-ii;
    input(ii,1:n1+1)=x(n2:n3)';
end

%��������
net=newff(minmax(input),[2*lk,1],{'tansig','purelin'},'trainlm');

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
out_test=sim(net,input);

%�������
E(ii,:)=output-out_test;%ii��Ԥ�����
MSE(ii)=mse(E(ii,:));

input1(1,:)=out_test(1:end);
input1(2:lk,:)=input(1:lk-1,:);
input=input1;
end

figure(1);
plot(MSE);




%===============Ԥ��===========
figure(2);
for ii=1:lk
inputp(1:lk,1)=x(n+ii-1:-1:n-lk+ii);
x(n+ii)=sim(net,inputp);
end
x1 = postmnmx(x,minx,maxx);  %����һ��
plot(x1)
hold on
plot(x0,'r')