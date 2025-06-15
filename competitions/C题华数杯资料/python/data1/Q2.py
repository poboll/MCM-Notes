# import pandas as pd
# from sklearn.preprocessing import StandardScaler
# import matplotlib.pyplot as plt
#
# # 设置全局字体为中文
# plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用SimHei字体
# plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号
#
# # 加载数据
# file_path = 'E:/CTi/Q2_Data.xlsx'
# data = pd.read_excel(file_path)
#
# # 显示数据结构，确保正确加载
# print("数据预览：")
# print(data.head())
#
# # 提取需要的指标
# features = [
#     'AQI', '绿化覆盖率 (%)', '废水处理率 (%)', '废气处理率 (%)', '垃圾分类处理率 (%)',
#     '历史遗迹数量', '博物馆数量', '文化活动频次', '文化设施数量',
#     '公共交通覆盖率 (%)', '线路密度 (km/km²)', '高速公路里程 (km)', '机场航班数量',
#     '年平均气温 (℃)', '年降水量 (mm)', '适宜旅游天数', '空气湿度 (%)',
#     '餐馆数量', '特色美食数量', '美食活动频次'
# ]
#
# # 将所有需要的指标列转换为数值类型，并处理错误
# for feature in features:
#     data[feature] = pd.to_numeric(data[feature], errors='coerce')
#
# # 删除包含NaN的行
# data.dropna(subset=features, inplace=True)
#
# # 数据标准化
# scaler = StandardScaler()
# standardized_data = scaler.fit_transform(data[features])
#
# # 转换回DataFrame并添加城市列
# standardized_data = pd.DataFrame(standardized_data, columns=features)
# standardized_data['城市'] = data['来源城市']
#
# # 设定权重（示例）
# weights = {
#     'AQI': 0.05, '绿化覆盖率 (%)': 0.05, '废水处理率 (%)': 0.05, '废气处理率 (%)': 0.05, '垃圾分类处理率 (%)': 0.05,
#     '历史遗迹数量': 0.05, '博物馆数量': 0.05, '文化活动频次': 0.05, '文化设施数量': 0.05,
#     '公共交通覆盖率 (%)': 0.05, '线路密度 (km/km²)': 0.05, '高速公路里程 (km)': 0.05, '机场航班数量': 0.05,
#     '年平均气温 (℃)': 0.05, '年降水量 (mm)': 0.05, '适宜旅游天数': 0.05, '空气湿度 (%)': 0.05,
#     '餐馆数量': 0.05, '特色美食数量': 0.05, '美食活动频次': 0.05
# }
#
# # 计算综合评分
# weighted_data = standardized_data.copy()
# for col, weight in weights.items():
#     weighted_data[col] = standardized_data[col] * weight
#
# # 计算综合评分时排除'城市'列
# weighted_data['综合评分'] = weighted_data[features].sum(axis=1)
#
# # 添加城市列
# weighted_data['城市'] = data['来源城市']
#
# # 按综合评分排序，选出前50个城市
# top_50_cities = weighted_data.sort_values(by='综合评分', ascending=False).head(50)
#
# # 显示结果
# print("最令外国游客向往的50个城市:")
# print(top_50_cities[['城市', '综合评分']])
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from scipy.linalg import eig
import numpy as np
import warnings

warnings.filterwarnings("ignore", category=RuntimeWarning)

# 设置全局字体为中文
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用SimHei字体
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 加载数据
file_path = 'E:/CTi/Q2_Data.xlsx'
data = pd.read_excel(file_path)

# 显示数据结构，确保正确加载
print("数据预览：")
print(data.head())

# 提取需要的指标
features = [
    'AQI', '绿化覆盖率 (%)', '废水处理率 (%)', '废气处理率 (%)', '垃圾分类处理率 (%)',
    '历史遗迹数量', '博物馆数量', '文化活动频次', '文化设施数量',
    '公共交通覆盖率 (%)', '线路密度 (km/km²)', '高速公路里程 (km)', '机场航班数量',
    '年平均气温 (℃)', '年降水量 (mm)', '适宜旅游天数', '空气湿度 (%)',
    '餐馆数量', '特色美食数量', '美食活动频次'
]

# 将所有需要的指标列转换为数值类型，并处理错误
for feature in features:
    data[feature] = pd.to_numeric(data[feature], errors='coerce')

# 删除包含NaN的行
data.dropna(subset=features, inplace=True)

# 数据标准化
scaler = StandardScaler()
standardized_data = scaler.fit_transform(data[features])

# 转换回DataFrame并添加城市列
standardized_data = pd.DataFrame(standardized_data, columns=features)
standardized_data['城市'] = data['来源城市']

# AHP确定权重
# 构建AHP判断矩阵
AHP_matrix = np.array([
    [1, 1/3, 1/5, 1/2, 1/4],
    [3, 1, 1/3, 2, 1/2],
    [5, 3, 1, 4, 2],
    [2, 1/2, 1/4, 1, 1/3],
    [4, 2, 1/2, 3, 1]
])

