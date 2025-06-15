function [Score,quan2]=bianyixishu(data1)
%数据标准化 
data2=data1;
for j=1:size(data1,2)
    data2(:,j)= data1(:,j)./sqrt(sum(data1(:,j).^2));
end
%计算变异系数
A=mean(data2);%求每列平均值
S=std(data2);  %求每列方差
V=S./A; %变异系数
%计算权重
w=V./sum(V);
quan2=w;
%计算得分
s=data2*w';
Score=100*s/max(s);
end