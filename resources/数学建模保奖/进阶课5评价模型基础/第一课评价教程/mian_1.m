clc;clear;close all;
% 原始数据读入
data_table=readtable("银行数据.xlsx","VariableNamingRule","preserve");
%%
name_label=table2cell(data_table(:,2));
data_array=table2array(data_table(:,3:9));
%% 
%原始数据
data=[9	9	97	38
8	8	97	40
10	8	98	35
9	9	99	30
8	8	96	25];
%%  数据-评分
data1=data;
data1(:,2)=data(:,2).^2;
data1(:,4)=log(data(:,4));

%% 正向化处理
data2=data1;

data2(:,2)=max(data1(:,2))-data1(:,2);
% data2(:,2)=(max(data1(:,2))-data1(:,2))./(max(data1(:,2))-min(data1(:,2)));
% data2(:,2)=1./(data1(:,2)+max(abs(data1(:,2)))+(data1(:,2)));

data2(:,3)=1-abs(data1(:,3)-98)./max(abs(data1(:,3)-98));

qu=[3.4,3.6];
for i=1:size(data2,1)
    if  data2(i,4)>qu(1) && data2(i,4)<qu(2) 
        data2(i,4)=1;
    elseif  data2(i,4)<=qu(1)
        data2(i,4)=data1(i,4)/qu(1);
    else
        data2(i,4)=qu(2)/data1(i,4);
          
    end
