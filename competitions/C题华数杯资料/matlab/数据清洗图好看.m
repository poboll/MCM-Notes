% 定义 tab20c 颜色数组
tab20c = [
    0.192, 0.540, 0.749;  % 蓝色
    0.678, 0.847, 0.902;  % 浅蓝色
    0.239, 0.741, 0.392;  % 绿色
    0.598, 0.874, 0.541;  % 浅绿色
    1.000, 0.596, 0.588;  % 粉色
    1.000, 0.733, 0.471;  % 浅橙色
    0.988, 0.804, 0.898;  % 粉紫色
    0.749, 0.561, 0.561;  % 灰粉色
    0.992, 0.749, 0.435;  % 橙色
    0.894, 0.102, 0.110;  % 红色
];

% 读取数据
data = readtable('merged_data_with_source.csv', 'PreserveVariableNames', true);

% 数据预处理
data.Properties.VariableNames{'评分'} = 'Rating';
data = data(~(ismissing(data.Rating) | data.Rating == 0 | strcmp(data.Rating, '--')), :);

% 获取清理前后的评分分布
before_cleaning_counts = countcats(categorical(data.Rating));
before_cleaning_categories = categories(categorical(data.Rating));

% 清理数据
cleanedData = data(~(ismissing(data.Rating) | data.Rating == 0 | strcmp(data.Rating, '--')), :);
after_cleaning_counts = countcats(categorical(cleanedData.Rating));

% 对比图
figure;
b = bar([before_cleaning_counts, after_cleaning_counts], 'stacked');
set(gca, 'XTickLabel', before_cleaning_categories, 'XTickLabelRotation', 45);
xlabel('评分');
ylabel('频率');
title('清理前后的评分分布');

% 设置每个条形的颜色
for k = 1:length(b)
    b(k).FaceColor = 'flat';
    b(k).CData = tab20c(k,:);
end

% 添加图例
legend('清理前', '清理后', 'Location', 'northeastoutside');

% 添加数据标签
for k = 1:length(b)
    xtips = b(k).XEndPoints;
    ytips = b(k).YEndPoints;
    labels = string(b(k).YData);
    text(xtips, ytips, labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
end

% 保存图像
saveas(gcf, 'cleaning_process_comparison.png');
