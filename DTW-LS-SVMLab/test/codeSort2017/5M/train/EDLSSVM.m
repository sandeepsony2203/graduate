function [prediction]=EDLSSVM(SSS,SSY,SSQ,cjy)
%��Ӧ��SVMģ�����棬������Ե������ǹ�������ĺ������õ�alpha��b����Ԥ��

%tunel ����
[gam,sig2] = tunelssvm({SSS,SSY,'f',[],[],'RBF_kernel'},'simplex',...
'crossvalidatelssvm',{10,'mae'});

%predict
% prediction= predict({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,1);
prediction= predictknn({SSS,SSY,'f',gam,sig2,'RBF_kernel'},SSQ,cjy,1);
% prediction = predictcjy({Xtra,Ytra,'f',gam,sig2,'lin_kernel'},{[X;Xt],Xs},{d,100});
end