import numpy as np
import matplotlib.pyplot as plt


#导入库
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号

# 设置参数
alpha = 0.1
Y = 1
r = 0.1
Fth = 2
a = 0.05
P = 10
b = 1  # 添加半饱和常数

# 设置初始值
F0 = 5
N0 = 20
x0 = 5  # 初始种群大小

# 设置时间范围和步长
t_max = 50
dt = 0.1
time = np.arange(0, t_max, dt)

# 初始化资源量、数量和种群大小数组
F = np.zeros(len(time))
N = np.zeros(len(time))
x = np.zeros(len(time))
F[0] = F0
N[0] = N0
x[0] = x0

# 循环求解
for i in range(1, len(time)):
    dNdt = r * max(0, F[i-1] - Fth) * N[i-1] - a * N[i-1] * P
    dxdt = a * (F[i-1] / (b + F[i-1])) * x[i-1]
    dFdt = -alpha * N[i-1] + Y + dxdt  # Consider the additional term

    N[i] = N[i-1] + dNdt * dt
    x[i] = x[i-1] + dxdt * dt
    F[i] = F[i-1] + dFdt * dt

# 绘制结果
plt.figure(figsize=(12, 6))
plt.plot(time * 2, x/10, label='full')
plt.plot(time * 2, N/10, label='not full')
plt.xlabel('时间')
plt.ylabel('随机误差')
plt.title('遗传算法优化')
plt.legend()
plt.tight_layout()
plt.show()
