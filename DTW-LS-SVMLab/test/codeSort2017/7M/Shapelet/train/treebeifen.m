function[valueintree, nodeintree] = tree(tree_depth, tree_width, seek_value)
       %���룺������ȡ����Ĺ�ȡ�������ֵ
       %���أ����нӽ���ֵ���ڵ����֣����û�нӽ���ֵ���ڵ�����Ϊ��
       %����������ȡ��ڵ�Ķ��������������ܵĽڵ����
       node_num = 0;
       for n= 0 : (tree_depth-1)
              node_num = node_num + tree_width ^ n;
       end
 
       %Ϊ���Ĵ洢�ռ丳ֵ
       %node name�����չ������Ϊ�ڵ��ź�
       tree_nodename = (1 : node_num);
       %node value
       tree_nodevalue = rand(1 : node_num);
       %node father and son
       tree_nodefather(1) = 0;
       tree_nodeson = zeros(1, node_num);
       n = 2;
       k = 1;
       while n <= node_num
              for m = 1 : tree_width
                     tree_nodefather(n) = k;
                     if m==1
                            tree_nodeson(k) = n;
                     end
                     n = n + 1;
              end
              k = k + 1;
       end
       %node neighbor
       tree_nodeneighbor(1) = 0;
       n = 2;
       while n <= node_num
              for m = 1 : tree_width
                     if m ==tree_width
                            tree_nodeneighbor(n) = 0;
                     else
                            tree_nodeneighbor(n) = n + 1;
                     end
                     n = n + 1;
              end
       end
stack = zeros(1, tree_depth);
nodeinstack = zeros(1, node_num);
stack_ptr = 1;
stack(1) = 1;
nodeinstack(1) = 1;
valueintree = seek_value;
nodeintree = 0;
 
while stack_ptr > 0
    n = stack(stack_ptr);
    if abs(tree_nodevalue(n) - seek_value) < 1e-3
              %���������ֵ������
              valueintree = tree_nodevalue(n);
              nodeintree = tree_nodename(n);
              break;
    end
    
    if tree_nodeson(n) ~= 0 && nodeinstack(n) == 1
        %����ڵ��ж��ӣ����ҵ�һ����ջ�������ӽڵ���ջ
        stack_ptr = stack_ptr + 1;
        m = tree_nodeson(n);
        stack(stack_ptr) = m;
        nodeinstack(m) = nodeinstack(m) + 1;
    elseif tree_nodeneighbor(n) ~= 0
        %��������ڵ��ұ����ֵܣ��ڵ��ջ��Ȼ���ұ��ֵ���ջ
        m = tree_nodeneighbor(n);
        stack(stack_ptr) = m;
        nodeinstack(m) = nodeinstack(m) + 1;
    else
        %�ٷ��򣬳�ջ��Ȼ�󽫸��׽ڵ����ջ������һ
        stack_ptr = stack_ptr - 1;
        m = stack(stack_ptr);
        nodeinstack(m) = nodeinstack(m) + 1;
    end
end
end