function [NMI] = MIfunction(X,Y)
%����MIֵ�ú���
%Ҫ�õ����ּ���...������

% clear all 
% close all 
% clc 
L=9;
% m=10; 
% f=2;fs=50; 
% for n=1:10000; 
% y(n)=sin(2*pi*f*n/fs); 
% u(n)=0.02*sin(2*pi*f*n/fs); 
% end 
% s=y+u;d=y+m*u; 
n=size(X,2);
S=paixu(X);D=paixu(Y);    %��s��d���д�С�������� 
z1=(S(n)-S(1))/L;    %��S��D��ֵ��ƽ���ֳ�L������ÿ������Ŀ�� 
z2=(D(n)-D(1))/L;      
%ͳ����������(i,j)�ڵĵ����ֱ�ΪN(i,j) 
N=zeros(L,L); 
for k=1:n 
    if X(k)==S(1) 
        for r=1:L 
            if Y(k)==D(1) 
                N(1,1)=N(1,1)+1; 
            elseif D(1)+(r-1)*z2<Y(k)&&Y(k)<=D(1)+r*z2   
                N(1,r)=N(1,r)+1; 
            end 
        end 
    elseif Y(k)==D(1) 
        for t=1:L 
            if S(1)+(t-1)*z1<X(k)&&X(k)<=S(1)+t*z1 
               N(t,1)=N(t,1)+1; 
            end 
        end 
    end 
end 
for w=1:n 
    for i=1:L 
        if S(1)+(i-1)*z1<X(w)&&X(w)<=S(1)+i*z1 
             for j=1:L 
                 if D(1)+(j-1)*z2<Y(w)&&Y(w)<=D(1)+j*z2 
                     N(i,j)= N(i,j)+1; 
                 end 
             end 
        end 
    end 
end 
%�������ϸ��� 
p=zeros(L,L); 
for i=1:L 
    for j=1:L 
        p(i,j)=N(i,j)/n; 
    end  
end 
%���㻥��Ϣ 
Is=entropy(X);Id=entropy(Y); %��������Ե�ͳ�Ʋ��������������ڱ�����������ͼ�������-sum(p.*log2(p))
                             %p����ֱ��ͼ������IMHIST���ء����ڿ�ѧ��������������������ϵͳ��ȷ���̶ȵĺ�����
disp(Is); 
disp(Id); 
Isd=0; 
for i=1:L 
    for j=1:L 
        if p(i,j)==0 
            continue; 
        else 
            Isd=Isd-p(i,j)*log2(p(i,j)); 
        end 
    end 
end 
disp(Isd); 
MI=Is+Id-Isd; 
disp(MI); 
NMI=(Is+Id)/Isd; 
disp(NMI);

