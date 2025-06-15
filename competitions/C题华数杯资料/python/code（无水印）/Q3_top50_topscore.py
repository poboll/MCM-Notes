import pandas as pd
import numpy as np

# 读取CSV数据
df = pd.read_csv('E:/CTi/Q3_top50.csv')

# 找到每个城市评分最高的样本
highest_rated = df[df.groupby('来源城市')['评分'].transform('max') == df['评分']]

# 对于评分相同的样本，随机选择一个
random_selected = highest_rated.groupby('来源城市').apply(lambda x: x.sample(1)).reset_index(drop=True)

# 保存结果到新的CSV文件
random_selected.to_csv('E:/CTi/Q3_top50_topscore.csv', index=False)

print("已保存每个城市评分最高且随机选择的样本到 'E:/CTi/Q3_top50_topscore.csv'")
