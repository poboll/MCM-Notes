% 导入数据
attractions = readtable('问题五导入数据.xlsx', 'VariableNamingRule', 'preserve');
cityCoordinates = readtable('问题五经纬度.csv', 'VariableNamingRule', 'preserve');

% 检查数据读取
disp('城市和经纬度数据:');
disp(cityCoordinates);
disp('景点数据:');
disp(attractions);

% 获取城市数量和景点数量
numCities = height(cityCoordinates);
numAttractions = height(attractions);

% 高铁参数
highSpeedTrainSpeed = 300;  % km/h
highSpeedTrainCostPerKm = 0.6;  % 元/km

% 初始化参数
numAnts = 10;
pheromoneLevels = ones(numCities) * 0.1;  % 初始信息素
evaporationRate = 0.5;
alpha = 1;  % 引力因子
beta = 2;   % 可见性因子
maxTime = 148;  % 可用的最大时间（考虑到必须休息的时间）

% 计算城市间的直线距离矩阵
distanceMatrix = zeros(numCities);
for i = 1:numCities
    for j = 1:numCities
        if i ~= j
            % 根据经纬度计算两点之间的地理距离
            lat1 = cityCoordinates.("纬度")(i);
            lon1 = cityCoordinates.("经度")(i);
            lat2 = cityCoordinates.("纬度")(j);
            lon2 = cityCoordinates.("经度")(j);
            distanceMatrix(i, j) = haversine(lat1, lon1, lat2, lon2);
        else
            distanceMatrix(i, j) = inf; % 避免自循环
        end
    end
end

% 基于距离矩阵计算时间和费用矩阵
timeMatrix = distanceMatrix / highSpeedTrainSpeed;  % 高铁时间 = 距离 / 速度
costMatrix = distanceMatrix * highSpeedTrainCostPerKm;  % 高铁费用 = 距离 * 费用率

% 调试输出时间和费用矩阵
disp('时间矩阵:');
disp(timeMatrix);
disp('费用矩阵:');
disp(costMatrix);

% 蚁群算法
bestPath = [];
bestCost = inf;
bestScore = 0;
bestTimeUtilization = 0;  % 最优的时间使用
bestAttractions = {};     % 保存最优路径经过的景点名称

for iter = 1:100
    for ant = 1:numAnts
        % 随机选择一个起始城市
        startCity = randi(numCities);
        path = startCity;
        totalTime = 0;
        totalCost = 0;
        visitedAttractions = {};
        unvisitedCities = setdiff(1:numCities, startCity);  % 未访问的城市列表

        % 构建路径
        while ~isempty(unvisitedCities)
            currentCity = path(end);
            % 计算可能的下一步选择的吸引力
            attractiveness = (pheromoneLevels(currentCity, unvisitedCities) .^ alpha) .* ...
                             ((1 ./ (timeMatrix(currentCity, unvisitedCities) + ...
                             costMatrix(currentCity, unvisitedCities))) .^ beta);

            % 归一化吸引力
            attractiveness = attractiveness / sum(attractiveness);

            % 增加随机性，避免过早收敛
            randomFactor = 0.1;  % 增加探索性的随机因素
            attractiveness = attractiveness * (1 - randomFactor) + randomFactor * rand(size(attractiveness));
            attractiveness = attractiveness / sum(attractiveness);

            % 根据吸引力随机选择下一步城市
            nextCity = randsample(unvisitedCities, 1, true, attractiveness);
            
            % 计算时间和费用
            travelTime = timeMatrix(currentCity, nextCity);
            travelCost = costMatrix(currentCity, nextCity);
            playTime = attractions.("建议游玩时间")(nextCity);
            ticketPrice = attractions.("门票")(nextCity);
            
            % 检查时间限制
            if totalTime + travelTime + playTime > maxTime
                break;  % 如果超过时间限制，停止本次路径构建
            end
            
            % 更新路径和已访问景点
            totalTime = totalTime + travelTime + playTime;
            totalCost = totalCost + travelCost + ticketPrice;
            path = [path nextCity];
            visitedAttractions{end+1} = attractions.("名字"){nextCity};

            % 移除已访问的城市
            unvisitedCities(unvisitedCities == nextCity) = [];

            % 调试输出当前选择的城市和总费用
            % 打印当前选择的城市和详细费用
            % 打开一个文件用于追加
fileID = fopen('simulation_log.txt', 'a');

% 在您的蚂蚁循环中，使用文件ID来记录
fprintf(fileID, '当前城市: %s, 下一城市: %s, 高铁费用: %.2f, 门票费: %.2f, 累计费用: %.2f, 累计时间: %.2f, 景点: %s\n', ...
    cityCoordinates.("城市"){currentCity}, cityCoordinates.("城市"){nextCity}, travelCost, ticketPrice, totalCost, totalTime, attractions.("名字"){nextCity});

% 在完成所有操作后，关闭文件
fclose(fileID);

fprintf('当前城市: %s, 下一城市: %s, 高铁费用: %.2f, 门票费: %.2f, 累计费用: %.2f, 累计时间: %.2f, 景点: %s\n', ...
    cityCoordinates.("城市"){currentCity}, cityCoordinates.("城市"){nextCity}, travelCost, ticketPrice, totalCost, totalTime, attractions.("名字"){nextCity});
        end

        % 检查路径是否有效并更新最优解
        if ~isempty(path)
            pathScore = sum(attractions.("评分")(ismember(cellstr(attractions.("名字")), visitedAttractions)));
            timeUtilization = totalTime / maxTime;  % 时间使用效率

            % 更新最优路径：考虑时间使用和路径评分
            if totalCost < bestCost || (totalCost == bestCost && pathScore > bestScore)
                bestTimeUtilization = timeUtilization;
                bestScore = pathScore;
                bestCost = totalCost;
                bestPath = path;
                bestAttractions = visitedAttractions;
            end
        end

        % 更新信息素
        for k = 1:length(path)-1
            i = path(k);
            j = path(k+1);
            pheromoneLevels(i, j) = ((attractions.("评分")(j) / (totalCost + 1e-5)) * timeUtilization) + pheromoneLevels(i, j);
        end
    end
    % 信息素挥发
    pheromoneLevels = (1 - evaporationRate) * pheromoneLevels;
end

% 打印结果
if ~isempty(bestPath)
    fprintf('最佳路径: %s\n', strjoin(cityCoordinates.("城市")(bestPath), ' -> '));
    fprintf('总花费: %.2f\n', bestCost);
    fprintf('总游玩时间: %.2f\n', sum(attractions.("建议游玩时间")(ismember(cellstr(attractions.("名字")), bestAttractions))));
    fprintf('总游玩景点数量: %d\n', length(bestAttractions));
    fprintf('访问的景点: %s\n', strjoin(bestAttractions, ', '));  % 打印访问的所有景点名称
else
    fprintf('未找到符合条件的路径。\n');
end

% Haversine公式函数计算地理距离
function d = haversine(lat1, lon1, lat2, lon2)
    R = 6371; % 地球平均半径，单位：公里
    dLat = deg2rad(lat2 - lat1);
    dLon = deg2rad(lon2 - lon1);
    a = sin(dLat/2)^2 + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    d = R * c;
end