end
%% 标准化处理
data3=zscore(data2)-min(zscore(data2));  %zscore
data3=mapminmax(data2',0,1)';  %maxminmap
data3=mapminmax(data2',0.002,1)';%标准化到0.002-1区间
%%  层次分析法
A=[1,1/2,1/3,1;2,1,2,3;1/2,1/2,1,3;1,1/3,1/3,1];

[n,m]=size(A);
%求特征值特征向量,找到最大特征值对应的特征向量
[V,D]=eig(A);    %求特征值和特征向量  D记录特征值  V代表特征向量
tzz=max(max(D));     %找到最大的特征值
c1=find(max(D)==tzz);%找到最大的特征值位置
tzx=V(:,c1);%最大特征值对应的特征向量
%赋权重
quan=zeros(n,1);
for i=1:n
quan(i,1)=tzx(i,1)/sum(tzx);
end
%%%
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

%显示出所有评分对象的评分值
 score=data3*Q;
 for i=1:length(score)
     name=['object_score',num2str(i)];
    eval([name,'=score(i)'])
 end

 
 %%  熵权法
%得到信息熵 
[m,n]=size(data3);
p=zeros(m,n);
for j=1:n
    p(:,j)=data3(:,j)/sum(data3(:,j));
end
for j=1:n
   E(j)=-1/log(m)*sum(p(:,j).*log(p(:,j)));
end
%计算权重
w=(1-E)/sum(1-E);
%计算得分
s=data3*w';
Score=100*s/max(s);
disp('评价对象分别得分为：')
disp(Score)
%% TOPSIS法
%得到加权重后的数据
% w=[0.3724, 0.1003,0.1991, 0.1991,0.0998,0.0485]; %使用求权重的方法求得
R=data3.*w;
%得到最大值和最小值距离
r_max=max(R);  %每个指标的最大值
r_min=min(R);  %每个指标的最小值
d_z = sqrt(sum([(R -repmat(r_max,size(R,1),1)).^2 ],2)) ;  %d+向量
d_f = sqrt(sum([(R -repmat(r_min,size(R,1),1)).^2 ],2)); %d-向量  
%sum(data,2)对行求和 ，sum(data）默认对列求和
%得到得分
s=d_f./(d_z+d_f );
Score=100*s/max(s);
for i=1:length(Score)
    fprintf('第%d个评价百分制评分为：%d\n',i,Score(i));   
end
%% 权重可视化 柱状图
W=[0.353196235935392	0.318583577036157	0.172569147635985	0.155651039392466];

%% 柱状图
% load('color_list.mat')
% color=color_list(1:6,:);
% color=[0.717647058823529,0.682352941176471,0.741176470588235;...
%     0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
%     0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
%     0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
%     0.372549019607843,0.282352941176471,0.600000000000000;0.0156862745098039,...
%     0.0196078431372549,0.0156862745098039];% 颜色数据
%
% color=[0.741176470588235,0.729411764705882,0.725490196078431;0.525490196078431,...
%     0.623529411764706,0.752941176470588;0.631372549019608,0.803921568627451,...
%     0.835294117647059;0.588235294117647,0.576470588235294,0.576470588235294;...
%     0.0745098039215686,0.407843137254902,0.607843137254902;0.454901960784314,...
%     0.737254901960784,0.776470588235294;0.0156862745098039,0.0196078431372549,0.0156862745098039];% 颜色

color=[    0.2667    0.6235    0.7098
    0.5333    0.8157    0.6510
    0.9961    0.9137    0.6078
    0.9922    0.7294    0.4157];

y=W;%柱状图纵坐标
x=1:length(W);     %柱状图横坐标

%%初始化显示位置 [x,y,dx,dy] 从 x,y坐标开始，dx,dy为沿升的长度
figure('Units', 'pixels', ...
    'Position', [200 200 460 275]);

width=0.7; %柱状图宽度 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(W); 
ax.XTickLabel={'指标1','指标2','指标3','指标4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y轴标签
% ax.YTick= 0:20:80;
% %y轴范围
% ax.YLim=[0,60];
%使得只显示x,y轴两根线
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("权重大小");

%% 加斜线的
figure('Units', 'pixels', ...
    'Position', [200 200 460 275]);

width=0.7; %柱状图宽度 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(W); 
ax.XTickLabel={'指标1','指标2','指标3','指标4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y轴标签
% ax.YTick= 0:20:80;
% %y轴范围
% ax.YLim=[0,60];
%使得只显示x,y轴两根线
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("权重大小");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');


%% 加斜线的
figure('Units', 'pixels', ...
    'Position', [200 200 560 375]);

width=0.7; %柱状图宽度 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h1(i)=barh(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%绘制虚线
xlabel('value')
ax = gca;
%x轴标签
ax.YTick = 1:length(W); 
ax.YTickLabel={'指标1','指标2','指标3','指标4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y轴标签
% ax.YTick= 0:20:80;
% %y轴范围
% ax.YLim=[0,60];
%使得只显示x,y轴两根线
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("权重大小");
hatchfill2(h1(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

%% 
figure
Label={'指标1','指标2','指标3','指标4'};
X = y;
pie(X,Label)
colormap([color])

%%
% load('color_list.mat')
% color=color_list(1:6,:);
% color=[0.717647058823529,0.682352941176471,0.741176470588235;...
%     0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
%     0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
%     0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
%     0.372549019607843,0.282352941176471,0.600000000000000;0.0156862745098039,...
%     0.0196078431372549,0.0156862745098039];% 颜色数据
%
% color=[0.741176470588235,0.729411764705882,0.725490196078431;0.525490196078431,...
%     0.623529411764706,0.752941176470588;0.631372549019608,0.803921568627451,...
%     0.835294117647059;0.588235294117647,0.576470588235294,0.576470588235294;...
%     0.0745098039215686,0.407843137254902,0.607843137254902;0.454901960784314,...
%     0.737254901960784,0.776470588235294;0.0156862745098039,0.0196078431372549,0.0156862745098039];% 颜色

color=[        0.2824    0.4824    0.5608
    0.4706    0.7176    0.7882
    0.9686    0.8824    0.5843
    0.8902    0.5569    0.4980
    0.5961    0.6941    0.0941];

y=score;%柱状图纵坐标
x=1:length(score);     %柱状图横坐标

%%初始化显示位置 [x,y,dx,dy] 从 x,y坐标开始，dx,dy为沿升的长度
figure('Units', 'pixels', ...
    'Position', [200 200 660 375]);
h=[];
width=0.7; %柱状图宽度 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width 柱状图宽占比  ，FaceColor 柱状图填充颜色 ，EdgeColor 柱状图边缘颜色
   % LineWidth  边缘线宽 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end
plot(y,'LineWidth',2)
hold on
%绘制虚线
ylabel('value')
ax = gca;
%x轴标签
ax.XTick = 1:length(y); 
ax.XTickLabel={'评价对象1','评价对象2','评价对象3','评价对象4','评价对象5',};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y轴标签
% ax.YTick= 0:20:80;
% %y轴范围
% ax.YLim=[0,60];
%使得只显示x,y轴两根线
box off
%坐标轴字体和大小
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("权重大小");

hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,5),'cross','HatchAngle',90,'HatchDensity',30,'HatchColor','k');