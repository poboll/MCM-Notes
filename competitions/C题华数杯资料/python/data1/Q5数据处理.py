import pandas as pd

# 读取CSV文件
csv_file_path = 'E:/CTi/Q5_jingweidu.csv'
try:
    csv_data = pd.read_csv(csv_file_path, encoding='utf-8')
except UnicodeDecodeError:
    csv_data = pd.read_csv(csv_file_path, encoding='GBK')

# 读取Excel文件
excel_file_path = 'E:/CTi/Q5_data.xlsx'
excel_data = pd.read_excel(excel_file_path)

# 将CSV数据的列重命名为与Excel数据匹配
csv_data.columns = ['来源城市', '经度', '纬度']

# 合并数据，基于“来源城市”匹配
merged_data = pd.merge(excel_data, csv_data, on='来源城市', how='left')

# 检查合并后的数据
print(merged_data.head())

# 保存修改后的数据到新的Excel文件
output_file_path = 'E:/CTi/Q5_data1.xlsx'
merged_data.to_excel(output_file_path, index=False)

# 提示用户下载文件
output_file_path
