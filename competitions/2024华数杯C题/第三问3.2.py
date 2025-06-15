import random
import numpy as np
import matplotlib.pyplot as plt
from deap import base, creator, tools, algorithms

#导入库
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# 模拟数据生成
np.random.seed(42)
random.seed(42)

# 城市列表
cities = ['广州','本溪', '毕节', '滨州', '蚌埠', '博尔塔拉', '泊头', '昌吉', '昌江', '常德', '常州', '巢湖', '朝阳', '潮州', '郴州', '成都', '承德', '遵化', '赤峰', '萍乡', '蓬莱', '楚雄州', '达州', '大理', '大连', '大庆', '大同', '大兴安岭']
num_cities = len(cities)

# 城市间高铁时间和费用 (单位: 小时, 元)
high_speed_rail_time = np.random.uniform(1, 5, size=(num_cities, num_cities))
high_speed_rail_cost = np.random.uniform(50, 200, size=(num_cities, num_cities))

# 城市的景点游览时间和门票费用 (单位: 小时, 元)
city_sightseeing_time = np.random.uniform(1, 5, size=num_cities)
city_sightseeing_cost = np.random.uniform(20, 100, size=num_cities)
city_sightseeing_score = np.random.uniform(60, 100, size=num_cities)

# 初始化DEAP框架
creator.create("FitnessMax", base.Fitness, weights=(1.0,))
creator.create("Individual", list, fitness=creator.FitnessMax)

toolbox = base.Toolbox()
toolbox.register("indices", random.sample, range(num_cities), num_cities)
toolbox.register("individual", tools.initIterate, creator.Individual, toolbox.indices)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)

def evalTSP(individual):
    total_time = 0
    total_score = 0
    total_cost = 0

    for i in range(num_cities):
        if i < num_cities - 1:
            total_time += high_speed_rail_time[individual[i]][individual[i+1]]
            total_cost += high_speed_rail_cost[individual[i]][individual[i+1]]
        total_time += city_sightseeing_time[individual[i]]
        total_cost += city_sightseeing_cost[individual[i]]
        total_score += city_sightseeing_score[individual[i]]

    if total_time > 144:
        return -1000000,  # 罚分，若总时间超过144小时
    return total_score - total_cost,

toolbox.register("mate", tools.cxOrdered)
toolbox.register("mutate", tools.mutShuffleIndexes, indpb=0.2)
toolbox.register("select", tools.selTournament, tournsize=3)
toolbox.register("evaluate", evalTSP)

def main():
    pop = toolbox.population(n=300)
    hof = tools.HallOfFame(1)
    stats = tools.Statistics(lambda ind: ind.fitness.values)
    stats.register("avg", np.mean)
    stats.register("std", np.std)
    stats.register("min", np.min)
    stats.register("max", np.max)

    pop, log = algorithms.eaSimple(pop, toolbox, 0.7, 0.2, 50, stats=stats, halloffame=hof, verbose=True)

    return pop, log, hof

# 执行遗传算法
pop, log, hof = main()

# 最佳个体
best_ind = hof[0]
best_route = [cities[i] for i in best_ind]
print("最佳游览路线:", best_route)

# 绘制城市的二维图形
city_coords = np.random.rand(num_cities, 2) * 100  # 模拟城市的坐标

plt.figure(figsize=(10, 6))
for i, city in enumerate(cities):
    plt.plot(city_coords[i][0], city_coords[i][1], 'bo')
    plt.text(city_coords[i][0] + 1, city_coords[i][1], city, fontsize=12)

for i in range(num_cities - 1):
    plt.plot([city_coords[best_ind[i]][0], city_coords[best_ind[i+1]][0]],
             [city_coords[best_ind[i]][1], city_coords[best_ind[i+1]][1]], 'r-')

plt.plot([city_coords[best_ind[-1]][0], city_coords[best_ind[0]][0]],
         [city_coords[best_ind[-1]][1], city_coords[best_ind[0]][1]], 'r-')

plt.title("最佳游览路线")
plt.xlabel("X 坐标")
plt.ylabel("Y 坐标")
plt.grid(True)
plt.show()