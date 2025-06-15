import pandas as pd
import numpy as np

# 定义城市名称
cities = ['广州', '本溪', '毕节', '滨州', '蚌埠', '博尔塔拉', '泊头', '昌吉', '昌江', '常德', '常州', '巢湖',
          '朝阳', '潮州', '郴州', '成都', '承德', '遵化', '赤峰', '萍乡', '蓬莱', '楚雄州', '达州', '大理',
          '大连', '大庆', '大同', '大兴安岭']

num_cities = len(cities)
num_sights_per_city = 100
max_score = 5.0

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
print(f"最高评分 (BS): {BS}")

# 统计获得最高评分BS的景点数量
BS_count = np.sum(all_scores == BS)
print(f"获得最高评分BS的景点数量: {BS_count}")

# 统计每个城市中最高评分BS的景点数量
city_BS_counts = df.apply(lambda x: np.sum(x == BS), axis=0)

# 找到拥有最多BS评分景点的前10名城市
top_10_cities = city_BS_counts.sort_values(ascending=False).head(10)
print("拥有最多BS评分景点的前10名城市:")
print(top_10_cities)

# 打印详细信息
print("详细信息:")
for city, count in top_10_cities.items():
    print(f"{city}: {count}个景点")
