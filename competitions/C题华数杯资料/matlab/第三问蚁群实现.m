% 蚁群算法
bestPath = [];
bestCost = inf;
bestScore = 0;
bestTimeUtilization = 0;  % 最优的时间使用
bestAttractions = {};     % 保存最优路径经过的景点名称

for iter = 1:100
    for ant = 1:numAnts
        path = [guangzhouIndex randperm(numCities)];
        totalTime = 0;
        totalCost = 0;
        visitedAttractions = {};

        for k = 1:length(path)-1
            i = path(k);
            j = path(k+1);
            travelTime = timeMatrix(i, j);
            travelCost = costMatrix(i, j);
            playTime = attractions.("建议游玩时间")(j);
            ticketPrice = attractions.("门票")(j);
            
            % 检查时间限制
            if totalTime + travelTime + playTime > maxTime
                continue;
            end

            totalTime = travelTime + playTime + totalTime;
            totalCost = travelCost + ticketPrice + totalCost;
            visitedAttractions{end+1} = attractions.("名字")(j);  % 记录景点名称
        end

        pathScore = sum(attractions.("评分")(path(1:length(visitedAttractions))));
        timeUtilization = totalTime / maxTime;  % 时间使用效率

        % 更新最优路径：考虑时间使用和路径评分
        if timeUtilization > bestTimeUtilization || (timeUtilization == bestTimeUtilization && pathScore > bestScore)
            bestTimeUtilization = timeUtilization;
            bestScore = pathScore;
            bestCost = totalCost;
            bestPath = path(1:length(visitedAttractions));
            bestAttractions = visitedAttractions;  % 确保所有元素均为字符向量
        end

        % 更新信息素
        for k = 1:length(path)-1
            i = path(k);
            j = path(k+1);
            pheromoneLevels(i, j) = ((attractions.("评分")(j) / totalCost) * timeUtilization) + pheromoneLevels(i, j);
        end
    end
    % 信息素挥发
    pheromoneLevels = (1 - evaporationRate) * pheromoneLevels;
end

% 打印结果
fprintf('最佳路径: %s\n', strjoin(cities.("城市")(bestPath), ' -> '));
fprintf('总花费: %.2f\n', bestCost);
fprintf('总游玩时间: %.2f\n', sum(attractions.("建议游玩时间")(bestPath)));
fprintf('总游玩景点数量: %d\n', length(bestAttractions));
% fprintf('访问的景点: %s\n', strjoin(bestAttractions, ', '));  % 打印访问的所有景点名称
