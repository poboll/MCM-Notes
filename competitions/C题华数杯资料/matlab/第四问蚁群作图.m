ax = worldmap('China');
setm(ax, 'FFaceColor', [153,179,204]./255)

% 绘制附近大陆
antarctica = shaperead('landareas.shp', 'UseGeoCoords', true, 'Selector',{@(name) strcmp(name,'Africa and Eurasia'), 'Name'});
patchm(antarctica.Lat, antarctica.Lon, [0.5 0.7 0.5])

% 绘制中国国界
bordersl = shaperead('bou1_4l.shp', 'UseGeoCoords', true);
geoshow(bordersl, 'Color', [.3,.3,.3], 'LineWidth', 1)
bordersp = shaperead('bou1_4p.shp', 'UseGeoCoords', true);
patchm([bordersp.Lat], [bordersp.Lon], [239,238,234]./255);

% 绘制河流
riversp = shaperead('hyd1_4p.shp', 'UseGeoCoords', true);
riversl = shaperead('hyd1_4l.shp', 'UseGeoCoords', true);
geoshow(riversp, 'FaceColor', [127,141,181]./255, 'EdgeColor', [127,141,181]./255)
geoshow(riversl, 'Color', [127,141,181]./255, 'LineWidth', 1)

% 绘制铁路
roads = shaperead('rai_4m.shp', 'UseGeoCoords', true);
geoshow(roads, 'Color', [250,227,158]./255, 'LineWidth', 1.5)

% 更新后的城市列表和对应的经纬度（已添加广州）
cityNames = {'广州', '攀枝花', '博尔塔拉', '宝鸡', '杭州', '邵阳', '保亭', '丽江', '珠海', '恩施', ...
             '三亚', '常德', '惠州', '琼海', '呼和浩特', '潍坊', '台州', '运城', '大理', '贵阳', ...
             '扬州', '汕尾', '咸宁', '通化', '定西'};
cityLat = [23.1291, 26.5823, 44.9065, 34.367, 30.2741, 27.2333, 18.6011, 26.8721, 22.277, 30.2722, ...
           18.2528, 29.0316, 23.1103, 19.2592, 40.8426, 36.7068, 28.6564, 35.0958, 25.6065, 26.6477, ...
           32.3929, 22.7877, 29.8413, 41.7212, 35.5807];
cityLon = [113.2644, 101.716, 82.0721, 107.2313, 120.1551, 111.4672, 109.6957, 100.2296, 113.562, 109.488, ...
           109.5119, 111.6537, 114.4168, 110.4745, 111.749, 119.1035, 121.4208, 111.0036, 100.2676, 106.6302, ...
           119.421, 115.3751, 114.3228, 125.9406, 104.6266];

% 定义出发地（广州为出发地）
departureCity = '广州';
departureLat = 23.1291;
departureLon = 113.2644;

% 高亮显示城市
hold on;
for k = 1:length(cityNames)
    if strcmp(cityNames{k}, departureCity)
        % 使用红色标记表示出发地
        plotm(cityLat(k), cityLon(k), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    else
        % 使用黑色标记表示其他访问城市
        plotm(cityLat(k), cityLon(k), 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
    end
    textm(cityLat(k)+0.5, cityLon(k), cityNames{k}, 'Color', 'k', 'HorizontalAlignment', 'right');
end

% 添加旅行路径
for k = 1:(length(cityNames) - 1)
    % 获取当前城市和下一个城市的经纬度
    lat1 = cityLat(k);
    lon1 = cityLon(k);
    lat2 = cityLat(k + 1);
    lon2 = cityLat(k + 1);
    
    % 绘制沿铁路的连线
    plotm([lat1 lat2], [lon1 lon2], 'LineWidth', 2, 'Color', 'b');
end

% 添加图例
legend('访问城市', '出发地', '旅行路径');

tightmap;
