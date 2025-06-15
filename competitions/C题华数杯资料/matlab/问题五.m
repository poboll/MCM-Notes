% 读取问题五数据
mountain_data = readtable('问题五导入数据.xlsx', 'TextType', 'string', 'VariableNamingRule', 'preserve');
city_coords = readtable('问题五经纬度.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 定义初始参数
total_time_limit = 144; % 144小时
current_time = 0;
current_cost = 0;
current_city = '';
visited_cities = {};
visited_spots = {};
total_spots = 0;

% 高铁速度和费用
high_speed = 300; % km/h
cost_per_km = 0.5; % 元/km

% Haversine formula to calculate distance
haversine_distance = @(lat1, lon1, lat2, lon2) ...
    2 * 6371 * asin(sqrt(sin(deg2rad(lat2 - lat1) / 2).^2 + cos(deg2rad(lat1)) .* cos(deg2rad(lat2)) .* sin(deg2rad(lon2 - lon1) / 2).^2));

% 找到评分最高的山的每个城市
unique_cities = unique(mountain_data.("来源城市"));
best_mountains = table();

for i = 1:length(unique_cities)
    city = unique_cities{i};
    city_mountains = mountain_data(strcmp(mountain_data.("来源城市"), city), :);
    [~, idx] = max(city_mountains.("评分"));
    best_mountains = [best_mountains; city_mountains(idx, :)];
end

% 初始化贪心算法变量
max_score = 0;
best_route = {};
best_cost = inf;
best_time = inf;

% 寻找最佳入境城市（选择评分最高的山所在的城市作为初始城市）
[~, start_idx] = max(best_mountains.("评分"));
initial_city = best_mountains.("来源城市"){start_idx};
current_city = initial_city;
visited_cities = {current_city};

% 调试信息
fprintf('开始旅程，从%s出发，时间限制为%d小时\n', initial_city, total_time_limit);

while current_time < total_time_limit
    best_city = '';
    best_experience = 0;
    best_city_time = 0;
    best_city_cost = 0;
    best_spot_name = '';
    
    for i = 1:height(city_coords)
        city = city_coords.("城市"){i}; % 使用正确的引用方式
        if ~ismember(city, visited_cities)
            % 计算当前城市到目标城市的距离
            current_city_index = find(strcmp(city_coords.("城市"), current_city));
            city_lat = city_coords.("纬度")(current_city_index);
            city_lon = city_coords.("经度")(current_city_index);
            
            target_city_index = find(strcmp(city_coords.("城市"), city));
            target_lat = city_coords.("纬度")(target_city_index);
            target_lon = city_coords.("经度")(target_city_index);
            
            % 计算距离，转换为公里
            dist = haversine_distance(city_lat, city_lon, target_lat, target_lon);
            travel_time = dist / high_speed; % 转换为小时
            travel_cost = dist * cost_per_km; % 元

            spot_data = best_mountains(strcmp(best_mountains.("来源城市"), city), :);
            if isempty(spot_data)
                continue;
            end
            best_spot = spot_data;
            visit_time = best_spot.("建议游玩时间"); % 使用小时
            total_city_time = travel_time + 0.5 + visit_time; % 加入城市内赶路时间0.5小时
            
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
                    best_spot_name = best_spot.("名字"){1};
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
    fprintf('访问城市: %s（%s），当前总时间: %.2f小时，当前总费用: %.2f元\n', best_city, best_spot_name, current_time, current_cost);
end

% 输出结果
fprintf('Travel Route: %s\n', strjoin(visited_cities, ' -> '));
fprintf('Total Travel Time (hours): %.2f\n', current_time);
fprintf('Total Cost: %.2f\n', current_cost);
fprintf('Total Scenic Spots: %d\n', total_spots);


% 可视化结果
figure;
geoplot(city_coords.("纬度"), city_coords.("经度"), '.b');
hold on;

% 绘制访问过的城市和路径
for i = 1:length(visited_cities)
    city_index = find(strcmp(city_coords.("城市"), visited_cities{i}));
    geoplot(city_coords.("纬度")(city_index), city_coords.("经度")(city_index), 'or', 'MarkerFaceColor', 'r');
    text(city_coords.("纬度")(city_index), city_coords.("经度")(city_index), num2str(i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    if i > 1
        prev_city_index = find(strcmp(city_coords.("城市"), visited_cities{i-1}));
        geoplot([city_coords.("纬度")(prev_city_index), city_coords.("纬度")(city_index)], ...
              [city_coords.("经度")(prev_city_index), city_coords.("经度")(city_index)], '-k');
    end
end

title('旅行路线');
grid on;



% 打印总信息
fprintf('总旅行时间: %.2f小时\n', current_time);
fprintf('总费用: %.2f元\n', current_cost);
fprintf('总景点数量: %d\n', total_spots);