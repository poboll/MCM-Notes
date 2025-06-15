% 读取数据
data = readtable('问题二数据集.xlsx', 'VariableNamingRule', 'preserve');

% 数据清洗和预处理
data = rmmissing(data); % 删除缺失值

% 分类
city_scale = data{:, {'线路密度 (km/km²)', '高速公路里程 (km)', '机场航班数量'}};
environment = data{:, {'AQI', '绿化覆盖率 (%)', '废水处理率 (%)', '废气处理率 (%)', '垃圾分类处理率 (%)'}};
culture = data{:, {'历史遗迹数量', '博物馆数量', '文化活动频次', '文化设施数量'}};
transport = data{:, {'公共交通覆盖率 (%)', '线路密度 (km/km²)'}};
climate = data{:, {'年平均气温 (℃)', '年降水量 (mm)', '适宜旅游天数', '空气湿度 (%)'}};
food = data{:, {'餐馆数量', '特色美食数量', '美食活动频次'}};

% KMO检验和降维
categories = {city_scale, environment, culture, transport, climate, food};
category_names = {'City Scale', 'Environment', 'Culture', 'Transport', 'Climate', 'Food'};
scores = zeros(size(data, 1), length(categories));

for i = 1:length(categories)
    category = categories{i};
    kmoValue = kmo_test(category);
    
    if kmoValue > 0.6 % 假设通过KMO检验的阈值为0.6
        [~, score] = pca(category);
        scores(:, i) = score(:, 1);
    else
        % 使用基于熵权法的TOPSIS降维
        normalized_category = zscore(category);
        entropy = -sum(normalized_category .* log(normalized_category + eps)) / log(size(normalized_category, 1));
        weights = (1 - entropy) / sum(1 - entropy);
        ideal_solution = max(normalized_category);
        negative_solution = min(normalized_category);
        distance_to_ideal = sqrt(sum((normalized_category - ideal_solution).^2, 2));
        distance_to_negative = sqrt(sum((normalized_category - negative_solution).^2, 2));
        topsis_score = distance_to_negative ./ (distance_to_ideal + distance_to_negative);
        scores(:, i) = topsis_score;
    end
    
    % 可视化降维结果
    figure;
    
    % 定义渐变色（深蓝色到淡蓝色）
    startColor = [0, 0, 0.5]; % 深蓝色
    endColor = [0.678, 0.847, 0.902]; % 淡蓝色
    n = length(score(:, 1)); % 数据点数量
    gradientColors = [linspace(startColor(1), endColor(1), n)', ...
                      linspace(startColor(2), endColor(2), n)', ...
                      linspace(startColor(3), endColor(3), n)'];

    % 创建 bar 图
    b = bar(score(:, 1));
    % 设置 bar 图颜色
    b.FaceColor = 'flat';
    b.CData = gradientColors; % 应用渐变色

    if kmoValue > 0.6
        title(['PCA降维结果 - ', category_names{i}]);
    else
        b = bar(topsis_score);
        b.FaceColor = 'flat';
        b.CData = gradientColors; % 应用渐变色
        title(['TOPSIS降维结果 - ', category_names{i}]);
    end
    xlabel('城市指数');
    ylabel('评分');
    grid on;
    saveas(gcf, ['dimensionality_reduction_', category_names{i}, '.png']);
end

% 综合评价模型构建（熵权法的TOPSIS）
normalized_data = zscore(scores);
entropy = -sum(normalized_data .* log(normalized_data + eps)) / log(size(normalized_data, 1));
weights = (1 - entropy) / sum(1 - entropy);
ideal_solution = max(normalized_data);
negative_solution = min(normalized_data);
distance_to_ideal = sqrt(sum((normalized_data - ideal_solution).^2, 2));
distance_to_negative = sqrt(sum((normalized_data - negative_solution).^2, 2));
topsis_score = distance_to_negative ./ (distance_to_ideal + distance_to_negative);

% 选出前50个城市
[~, sorted_index] = sort(topsis_score, 'descend');
top50_cities = data(sorted_index(1:50), :);

% 创建一个新的图形窗口
figure;

% 获取城市名称并转换为单元数组，以便在图表中使用
city_names = top50_cities.('来源城市');
city_names_cell = cellstr(city_names);

% 绘制渐变色柱状图
b = bar(topsis_score(sorted_index(1:50)));
b.FaceColor = 'flat';

% 稍微调整渐变色使其略浅一点
startColor7 = [0, 0, 0.5]; % 深蓝色
endColor7 = [0.729, 0.894, 0.945]; % 稍浅的蓝色
n = length(topsis_score(sorted_index(1:50))); % 数据点数量
gradientColors7 = [linspace(startColor7(1), endColor7(1), n)', ...
                    linspace(startColor7(2), endColor7(2), n)', ...
                    linspace(startColor7(3), endColor7(3), n)'];

b.CData = gradientColors7; % 应用稍浅的渐变色

% 设置X轴刻度标签并旋转
set(gca, 'XTick', 1:50, 'XTickLabel', city_names_cell, 'XTickLabelRotation', 45);

% 设置图表标题和轴标签
title('最令外国游客向往的50个城市综合评分');
xlabel('城市');
ylabel('TOPSIS评分');
grid on;

% 保存结果
writetable(top50_cities, 'top50_cities.csv');
saveas(gcf, 'top50_cities.png');

% 输出排名结果为表格文件
full_ranking = data(sorted_index, :);
writetable(full_ranking, 'full_city_ranking.csv');

% 创建热图
% 选取前50个城市的各指标得分进行热图展示
heatmap_data = zeros(50, length(categories)); % 初始化热图数据矩阵
for i = 1:length(categories)
    % 使用TOPSIS得分作为热图数据
    heatmap_data(:, i) = scores(sorted_index(1:50), i);
end

% 创建热图图形窗口
figure;

% 定义一个从深蓝到浅蓝的渐变色映射
deepBlue = [0, 0.1, 0.6];  % 较深的蓝色
lightBlue = [0.5, 0.8, 1.0];  % 较浅的蓝色
% 生成渐变色系
newColorMap = [linspace(deepBlue(1), lightBlue(1), 50)' ...
               linspace(deepBlue(2), lightBlue(2), 50)' ...
               linspace(deepBlue(3), lightBlue(3), 50)'];

% 应用新的配色方案
colormap(newColorMap);

% 创建热图并应用配色方案
heatmap(heatmap_data, 'GridVisible', 'off', ...
    'XDisplayLabels', category_names, ... % 使用中文指标名称
    'YDisplayLabels', city_names_cell);

% 设置标题和轴标签
title('前50个城市在不同指标上的得分情况（0-5范围）');
xlabel('指标');
ylabel('城市');

% 保存热图
saveas(gcf, 'heatmap_top50_cities_gradient_blue.png');

% 整合前六张图到一个图形窗口
figure;

for i = 1:6
    subplot(2, 3, i);
    
    % 获取当前类别数据
    category = categories{i};
    
    % KMO检验和降维
    kmoValue = kmo_test(category);
    
    if kmoValue > 0.6
        [~, score] = pca(category);
        data_to_plot = score(:, 1);
    else
        % 使用熵权法的TOPSIS降维
        normalized_category = zscore(category);
        entropy = -sum(normalized_category .* log(normalized_category + eps)) / log(size(normalized_category, 1));
        weights = (1 - entropy) / sum(1 - entropy);
        ideal_solution = max(normalized_category);
        negative_solution = min(normalized_category);
        distance_to_ideal = sqrt(sum((normalized_category - ideal_solution).^2, 2));
        distance_to_negative = sqrt(sum((normalized_category - negative_solution).^2, 2));
        data_to_plot = distance_to_ideal ./ (distance_to_ideal + distance_to_negative);
    end
    
    % 定义渐变色
    n = length(data_to_plot); % 数据点数量
    gradientColors = [linspace(startColor(1), endColor(1), n)', ...
                      linspace(startColor(2), endColor(2), n)', ...
                      linspace(startColor(3), endColor(3), n)'];
    
    % 使用 bar 函数绘制图表并应用渐变色
    b = bar(data_to_plot);
    b.FaceColor = 'flat';
    b.CData = gradientColors; % 应用渐变色
    
    % 设置标题和标签
    title(['PCA/TOPSIS - ', category_names{i}]);
    xlabel('城市指数');
    ylabel('评分');
    grid on;
end

% 调整子图间距
sgtitle('按类别划分的降维结果');
set(gcf, 'Position', [100, 100, 1400, 700]); % 调整图形窗口大小

% 保存整合后的图形
saveas(gcf, 'combined_results.png');


%% 绘制地图并显示前50个城市的位置和评分

% 手动创建城市名称和经纬度的映射
city_coordinates = {
    '福州', 26.0745, 119.2965;
    '汕尾', 22.7857, 115.3753;
    '安庆', 30.5429, 117.0637;
    '北京', 39.9042, 116.4074;
    '常德', 29.0402, 111.6685;
    '成都', 30.5728, 104.0668;
    '楚雄州', 25.0453, 101.5460;
    '儋州', 19.5211, 109.5807;
    '定西', 35.5811, 104.6258;
    '恩施', 30.2722, 109.4882;
    '贵阳', 26.6477, 106.6302;
    '杭州', 30.2741, 120.1551;
    '贺州', 24.4094, 111.5617;
    '呼和浩特', 40.8426, 111.7492;
    '惠州', 23.1115, 114.4152;
    '济源', 35.0671, 112.6027;
    '嘉峪关', 39.7720, 98.2891;
    '晋城', 35.4907, 112.8512;
    '可克达拉', 43.6832, 81.0199;
    '丽江', 26.8721, 100.2330;
    '临高', 19.9120, 109.6900;
    '泸州', 28.8717, 105.4425;
    '南充', 30.8379, 106.1107;
    '攀枝花', 26.5823, 101.7186;
    '潜江', 30.4017, 112.8990;
    '琼海', 19.2584, 110.4746;
    '三亚', 18.2528, 109.5119;
    '邵阳', 27.2389, 111.4677;
    '朔州', 39.3316, 112.4328;
    '台州', 28.6564, 121.4208;
    '通化', 41.7212, 125.9399;
    '潍坊', 36.7069, 119.1618;
    '五家渠', 44.1676, 87.5499;
    '咸宁', 29.8413, 114.3225;
    '雄安新区', 39.0229, 116.0090;
    '扬州', 32.3936, 119.4127;
    '中山', 22.5159, 113.3926;
    '大理', 25.6075, 100.2676;
    '包头', 40.6578, 109.8405;
    '忻州', 38.4167, 112.7342;
    '珠海', 22.2711, 113.5767;
    '凉山', 27.8816, 102.2644;
    '运城', 35.0228, 110.9925;
    '白城', 45.6196, 122.8387;
    '唐山', 39.6305, 118.1806;
    '博尔塔拉', 44.9064, 82.0660;
    '阜新', 42.0217, 121.6701;
    '宝鸡', 34.3610, 107.2374;
    '阿里', 32.5011, 80.1054;
    '保亭', 18.6462, 109.7025;
};

% 创建城市排名表
top50_cities = {'福州', '汕尾', '安庆', '北京', '常德', '成都', '楚雄州', '儋州', '定西', '恩施', '贵阳', '杭州', '贺州', '呼和浩特', '惠州', '济源', '嘉峪关', '晋城', '可克达拉', '丽江', '临高', '泸州', '南充', '攀枝花', '潜江', '琼海', '三亚', '邵阳', '朔州', '台州', '通化', '潍坊', '五家渠', '咸宁', '雄安新区', '扬州', '中山', '大理', '包头', '忻州', '珠海', '凉山', '运城', '白城', '唐山', '博尔塔拉', '阜新', '宝鸡', '阿里', '保亭'};

% 获取经纬度数据
latitudes = zeros(length(top50_cities), 1);
longitudes = zeros(length(top50_cities), 1);

for i = 1:length(top50_cities)
    city = top50_cities{i};
    idx = strcmp(city_coordinates(:, 1), city);
    if any(idx)
        latitudes(i) = city_coordinates{idx, 2};
        longitudes(i) = city_coordinates{idx, 3};
    else
        warning(['城市 ' city ' 的经纬度数据缺失']);
    end
end

% 创建中国地图
figure('Units', 'normalized', 'Position', [0, 0, 1, 1]); % 新建一个全屏图形窗口
ax = worldmap('china');
setm(ax, 'mapprojection', 'mercator');

% 绘制国界
bordersl = shaperead('bou1_4l.shp', 'UseGeoCoords', true);
geoshow(bordersl, 'Color', [0.3, 0.3, 0.3], 'LineWidth', 1);

% 绘制省份
colorList = [197, 228, 212; 255, 254, 216; 251, 197, 221; 199, 205, 231] ./ 255;
colorList = repmat(colorList, [250, 1]);
provinces = shaperead('bou2_4p.shp', 'UseGeoCoords', true);
colorList = colorList(1:numel(provinces), :);
faceColors = makesymbolspec('Polygon', {'INDEX', [1 numel(provinces)], 'FaceColor', colorList});
geoshow(provinces, 'DisplayType', 'polygon', 'SymbolSpec', faceColors);

% 创建颜色渐变（使用蓝色渐变，深蓝表示排名靠前，浅蓝表示排名靠后）
startColor = [0, 0, 0.5]; % 深蓝色
endColor = [0.678, 0.847, 0.902]; % 淡蓝色
n = length(top50_cities);
gradientColors = [linspace(startColor(1), endColor(1), n)', ...
                  linspace(startColor(2), endColor(2), n)', ...
                  linspace(startColor(3), endColor(3), n)'];

% 绘制城市点并根据排名进行着色，缩小点的大小
for i = 1:length(latitudes)
    geoshow(latitudes(i), longitudes(i), 'DisplayType', 'point', ...
        'Marker', 'o', 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', gradientColors(i, :), 'MarkerSize', 5); % 缩小点的大小
end

% 添加城市标签
for i = 1:length(latitudes)
    textm(latitudes(i), longitudes(i), top50_cities{i}, 'FontSize', 7, 'Color', 'k', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right'); % 调整标签位置
end

% 指北针
northarrow('latitude', 50, 'longitude', 80, 'scaleratio', .08, 'FaceColor', [0.4, 0.4, 0.4]);

% 比例尺
scaleruler on;
setm(handlem('scaleruler1'), 'XLoc', -3.2e6, 'YLoc', 1.8e6, 'MajorTick', 0:500:2000, 'MinorTick', 0:40:200, 'FontSize', 7);
scaleruler('units', 'nm');
setm(handlem('scaleruler2'), 'XLoc', -3.15e6, 'YLoc', 1.7e6, 'TickDir', 'down', 'MajorTick', 0:250:1000, 'MinorTick', 0:40:200, 'MajorTickLength', km2nm(25), 'MinorTickLength', km2nm(12.5), 'FontSize', 7);

% 添加颜色对比板
colormap(ax, [linspace(startColor(1), endColor(1), n)', linspace(startColor(2), endColor(2), n)', linspace(startColor(3), endColor(3), n)']);
caxis([1 n]);
cbar = colorbar('Position', [0.85 0.15 0.02 0.7], 'YTick', linspace(1, n, 5), 'YTickLabel', {'Top', 'High', 'Medium', 'Low', 'Bottom'});

% 设置颜色对比板的标题竖直居中显示并右移和上下居中
ylabel(cbar, '综合评分颜色', 'Rotation', 90, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Position', [4, mean(get(cbar, 'YLim')), 0]);

% 显示图形
title('前50个城市在中国地图上的位置及排名');

% 保存为高清图片，设置DPI为600，图片尺寸大
print(gcf, 'China_City_Map_HD.png', '-dpng', '-r600');
