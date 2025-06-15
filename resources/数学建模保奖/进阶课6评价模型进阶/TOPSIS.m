function [score]=TOPSIS(X,W)   
%X输入的数据，W各指标的权重
[n,~]=size(X);
%Z=zscore(X);
Z = X ./ repmat(sum(X.*X) .^ 0.5, n, 1); %矩阵归一化
V_D = sum(((Z - repmat(max(Z),n,1)) .^ 2 ) .* repmat(W,n,1) ,2) .^ 0.5; 
V_X = sum(((Z - repmat(min(Z),n,1)) .^ 2 ) .* repmat(W,n,1) ,2) .^ 0.5; 
S = V_X ./ (V_D+V_X); %未归一化得分
Score_S = S / sum(S); %归一化得分,即为每个企业的投资风险评分，值越大，投资风险也越大
score=Score_S;
%  score=100*Score_S/max(Score_S);
end