% clear
% clc
% y0 = [0,2,9];          
% [t,y] = ode45('lorenz_diff',[0,200],y0); 
% plot(y(:,1),y(:,3),'.');
% grid on;

clf;
clear;
clc;
x0=[1,1,1];
[t,y]=ode45('lorenz_diff',[0,100],x0);
subplot(2,1,1)        %����һ�е�ͼ��һ��
plot(t,y(:,3))
 xlabel('time');ylabel('z');  %��z-tͼ��
subplot(2,2,3)             %�������е�ͼ������
plot(y(:,1),y(:,2))
xlabel('x');ylabel('y');   %��x-yͼ��
subplot(2,2,4)
plot3(y(:,1),y(:,2),y(:,3)) 
xlabel('x');ylabel('y');zlabel('z');   %��xyzͼ��