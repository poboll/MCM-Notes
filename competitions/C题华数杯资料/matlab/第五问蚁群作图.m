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

% 城市列表和对应的经纬度
cityNames = {'滁州', '芜湖', '攀枝花', '昌吉', '黄山', '定西', '舟山', '保山', '厦门', '九江'};
cityLat = [32.3016, 31.3525, 26.5823, 44.0145, 29.7152, 35.5807, 29.9854, 25.1120, 24.4798, 29.7051];
cityLon = [118.3161, 118.4335, 101.7160, 87.3088, 118.3375, 104.6266, 122.2072, 99.1618, 118.0894, 115.9902];

% 定义出发地（滁州为出发地）
departureCity = '滁州';
departureLat = 32.3016;
departureLon = 118.3161;

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
n