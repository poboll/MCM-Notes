import pandas as pd
import matplotlib.pyplot as plt

# 设置全局字体为中文
plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用SimHei字体
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 加载数据
file_path = 'E:/CTi/merged_data.csv'
data = pd.read_csv(file_path)

# 提取评分和城市字段
scores = data[['评分', '来源城市']].copy()

# 将'评分'列转换为数值型，并将无法转换的值设为NaN
scores['评分'] = pd.to_numeric(scores['评分'], errors='coerce')

# 删除'评分'列中包含NaN的行
scores.dropna(subset=['评分'], inplace=True)

# 找到最高评分 (BS)
BS = scores['评分'].max()

# 统计评分为最高评分 (BS) 的景点数量
BS_count = scores[scores['评分'] == BS].shape[0]

# 找到拥有评分为最高评分 (BS) 景点的城市，并统计每个城市的数量
BS_cities = scores[scores['评分'] == BS].groupby('来源城市').size().reset_index(name='景点数量')

# 按照拥有评分为最高评分 (BS) 景点的数量排序，列出前10个城市
top_BS_cities = BS_cities.sort_values(by='景点数量', ascending=False).head(10)

# 显示结果
print("最高评分 (BS):", BS)
print("获得最高评分的景点数量 (BS_count):", BS_count)
print("拥有最高评分景点最多的城市前10名 (Top 10 Cities with Highest Scoring 景点):")
print(top_BS_cities)

# 可视化1：柱状图
plt.figure(figsize=(12, 6))
plt.bar(top_BS_cities['来源城市'], top_BS_cities['景点数量'], color='skyblue')
plt.xlabel('城市')
plt.ylabel('景点数量')
plt.title('拥有最高评分景点数量最多的前10个城市')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 可视化2：饼图
plt.figure(figsize=(10, 10))
plt.pie(top_BS_cities['景点数量'], labels=top_BS_cities['来源城市'], autopct='%1.1f%%', startangle=140, colors=plt.cm.Paired(range(len(top_BS_cities))))
plt.title('拥有最高评分景点数量最多的前10个城市占比')
plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
plt.show()
