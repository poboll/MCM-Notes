% 读取城市经纬度数据
city_coords = readtable('问题五经纬度.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 绘制地理散点图
figure;
geoscatter(city_coords.("纬度"), city_coords.("经度"), 'filled');
title('问题五城市经纬度分布');

grid on;

% 添加标注
hold on;
for i = 1:height(city_coords)
    text(city_coords.("纬度")(i), city_coords.("经度")(i), city_coords.("城市"){i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
hold off;
