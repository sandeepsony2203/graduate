clear all;
close all;
clc;

%��һ������
mu1=[0 0];  %��ֵ
S1=[5.5 0 ;0 6.5 ];  %Э����
data1=mvnrnd(mu1,S1,200);   %������˹�ֲ�����

%%�ڶ�������
mu2=[10.25 10.25];
S2=[5.5 0;0 6.5];
data2=mvnrnd(mu2,S2,200);

% %������������
% mu3=[-1.25 1.25 -1.25];
% S3=[0.3 0 0;0 0.35 0;0 0 0.3];
% data3=mvnrnd(mu3,S3,100);

%��ʾ����
plot(data1(:,1),data1(:,2),'+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
hold on
plot(0,0,'g*');
hold on
plot(10.25,10.25,'g*');
grid on;

%�������ݺϳ�һ��������ŵ�������
data=[data1;data2];
% data=[data1;data2;data3];   %�����data�ǲ�����ŵ�

% DATA=data;
%  dtemp=pdist2(DATA,A);
% [Y,KT]=sort(dtemp);
% [K]=FuzzyEntropyPDF(dtemp,2)



%k-means����
[u re]=KMeansCJY(data,2);  %����������ŵ����ݣ�������������ݵ������˼���������ټ�һά��
[m n]=size(re);

%�����ʾ����������
figure;
hold on;
for i=1:m 
    if re(i,3)==1   
         plot(re(i,1),re(i,2),'ro'); 
    elseif re(i,3)==2
         plot(re(i,1),re(i,2),'go'); 
    end
end
grid on;