function [selection,Distance]=Kselect(S,Q,TT,qq,Direction,k)

dd1=NHDTW(S,Q,qq/2);
% dd1=zeros(size(S,1),1);
% for i=1:size(S,1)
%     dd1(i)=DTW(S(i,:),Q);
% end

SS=zeros(k,qq);%����ڵ�k������
K=zeros(k,1);
KH=zeros(k,1);

[maxn maxi]=max(dd1);%�����滻�����ֵ

jjj=1;
while (jjj<=k)
%     jjj=1;%��ֵ
    [minn mini]=min(dd1);%�ҵ�һ����Сֵ
    if mini>=qq&&mini<=size(S,1)
    K(jjj)=mini;%��¼��Ӧ����
    KH(jjj)=minn;
    dd1(mini)=maxn;
    jjj=jjj+1;
    else
    dd1(mini)=maxn;
    end   
%     jjj=jjj+1;
end
for iii=1:k
    SS(iii,:)=S(K(iii),:);
end

TD=zeros(k,1);
TH=zeros(k,1);
MD=0;
for i=1:k
    TD(i)=TT(K(i)+qq);
    if TD(i)>=0
        TH(i)=1;
    else
        TH(i)=-1;
    end
end
for j=1:k
    if TH(j)==Direction
        MD=MD+1;
    end
end

selection=MD/k;

% aa=0;
% for i=1:k
%     if KH(i)>=0.5001
%         aa=aa+1;
%     end
% end

Distance=mean(KH);
% Distance=aa/k;

    