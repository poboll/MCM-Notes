clc;clear ;close all
data_table=readtable('附件1 近5年402家供应商的相关数据.xlsx','Sheet','企业的订货量（m³）');
data_table1=readtable('附件1 近5年402家供应商的相关数据.xlsx','Sheet','供应商的供货量（m³）');
%% 将文字标签修改为数字标签
data_abc=data_table(:,2);%将第2列取出来，data_table(2,:)%将第2行取出来
data_abc_num=table2array(data_abc);  % 表文件转化为cell
data_tongji=tabulate(data_abc_num)%   统计ABC个数
for i=1:size(data_tongji,1)
dianli_str{1,i}=data_tongji{i,1};
end
data_shuju=zeros(length(data_abc_num),1);
for NN=1:length(dianli_str)
    idx = find(ismember(data_abc_num, dianli_str{1,NN} ));
    data_shuju(idx)=NN;
end
%% 表格有用的数据变成矩阵数据
data=table2array(data_table(:,3:end));
data1=table2array(data_table1(:,3:end));
%% 
%将ABC找出来分开评价
for i=1:size(data_tongji,1)  %将不同标签行的位置分别找出来存在不同的元胞里，因为维度不一样
    A(i)={find(data_shuju==i)};
end
%%
% for i=1:size(data_tongji,1)  %对应ABC三种供货商公司
    
    data_test=data;       %企业订单数
    data_test1=data1;   %企业供货数
  %index1 供货次数
    for k=1:size(data_test1,1)
        AA=1:size(data_test,2);
        AA1=find(data_test(k,:)~=0);
    B(k,1)=length(AA1);  %指标1各供应商供应可靠度
    end
  %index2 供应商最大供给
     B(:,2)=max(data_test1');  %指标2各供应商的供给
   %index3 供应商平均供给
   B(:,3)=mean(data_test1');  %指标3企业对供应商周平均订货
   
   %供给是否可靠
     B(:,4)=mean(data_test1'-data_test');  %指标3企业对供应商周平均订
   %index5 供应商平均波动
    C=[];
    for j=1:size(data_test1,1)  
        for m=1:size(data_test1,2)
        C(j,1)=sum(sqrt((data_test1(j,:)-mean(data_test1(j,:))).^2));
        end
    end
        B(:,5)=C;  %指标4得到供货的波动率
data_get=B;
%%
%最后求到的数据在数组B中然后都进行指标的正向化
%1,2 正向指标
%3,4,5 负向指标
%6 单点最优
%7 区间最优指标
zhibiao_label=[1,1,1,1,3];
data_last=jisuan(data_get,zhibiao_label);
%再标准化作用一下
[n,~]=size(data_last);
%Z=zscore(X);
A_data = data_last ./ repmat(sum(data_last.*data_last) .^ 0.5, n, 1); %矩阵归一化
%A的排序结果
% W=1/size(A_data,2)*ones(1,size(A_data,2));  %可以根据层次分析法求
panju=[1,3,1,5,1;
    1/3,1,1/2,1,1;
    1,2,1,1,1;
    1/5,1,1,1,1;
    1,1,1,1,1];
%层次分析法
[score_cengci,quan_cengci] = cengcifenxi(panju,A_data);
%熵权法
[Score_shangquan,quan_shang]=shangquanfa(A_data);
%变异系数法
% [Score_bianyi,quan_bianyi]=bianyixishu(A_data);
W=[quan_cengci,quan_shang'];   
Score_All=[score_cengci,Score_shangquan];
[~,R2] = corr(W,'type','Kendall'); 
R2(isnan(R2))=0;
R=R2(1,2:end);
W1=W';
if sum(R)<0.05*length(R)
    Wc=sum(W1)/sum(sum(W1));
    disp('一致性检验通过')
else
    disp('一致性检验不通过')
    the=std(W);  %矛盾性标准差计算
    r=corr(W);
    r(isnan(r))=0;%把NAN的元素都替换成0
    r(logical(eye(size(r))))=1;
    f=sum(1-r);%信息承载量
    c=the.*f;
    w=c/sum(c); %计算权重
    Wc1=w.*W;
    Wc=sum(Wc1');
end
%计算得分
s=A_data*Wc';
Score=100*s/max(s);

[AAA,BBB]=sort(Score,'descend');
data_resultA(:,1)= data_table1( BBB,1);
data_resultA(:,2)= data_table1( BBB,2);
data_resultA(:,3)= array2table(AAA);   %排序
data_resultA  %最后结果 
%%
% figure(1)
% plot(scoreA)
%%
mean_score_all=Score;
x_test=1:length(mean_score_all);
limit(1,:)=(mean(Score_All')-std(Score_All'))';
limit(2,:)=(mean(Score_All')+std(Score_All'))';
COLOR=[184  184  246]/255;
COLOR1=[207  155  255]/255;
COLOR2=[190  210  254]/255;
COLOR3=[184  184  246]/255;
h1=fill([x_test,fliplr(x_test)],[limit(1,:),fliplr(limit(2,:))],COLOR,'DisplayName','uncertain');
hold on
h1.FaceColor = COLOR;%定义区间的填充颜色      
h1.EdgeColor =[1,1,1];%边界颜色设置为白色
alpha .2   %设置透明色
plot(x_test,mean_score_all,'Color',COLOR1,'LineWidth',1,'DisplayName','prediction') 
hold on
plot(x_test,limit(1,:),'--','Color',COLOR2,'DisplayName','Lower  Limit')
hold on
plot(x_test,limit(2,:),'--','Color',COLOR3,'DisplayName','Upper  Limit')
hold on
legend('show','Location','Best');