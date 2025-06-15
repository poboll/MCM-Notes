function [Score,quan1]=shangquanfa(data)
data2=mapminmax(data',0.002,1);%标准化到0.002-1区间
data2=data2';
%得到信息熵
[m,n]=size(data2);
p=zeros(m,n);
for j=1:n
    p(:,j)=data2(:,j)/sum(data2(:,j));
end 
for j=1:n
   E(j)=-1/log(m)*sum(p(:,j).*log(p(:,j)));
end
%计算权重
quan1=(1-E)/sum(1-E);
%计算得分
s=data2*quan1';
Score=100*s/max(s);
end