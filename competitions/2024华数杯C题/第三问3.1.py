import pulp
import numpy as np
import pandas as pd

# 模拟数据生成
np.random.seed(42)  # 固定随机数种子，保证结果可重复

# 城市列表
cities = ['广州','本溪', '毕节', '滨州', '蚌埠', '博尔塔拉', '泊头', '昌吉', '昌江', '常德', '常州', '巢湖', '朝阳', '潮州', '郴州', '成都', '承德', '遵化', '赤峰', '萍乡', '蓬莱', '楚雄州', '达州', '大理', '大连', '大庆', '大同', '大兴安岭']

# 城市间高铁时间和费用 (单位: 小时, 元)
high_speed_rail_time = np.random.uniform(1, 5, size=(len(cities), len(cities)))
high_speed_rail_cost = np.random.uniform(50, 200, size=(len(cities), len(cities)))

# 城市的景点游览时间和门票费用 (单位: 小时, 元)
city_sightseeing_time = np.random.uniform(1, 5, size=len(cities))
city_sightseeing_cost = np.random.uniform(20, 100, size=len(cities))
city_sightseeing_score = np.random.uniform(60, 100, size=len(cities))

# 创建问题实例
prob = pulp.LpProblem("Tourist_Travel_Route", pulp.LpMaximize)

# 定义决策变量
x = pulp.LpVariable.dicts("x", [(i, j) for i in range(len(cities)) for j in range(len(cities))], 0, 1, pulp.LpBinary)
y = pulp.LpVariable.dicts("y", range(len(cities)), 0, 1, pulp.LpBinary)

# 目标函数：最大化游客游览的城市数量，同时考虑综合评分减去成本
prob += pulp.lpSum([y[i] * (city_sightseeing_score[i] - city_sightseeing_cost[i]) for i in range(len(cities))])

# 时间约束：总时间不超过144小时
prob += pulp.lpSum([x[(i, j)] * high_speed_rail_time[i][j] for i in range(len(cities)) for j in range(len(cities)) if i != j]) \
       + pulp.lpSum([y[i] * city_sightseeing_time[i] for i in range(len(cities))]) <= 144

# 流量约束：确保从广州出发并游览其他城市
for i in range(len(cities)):
    if i != 0:  # 0表示广州
        prob += pulp.lpSum([x[(i, j)] for j in range(len(cities)) if i != j]) - pulp.lpSum([x[(j, i)] for j in range(len(cities)) if i != j]) == 0

prob += pulp.lpSum([x[(0, j)] for j in range(len(cities)) if j != 0]) == 1

# 二元变量约束
for i in range(len(cities)):
    for j in range(len(cities)):
        if i != j:
            prob += x[(i, j)] <= y[i]
            prob += x[(i, j)] <= y[j]

# 解决问题
prob.solve()

# 输出结果
route = []
for i in range(len(cities)):
    if y[i].varValue == 1:
        route.append(cities[i])

print("游览的城市列表:", route)
print("总游览时间:", pulp.value(prob.objective))

# 输出详细路线
for i in range(len(cities)):
    for j in range(len(cities)):
        if i != j and x[(i, j)].varValue == 1:
            print(f"从 {cities[i]} 到 {cities[j]}: 高铁时间 {high_speed_rail_time[i][j]:.2f} 小时, 高铁费用 {high_speed_rail_cost[i][j]:.2f} 元")

print("每个城市的游览时间和门票费用:")
for i in range(len(cities)):
    if y[i].varValue == 1:
        print(f"{cities[i]}: 游览时间 {city_sightseeing_time[i]:.2f} 小时, 门票费用 {city_sightseeing_cost[i]:.2f} 元")