# 计算特征向量和特征值
eig_values, eig_vectors = eig(AHP_matrix)
max_eig_value = np.max(np.real(eig_values))
max_eig_vector = np.real(eig_vectors[:, np.argmax(np.real(eig_values))])

# 计算权重向量
weights = max_eig_vector / np.sum(max_eig_vector)
print("权重向量:", weights)

# 主成分分析（PCA）进行降维
categories = {
    '环境环保': ['AQI', '绿化覆盖率 (%)', '废水处理率 (%)', '废气处理率 (%)', '垃圾分类处理率 (%)'],
    '人文底蕴': ['历史遗迹数量', '博物馆数量', '文化活动频次', '文化设施数量'],
    '交通便利': ['公共交通覆盖率 (%)', '线路密度 (km/km²)', '高速公路里程 (km)', '机场航班数量'],
    '气候': ['年平均气温 (℃)', '年降水量 (mm)', '适宜旅游天数', '空气湿度 (%)'],
    '美食': ['餐馆数量', '特色美食数量', '美食活动频次']
}

pca_data = pd.DataFrame()
pca = PCA(n_components=1)
for category, features in categories.items():
    pca_result = pca.fit_transform(standardized_data[features])
    pca_data[category] = pca_result.flatten()

# 添加城市列
pca_data['城市'] = data['来源城市']

# 基于熵权法的TOPSIS进行综合评价
def entropy_weight(data):
    k = 1.0 / np.log(len(data))
    data = data / (data.sum(axis=0) + 1e-10)  # 归一化并避免出现0值
    data = data * np.log(data + 1e-10)  # 避免取对数时出现无效值
    entropy = -k * (data.sum(axis=0))
    weight = (1 - entropy) / (1 - entropy).sum()
    return weight

# 计算权重
topsis_weights = entropy_weight(pca_data.drop(columns=['城市']))

# TOPSIS综合评价
def topsis(data, weight):
    data = data.values
    weight = np.array(weight)
    Z = data / np.sqrt((data**2).sum(axis=0))  # 归一化矩阵
    A_pos = Z.max(axis=0)  # 正理想解
    A_neg = Z.min(axis=0)  # 负理想解
    D_pos = np.sqrt(((Z - A_pos) ** 2 * weight).sum(axis=1))  # 正理想解距离
    D_neg = np.sqrt(((Z - A_neg) ** 2 * weight).sum(axis=1))  # 负理想解距离
    score = D_neg / (D_pos + D_neg)
    return score

# 计算TOPSIS评分
topsis_scores = topsis(pca_data.drop(columns=['城市']), topsis_weights)
pca_data['综合评分'] = topsis_scores

# 按综合评分排序，选出前50个城市
top_50_cities = pca_data.sort_values(by='综合评分', ascending=False).head(50)

# 显示结果
print("最令外国游客向往的50个城市:")
print(top_50_cities[['城市', '综合评分']])


# 只保留前50个城市的数据
top_50_cities = pca_data.sort_values(by='综合评分', ascending=False).head(50)

# 可视化
# 绘制柱状图
plt.figure(figsize=(14, 8))
plt.barh(top_50_cities['城市'], top_50_cities['综合评分'])
plt.xlabel('综合评分')
plt.ylabel('城市')
plt.title('最令外国游客向往的50个城市综合评分')
plt.gca().invert_yaxis()  # 翻转Y轴，城市按综合评分从高到低排列
plt.show()

# 绘制热力图
plt.figure(figsize=(14, 10))
heatmap_data = standardized_data.loc[top_50_cities.index, features]
plt.imshow(heatmap_data, aspect='auto', cmap='viridis')
plt.colorbar(label='标准化得分')
plt.xticks(ticks=np.arange(len(features)), labels=features, rotation=90)
plt.yticks(ticks=np.arange(len(top_50_cities)), labels=top_50_cities['城市'])
plt.title('前50个城市在不同指标上的得分情况')
plt.show()

# 读取包含前50个城市及其经纬度的CSV文件
cities_coords = pd.read_csv('E:/CTi/china_cities.csv')

# 将top_50_cities与cities_coords合并，以获取经纬度信息
merged_data = pd.merge(top_50_cities, cities_coords, on='城市', how='left')

# 绘制城市位置图
plt.figure(figsize=(10, 8))
plt.scatter(merged_data['经度'], merged_data['纬度'], c=merged_data['综合评分'], cmap='viridis', s=100)
for i, city in enumerate(merged_data['城市']):
    plt.text(merged_data['经度'].iloc[i], merged_data['纬度'].iloc[i], city, fontsize=9)
plt.colorbar(label='综合评分')
plt.xlabel('经度')
plt.ylabel('纬度')
plt.title('前50个城市在中国地图上的位置')
plt.show()
