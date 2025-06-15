% 加载数据，并保留原始列标题
opts = detectImportOptions('merged_data_with_source.csv');
opts.VariableNamingRule = 'preserve';
data = readtable('merged_data_with_source.csv', opts);

% 使用 varfun 和 @(x) numel(x) 来计算每个城市的景点数量
cityCounts = varfun(@(x) numel(x), data, 'GroupingVariables', '来源城市', 'InputVariables', '名字');

% 调整列名，如果需要
cityCounts.Properties.VariableNames{'GroupCount'} = 'Count';

% 仅选择前100个城市，保持原始顺序
cityCountsTop100 = head(cityCounts, 150);

% 自定义颜色方案（仿照 tab20c 配色）
customColors = [
    0.1922, 0.5098, 0.7412;  % 蓝色
    0.1922, 0.5098, 0.7412;  % 浅蓝色
    ...
];

% 绘制柱状图
figure;
b = bar(cityCountsTop100.Count, 'FaceColor', 'flat');

% 将每个柱子设置为不同的颜色
for k = 1:length(b.CData)
    b.CData(k, :) = customColors(mod(k-1, size(customColors, 1)) + 1, :);
end

% 添加标题和轴标签
title('景点数量统计');
xlabel('城市');
ylabel('景点数量');

% 设置X轴的刻度标签
xticks(1:length(cityCountsTop100.("来源城市")));
xticklabels(cityCountsTop100.("来源城市"));
xtickangle(45); % 倾斜标签以便阅读

% 动态调整y轴范围
maxCount = max(cityCountsTop100.Count);
ylim([0 maxCount + 0.1 * maxCount]);  % 留出10%的空间以防数据顶部被切断

% 显示图形
grid on;
legend('show');
