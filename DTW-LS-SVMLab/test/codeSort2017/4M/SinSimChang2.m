clear all;
clc;
% Num=11*10;
% t=linspace(0,1,Num)*(10*2*pi);
% % TXT=sin(t);
% TXT=zeros(Num,1);
% % TXT=0.02*sin(sqrt(t+t.^2));
% for i=1:Num
%     if sin(sqrt(t(i)+t(i).^2))>0
%         TXT(i)=0.2*sin(sqrt(t(i)+t(i).^2));
%     else
%         TXT(i)=0.2*sin(sqrt(t(i)+t(i).^2));
%     end
% end
% plot(t,TXT)
TXT= importdata('C:\Documents and Settings\Administrator\桌面\cjy\2017\4\17\Sin(pi=11)main.txt');

% plot(TXT,'-*');
% grid on;

prediction=zeros(8,1);
jia=1;
while(jia<9)
    
X=TXT(1:(108+jia-1));
% Q=TXT(5591:5600)';
Xt=TXT((108+jia):116);
XXt=[X;Xt];

q=10; %时滞
qq=q+1;
s=1;  %预测窗口
% k=6;
% q=1;
% s=2;
% qq=q+1;
mm=size(TXT(1:(108+jia-1)),1);
Xtt=XXt((end-size(Xt,1)-q-s+1):end);
MN=X(1:(mm+1-s));
X=X(1:(mm+1-s));
mmm=size(X,1);


z=mm-s-qq+1;
Xtra=zeros(z,qq);
h=0; %用于移动时滞影响的原序列标签

for i=1:z
    for j=1:qq
    if h+j<=mm
    Xtra(i,j)=X(h+j);
%     S(i,2*j)=X(h+2*j);
    end
    end
    h=h+1;
end   %写得很棒！！

Ytra=X(s+qq:end);
Xs=X(end-q:end);
% d=3;

% Xmean=zeros(1,qq);
% for i=1:qq
%     Xmean(i)=mean(Xtra(:,i));
% end
% Ytra=X(s+qq:end);
% Ymean=mean(Ytra);
% for j=1:z
%     Xtra(j,:)=Xtra(j,:)-Xmean(i);
%     Ytra(j)=Ytra(j)-Ymean;
% end
% Xs=XXt((108-s-q+jia):(108+jia-s))'-Xmean;


[gam,sig2] = tunelssvm({Xtra,Ytra,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

% Prediction of the next 100 points
[alpha,b] = trainlssvm({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'});
%predict next 100 points
prediction(jia) = predict({Xtra,Ytra,'f',gam,sig2,'RBF_kernel'},Xs,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});

% prediction(jia)=prediction(jia) +Ymean;
jia=jia+1;
end



plot(prediction(1:end),'-+');
hold on;
% plot(Xt((s+1):end),'r')
plot(TXT(109:116),'-*r');
xlabel('time');
ylabel('Values of Sin function');
title('SVM: mae= ,rmse=');


Xt=TXT(109:116);

prediction=prediction(1:end);
mn=size(prediction,1);
w=0;
W=0;
PW=0;
for i=1:mn
    w=w+abs(prediction(i)-Xt(i));
    PW=PW+abs(prediction(i)-Xt(i))/Xt(i);
    W=W+(prediction(i)-Xt(i))^2;
end
mae=w/mn;
rmse=sqrt(W/mn);
mape=100*PW/mn;
