clear all;
close all;
clc;

%��һ������
mu1=[0 0];  %��ֵ
S1=[0.3 0 ;0 0.35 ];  %Э����
data1=mvnrnd(mu1,S1,200);   %������˹�ֲ�����

%%�ڶ�������
mu2=[2.25 2.25];
S2=[0.3 0;0 0.35];
data2=mvnrnd(mu2,S2,200);

mu3=[-2.25 2.25];
S3=[0.3 0;0 0.35];
data3=mvnrnd(mu3,S3,200);

mu4=[-2.25 -2.25];
S4=[0.3 0;0 0.35];
data4=mvnrnd(mu4,S4,200);

mu5=[2.25 -2.25];
S5=[0.3 0;0 0.35];
data5=mvnrnd(mu5,S5,200);

mu6=[5.25 0];
S6=[0.3 0;0 0.35];
data6=mvnrnd(mu6,S6,200);

mu7=[0 5.25];
S7=[0.3 0;0 0.35];
data7=mvnrnd(mu7,S7,200);

mu8=[0 -5.25];
S8=[0.3 0;0 0.35];
data8=mvnrnd(mu8,S8,200);

mu9=[-5.25 0];
S9=[0.3 0;0 0.35];
data9=mvnrnd(mu9,S9,200);

data=[data1;data2;data3;data4;data5;data6;data7;data8;data9];

%��ʾ����
plot(data1(:,1),data1(:,2),'r+');
hold on;
plot(data2(:,1),data2(:,2),'+');
hold on;
plot(data3(:,1),data3(:,2),'+');
hold on;
plot(data4(:,1),data4(:,2),'+');
hold on;
plot(data5(:,1),data5(:,2),'+');
hold on;
plot(data6(:,1),data6(:,2),'+');
hold on;
plot(data7(:,1),data7(:,2),'+');
hold on;
plot(data8(:,1),data8(:,2),'+');
hold on;
plot(data9(:,1),data9(:,2),'+');
hold on
plot(0,0,'g*');
hold on
plot(2.25,2.25,'g*');
hold on
plot(-2.25,2.25,'g*');
hold on
plot(2.25,-2.25,'g*');
hold on
plot(-2.25,-2.25,'g*');
hold on
plot(5.25,0,'g*');
hold on
plot(-5.25,0,'g*');
hold on
plot(0,-5.25,'g*');
hold on
plot(0,5.25,'g*');
grid on;


%�������ݺϳ�һ��������ŵ�������

% data=[data1;data2;data3];   %�����data�ǲ�����ŵ�

%k-means����
[u re]=KMeansCJY(data,4);  %����������ŵ����ݣ�������������ݵ������˼���������ټ�һά��
[m n]=size(re);

%�����ʾ����������
figure;
hold on;
for i=1:m 
    if re(i,3)==1   
         plot(re(i,1),re(i,2),'ro'); 
    elseif re(i,3)==2
         plot(re(i,1),re(i,2),'go'); 
    elseif re(i,3)==3
         plot(re(i,1),re(i,2),'yo'); 
    elseif re(i,3)==4
         plot(re(i,1),re(i,2),'ko'); 
    end
end
grid on;