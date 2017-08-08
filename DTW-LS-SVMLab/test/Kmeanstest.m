clear all;
close all;
clc;

% data=rand(100,2);
% [center,U,obj_fcn]=FCMClust(data,2);
% plot(data(:,1),data(:,2),'o');
% hold on;
% maxU=max(U);
% index1=find(U(1,:)==maxU);
% index2=find(U(2,:)==maxU);
% line(data(index1,1),data(index1,2),'marker','*','color','g');
% line(data(index2,1),data(index2,2),'marker','*','color','r');
% plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
% hold off;
% 


%��һ������
mu1=[0 0 0];  %��ֵ
S1=[0.3 0 0;0 0.35 0;0 0 0.3];  %Э����
data1=mvnrnd(mu1,S1,100);   %������˹�ֲ�����

%%�ڶ�������
mu2=[1.25 1.25 1.25];
S2=[0.3 0 0;0 0.35 0;0 0 0.3];
data2=mvnrnd(mu2,S2,100);

%������������
mu3=[-1.25 1.25 -1.25];
S3=[0.3 0 0;0 0.35 0;0 0 0.3];
data3=mvnrnd(mu3,S3,100);

%��ʾ����
plot3(data1(:,1),data1(:,2),data1(:,3),'+');
hold on;
plot3(data2(:,1),data2(:,2),data2(:,3),'r+');
plot3(data3(:,1),data3(:,2),data3(:,3),'g+');
grid on;

%�������ݺϳ�һ��������ŵ�������
data=[data1;data2;data3];   %�����data�ǲ�����ŵ�

[u1 re1]=FCMClust(data,3);


%k-means����
[u re]=KMeans(data,3);  %����������ŵ����ݣ�������������ݵ������˼���������ټ�һά��
[m n]=size(re);

%�����ʾ����������
figure;
hold on;
for i=1:m 
    if re(i,4)==1   
         plot3(re(i,1),re(i,2),re(i,3),'ro'); 
    elseif re(i,4)==2
         plot3(re(i,1),re(i,2),re(i,3),'go'); 
    else 
         plot3(re(i,1),re(i,2),re(i,3),'bo'); 
    end
end
grid on;
