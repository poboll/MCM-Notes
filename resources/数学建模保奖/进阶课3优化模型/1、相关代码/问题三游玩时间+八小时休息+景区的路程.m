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
visited_spots = {};
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
    best_spot_name = '';
    
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
            local_travel_time = 0.5; % 每个景区的本地赶路时间
            total_city_time = travel_time + local_travel_time + visit_time;
            
            % 加入休息时间的计算
            total_time_with_rest = current_time + total_city_time + floor((current_time + total_city_time) / 24) * 8;
            
            % 调试信息
            fprintf('评估城市: %s，旅行时间: %.2f小时，游玩时间: %.2f小时，总时间: %.2f小时，包含休息时间: %.2f小时\n', ...
                city, travel_time, visit_time, total_city_time, total_time_with_rest);
            
            if total_time_with_rest <= total_time_limit
                experience = best_spot.("评分");
                if experience > best_experience
                    best_experience = experience;
                    best_city = city;
                    best_city_time = total_city_time;
                    best_city_cost = travel_cost + best_spot.("门票");
                    best_spot_name = best_spot.("名字");
                end
            end
        end
    end
    
    if isempty(best_city)
        fprintf('未找到适合的下一站，旅程结束\n');
        break;
    end
    
    visited_cities = [visited_cities, best_city];
    visited_spots = [visited_spots, best_spot_name];
    current_time = current_time + best_city_time + floor((current_time + best_city_time) / 24) * 8; % 更新当前时间，包含休息时间
    current_cost = current_cost + best_city_cost;
    total_spots = total_spots + 1;
    current_city = best_city;
    
    % 调试信息
    fprintf('访问城市: %s，当前总时间: %.2f小时，当前总费用: %.2f元\n', best_city, current_time, current_cost);
end

% 输出结果
fprintf('Travel Route: %s\n', strjoin(visited_cities, ' -> '));
fprintf('Visited Spots: %s\n', strjoin(visited_spots, ' -> '));
fprintf('Total Travel Time (hours): %.2f\n', current_time);
fprintf('Total Cost: %.2f\n', current_cost);
fprintf('Total Scenic Spots: %d\n', total_spots);

% 可视化结果
figure;
geoscatter(city_data.("纬度"), city_data.("经度"), 50, 'blue', 'filled');
hold on;
% 标记访问过的城市
for i = 1:length(visited_cities)
    city_index = find(strcmp(city_data.("城市"), visited_cities{i}));
    geoscatter(city_data.("纬度")(city_index), city_data.("经度")(city_index), 100, 'red', 'filled');
    text(city_data.("纬度")(city_index), city_data.("经度")(city_index), num2str(i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% 绘制路径
for i = 1:(length(visited_cities)-1)
    start_city = visited_cities{i};
    end_city = visited_cities{i+1};
    start_index = find(strcmp(city_data.("城市"), start_city));
    end_index = find(strcmp(city_data.("城市"), end_city));
    
    latitudes = [city_data.("纬度")(start_index), city_data.("纬度")(end_index)];
    longitudes = [city_data.("经度")(start_index), city_data.("经度")(end_index)];
    
    geoplot(latitudes, longitudes, '-o', 'Color', 'black', 'LineWidth', 2);
end

% 显示广州位置
geoscatter(guangzhou_lat, guangzhou_lon, 100, 'green', 'filled');
text(guangzhou_lat, guangzhou_lon, '广州', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12, 'Color', 'green');

% 添加图例
legend({'未访问城市', '访问城市', '旅行路径', '出发地'}, 'Location', 'best');

title('旅行路线');
grid on;
