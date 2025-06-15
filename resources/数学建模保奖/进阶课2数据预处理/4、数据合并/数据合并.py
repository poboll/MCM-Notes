import os
import pandas as pd

# 定义文件夹路径和输出文件路径
folder_path = '附件'  # 你的文件夹路径
output_file = 'merged_data_with_source.csv'  # 合并后的输出文件

# 获取文件夹中的所有CSV文件
files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

# 初始化一个空的DataFrame用于合并数据
merged_df = pd.DataFrame()

# 遍历所有文件并合并内容
for file in files:
    file_path = os.path.join(folder_path, file)

    # 提取文件名（不包括扩展名）作为城市名
    city_name = os.path.splitext(file)[0]

    # 读取CSV文件到DataFrame
    df = pd.read_csv(file_path)

    # 增加一列用于区分来源城市
    df['来源城市'] = city_name

    # 将当前文件的DataFrame追加到合并的DataFrame中
    merged_df = pd.concat([merged_df, df], ignore_index=True)

# 将合并后的DataFrame写入输出文件
merged_df.to_csv(output_file, index=False)

print('文件合并完成。')
