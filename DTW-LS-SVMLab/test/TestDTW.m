% disp('���ڼ���ο�ģ��Ĳ���...')  
% for i=1:10     
%     fname = sprintf('d:\\matlab6p5\\work\\%da.wav',i-1);   
%     x = wavread(fname);    
%     [x1 x2] = vad(x);    
%     m = lpc(x);    
%     m = m(x1-2:x2-2,:);   
%     ref(i).lpc = m;  
% end
% disp('���ڼ������ģ��Ĳ���...')  
% for i=1:10
%     fname = sprintf(' d:\\matlab6p5\\work\\%db.wav',i-1);    
%     x = wavread(fname);    
%     [x1 x2] = vad(x);    
%     m = lpc(x);    
%     m = m(x1-2:x2-2,:);    
%     test(i).lpc = m;  
% end
ref=[8.3000,18.3000,26.7000,38.3000,60.0000,96.7000,48.3000,33.3000,16.7000,13.3000]';
test=[132.8000,190.6000,182.6000,148.0000,113.0000,79.2000,50.8000,27.1000,16.1000,55.3000]';
disp('���ڽ���ģ��ƥ��...')  
dist = zeros(10,10);  
for i=1:10  
    for j=1:10    
        dist(i,j) = DTW(test(i), ref(j));  
    end
end
disp('���ڼ���ƥ����...')  
for i=1:10     
    [d,j] = min(dist(i,:));     
    fprintf('����ģ�� %d ��ʶ����Ϊ��%d\n', i, j);  
end