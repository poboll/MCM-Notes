

% 读取城市数据和景点数据
city_data = readtable('high_speed_rail.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');
scenic_data = readtable('问题三导入数据.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 添加广州的经纬度
guangzhou_lat = 23.1291;
guangzhou_lon = 113.2644;

% 定义初始参数
initial_city = '广州';
total_time_limit = 144; % 144小时
current_time = 0;
current_cost = 0;
current_city = initial_city;
visited_cities = {current_city};
total_spots = 0;

% 高铁速度和费用
high_speed = 300; % km/h
cost_per_km = 0.5; % 元/km

% Haversine formula to calculate distance
haversine_distance = @(lat1, lon1, lat2, lon2) ...
    2 * 6371 * asin(sqrt(sin(deg2rad(lat2 - lat1) / 2).^2 + cos(deg2rad(lat1)) .* cos(deg2rad(lat2)) .* sin(deg2rad(lon2 - lon1) / 2).^2));

% 调试信息
fprintf('开始旅程，从%s出发，时间限制为%d小时\n', initial_city, total_time_limit);

while current_time < total_time_limit
    best_city = '';
    best_experience = 0;
    best_city_time = 0;
    best_city_cost = 0;
    
    for i = 1:height(city_data)
        city = city_data.("城市"){i}; % 使用正确的引用方式
        if ~ismember(city, visited_cities)
            % 计算当前城市到目标城市的距离
            if strcmp(current_city, '广州')
                city_lat = guangzhou_lat;
                city_lon = guangzhou_lon;
            else
                current_city_index = find(strcmp(city_data.("城市"), current_city));
                city_lat = city_data.("纬度")(current_city_index);
                city_lon = city_data.("经度")(current_city_index);
            end
            
            target_lat = city_data.("纬度")(i);
            target_lon = city_data.("经度")(i);
            
            % 计算距离，转换为公里
            dist = haversine_distance(city_lat, city_lon, target_lat, target_lon);
            travel_time = dist / high_speed; % 转换为小时
            travel_cost = dist * cost_per_km; % 元

            spot_data = scenic_data(strcmp(scenic_data.("来源城市"), city), :);
            if isempty(spot_data)
                continue;
            end
            % 选择评分最高的景点
            [max_score, idx] = max(spot_data.("评分"));
            best_spot = spot_data(idx, :);
            visit_time = best_spot.("建议游玩时间"); % 使用小时
            total_city_time = travel_time + visit_time;
            
            % 调试信息
            fprintf('评估城市: %s，旅行时间: %.2f小时，游玩时间: %.2f小时，总时间: %.2f小时\n', ...
                city, travel_time, visit_time, total_city_time);
            
            if current_time + total_city_time <= total_time_limit
                experience = best_spot.("评分");
                if experience > best_experience
                    best_experience = experience;
                    best_city = city;
                    best_city_time = total_city_time;
                    best_city_cost = travel_cost + best_spot.("门票");
                end
            end
        end
    end
    
    if isempty(best_city)
        fprintf('未找到适合的下一站，旅程结束\n');
        break;
    end
    
    visited_cities = [visited_cities, best_city];
    current_time = current_time + best_city_time;
    current_cost = current_cost + best_city_cost;
    total_spots = total_spots + 1;
    current_city = best_city;
    
    % 调试信息
    fprintf('访问城市: %s，当前总时间: %.2f小时，当前总费用: %.2f元\n', best_city, current_time, current_cost);
end

% 输出结果
fprintf('Travel Route: %s\n', strjoin(visited_cities, ' -> '));
fprintf('Total Travel Time (hours): %.2f\n', current_time);
fprintf('Total Cost: %.2f\n', current_cost);
fprintf('Total Scenic Spots: %d\n', total_spots);

% 可视化结果
figure;
geoscatter(city_data.("纬度"), city_data.("经度"), 'filled');
hold on;
for i = 1:length(visited_cities)
    city_index = find(strcmp(city_data.("城市"), visited_cities{i}));
    geoscatter(city_data.("纬度")(city_index), city_data.("经度")(city_index), 100, 'red', 'filled');
    text(city_data.("纬度")(city_index), city_data.("经度")(city_index), num2str(i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
title('旅行路线');
grid on;








% 读取结果数据
route_table = readtable('travel_route.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 获取城市名称
visited_cities = route_table.City;

% 获取城市经纬度
city_coords = city_data(ismember(city_data.("城市"), visited_cities), :);

% 绘制中国地图
figure;
worldmap('China');
load coastlines;
geoshow(coastlat, coastlon, 'DisplayType', 'polygon', 'FaceColor', [0.7 0.7 0.7]);
title('Travel Route from Guangzhou with Visit Sequence');

% 绘制城市点和标注顺序
for i = 1:height(city_coords)
    lat = city_coords.("纬度")(i);
    lon = city_coords.("经度")(i);
    city_name = city_coords.("城市"){i};
    geoshow(lat, lon, 'DisplayType', 'point', 'Marker', 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
    textm(lat, lon, sprintf('%s (%d)', city_name, i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% 绘制旅行路线
for i = 1:length(visited_cities)-1
    start_city = visited_cities{i};
    end_city = visited_cities{i+1};
    start_coords = city_coords(strcmp(city_coords.("城市"), start_city), {'纬度', '经度'});
    end_coords = city_coords(strcmp(city_coords.("城市"), end_city), {'纬度', '经度'});
    lat = [start_coords.("纬度"), end_coords.("纬度")];
    lon = [start_coords.("经度"), end_coords.("经度")];
    linem(lat, lon, 'r-', 'LineWidth', 2);
end

% 添加广州起点
guangzhou_coords = city_data(strcmp(city_data.("城市"), '广州'), {'纬度', '经度'});
geoshow(guangzhou_coords.("纬度"), guangzhou_coords.("经度"), 'DisplayType', 'point', 'Marker', 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

% 显示图例
legend('Cities', 'Route', 'Location', 'best');

% 显示总花费时间、总费用和游玩景点数量
total_time = current_time; % 从主程序中获取总时间
total_cost = current_cost; % 从主程序中获取总费用
total_spots = total_spots; % 从主程序中获取总景点数量

fprintf('Total Travel Time (minutes): %d\n', total_time);
fprintf('Total Cost: %.2f\n', total_cost);
fprintf('Total Scenic Spots: %d\n', total_spots);
