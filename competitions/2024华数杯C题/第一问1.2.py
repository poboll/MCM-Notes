import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

#导入库
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

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

# 找到拥有最多BS评分景点的前10名城市
top_10_cities = city_BS_counts.sort_values(ascending=False).head(10)

# 绘制柱状图
plt.figure(figsize=(12, 6))
top_10_cities.plot(kind='bar', color='skyblue')
plt.title('Top 10 Cities with Most Sights Rated as Highest Score (BS)')
plt.xlabel('City')
plt.ylabel('Number of Sights with Highest Score')
plt.xticks(rotation=45)
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()

# 显示图像
plt.show()
