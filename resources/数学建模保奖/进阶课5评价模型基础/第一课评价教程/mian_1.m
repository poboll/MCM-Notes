clc;clear;close all;
% ԭʼ���ݶ���
data_table=readtable("��������.xlsx","VariableNamingRule","preserve");
%%
name_label=table2cell(data_table(:,2));
data_array=table2array(data_table(:,3:9));
%% 
%ԭʼ����
data=[9	9	97	38
8	8	97	40
10	8	98	35
9	9	99	30
8	8	96	25];
%%  ����-����
data1=data;
data1(:,2)=data(:,2).^2;
data1(:,4)=log(data(:,4));

%% ���򻯴���
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
%% ��׼������
data3=zscore(data2)-min(zscore(data2));  %zscore
data3=mapminmax(data2',0,1)';  %maxminmap
data3=mapminmax(data2',0.002,1)';%��׼����0.002-1����
%%  ��η�����
A=[1,1/2,1/3,1;2,1,2,3;1/2,1/2,1,3;1,1/3,1/3,1];

[n,m]=size(A);
%������ֵ��������,�ҵ��������ֵ��Ӧ����������
[V,D]=eig(A);    %������ֵ����������  D��¼����ֵ  V������������
tzz=max(max(D));     %�ҵ���������ֵ
c1=find(max(D)==tzz);%�ҵ���������ֵλ��
tzx=V(:,c1);%�������ֵ��Ӧ����������
%��Ȩ��
quan=zeros(n,1);
for i=1:n
quan(i,1)=tzx(i,1)/sum(tzx);
end
%%%
Q=quan;
%һ���Լ���
CI=(tzz-n)/(n-1);
RI=[0,0,0.58,0.9,1.12,1.24,1.32,1.41,1.45,1.49,1.52,1.54,1.56,1.58,1.59];
%�ж��Ƿ�ͨ��һ���Լ���
CR=CI/RI(1,n);
if CR>=0.1
   fprintf('û��ͨ��һ���Լ���\n');
else
  fprintf('ͨ��һ���Լ���\n');
end

%��ʾ���������ֶ��������ֵ
 score=data3*Q;
 for i=1:length(score)
     name=['object_score',num2str(i)];
    eval([name,'=score(i)'])
 end

 
 %%  ��Ȩ��
%�õ���Ϣ�� 
[m,n]=size(data3);
p=zeros(m,n);
for j=1:n
    p(:,j)=data3(:,j)/sum(data3(:,j));
end
for j=1:n
   E(j)=-1/log(m)*sum(p(:,j).*log(p(:,j)));
end
%����Ȩ��
w=(1-E)/sum(1-E);
%����÷�
s=data3*w';
Score=100*s/max(s);
disp('���۶���ֱ�÷�Ϊ��')
disp(Score)
%% TOPSIS��
%�õ���Ȩ�غ������
% w=[0.3724, 0.1003,0.1991, 0.1991,0.0998,0.0485]; %ʹ����Ȩ�صķ������
R=data3.*w;
%�õ����ֵ����Сֵ����
r_max=max(R);  %ÿ��ָ������ֵ
r_min=min(R);  %ÿ��ָ�����Сֵ
d_z = sqrt(sum([(R -repmat(r_max,size(R,1),1)).^2 ],2)) ;  %d+����
d_f = sqrt(sum([(R -repmat(r_min,size(R,1),1)).^2 ],2)); %d-����  
%sum(data,2)������� ��sum(data��Ĭ�϶������
%�õ��÷�
s=d_f./(d_z+d_f );
Score=100*s/max(s);
for i=1:length(Score)
    fprintf('��%d�����۰ٷ�������Ϊ��%d\n',i,Score(i));   
end
%% Ȩ�ؿ��ӻ� ��״ͼ
W=[0.353196235935392	0.318583577036157	0.172569147635985	0.155651039392466];

%% ��״ͼ
% load('color_list.mat')
% color=color_list(1:6,:);
% color=[0.717647058823529,0.682352941176471,0.741176470588235;...
%     0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
%     0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
%     0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
%     0.372549019607843,0.282352941176471,0.600000000000000;0.0156862745098039,...
%     0.0196078431372549,0.0156862745098039];% ��ɫ����
%
% color=[0.741176470588235,0.729411764705882,0.725490196078431;0.525490196078431,...
%     0.623529411764706,0.752941176470588;0.631372549019608,0.803921568627451,...
%     0.835294117647059;0.588235294117647,0.576470588235294,0.576470588235294;...
%     0.0745098039215686,0.407843137254902,0.607843137254902;0.454901960784314,...
%     0.737254901960784,0.776470588235294;0.0156862745098039,0.0196078431372549,0.0156862745098039];% ��ɫ

color=[    0.2667    0.6235    0.7098
    0.5333    0.8157    0.6510
    0.9961    0.9137    0.6078
    0.9922    0.7294    0.4157];

y=W;%��״ͼ������
x=1:length(W);     %��״ͼ������

%%��ʼ����ʾλ�� [x,y,dx,dy] �� x,y���꿪ʼ��dx,dyΪ�����ĳ���
figure('Units', 'pixels', ...
    'Position', [200 200 460 275]);

width=0.7; %��״ͼ��� 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(W); 
ax.XTickLabel={'ָ��1','ָ��2','ָ��3','ָ��4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y���ǩ
% ax.YTick= 0:20:80;
% %y�᷶Χ
% ax.YLim=[0,60];
%ʹ��ֻ��ʾx,y��������
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("Ȩ�ش�С");

%% ��б�ߵ�
figure('Units', 'pixels', ...
    'Position', [200 200 460 275]);

width=0.7; %��״ͼ��� 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(W); 
ax.XTickLabel={'ָ��1','ָ��2','ָ��3','ָ��4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y���ǩ
% ax.YTick= 0:20:80;
% %y�᷶Χ
% ax.YLim=[0,60];
%ʹ��ֻ��ʾx,y��������
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("Ȩ�ش�С");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');


%% ��б�ߵ�
figure('Units', 'pixels', ...
    'Position', [200 200 560 375]);

width=0.7; %��״ͼ��� 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h1(i)=barh(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
xlabel('value')
ax = gca;
%x���ǩ
ax.YTick = 1:length(W); 
ax.YTickLabel={'ָ��1','ָ��2','ָ��3','ָ��4'};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y���ǩ
% ax.YTick= 0:20:80;
% %y�᷶Χ
% ax.YLim=[0,60];
%ʹ��ֻ��ʾx,y��������
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("Ȩ�ش�С");
hatchfill2(h1(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h1(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

%% 
figure
Label={'ָ��1','ָ��2','ָ��3','ָ��4'};
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
%     0.0196078431372549,0.0156862745098039];% ��ɫ����
%
% color=[0.741176470588235,0.729411764705882,0.725490196078431;0.525490196078431,...
%     0.623529411764706,0.752941176470588;0.631372549019608,0.803921568627451,...
%     0.835294117647059;0.588235294117647,0.576470588235294,0.576470588235294;...
%     0.0745098039215686,0.407843137254902,0.607843137254902;0.454901960784314,...
%     0.737254901960784,0.776470588235294;0.0156862745098039,0.0196078431372549,0.0156862745098039];% ��ɫ

color=[        0.2824    0.4824    0.5608
    0.4706    0.7176    0.7882
    0.9686    0.8824    0.5843
    0.8902    0.5569    0.4980
    0.5961    0.6941    0.0941];

y=score;%��״ͼ������
x=1:length(score);     %��״ͼ������

%%��ʼ����ʾλ�� [x,y,dx,dy] �� x,y���꿪ʼ��dx,dyΪ�����ĳ���
figure('Units', 'pixels', ...
    'Position', [200 200 660 375]);
h=[];
width=0.7; %��״ͼ��� 0~1
for  i=1:length(y)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,y(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end
plot(y,'LineWidth',2)
hold on
%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(y); 
ax.XTickLabel={'���۶���1','���۶���2','���۶���3','���۶���4','���۶���5',};
% set(gca,'XTickLabel',{['\color[rgb]{',num2str(color(4,:)) ,'}','Pre-Injection'],['\color[rgb]{',num2str(color(5,:)) ,'}','1 hr CFA'] , ['\color[rgb]{',num2str(color(6,:)) ,'}','1wk CFA']},"LineWidth",2);
% %y���ǩ
% ax.YTick= 0:20:80;
% %y�᷶Χ
% ax.YLim=[0,60];
%ʹ��ֻ��ʾx,y��������
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",12,"LineWidth",2)
title("Ȩ�ش�С");

hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,5),'cross','HatchAngle',90,'HatchDensity',30,'HatchColor','k');