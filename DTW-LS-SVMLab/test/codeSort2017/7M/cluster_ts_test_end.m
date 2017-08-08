clear all
close all
clc
disp('The only input needed is a distance matrix file')
disp('The format of this file should be: ')
disp('Column 1: id of element i')
disp('Column 2: id of element j')
disp('Column 3: dist(i,j)')

disp('Reading input distance matrix')

% TXT= load('data\KNN\ElectricFixedTest.mat');
% TXT1= load('data\KNN\ElectricFixed.mat');
% TXT=[TXT1.learn;TXT.test];
% 
% h0=1350;
% h1=1450;

% TXT= importdata('data\KNN\Laser.txt');
% TXT1= importdata('data\KNN\Lasercon.txt');
% TXT=[TXT;TXT1];
% 
% h0=5605;
% h1=5700;
% % 
% X0=TXT(1:(h0));
% Xt=TXT((h0+1):h1);
% XXt=[X0;Xt];
% 
% q=8; %ʱ��
% qq=q+1;
% s=1;  %Ԥ�ⴰ��
% mm=size(TXT(1:(h0)),1);
% Xtt=XXt((end-size(Xt,1)-q-s+1):end);
% MN=X0(1:(mm+1-s));
% X=X0(1:(mm+1-s));
% mmm=size(X,1);
% 
% z=mm-s-qq+1;
% S=zeros(z,qq);
% h=0; %�����ƶ�ʱ��Ӱ���ԭ���б�ǩ
% 
% for i=1:z
%     for j=1:qq
%     if h+j<=mm
%     S(i,j)=X(h+j);
% %     S(i,2*j)=X(h+2*j);
%     end
%     end
%     h=h+1;
% end   %д�úܰ�����
% 
% xx=Computedist(S(end-2000:end,:));
% 
TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2017\7\data\Flame.txt');
%TXT= importdata('C:\Documents and Settings\Administrator\����\cjy\2017\7\24\Aggregation.txt');
% plot(TXT(:,1),TXT(:,2),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k')
S=TXT(:,1:end);
% S=TXT.data;
xx=Computedist(S);

% load mydata xx;
ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
  ND=NL;
end
N=size(xx,1);
for i=1:ND
  for j=1:ND
    dist(i,j)=0;
  end
end
for i=1:N
  ii=xx(i,1);
  jj=xx(i,2);
  dist(ii,jj)=xx(i,3);
  dist(jj,ii)=xx(i,3);
end
percent=2.0;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(N*percent/100);
sda=sort(xx(:,3));
dc=sda(position)*1;

fprintf('Computing Rho with Cut-off kernel of radius: %12.6f\n', dc);

rho=zeros(ND,1);
for i=1:ND
    A=S(i,:);
    temp=S;
    temp(i,:)=[];
    dd=pdist2(temp,A,'Euclidean');
%     rho(i)=minEntropyD(dd);
    rho(i)=minEntropyPDFs(dd,size(S,2));
end
%
% Gaussian kernel
%
% for i=1:ND-1
%   for j=i+1:ND
%      rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%      rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
%   end
% end
%
% "Cut off" kernel
% 
% for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
% end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end
delta(ordrho(1))=max(delta(:));
disp('Generated file:DECISION GRAPH')
disp('column 1:Density')
disp('column 2:Delta')

fid = fopen('DECISION_GRAPH', 'w');
for i=1:ND
   fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
end

disp('Select a rectangle enclosing cluster centers')
scrsz = get(0,'ScreenSize');
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
for i=1:ND
  ind(i)=i;
  gamma(i)=rho(i)*delta(i);
end
subplot(1,1,1)
tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho')
ylabel ('\delta')


subplot(1,1,1)
rect = getrect(1);
rhomin=rect(1);
deltamin=rect(4);
NCLUST=0;
for i=1:ND
  cl(i)=-1;
end
for i=1:ND
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     NCLUST=NCLUST+1;
     cl(i)=NCLUST;
     icl(NCLUST)=i;
  end
end
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

%assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end
%halo
for i=1:ND
  halo(i)=cl(i);
end
if (NCLUST>1)
  for i=1:NCLUST
    bord_rho(i)=0.;
  end
  for i=1:ND-1
    for j=i+1:ND
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
        rho_aver=(rho(i)+rho(j))/2.;
        if (rho_aver>bord_rho(cl(i))) 
          bord_rho(cl(i))=rho_aver;
        end
        if (rho_aver>bord_rho(cl(j))) 
          bord_rho(cl(j))=rho_aver;
        end
      end
    end
  end
  for i=1:ND
    if (rho(i)<bord_rho(cl(i)))
      halo(i)=0;
    end
  end
end
for i=1:NCLUST
  nc=0;
  nh=0;
  for j=1:ND
    if (cl(j)==i) 
      nc=nc+1;
    end
    if (halo(j)==i) 
      nh=nh+1;
    end
  end
  fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
end

cmap=colormap;
 figure;
for i=1:NCLUST
   ic=int8((i*64.)/(NCLUST*1.)+1);%int8((i*64.)/(NCLUST*1.);
   subplot(2,1,1)
   hold on
   if ic>64
       ic=64;
   end
   plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
subplot(2,1,2)
disp('Performing 2D nonclassical multidimensional scaling')
Y1 = mdscale(dist, 2, 'criterion','metricsstress');%metricstress
plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
xlabel ('X')
ylabel ('Y')
for i=1:ND
 A(i,1)=0.;
 A(i,2)=0.;
end
figure;
for i=1:NCLUST
  nn=0;
  ic=int8((i*64.)/(NCLUST*1.)+1);
  for j=1:ND
    if (halo(j)==i)
      nn=nn+1;
      A(nn,1)=Y1(j,1);
      A(nn,2)=Y1(j,2);
    end
  end
  hold on
  if ic>64
       ic=64;
  end
  plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',7,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end

%for i=1:ND
%   if (halo(i)>0)
%      ic=int8((halo(i)*64.)/(NCLUST*1.));
%      hold on
%      plot(Y1(i,1),Y1(i,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%   end
%end
faa = fopen('E:\cjy\2017\CLUSTER_ASSIGNATION.txt', 'w');
disp('Generated file:CLUSTER_ASSIGNATION')
disp('column 1:element id')
disp('column 2:cluster assignation without halo control')
disp('column 3:cluster assignation with halo control')
for i=1:ND
   fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
end