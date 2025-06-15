import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#导入库
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# 设置城市数量和要选出的城市数量
num_cities = 28
top_n = 27

# 随机生成城市名称
cities = ['广州','本溪', '毕节', '滨州', '蚌埠', '博尔塔拉', '泊头', '昌吉', '昌江', '常德', '常州', '巢湖', '朝阳', '潮州', '郴州', '成都', '承德', '遵化', '赤峰', '萍乡', '蓬莱', '楚雄州', '达州', '大理', '大连', '大庆', '大同', '大兴安岭']

# 随机生成各个指标的数据
np.random.seed(42)  # 固定随机种子，保证结果可重复
city_size = np.random.rand(num_cities) * 100
environmental_protection = np.random.rand(num_cities) * 100
cultural_heritage = np.random.rand(num_cities) * 100
transportation_convenience = np.random.rand(num_cities) * 100
climate = np.random.rand(num_cities) * 100
cuisine = np.random.rand(num_cities) * 100

# 组合成数据框
data = {
    "城市": cities,
    "城市规模": city_size,
    "环境环保": environmental_protection,
    "人文底蕴": cultural_heritage,
    "交通便利": transportation_convenience,
    "气候": climate,
    "美食": cuisine
}
df = pd.DataFrame(data)

# 标准化处理（Min-Max 标准化）
for col in df.columns[1:]:
    df[col] = (df[col] - df[col].min()) / (df[col].max() - df[col].min())

# 设置权重（假设每个指标权重相等）
weights = {
    "城市规模": 1,
    "环境环保": 1,
    "人文底蕴": 1,
    "交通便利": 1,
    "气候": 1,
    "美食": 1
}

# 计算综合评分
df["综合评分"] = sum(df[col] * weight for col, weight in weights.items())

# 根据综合评分排序，选出前50个城市
top_cities = df.sort_values(by="综合评分", ascending=False).head(top_n)

# 输出结果
print(top_cities[["城市", "综合评分"]])

# 可视化
plt.figure(figsize=(15, 10))
sns.barplot(x="综合评分", y="城市", data=top_cities, palette="viridis")
plt.title("前50个最令外国游客向往的城市综合评分")
plt.xlabel("综合评分")
plt.ylabel("城市")
plt.show()