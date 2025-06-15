import pandas as pd

# 定义前50个城市列表
top_50_cities = [
    '福州', '大理', '恩施', '潜江', '咸宁', '三亚', '惠州', '朔州', '常德', '攀枝花',
    '晋城', '琼海', '可克达拉', '成都', '临高', '台州', '定西', '楚雄州', '嘉峪关', '扬州',
    '雄安新区', '济源', '北京', '儋州', '呼和浩特', '中山', '贵阳', '丽江', '安庆', '五家渠',
    '南充', '潍坊', '贺州', '邵阳', '通化', '杭州', '泸州', '汕尾', '济南', '广州',
    '河源', '衡阳', '马鞍山', '迪庆', '鄂尔多斯', '清远', '邢台', '七台河', '铁岭', '海口'
]

# 加载数据，指定编码格式
file_path = 'E:/CTi/Q3_all.xlsx'
data = pd.read_excel(file_path)


# 提取前50个城市的信息
filtered_data = data[data['来源城市'].isin(top_50_cities)]

# 删除“建议游玩时长”为空值的行
filtered_data = filtered_data.dropna(subset=['建议游玩时间'])

# 显示提取并删除后的信息
print("前50个城市的信息（删除“建议游玩时长”为空值的行）:")
print(filtered_data.head())

# 保存提取并删除后的信息到新的CSV文件
filtered_data.to_csv('E:/CTi/Q3_top50.csv', index=False)
print("提取并删除后的信息已保存到 'E:/CTi/Q3_top50.csv'")
