
import matplotlib.pyplot as plt

# 假设有两个变量：X和Y
X = [1, 2, 3, 4, 5,15,4,9,1,5,7,3,74,5]
Y = [2, 3, 5, 7, 5,15,4,9,1,5,7,3,74,5]

plt.scatter(X, Y)
plt.title('Scatter Plot Example')
plt.xlabel('X')
plt.ylabel('Y')
plt.show()


import matplotlib.pyplot as plt

# 假设有三个类别的数量
categories = ['A', 'B', 'C']
values = [10, 20, 15]

plt.bar(categories, values)
plt.title('Bar Chart Example')
plt.xlabel('Category')
plt.ylabel('Values')
plt.show()

import matplotlib.pyplot as plt

# 假设有一组数据
data = [1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 10, 10, 11]

plt.boxplot(data)
plt.title('Box Plot Example')
plt.ylabel('Values')
plt.show()

import matplotlib.pyplot as plt

# 假设有一组数据
data = [1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 10, 10, 11]

plt.hist(data, bins=5)
plt.title('Histogram Example')
plt.xlabel('Values')
plt.ylabel('Frequency')
plt.show()

import seaborn as sns
import numpy as np

# 假设有一个相关性矩阵
data = np.random.rand(10, 10)

sns.heatmap(data, annot=True, cmap='coolwarm')
plt.title('Heatmap Example')
plt.show()

import matplotlib.pyplot as plt

# 假设有一组时间序列数据
time = [1, 2, 3, 4, 5]
values = [2, 3, 5, 7, 11]

plt.plot(time, values)
plt.title('Line Plot Example')
plt.xlabel('Time')
plt.ylabel('Values')
plt.show()
