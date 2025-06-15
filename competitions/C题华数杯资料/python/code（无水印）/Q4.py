import pandas as pd
import numpy as np
from geopy.distance import geodesic
import matplotlib.pyplot as plt
import pandas as pd
from geopy.distance import geodesic
import matplotlib.pyplot as plt
import geopandas as gpd
from shapely.geometry import Point, LineString
import contextily as ctx

# 设置全局字体为中文
plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用SimHei字体
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 读取CSV文件
file_path = 'E:/CTi/Q3_top50_topscore_1.csv'

try:
    data = pd.read_csv(file_path, encoding='utf-8')
except UnicodeDecodeError:
    data = pd.read_csv(file_path, encoding='GBK')

# 更改列名
data.columns = ['名字', '开放时间', '评分', '建议游玩时间', '门票', '来源城市', '纬度', '经度']

# 显示文件内容前几行，检查读取是否正确
print(data.head())

# 计算两个经纬度点之间的距离
def calculate_distance(lat1, lon1, lat2, lon2):
    return geodesic((lat1, lon1), (lat2, lon2)).kilometers

# 定义高铁速度和费用参数
train_speed_kmh = 300
cost_per_km = 0.555
daily_rest_hours = 10

# 初始化路径规划变量
starting_city = '广州'
time_limit_hours = 144
effective_hours = time_limit_hours - 7 * daily_rest_hours  # 有效游玩时间
cities = data['来源城市'].tolist()
visited_cities = [starting_city]
remaining_cities = [city for city in cities if city != starting_city]
current_city = starting_city
total_time_spent = 0
total_cost = 0
total_ticket_cost = 0  # 门票总费用
total_train_cost = 0  # 高铁总费用
stay_durations = [0]  # 用于记录每个城市停留时间，广州起点停留时间为0

# 创建字典保存城市的经纬度和评分
city_info = {
    row['来源城市']: {'coords': (row['纬度'], row['经度']), 'score': row['评分'], 'suggested_time': row['建议游玩时间'], 'ticket_price': row['门票']}
    for idx, row in data.iterrows()
}

# 启发式算法：每次选择费用最低的城市（考虑距离和门票）
while remaining_cities and total_time_spent < effective_hours:
    min_cost = float('inf')
    next_city = None
    for city in remaining_cities:
        distance = calculate_distance(
            city_info[current_city]['coords'][0], city_info[current_city]['coords'][1],
            city_info[city]['coords'][0], city_info[city]['coords'][1]
        )
        travel_time = distance / train_speed_kmh
        travel_cost = distance * cost_per_km
        ticket_price = city_info[city]['ticket_price']
        total_cost_for_city = travel_cost + ticket_price
        if total_cost_for_city < min_cost:
            min_cost = total_cost_for_city
            next_city = city

    if next_city:
        distance = calculate_distance(
            city_info[current_city]['coords'][0], city_info[current_city]['coords'][1],
            city_info[next_city]['coords'][0], city_info[next_city]['coords'][1]
        )
        travel_time = distance / train_speed_kmh
        suggested_time = city_info[next_city]['suggested_time']
        if total_time_spent + travel_time + suggested_time > effective_hours:
            break
        total_time_spent += travel_time + suggested_time
        travel_cost = distance * cost_per_km
        ticket_price = city_info[next_city]['ticket_price']
        total_cost += travel_cost + ticket_price
        total_train_cost += travel_cost
        total_ticket_cost += ticket_price
        visited_cities.append(next_city)
        stay_durations.append(suggested_time)
        remaining_cities.remove(next_city)
        current_city = next_city

# 输出结果
total_scores = sum(city_info[city]['score'] for city in visited_cities)
total_travel_time = total_time_spent + len(visited_cities) * daily_rest_hours

# 逐步输出调试信息
print(f"Visited Cities: {visited_cities}")
print(f"Stay Durations: {stay_durations}")
print(f"Total Time Spent (hours): {total_travel_time}")
print(f"Total Cost (RMB): {total_cost}")
print(f"Total Ticket Cost (RMB): {total_ticket_cost}")
print(f"Total Train Cost (RMB): {total_train_cost}")
print(f"Total Cities Visited: {len(visited_cities)}")
print(f"Total Scores: {total_scores}")

result = {
    'Visited Cities': visited_cities,
    'Stay Durations': stay_durations,
    'Total Time Spent (hours)': total_travel_time,
    'Total Cost (RMB)': total_cost,
    'Total Ticket Cost (RMB)': total_ticket_cost,
    'Total Train Cost (RMB)': total_train_cost,
    'Total Cities Visited': len(visited_cities),
    'Total Scores': total_scores
}

# 创建结果DataFrame
result_df = pd.DataFrame([result])
print(result_df)

# 使用geopandas和contextily绘制路线图
# 创建GeoDataFrame
gdf = gpd.GeoDataFrame(
    visited_cities,
    geometry=[Point(city_info[city]['coords'][1], city_info[city]['coords'][0]) for city in visited_cities],
    columns=['City']
)
gdf.set_crs(epsg=4326, inplace=True)  # 设置坐标参考系统为WGS84

# 创建路线
route = LineString(gdf.geometry.tolist())

# 绘制路线和点
fig, ax = plt.subplots(1, 1, figsize=(10, 10))
gdf.plot(ax=ax, color='blue', edgecolor='black', markersize=50)
gpd.GeoSeries(route).plot(ax=ax, color='red')
for x, y, label in zip(gdf.geometry.x, gdf.geometry.y, visited_cities):
    ax.text(x, y, label, fontsize=12)

# 添加底图
ctx.add_basemap(ax, crs=gdf.crs.to_string(), source=ctx.providers.OpenStreetMap.Mapnik)

plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.title('Travel Route')
plt.show()

# 可视化每个城市的停留时间
plt.figure(figsize=(10, 6))
plt.bar(visited_cities, stay_durations, color='skyblue')
plt.xlabel('Cities')
plt.ylabel('Stay Duration (hours)')
plt.title('Stay Duration in Each City')
plt.xticks(rotation=90)
plt.grid(True)
plt.show()
