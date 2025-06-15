% 读取数据
data = readtable('cleaned_data.csv', 'PreserveVariableNames', true);
% 输出所有列名
% disp(data.Properties.VariableNames);

% 将中文列名转换为英文（如果还没有转换）
% data.Properties.VariableNames{'名字'} = 'Name';
% data.Properties.VariableNames{'链接'} = 'Link';
% data.Properties.VariableNames{'地址'} = 'Address';
% data.Properties.VariableNames{'介绍'} = 'Introduction';
% data.Properties.VariableNames{'开放时间'} = 'OpenTime';
% data.Properties.VariableNames{'图片链接'} = 'ImageLink';
% data.Properties.VariableNames{'评分'} = 'Rating';
% data.Properties.VariableNames{'建议游玩时间'} = 'SuggestedPlayTime';
% data.Properties.VariableNames{'建议季节'} = 'SuggestedSeason';
% data.Properties.VariableNames{'门票'} = 'Ticket';
% data.Properties.VariableNames{'小贴士'} = 'Tips';
% data.Properties.VariableNames{'Page'} = 'Page';
% data.Properties.VariableNames{'来源城市'} = 'SourceCity';

% 找出最高评分
maxRating = max(data.Rating);

% 统计每个城市获得最高评分的景点数量
maxRatingData = data(data.Rating == maxRating, :);
cityCounts = groupcounts(maxRatingData, 'SourceCity');

% 按照景点数量降序排序
cityCounts = sortrows(cityCounts, 'GroupCount', 'descend');

% 提取前10个城市
top10Cities = cityCounts(1:10, :);

% 可视化前10个城市的结果
figure;
hold on;

% 获取 Pastel1 颜色
pastel1Colors = [ ...
    1.0000    0.6980    0.4980; % Light Red
    1.0000    0.7882    0.7882; % Light Pink
    1.0000    0.8784    0.7020; % Light Yellow
    0.7490    0.8490    0.8490; % Light Cyan
    0.6471    0.7647    0.6471; % Light Green
    0.7647    0.7647    0.7647; % Light Gray
    1.0000    0.8471    0.6980; % Light Orange
    1.0000    0.9490    0.8824; % Light Peach
    0.9490    0.9490    1.0000; % Light Blue
    1.0000    1.0000    0.8980  % Light Cream
];

% 确保颜色数量与前10个城市匹配
colors = pastel1Colors(1:height(top10Cities), :);

% 绘制柱状图
bars = bar(top10Cities.GroupCount, 'FaceColor', 'flat');

% 为每个柱子指定 Pastel1 颜色
bars.CData = colors;

% 在每个柱子上添加数量标签
for i = 1:numel(bars)
    text(bars(i).XEndPoints, bars(i).YEndPoints, num2str(bars(i).YData'), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontSize', 10, 'Color', 'k');
end

% 设置图表标题和轴标签
title('得分最高的十大景点城市', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');
xlabel('城市', 'FontSize', 14, 'FontName', 'Microsoft YaHei');
ylabel('景点数量', 'FontSize', 14, 'FontName', 'Microsoft YaHei');

% 设置X轴刻度标签
set(gca, 'XTick', 1:height(top10Cities), 'XTickLabel', top10Cities.SourceCity, 'XTickLabelRotation', 45, 'FontSize', 12, 'FontName', 'Microsoft YaHei');

% 添加图例
legend('景点数量', 'Location', 'northeastoutside', 'FontSize', 12, 'FontName', 'Microsoft YaHei');

% 设置背景颜色
set(gca, 'Color', [0.95, 0.95, 0.95]);

% 添加网格线
grid on;

% 调整柱子边缘的颜色（增强视觉效果）
set(findobj(gca, 'Type', 'Bar'), 'EdgeColor', 'k');

% 显示最高评分和全国获评这个最高评分的景点数量
disp(['最高评分为: ', num2str(maxRating)]);
disp(['全国获评最高评分的景点数量为: ', num2str(height(maxRatingData))]);

% 保存图表为图片文件
saveas(gcf, 'top10_cities_highest_score.png');

% 保存前10个城市的表格到文件
writetable(top10Cities, 'top10_cities_highest_score.csv');

% 饼图
% 计算前十个城市评分景点数量的总数
totalTop10Count = sum(top10Cities.GroupCount);

% 计算前十个城市内部的百分比
percentages = (top10Cities.GroupCount / totalTop10Count) * 100;

% 绘制饼图并获取每个扇区的数据
figure;
p = pie(top10Cities.GroupCount); % 仅绘制景点数量

% 确保颜色数量与前10个城市匹配
colors = pastel1Colors(1:height(top10Cities), :);

% 为每个饼图分块指定 Pastel1 颜色
for i = 1:2:length(p) % 饼图的每个扇区元素是两部分，奇数部分是扇区，偶数部分是标签
    p(i).FaceColor = colors(ceil(i/2), :);
end

% 在扇区内部显示百分比，并在扇区外显示城市名字
for i = 1:2:length(p)
    % 获取当前扇区的顶点位置
    pos = p(i+1).Position;
    
    % 计算扇区内部的中间位置，用于显示百分比
    midPos = pos * 0.6;  % 缩小到60%，使百分比更靠近圆心
    
    % 显示百分比在扇区内部
    percentageText = [num2str(percentages(ceil(i/2)), '%.2f'), '%'];
    text(midPos(1), midPos(2), percentageText, 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'FontName', 'Microsoft YaHei');
    
    % 在扇区外部显示城市名字
    cityName = top10Cities.SourceCity{ceil(i/2)};
    p(i+1).String = cityName;  % 只显示城市名，不再显示百分比
    p(i+1).FontSize = 10;
    p(i+1).FontName = 'Microsoft YaHei';
    p(i+1).FontWeight = 'bold';
end

% 设置图表标题
title('前十个城市最高评分景点数量占比', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Microsoft YaHei');

% 添加图例
legend(top10Cities.SourceCity, 'Location', 'bestoutside', 'FontSize', 12, 'FontName', 'Microsoft YaHei');
