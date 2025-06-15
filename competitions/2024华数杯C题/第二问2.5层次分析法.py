import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D


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

# 构建判断矩阵（这里假设一个示例矩阵）
# 需要根据实际情况进行专家打分构建
judgement_matrix = np.array([
    [1, 1/3, 3, 3, 5, 7],
    [3, 1, 5, 3, 5, 7],
    [1/3, 1/5, 1, 1, 3, 5],
    [1/3, 1/3, 1, 1, 3, 5],
    [1/5, 1/5, 1/3, 1/3, 1, 3],
    [1/7, 1/7, 1/5, 1/5, 1/3, 1]
])

# 计算权重
eigvals, eigvecs = np.linalg.eig(judgement_matrix)
max_eigval = np.max(eigvals)
max_eigvec = eigvecs[:, np.argmax(eigvals)]
weights = max_eigvec / np.sum(max_eigvec)

# 将权重应用到每个指标
df["综合评分"] = (
    df["城市规模"] * weights[0] +
    df["环境环保"] * weights[1] +
    df["人文底蕴"] * weights[2] +
    df["交通便利"] * weights[3] +
    df["气候"] * weights[4] +
    df["美食"] * weights[5]
)

# 根据综合评分排序，选出前50个城市
top_cities = df.sort_values(by="综合评分", ascending=False).head(top_n)

# 输出结果
print(top_cities[["城市", "综合评分"]])

# 可视化
fig = plt.figure(figsize=(18, 10))
ax = fig.add_subplot(111, projection='3d')

# 获取需要绘制的数据
x = np.arange(top_n)
y = np.zeros(top_n)
z = np.zeros(top_n)
dx = np.ones(top_n)
dy = np.ones(top_n)
dz = top_cities["综合评分"].values

# 绘制三维柱状图
ax.bar3d(x, y, z, dx, dy, dz, shade=True)
ax.set_xticks(x)
ax.set_xticklabels(top_cities["城市"], rotation=90)
ax.set_xlabel('城市')
ax.set_ylabel('Y')
ax.set_zlabel('综合评分')
ax.set_title("前50个最令外国游客向往的城市综合评分")

plt.show()