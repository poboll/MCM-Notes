function [score1,quan] = cengcifenxi(A,data)
% A判别矩阵
% A=[1,3,1,1/3;
%     1/3,1,1/2,1/5;
%     1,2,1,1/3;
%     3,5,3,1];
[n,~]=size(data);
%Z=zscore(X);
Z = data ./ repmat(sum(data.*data) .^ 0.5, n, 1); %矩阵归一化

[n,~]=size(A);
%求特征值特征向量,找到最大特征值对应的特征向量
[V,D]=eig(A);
tzz=max(max(D));     %找到最大的特征值
c1=find(D(1,:)==tzz);%找到最大的特征值位置
tzx=V(:,c1);%最大特征值对应的特征向量
% disp(tzx)
%赋权重
quan=zeros(n,1);
for i=1:n
quan(i,1)=tzx(i,1)/sum(tzx);
end
Q=quan;
%一致性检验
CI=(tzz-n)/(n-1);
RI=[0,0,0.58,0.9,1.12,1.24,1.32,1.41,1.45,1.49,1.52,1.54,1.56,1.58,1.59];
%判断是否通过一致性检验
CR=CI/RI(1,n);
if CR>=0.1
   fprintf('没有通过一致性检验\n');
else
  fprintf('通过一致性检验\n');
end
 score=Z*Q;
 score1=100*score/max(score);
end