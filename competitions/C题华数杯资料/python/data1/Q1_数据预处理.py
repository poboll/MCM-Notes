import pandas as pd

# 加载数据
file_path = 'E:/CTi/merged_data.csv'
data = pd.read_csv(file_path)

# 显示数据前几行，确保数据正确加载
print("原始数据：")
print(data.head())

# 将评分列中的 '--' 转换为 NaN
data['评分'] = data['评分'].replace('--', pd.NA)

# 删除评分缺失的行
cleaned_data = data.dropna(subset=['评分'])

# 保存清洗后的数据
cleaned_file_path = 'E:/CTi/cleaned_merged_data.csv'
cleaned_data.to_csv(cleaned_file_path, index=False)

# 显示清洗后的数据前几行，确保数据正确保存
print("清洗后的数据：")
print(cleaned_data.head())
