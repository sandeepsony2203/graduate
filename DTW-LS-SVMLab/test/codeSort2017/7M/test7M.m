clear all;
clc;

% S1=-1+2.*rand(1,300);
% S2=-1+2.*rand(1,300);
% S=[S1',S2'];
% S0=S;

[X,Y]=meshgrid(-20:1:20,-10:1:10);
S=zeros(861,2);
for i=1:21
    for j=1:41
        S((i-1)*41+j,1)=X(i,j);
        S((i-1)*41+j,2)=Y(i,j);
    end
end

A=mean(S);
dd= pdist2(S,A);

k=EntropyPDF(dd,2);

SS=zeros(k,2);%����ڵ�k������
K=zeros(k,1);
[maxn maxi]=max(dd);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd);%�ҵ�һ����Сֵ
    K(jjj)=mini;%��¼��Ӧ����
    dd(mini)=maxn;
    jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
    S(K(iii),:)=zeros(2,1);
end

plot(SS(:,1),SS(:,2),'.')
hold on
plot(A(1),A(2),'r*')
hold on
plot(S(:,1),S(:,2),'.k')
hold on
