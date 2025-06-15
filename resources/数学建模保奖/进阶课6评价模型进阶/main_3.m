clc;clear;close all
data_table=readtable("银行数据.xlsx","VariableNamingRule","preserve");
%%
name_label=table2cell(data_table(:,2));
%%
data_array=table2array(data_table(:,3:9));

%%  数据-评分
data1=data_array;
data1(:,2)=data_array(:,2).^2;    % .^2    .*   .^2
data1(:,4)=log(data_array(:,4));

%% 正向化处理
data2=data1;

data2(:,2)=max(data1(:,2))-data1(:,2);  %max([1,3,5])
% data2(:,2)=(max(data1(:,2))-data1(:,2))./(max(data1(:,2))-min(data1(:,2)));
% data2(:,2)=1./(data1(:,2)+max(abs(data1(:,2)))+(data1(:,2)));
% a=98;
% data2(:,3)=1-abs(data1(:,3)-a)./max(abs(data1(:,3)-a));
%%
data3=zscore(data2)-min(zscore(data2));  %zscore
data3=mapminmax(data2',0,1)';  %maxminmap
data3=mapminmax(data2',0.002,1)';%标准化到0.002-1区间

the=std(data3);
%%矛盾性
r=corr(data3);%计算指标间的相关系数
f=sum(1-r);
%%信息承载量
c=the.*f;
%计算权重
w=c/sum(c);
Q3=w;
%% 用评价权重函数
% pangju=[1,1/2,1/3,1;2,1,2,3;3,1/2,1,3;1,1/3,1/3,1];
pangju=ones(size(data3,2),size(data3,2));
pangju(2,3)=2;pangju(3,2)=1/2;

[P_ceng,Q_ceng]=cengcifenxi(pangju,data3);
[P_shang,Q_shang]=shangquanfa(data3);
W=[Q_ceng,Q_shang'];
%% 检验+权重计算
[~,R2] = corr(W,'type','Kendall'); %计算Kendall相关系数
R2(isnan(R2))=0;
R=R2(1,2:end);

if sum(R)<0.05*length(R)
    % 表示在各个方法得到权重结果相差不大时候，直接指标求平均
    W1=W';
    Wc=sum(W1)/sum(sum(W1));
        
else
    % 表示在各个方法得到权重结果相差大时候，用CRITIC法对权重 再计算权重
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

%%  组合博弈
% W_s=W';
% W1=[];P=[];
% for i=1:size(W_s,1)   %构造权重矩阵
%     for j=1:size(W_s,1)
% 
%         W1(i,j)=W_s(i,:)*W_s(j,:)';  %左边矩阵
% 
%     end
%     P(i,1)=W_s(i,:)*W_s(i,:)';       %右边矩阵
% end
% 
% A=(W1)^(-1)*P;  %求解优化问题，求解组合系数
% if min(A)<0    %避免组合系数为负数导致权重为负的情况
%     A1=(A-min(A))/(sum((A-min(A))));
% else
%     A1=A;  
% end
% 
% W2=A1'*W_s;    
% Wc=W2/sum(W2);   %最终的组合权重
%%  多个权重可视化  子图的绘制
%设置颜色
color=[    0.0588    0.5216    0.5176
    0.8039    0.8980    0.8902
    0.5176    0.0275    0.5059
    0.8941    0.8039    0.8863
    0.4902    0.7059    0.8471
    0.9647    0.6314    0.3059
    0.8941    0.8000    0.5725
    0.717647058823529,0.682352941176471,0.741176470588235;...
    0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
    0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
    0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
    0.372549019607843,0.282352941176471,0.600000000000000;0.6156862745098039,...
    0.2196078431372549,0.0156862745098039];% 颜色数据

%定义布局 
  figure('Units', 'pixels', ...
    'Position', [200 200 760 475]);
  
subplot(2,2,1)  %2*2的布局

% Q_ceng,Q_shang
Q=Q_ceng;     %
width=0.7; %柱状图宽度 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("层次分析法权重大小");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

subplot(2,2,2)  %2*2的布局

Q=Q_shang;     %
width=0.7; %柱状图宽度 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("熵权法权重大小");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

subplot(2,2,3)  %2*2的布局

Q=Wc;     %
width=0.7; %柱状图宽度 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("组合权重大小");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');


%% 随机权重评价方法
[P_shang,Q_shang]=shangquanfa(data3);
W0=Q_shang;        %直接设定一个初始权重
%接下来可以在初始权重的基础上变换
S_num=100;           %设定的随机次数
W=W0;
W1=[];
for n=1:S_num       %接下了对权重随机变换，可以自定义随机策略，这里是对权重前面的元素在原来基础上相加减，再用1减去前面之和
    for i=1:size(W,2)-1
        rand1=rand(1)*0.5*max(W);
        rand2=rand(1);
        if(rand2>0.5)
            rand1=W(i)-rand1;
        else
            rand1=W(i)+rand1;
        end
        W1(i)=rand1;

    end
    W2=W1;
    W2(length(W))=1-sum(W1);
    if  min(W2) <0     %保证不会随机出现为0的权重
        W2=W2-min(W2);
    end
    W_all(n,:)=W2;  %记录很多权重
end
%Topsis法进行评分
for N=1: size(W_all,1)
    W_get=W_all(N,:)/sum(W_all(N,:));    %再一次保证权重和为1
    score_all(:,N)=TOPSIS(data3,W_get);
end
score=mean(score_all');       %求随机权重的均值
std_score_all=std(score_all');
score_L=score-std_score_all;   %求随机权重的上限
score_H=score+std_score_all;  %求随机权重的下限
%% 接下来对很多组权重可视化

color_list=[0.717647058823529,0.682352941176471,0.741176470588235;...
    0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
    0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
    0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
    0.372549019607843,0.282352941176471,0.600000000000000;0.0156862745098039,...
    0.0196078431372549,0.0156862745098039];% 颜色数据;
figure('Position',[200,200,800,400])
W_plot_quan=W_all;
subplot(1,2,1)
for i=1:size(W_plot_quan,1)
    plot(W_plot_quan(i,:))
    hold on
end
ylabel('权重')
set(gca,'LineWidth',1.2)
box off
xticks([1:size(W_plot_quan,2)])
mean_quan=mean(W_plot_quan);  %权重均值
std_quan=std(W_plot_quan);
L_quan=mean_quan-std_quan;   %权重上限
H_quan=mean_quan+std_quan;  %权重下限

subplot(1,2,2)

    h1=fill(gca,[1:length(mean_quan),fliplr(1:length(mean_quan))],[L_quan,fliplr(H_quan)],'r');
    hold (gca,'on')
    h1.FaceColor = color_list(1,:);%定义区间的填充颜色
    h1.EdgeColor =[1,1,1];%边界颜色设置为白色
    hold on
    alpha (gca,0.3)   %设置透明色
    plot(gca,1:length(mean_quan), mean_quan,'-*','Color',color_list(1,:),'LineWidth',1.2,'MarkerSize',3)
    hold on

xticks([1:size(W_plot_quan,2)])
ylabel('权重')
set(gca,'LineWidth',1.2)
box off

%%
figure
    h1=fill(gca,[1:length(score),fliplr(1:length(score))],[score_L,fliplr(score_H)],'r');
    hold (gca,'on')
    h1.FaceColor = color_list(1,:);%定义区间的填充颜色
    h1.EdgeColor =[1,1,1];%边界颜色设置为白色
    hold on
    alpha (gca,0.3)   %设置透明色
    plot(gca,1:length(score), score,'-*','Color',color_list(1,:),'LineWidth',1.2,'MarkerSize',3)
    hold on

xticks([1:length(score)])
ylabel('评分')
xlabel('评价对象')
set(gca,'LineWidth',1.2)
box off