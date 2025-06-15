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
cityNames = {'邵阳', '博尔塔拉', '宝鸡', '珠海', '可克达拉', '福州', '成都', '贵阳', '惠州', '忻州', '三亚', ...
             '常德', '凉山', '丽江', '南充', '潍坊', '济源', '包头', '呼和浩特', '咸宁', '琼海', '潜江', '嘉峪关', '广州'}; 
cityLat = [27.2333, 44.9065, 34.367, 22.277, 43.6836, 26.0745, 30.5728, 26.6477, 23.1103, 38.4167, 18.2528, ...
           29.0316, 27.8268, 26.8721, 30.8375, 36.7068, 35.0671, 40.6582, 40.8426, 29.8413, 19.2592, 30.4268, 39.8023, 23.1291]; 
cityLon = [111.4672, 82.0721, 107.2313, 113.562, 81.164, 119.2965, 104.0668, 106.6302, 114.4168, 112.7196, 109.5119, ...
           111.6537, 99.7071, 100.2296, 106.0806, 119.1035, 112.5876, 109.8463, 111.749, 114.3228, 110.4745, 112.899, 98.2901, 113.2644]; 

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
