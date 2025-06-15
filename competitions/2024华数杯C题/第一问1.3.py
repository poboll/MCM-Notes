import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# 导入库
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 定义城市名称
cities = ['广州', '本溪', '毕节', '滨州', '蚌埠', '博尔塔拉', '泊头', '昌吉', '昌江', '常德', '常州', '巢湖',
          '朝阳', '潮州', '郴州', '成都', '承德', '遵化', '赤峰', '萍乡', '蓬莱', '楚雄州', '达州', '大理',
          '大连', '大庆', '大同', '大兴安岭']

num_cities = len(cities)
num_sights_per_city = 100
max_score = 5

# 固定随机种子以保证可重复性
np.random.seed(42)

# 随机生成每个城市100个景点的评分数据
data = {
    city: np.random.randint(1, max_score + 1, num_sights_per_city).tolist()
    for city in cities
}

# 转换为DataFrame
df = pd.DataFrame(data)

# 找到最高评分BS
all_scores = df.values.flatten()
BS = np.max(all_scores)

# 统计每个城市中最高评分BS的景点数量
city_BS_counts = df.apply(lambda x: np.sum(x == BS), axis=0)

# 遗传算法参数
population_size = 100
num_generations = 50
mutation_rate = 0.01
num_parents_mating = 20

# 初始化种群
def init_population(pop_size, num_cities):
    return np.random.randint(2, size=(pop_size, num_cities))

# 适应度函数
def fitness_function(population, city_counts):
    return np.sum(population * city_counts.values, axis=1)

# 选择父代
def select_mating_pool(population, fitness, num_parents):
    parents = np.empty((num_parents, population.shape[1]))
    for parent_num in range(num_parents):
        max_fitness_idx = np.where(fitness == np.max(fitness))[0][0]
        parents[parent_num, :] = population[max_fitness_idx, :]
        fitness[max_fitness_idx] = -999999
    return parents

# 交叉操作
def crossover(parents, offspring_size):
    offspring = np.empty(offspring_size)
    crossover_point = np.uint8(offspring_size[1] / 2)

    for k in range(offspring_size[0]):
        parent1_idx = k % parents.shape[0]
        parent2_idx = (k + 1) % parents.shape[0]
        offspring[k, 0:crossover_point] = parents[parent1_idx, 0:crossover_point]
        offspring[k, crossover_point:] = parents[parent2_idx, crossover_point:]
    return offspring

# 变异操作
def mutation(offspring_crossover, mutation_rate):
    for idx in range(offspring_crossover.shape[0]):
        for _ in range(np.uint8(offspring_crossover.shape[1] * mutation_rate)):
            gene_idx = np.random.randint(0, offspring_crossover.shape[1])
            offspring_crossover[idx, gene_idx] = 1 - offspring_crossover[idx, gene_idx]
    return offspring_crossover

# 遗传算法主循环
population = init_population(population_size, num_cities)
for generation in range(num_generations):
    fitness = fitness_function(population, city_BS_counts)
    parents = select_mating_pool(population, fitness, num_parents_mating)
    offspring_crossover = crossover(parents, (population_size - parents.shape[0], num_cities))
    offspring_mutation = mutation(offspring_crossover, mutation_rate)
    population[0:parents.shape[0], :] = parents
    population[parents.shape[0]:, :] = offspring_mutation

# 找到最佳解决方案
best_solution_idx = np.where(fitness == np.max(fitness))[0][0]
best_solution = population[best_solution_idx, :]
best_cities = np.where(best_solution == 1)[0]

# 打印结果
print("最佳城市组合：")
print([cities[i] for i in best_cities])
print("最佳组合的景点数量：")
print(fitness[best_solution_idx])

# 三维图像绘制
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

x = np.arange(num_cities)
y = city_BS_counts.values
z = np.zeros(num_cities)

dx = np.ones(num_cities)
dy = np.ones(num_cities)
dz = y

ax.bar3d(x, y, z, dx, dy, dz, color='red')

ax.set_xlabel('城市索引')
ax.set_ylabel('BS数量')
ax.set_zlabel('数量')

plt.title('城市BS数量的三维可视化')
plt.tight_layout()

# 显示图像
plt.show()
