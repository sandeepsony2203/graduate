function [train_data,test_data]=LSTM_sales_process(zis)
%% ���ݼ��ز���ɳ�ʼ��һ��
TXT=importdata('C:\Documents and Settings\Administrator\����\cjy\MIToolbox2.11\LS-SVMLab v1.7(R2006a-R2009a)\data\ARIMA.txt');
% [TXT,minx,maxx] = premnmx(TXT);

q=11; %ʱ��
qq=q+1;
s=1;  
t=12;

X=TXT(1:200+zis-1);
Xt=TXT((200+zis):216);
XXt=[X;Xt];

mm=size(TXT(1:(200+zis-1)),1);

z=mm-s-qq+1+1;
S=zeros(z,qq);
h=0; %�����ƶ�ʱ��Ӱ���ԭ���б��?

for i=1:z
    for j=1:qq
    if h+j<=mm
    S(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end  

Test_data_initial=zeros(z,t);
i=z;
while i>t
    Test_data_initial(z-i+1,:)=S(i,:);
    i=i-t;
end
Test_data_initial(ismember(Test_data_initial,zeros(1,t),'rows')==1,:)=[];
% test_data_initial=flipdim(Test_data_initial,1);
test_data_initial=Test_data_initial';

train_data_initial=zeros(z,3*qq);
i=z-t;
while i>2
    train_data_initial(z-1-i+1,1:qq)=S(i-2,:);
    train_data_initial(z-1-i+1,qq+1:2*qq)=S(i-1,:);
    train_data_initial(z-1-i+1,2*qq+1:3*qq)=S(i,:);
    i=i-t;
end

train_data_initial(ismember(train_data_initial,zeros(1,3*qq),'rows')==1,:)=[];

% train_data_initial=flipdim(train_data_initial,1);
train_data_initial=train_data_initial';
data_length=size(train_data_initial,1);            %ÿ�������ĳ���
data_num=size(train_data_initial,2);               %������Ŀ  

%%��һ������
for n=1:data_num
    train_data(:,n)=train_data_initial(:,n)/sqrt(sum(train_data_initial(:,n).^2));  
end
% test_data=test_data_initial;
for m=1:size(test_data_initial,2)
    test_data(:,m)=test_data_initial(:,m)/sqrt(sum(test_data_initial(:,m).^2));
end