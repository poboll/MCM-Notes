%%对比性
function [Score,quan3]=CRITIC(data1)
the=std(data1);
%%矛盾性
r=corr(data1);%计算指标间的相关系数
f=sum(1-r);
%%信息承载量
c=the.*f;
%计算权重
w=c/sum(c);
quan3=w;
%计算得分
[n,m]=size(data1);
data= data1 ./ repmat(sum(data1.*data1) .^ 0.5, n, 1); %矩阵归一化
% data=mapminmax(data1',0.002,1);%标准化到0.002-1区间
% data=data';
s=data*w';
Score=100*s/max(s);
end