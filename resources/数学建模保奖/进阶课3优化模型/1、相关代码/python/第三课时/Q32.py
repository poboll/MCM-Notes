import pandas as pd
import numpy as np
from geopy.distance import geodesic
import matplotlib.pyplot as plt

# 设置全局字体为中文
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

# 读取CSV文件
file_path = 'Q3_top50_topscore_1.csv'

try:
    data = pd.read_csv(file_path, encoding='utf-8')
except UnicodeDecodeError:
    data = pd.read_csv(file_path, encoding='GBK')

# 更改列名
data.columns = ['名字', '开放时间', '评分', '建议游玩时间', '门票', '来源城市', '纬度', '经度']

# 强制将经纬度列转换为数字，无法转换的部分会变为 NaN
data['纬度'] = pd.to_numeric(data['纬度'], errors='coerce')
data['经度'] = pd.to_numeric(data['经度'], errors='coerce')

# 检查并清理数据
if data[['纬度', '经度']].isnull().any().any():
    print("存在缺失的经纬度信息，清理数据...")
    data = data.dropna(subset=['纬度', '经度'])

# 手动添加广州的经纬度信息（如有需要）
if '广州' not in data['来源城市'].values:
    guangzhou_data = pd.DataFrame([{
        '名字': '广州', '开放时间': None, '评分': 0, '建议游玩时间': 0, '门票': None,
        '来源城市': '广州', '纬度': 23.1291, '经度': 113.2644
    }])
    data = pd.concat([data, guangzhou_data], ignore_index=True)

# 创建字典保存城市的经纬度和评分
city_info = {
    row['来源城市']: {'coords': (row['纬度'], row['经度']), 'score': row['评分'], 'suggested_time': row['建议游玩时间']}
    for idx, row in data.iterrows()
}

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
effective_hours = time_limit_hours - 7 * daily_rest_hours
cities = data['来源城市'].tolist()
visited_cities = [starting_city]
remaining_cities = [city for city in cities if city != starting_city]
current_city = starting_city
total_time_spent = 0
total_cost = 0
stay_durations = [0]

# 启发式算法：每次选择最近的城市
while remaining_cities and total_time_spent < effective_hours:
    min_distance = float('inf')
    next_city = None
    for city in remaining_cities:
        lat1, lon1 = city_info[current_city]['coords']
        lat2, lon2 = city_info[city]['coords']

        if np.isnan(lat1) or np.isnan(lon1) or np.isnan(lat2) or np.isnan(lon2):
            print(f"跳过 {city} 因为存在无效的经纬度")
            continue

        distance = calculate_distance(lat1, lon1, lat2, lon2)

        if distance < min_distance:
            min_distance = distance
            next_city = city

    if next_city:
        travel_time = min_distance / train_speed_kmh
        suggested_time = city_info[next_city]['suggested_time']
        if total_time_spent + travel_time + suggested_time > effective_hours:
            break
        total_time_spent += travel_time + suggested_time
        total_cost += min_distance * cost_per_km
        visited_cities.append(next_city)
        stay_durations.append(suggested_time)
        remaining_cities.remove(next_city)
        current_city = next_city

# 输出结果
total_scores = sum(city_info[city]['score'] for city in visited_cities)
result = {
    'Visited Cities': visited_cities,
    'Stay Durations': stay_durations,
    'Total Time Spent (hours)': total_time_spent + len(visited_cities) * daily_rest_hours,
    'Total Cost (RMB)': total_cost,
    'Total Cities Visited': len(visited_cities),
    'Total Scores': total_scores
}

# 创建结果DataFrame
result_df = pd.DataFrame([result])
print(result_df)

# 绘制路线图
latitudes = [city_info[city]['coords'][0] for city in visited_cities]
longitudes = [city_info[city]['coords'][1] for city in visited_cities]

plt.figure(figsize=(10, 8))
plt.plot(longitudes, latitudes, marker='o', linestyle='-', color='b')
for i, city in enumerate(visited_cities):
    plt.text(longitudes[i], latitudes[i], city, fontsize=9)
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.title('Travel Route')
plt.grid(True)
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

# 可视化每个城市的评分
scores = [city_info[city]['score'] for city in visited_cities]
plt.figure(figsize=(10, 6))
plt.bar(visited_cities, scores, color='lightgreen')
plt.xlabel('Cities')
plt.ylabel('Score')
plt.title('Scores of Visited Cities')
plt.xticks(rotation=90)
plt.grid(True)
plt.show()
