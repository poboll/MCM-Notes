clc;clear;close all
data_table=readtable("��������.xlsx","VariableNamingRule","preserve");
%%
name_label=table2cell(data_table(:,2));
%%
data_array=table2array(data_table(:,3:9));

%%  ����-����
data1=data_array;
data1(:,2)=data_array(:,2).^2;    % .^2    .*   .^2
data1(:,4)=log(data_array(:,4));

%% ���򻯴���
data2=data1;

data2(:,2)=max(data1(:,2))-data1(:,2);  %max([1,3,5])
% data2(:,2)=(max(data1(:,2))-data1(:,2))./(max(data1(:,2))-min(data1(:,2)));
% data2(:,2)=1./(data1(:,2)+max(abs(data1(:,2)))+(data1(:,2)));
% a=98;
% data2(:,3)=1-abs(data1(:,3)-a)./max(abs(data1(:,3)-a));
%%
data3=zscore(data2)-min(zscore(data2));  %zscore
data3=mapminmax(data2',0,1)';  %maxminmap
data3=mapminmax(data2',0.002,1)';%��׼����0.002-1����

the=std(data3);
%%ì����
r=corr(data3);%����ָ�������ϵ��
f=sum(1-r);
%%��Ϣ������
c=the.*f;
%����Ȩ��
w=c/sum(c);
Q3=w;
%% ������Ȩ�غ���
% pangju=[1,1/2,1/3,1;2,1,2,3;3,1/2,1,3;1,1/3,1/3,1];
pangju=ones(size(data3,2),size(data3,2));
pangju(2,3)=2;pangju(3,2)=1/2;

[P_ceng,Q_ceng]=cengcifenxi(pangju,data3);
[P_shang,Q_shang]=shangquanfa(data3);
W=[Q_ceng,Q_shang'];
%% ����+Ȩ�ؼ���
[~,R2] = corr(W,'type','Kendall'); %����Kendall���ϵ��
R2(isnan(R2))=0;
R=R2(1,2:end);

if sum(R)<0.05*length(R)
    % ��ʾ�ڸ��������õ�Ȩ�ؽ������ʱ��ֱ��ָ����ƽ��
    W1=W';
    Wc=sum(W1)/sum(sum(W1));
        
else
    % ��ʾ�ڸ��������õ�Ȩ�ؽ������ʱ����CRITIC����Ȩ�� �ټ���Ȩ��
    the=std(W);  %ì���Ա�׼�����
    r=corr(W);
    r(isnan(r))=0;%��NAN��Ԫ�ض��滻��0
    r(logical(eye(size(r))))=1;
    f=sum(1-r);%��Ϣ������
    c=the.*f;
    w=c/sum(c); %����Ȩ��
    Wc1=w.*W;
    Wc=sum(Wc1');
end

%%  ��ϲ���
% W_s=W';
% W1=[];P=[];
% for i=1:size(W_s,1)   %����Ȩ�ؾ���
%     for j=1:size(W_s,1)
% 
%         W1(i,j)=W_s(i,:)*W_s(j,:)';  %��߾���
% 
%     end
%     P(i,1)=W_s(i,:)*W_s(i,:)';       %�ұ߾���
% end
% 
% A=(W1)^(-1)*P;  %����Ż����⣬������ϵ��
% if min(A)<0    %�������ϵ��Ϊ��������Ȩ��Ϊ�������
%     A1=(A-min(A))/(sum((A-min(A))));
% else
%     A1=A;  
% end
% 
% W2=A1'*W_s;    
% Wc=W2/sum(W2);   %���յ����Ȩ��
%%  ���Ȩ�ؿ��ӻ�  ��ͼ�Ļ���
%������ɫ
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
    0.2196078431372549,0.0156862745098039];% ��ɫ����

%���岼�� 
  figure('Units', 'pixels', ...
    'Position', [200 200 760 475]);
  
subplot(2,2,1)  %2*2�Ĳ���

% Q_ceng,Q_shang
Q=Q_ceng;     %
width=0.7; %��״ͼ��� 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("��η�����Ȩ�ش�С");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

subplot(2,2,2)  %2*2�Ĳ���

Q=Q_shang;     %
width=0.7; %��״ͼ��� 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("��Ȩ��Ȩ�ش�С");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');

subplot(2,2,3)  %2*2�Ĳ���

Q=Wc;     %
width=0.7; %��״ͼ��� 0~1
for  i=1:length(Q)
   %bar(i,y(i),width) width ��״ͼ��ռ��  ��FaceColor ��״ͼ�����ɫ ��EdgeColor ��״ͼ��Ե��ɫ
   % LineWidth  ��Ե�߿� 
   h(i)=bar(i,Q(i),width,'FaceColor',color(i,:),'EdgeColor',color(i,:),'LineWidth',2);
   hold on
end

%��������
ylabel('value')
ax = gca;
%x���ǩ
ax.XTick = 1:length(Q); 
ax.XTickLabel=name_label;
box off
%����������ʹ�С
% set(gca,"FontName","Times New Roman","FontSize",12,"LineWidth",2)
set(gca,"FontSize",11,"LineWidth",1.2)
title("���Ȩ�ش�С");
hatchfill2(h(1,1),'cross','HatchAngle',45,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,2),'single','HatchAngle',60,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,3),'single','HatchAngle',0,'HatchDensity',30,'HatchColor','k');
hatchfill2(h(1,4),'single','HatchAngle',-45,'HatchDensity',30,'HatchColor','k');


%% ���Ȩ�����۷���
[P_shang,Q_shang]=shangquanfa(data3);
W0=Q_shang;        %ֱ���趨һ����ʼȨ��
%�����������ڳ�ʼȨ�صĻ����ϱ任
S_num=100;           %�趨���������
W=W0;
W1=[];
for n=1:S_num       %�����˶�Ȩ������任�������Զ���������ԣ������Ƕ�Ȩ��ǰ���Ԫ����ԭ����������Ӽ�������1��ȥǰ��֮��
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
    if  min(W2) <0     %��֤�����������Ϊ0��Ȩ��
        W2=W2-min(W2);
    end
    W_all(n,:)=W2;  %��¼�ܶ�Ȩ��
end
%Topsis����������
for N=1: size(W_all,1)
    W_get=W_all(N,:)/sum(W_all(N,:));    %��һ�α�֤Ȩ�غ�Ϊ1
    score_all(:,N)=TOPSIS(data3,W_get);
end
score=mean(score_all');       %�����Ȩ�صľ�ֵ
std_score_all=std(score_all');
score_L=score-std_score_all;   %�����Ȩ�ص�����
score_H=score+std_score_all;  %�����Ȩ�ص�����
%% �������Ժܶ���Ȩ�ؿ��ӻ�

color_list=[0.717647058823529,0.682352941176471,0.741176470588235;...
    0.807843137254902,0.792156862745098,0.890196078431373;0.580392156862745,...
    0.525490196078431,0.729411764705882;0.392156862745098,0.345098039215686,...
    0.470588235294118;0.560784313725490,0.533333333333333,0.741176470588235;...
    0.372549019607843,0.282352941176471,0.600000000000000;0.0156862745098039,...
    0.0196078431372549,0.0156862745098039];% ��ɫ����;
figure('Position',[200,200,800,400])
W_plot_quan=W_all;
subplot(1,2,1)
for i=1:size(W_plot_quan,1)
    plot(W_plot_quan(i,:))
    hold on
end
ylabel('Ȩ��')
set(gca,'LineWidth',1.2)
box off
xticks([1:size(W_plot_quan,2)])
mean_quan=mean(W_plot_quan);  %Ȩ�ؾ�ֵ
std_quan=std(W_plot_quan);
L_quan=mean_quan-std_quan;   %Ȩ������
H_quan=mean_quan+std_quan;  %Ȩ������

subplot(1,2,2)

    h1=fill(gca,[1:length(mean_quan),fliplr(1:length(mean_quan))],[L_quan,fliplr(H_quan)],'r');
    hold (gca,'on')
    h1.FaceColor = color_list(1,:);%��������������ɫ
    h1.EdgeColor =[1,1,1];%�߽���ɫ����Ϊ��ɫ
    hold on
    alpha (gca,0.3)   %����͸��ɫ
    plot(gca,1:length(mean_quan), mean_quan,'-*','Color',color_list(1,:),'LineWidth',1.2,'MarkerSize',3)
    hold on

xticks([1:size(W_plot_quan,2)])
ylabel('Ȩ��')
set(gca,'LineWidth',1.2)
box off

%%
figure
    h1=fill(gca,[1:length(score),fliplr(1:length(score))],[score_L,fliplr(score_H)],'r');
    hold (gca,'on')
    h1.FaceColor = color_list(1,:);%��������������ɫ
    h1.EdgeColor =[1,1,1];%�߽���ɫ����Ϊ��ɫ
    hold on
    alpha (gca,0.3)   %����͸��ɫ
    plot(gca,1:length(score), score,'-*','Color',color_list(1,:),'LineWidth',1.2,'MarkerSize',3)
    hold on

xticks([1:length(score)])
ylabel('����')
xlabel('���۶���')
set(gca,'LineWidth',1.2)
box off