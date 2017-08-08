clear all;
close all;
clc;

%��һ������
mu1=[0 0];  %��ֵ
S1=[0.3 0 ;0 0.35 ];  %Э����
data1=mvnrnd(mu1,S1,800);   %������˹�ֲ�����

data2=normrnd(0,0.35,800,2);
%��ʾ����
plot(data1(:,1),data1(:,2),'r+');
hold on;
plot(0,0,'g*');
grid on;


%�������ݺϳ�һ��������ŵ�������

% data=[data1;data2;data3];   %�����data�ǲ�����ŵ�

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