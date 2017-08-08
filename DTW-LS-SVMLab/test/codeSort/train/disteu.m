function distance = disteu(y, x)
% DISTEU �����������֮���ŷ�Ͼ���
%
% Input:
%       x, y:   ��������ÿһ�ж���һ��ʸ��
%
% Output:
%       d:      Ԫ�� d(i,j) ������������X(:,i) �� Y(:,j)֮���ŷ�Ͼ���
%
% Note:
%       ʸ��X �� Y֮���ŷ�Ͼ���DΪ:
%       D = sum((x-y).^2).^0.5
[dim1 L]=size(x');
[dim2 cluster]=size(y');
distance = 0;
for i=1:L
    temp = repmat(x(:,i),1,cluster);
    distance = min(sum((temp-y).^2,1))+distance;
end