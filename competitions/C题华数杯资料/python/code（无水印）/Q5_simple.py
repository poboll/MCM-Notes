import pandas as pd
from geopy.distance import geodesic
import matplotlib.pyplot as plt

# 设置全局字体为中文
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

# 读取Excel文件
excel_file_path = 'E:/CTi/Q5_data1.xlsx'
data = pd.read_excel(excel_file_path)

# 过滤出所有山景的景点数据
mountain_data = data[data['名字'].str.contains('山')]

# 根据评分选择每个城市评分最高的山景景点
top_mountain_per_city = mountain_data.loc[mountain_data.groupby('来源城市')['评分'].idxmax()]

# 定义高铁速度和费用参数
train_speed_kmh = 300
cost_per_km = 0.555
daily_rest_hours = 10
time_limit_hours = 144
effective_hours = time_limit_hours - 7 * daily_rest_hours  # 有效游玩时间

# 初始化路径规划变量
starting_city = top_mountain_per_city.iloc[0]['来源城市']
visited_cities = [starting_city]
remaining_cities = top_mountain_per_city['来源城市'].tolist()
remaining_cities.remove(starting_city)
current_city = starting_city
total_time_spent = 0
total_cost = 0
total_ticket_cost = 0  # 门票总费用
total_train_cost = 0  # 高铁总费用
stay_durations = [0]  # 用于记录每个城市停留时间，起点停留时间为0

# 创建字典保存城市的经纬度和评分
city_info = {
    row['来源城市']: {'coords': (row['经度'], row['纬度']), 'score': row['评分'], 'suggested_time': row['建议游玩时间'], 'ticket_price': row['门票']}
    for idx, row in top_mountain_per_city.iterrows()
}

# 启发式算法：每次选择费用最低的城市（考虑距离和门票）
while remaining_cities and total_time_spent < effective_hours:
    min_cost = float('inf')
    next_city = None
    for city in remaining_cities:
        distance = geodesic(city_info[current_city]['coords'], city_info[city]['coords']).kilometers
        travel_time = distance / train_speed_kmh
        travel_cost = distance * cost_per_km
        ticket_price = city_info[city]['ticket_price']
        total_cost_for_city = travel_cost + ticket_price
        if total_cost_for_city < min_cost:
            min_cost = total_cost_for_city
            next_city = city

    if next_city:
        distance = geodesic(city_info[current_city]['coords'], city_info[next_city]['coords']).kilometers
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

# 逐步输出调试信息
print(f"Visited Cities: {visited_cities}")
print(f"Stay Durations: {stay_durations}")
print(f"Total Time Spent (hours): {total_travel_time}")
print(f"Total Cost (RMB): {total_cost}")
print(f"Total Ticket Cost (RMB): {total_ticket_cost}")
print(f"Total Train Cost (RMB): {total_train_cost}")
print(f"Total Cities Visited: {len(visited_cities)}")
print(f"Total Scores: {total_scores}")

# 创建结果DataFrame
result_df = pd.DataFrame([result])
print(result_df)

# 可视化每个城市的停留时间
plt.figure(figsize=(10, 6))
plt.bar(visited_cities, stay_durations, color='skyblue')
plt.xlabel('Cities')
plt.ylabel('Stay Duration (hours)')
plt.title('Stay Duration in Each City')
plt.xticks(rotation=90)
plt.grid(True)
plt.show()

# 可视化旅行路线
lats = [city_info[city]['coords'][1] for city in visited_cities]
lons = [city_info[city]['coords'][0] for city in visited_cities]

plt.figure(figsize=(10, 6))
plt.plot(lons, lats, marker='o', color='b')
for i, city in enumerate(visited_cities):
    plt.text(lons[i], lats[i], city, fontsize=12)
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.title('Travel Route')
plt.grid(True)
plt.show()
