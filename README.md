# 📊 MCM-Notes | 数学建模竞赛备份仓库

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/username/MCM-Notes?style=flat-square)](https://github.com/username/MCM-Notes/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/username/MCM-Notes?style=flat-square)](https://github.com/username/MCM-Notes/network)
[![GitHub license](https://img.shields.io/github/license/username/MCM-Notes?style=flat-square)](https://github.com/username/MCM-Notes/blob/main/LICENSE)
[![Python](https://img.shields.io/badge/Python-3.7+-blue?style=flat-square&logo=python)](https://www.python.org/)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a+-orange?style=flat-square&logo=mathworks)](https://www.mathworks.com/)

**🏆 中国大学生数学建模竞赛 (CUMCM) 完整备份仓库**

*一个包含2023-2024年数学建模竞赛源码、文档、数据的综合性学习资源库*

[📖 快速开始](#快速开始) • [🎯 项目特色](#项目特色) • [📁 目录结构](#目录结构) • [🛠️ 技术栈](#技术栈) • [📊 竞赛成果](#竞赛成果)

</div>

---

## 🎯 项目特色

- 🏅 **获奖经验**: 包含省一、省二等奖获奖论文和代码
- 🔬 **多算法实现**: 涵盖机器学习、优化算法、数据分析等多种方法
- 📚 **完整资料**: 从数据预处理到模型建立的完整解决方案
- 🌐 **数据丰富**: 包含爬虫获取的山西省高校数学建模提交文档数据库
- 🎨 **可视化**: 丰富的数据可视化图表和地图展示
- 📖 **学习资源**: 详细的算法教程和建模方法指导

## 📁 项目结构

```
MCM-Notes/
├── 🏆 awards/                    # 获奖证书
│   ├── 奖状_省一_2024年广东省大学生数学建模竞赛暨全国大学生数学建模竞赛广东省分赛苏增烨、聂宇丹、李绪信_2404011402.pdf
│   └── 奖状_省二_2023年广东省大学生数学建模竞赛暨全国大学生数学建模竞赛广东省分赛吴粤、黄雨萱苏增烨_2304012334.pdf
├── 🏁 competitions/              # 竞赛资料
│   ├── 2021高教社杯数学建模竞赛/
│   │   ├── A/ B/ C/ D/ E/         # 各题目分类
│   │   └── format2021.doc        # 论文格式模板
│   ├── 2024华数杯C题/
│   │   ├── C题/                  # 题目资料
│   │   ├── 第一问1.1.py ~ 第一问1.3.py  # 第一问解答代码
│   │   ├── 第二问2.1.py ~ 第二问2.5层次分析法.py  # 第二问解答代码
│   │   ├── 第三问3.1.py ~ 第三问3.2.py  # 第三问解答代码
│   │   ├── 华数杯C题第一问思路.pdf ~ 华数杯C题第三问思路.pdf  # 解题思路
│   │   ├── 2024年第五届华数杯数学建模竞赛论文格式规范与提交说明.pdf
│   │   ├── 2024第五届华数杯竞赛论文模板.docx
│   │   └── 相关参考文献.caj       # 多篇参考文献
│   └── C题华数杯资料/
│       ├── C题论文（总）-无水印版.docx
│       ├── matlab/               # MATLAB实现代码
│       ├── python/               # Python实现代码
│       └── 基于贪心算法下的外国人7天中国游优化研究.docx
├── 📝 papers/                    # 论文文档
│   ├── 23数模国赛-基于数学方法对多波束测深的研究.docx/.pdf
│   ├── 24数模国赛-基于离散过程回归分析的农作物种植策略研究.docx/.pdf
│   └── 24数模练手_2024华数杯C_老外游中国_基于蚁群算法和多目标优化的景点评价与旅行路径规划研究.docx/.pdf
├── 📚 resources/                 # 学习资源
│   ├── 数学建模保奖/              # 数学建模保奖班完整教程
│   │   ├── 进阶课1竞赛介绍+数模入门/
│   │   ├── 进阶课2数据预处理/
│   │   ├── 进阶课3优化模型/
│   │   ├── 进阶课4评价模型/
│   │   ├── 进阶课5评价模型基础/
│   │   ├── 进阶课6评价模型进阶/
│   │   ├── 保奖班第一课评价.pdf
│   │   ├── 保奖班第二课评价进阶.pdf
│   │   └── 论文规范排版 2024.docx
│   ├── 优秀论文/                 # 历年优秀论文集
│   ├── TOPSIS法（优劣解距离法）.pdf
│   ├── 层次分析法（AHP）.pdf
│   ├── 基于正态云组合赋权的水资源配置方案综合评价方法_龚艳冰.pdf
│   ├── 数学建模获奖及经验分享.pdf/.pptx
│   ├── 2021-2022学年度第二学期试卷数学建模基础考试卷.docx
│   ├── 在探索与热爱中，遇见更好的我们.doc
│   └── 讲稿在探索与热爱中，遇见更好的我们.pdf
├── 📋 templates/                 # 论文模板
│   ├── Word模版/
│   │   ├── 1.国赛论文模版.docx
│   │   ├── 2.使用国赛Word模版排版的论文.docx
│   │   ├── 3.使用国赛Word模版排版的论文.pdf
│   │   └── 4.国赛2011B题原论文.doc
│   ├── 论文模版-简化版.docx
│   └── 论文模版-说明版.docx
├── 🛠️ tools/                     # 工具与代码
│   ├── 食堂菜品预测.py           # 美食推荐算法实现
│   └── data.xlsx                # 相关数据文件
├── 📄 README.md                  # 项目说明文档
├── 📋 requirements.txt           # Python依赖包列表
├── 📜 LICENSE                    # 开源协议
└── 🚫 .gitignore                 # Git忽略文件配置
```

## 🛠️ 技术栈

### 编程语言
- **Python 3.7+**: 主要开发语言
- **MATLAB R2020a+**: 数值计算和可视化

### 核心算法
- 🤖 **机器学习**: 随机森林、K-means聚类、支持向量机
- 🔍 **优化算法**: 蚁群算法、遗传算法、粒子群优化
- 📊 **数据分析**: 主成分分析(PCA)、层次分析法(AHP)、TOPSIS
- 🗺️ **路径规划**: Floyd算法、Dijkstra算法、A*算法

### Python依赖库
```python
pandas>=1.3.0          # 数据处理
numpy>=1.21.0           # 数值计算
scikit-learn>=1.0.0     # 机器学习
matplotlib>=3.4.0       # 数据可视化
seaborn>=0.11.0         # 统计可视化
jieba>=0.42.1           # 中文分词
gensim>=4.1.0           # 主题模型
scipy>=1.7.0            # 科学计算
```

### MATLAB工具箱
- Statistics and Machine Learning Toolbox
- Optimization Toolbox
- Mapping Toolbox
- Image Processing Toolbox

## 📊 竞赛成果

### 🏆 获奖记录
- **2024年广东省数学建模竞赛**: 省级一等奖 🥇
- **2023年广东省数学建模竞赛**: 省级二等奖 🥈
- **2024年华数杯数学建模竞赛**: 优秀奖

### 📈 项目亮点
- ✅ **多波束测深研究**: 基于数学方法的海洋测深技术优化
- ✅ **农作物种植策略**: 离散过程回归分析在农业中的应用
- ✅ **旅游路径规划**: 蚁群算法和多目标优化的景点推荐系统
- ✅ **美食推荐算法**: 基于随机森林的智能推荐系统

## 🚀 快速开始

### 环境配置

1. **克隆仓库**
```bash
git clone https://github.com/username/MCM-Notes.git
cd MCM-Notes
```

2. **Python环境设置**
```bash
# 创建虚拟环境
python -m venv mcm_env
source mcm_env/bin/activate  # Linux/Mac
# mcm_env\Scripts\activate  # Windows

# 安装依赖
pip install -r requirements.txt
```

3. **MATLAB环境**
- 确保安装MATLAB R2020a或更高版本
- 安装必要的工具箱

### 运行示例

#### 🍽️ 食堂菜品推荐系统
```bash
python 食堂菜品预测.py
```

#### 🗺️ 旅游路径规划 (华数杯C题)
```bash
# 运行第一问：城市景点评分
python 2024华数杯C题/第一问1.1.py

# 运行第二问：多目标优化
python 2024华数杯C题/第二问2.1.py

# 运行第三问：路径规划
python 2024华数杯C题/第三问3.1.py
```

#### 📊 MATLAB数据可视化
```matlab
% 在MATLAB中运行
cd('C题华数杯资料/matlab')
run('数据可视化.m')
```

## 📖 使用指南

### 🎯 竞赛题目分析流程
1. **问题理解**: 仔细阅读题目，明确问题类型和要求
2. **数据预处理**: 使用提供的数据清洗脚本
3. **模型选择**: 根据问题特点选择合适的算法
4. **代码实现**: 参考对应的Python/MATLAB代码
5. **结果验证**: 使用可视化工具验证结果合理性
6. **论文撰写**: 参考论文模板和获奖论文

### 🔧 代码结构说明
- `第一问*.py`: 数据分析和特征工程
- `第二问*.py`: 模型建立和优化
- `第三问*.py`: 结果验证和可视化
- `*.m`: MATLAB实现的算法和可视化

## 🤝 贡献指南

我们欢迎任何形式的贡献！

### 如何贡献
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 贡献类型
- 🐛 Bug修复
- ✨ 新功能添加
- 📚 文档改进
- 🎨 代码优化
- 📊 新的数据集
- 🧮 算法改进

## 📚 学习资源

### 📖 推荐阅读
- [中国大学生数学建模竞赛官网](https://www.mcm.edu.cn/)
- 《数学建模方法与分析》
- 《MATLAB数学建模经典案例实战》
- 《Python数据科学手册》

### 🎥 视频教程
- 项目内包含MATLAB和Python代码讲解视频
- 清风数学建模系列教程
- 数学建模算法详解

### 🔗 相关链接
- [全国大学生数学建模竞赛](https://www.mcm.edu.cn/)
- [华数杯数学建模竞赛](http://www.huashumath.com/)
- [数学建模社区](https://www.shumo.com/)

## 📄 许可证

本项目采用 [MIT License](LICENSE) 许可证。

## 🙏 致谢

- 感谢中国工业与应用数学学会主办的数学建模竞赛
- 感谢华数杯组委会提供的竞赛平台
- 感谢所有开源算法和工具的贡献者
- 感谢队友们的协作和努力

## 📞 联系方式

- 📧 Email: caiths@icloud.com
- 🐙 GitHub: [@poboll](https://github.com/poboll)
- 💬 微信: your_wechat_id

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给个Star支持一下！**

*在探索与热爱中，遇见更好的我们* 🌟

</div>
