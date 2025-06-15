import pandas as pd
from sklearn.model_selection import train_test_split
import numpy as np
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn import model_selection
from sklearn.cluster import KMeans
from gensim import corpora, models
import gensim
import jieba
import re

# 用户对特征的重要性
criteria = [4, 4, 1, 2, 2, 2, 1, 4, 5, 3]

# 存储不需要的特征
exclude = []

# 存储关键词
k_y = []

# 存储聚类个数
k_ = []

# 存储聚类SSE (Sum of Squared Errors)
SSE = []

# 存储处理过的菜名
doc_clean = []
d_c = []

# 原始数据
pos_data = pd.DataFrame(
    {'name': ['红烧牛肉面', '酸菜肉丝面', '红烧排骨面', '西红柿鸡蛋面', '泡椒鸡杂面', '担担面', '香菇肉片面',
              '大盘鸡拌面', '香菇鸡块面', '豌杂干拌面', '豌杂面', '肉沫豆角面', '麻酱拌面', '奥尔良鸡肉饭',
              '黑椒烤肉饭', '肥牛饭', '香辣烤肉饭', '孜然烤肉饭', '孜然培根饭', '素三鲜饭', '辣白菜五花肉石锅拌饭',
              '素石锅拌饭', '咖喱鸡排饭', '咖喱鸡肉饭', '咖喱鸡柳饭', '咖喱辣子鸡饭', '咖喱奥尔良饭', '香辣鸡排饭',
              '甜辣鸡排饭', '照烧鸡排饭', '孜然鸡排饭', '番茄鸡排饭', '沙拉鸡排饭', '红烧牛肉米粉', '红烧排骨米粉',
              '泡椒鸡杂米粉', '香菇肉片米粉', '香菇鸡块米粉', '豌杂米粉', '肉沫豆角米粉', '酸菜肉沫米粉', '担担米粉',
              '酸辣粉', '油饼母鸡汤', '经典黄焖鸡', '黄焖鱼豆腐肉片', '黄焖金菇肉片', '黄焖娃娃菜肉片', '黄焖豆腐肉片',
              '黄焖土豆肉片', '黄焖茄子肉片', '麻辣烫', '麻辣香锅', '猪肉大葱包', '肉末豇豆包', '肉沫雪里红包',
              '卤蛋蔬菜卷', '片肠蔬菜卷', '金枪鱼炒饭', '培根火腿炒饭', '奥尔良炒饭', '手抓饼', '烤冷面', '鲜肉锅贴',
              '虾仁锅贴', '猪肉酸菜水饺', '猪肉白菜水饺', '猪肉芹菜水饺', '猪肉茴香水饺', '猪肉韭菜水饺',
              '韭菜鸡蛋水饺',
              '猪肉大葱水饺', '杏鲍菇鸡肉馄饨', '香菇猪肉馄饨', '鲜肉馄饨', '芹菜馄饨', '烤肠蔬菜卷', '鸡柳蔬菜卷',
              '里脊蔬菜卷', '培根蔬菜卷', '鸡排蔬菜卷', '奥尔良鸡腿蔬菜卷', '红豆粥', '八宝粥', '银耳莲子粥',
              '冰糖绿豆粥', '皮蛋瘦肉粥', '梅菜饼', '铁板土豆片', '铁板鸡蛋', '铁板烤肉', '腊肠炒饭', '铁板炒面',
              '铁板炒饭', '瘦肉炒饭', '铁板牛肉', '椒麻鸡套餐', '粉蒸肉套餐', '辣子鸡套餐', '红烧肉套餐',
              '牛柳乌冬面', '培根火腿乌冬面', '金枪鱼乌冬面', '麻辣鸡排乌冬面', '咖喱炒饭', '鸡肉焗饭', '培根火腿焗饭',
              '芝士焗饭', '牛肉焗饭', '素炒河粉', '鸡蛋炒河粉', '鸡排炒河粉', '五花肉炒河粉', '牛肉炒河粉',
              '黑椒汁鸡饭', '香菇汁鸡饭', '照烧汁鸡饭', '奥尔良鸡饭', '火焰猪排饭', '秘制猪排饭', '麻辣五花肉饭',
              '黑椒牛柳意面', '培根火腿意面', '麻辣鸡排意面', '意大利肉酱面', '维也纳意面', '炸土豆串', '炸火腿肠',
              '炭烤培根', '炭烤牙签肉'],
     'classify': [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3,
                  1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 3, 3, 1, 1, 1, 3, 3, 1, 1, 1,
                  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 3,
                  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1,
                  1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 3, 3, 3, 3],
     'youni': [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 1, 3, 3,
               2, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2,
               2, 2, 2, 2, 2, 2, 2, 3, 3, 1, 1, 1, 1, 1, 3, 3, 3, 2, 2, 3, 3, 1,
               1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 3,
               3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3,
               3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2],
     'hunsu': [1, 3, 1, 2, 1, 2, 3, 3, 3, 2, 2, 3, 2, 1, 1, 1, 1, 1, 1, 2, 3, 2,
               3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 3, 3, 2, 3, 3, 2, 2, 2,
               3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 2, 3, 3, 3, 3, 3, 3, 1, 3, 3,
               3, 3, 3, 3, 2, 3, 3, 3, 1, 2, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3,
               2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 2,
               2, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1],
     'shicai': [1, 2, 2, 5, 4, 5, 2, 4, 4, 5, 5, 2, 5, 4, 2, 1, 2, 2, 2, 5, 2, 5,
                4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 2, 4, 2, 4, 5, 2, 2, 5, 5, 5,
                4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 2, 3, 2, 4, 2, 2, 2, 3, 2,
                2, 2, 2, 2, 5, 2, 4, 2, 2, 5, 2, 4, 2, 2, 4, 4, 5, 5, 5, 5, 5, 2,
                5, 5, 2, 2, 2, 2, 2, 1, 4, 2, 4, 2, 1, 2, 3, 4, 5, 4, 2, 3, 1, 5,
                5, 4, 2, 1, 4, 4, 4, 4, 2, 2, 2, 1, 2, 4, 2, 2, 5, 2, 2, 2],
     'tiaowei': [3, 3, 3, 3, 1, 1, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3, 2, 2,
                 3, 3, 3, 1, 3, 1, 1, 2, 3, 2, 2, 3, 3, 1, 3, 3, 3, 3, 3, 3, 1, 3,
                 1, 3, 1, 1, 3, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
                 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3,
                 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1, 3, 3, 3, 3, 1, 3, 2, 2, 2, 2, 3,
                 3, 3, 3, 3, 2, 2, 2, 3, 3, 2, 1, 3, 3, 1, 2, 2, 3, 3, 3, 3],
     'make': [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4,
              4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 5, 5, 2, 2, 2, 5, 5, 5, 5, 1,
              1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 5,
              2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 2, 2, 2, 2, 2, 4, 4, 4, 4, 2,
              2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 5, 5, 5, 5],
     'price': [14, 10, 14, 10, 14, 10, 14, 12, 12, 12, 12, 10, 10, 13, 13, 15, 12,
               13, 13, 9, 15, 11, 13, 13, 12, 13, 13, 12, 13, 13, 12, 12, 13, 14,
               14, 14, 14, 12, 12, 10, 10, 10, 9, 9, 15, 15, 15, 13, 13, 13, 13,
               18, 18, 8, 8, 8, 5, 5, 11, 12, 12, 9, 9, 15, 15, 8, 8, 8,
               8, 8, 8, 10, 8, 8, 9, 9, 6, 5, 6, 6, 7, 8, 3, 3, 3,
               3, 3, 5, 10, 12, 13, 14, 14, 14, 15, 16, 14, 14, 14, 14, 15, 14,
               13, 14, 11, 14, 14, 14, 15, 11, 12, 14, 14, 15, 13, 13, 13, 13, 15,
               15, 15, 15, 14, 13, 13, 12, 12, 13, 14, 14]})
pre_data = pd.DataFrame(
    {'name': ['鸡肉石锅拌饭', '香辣鸡扒饭', '韭菜鸡蛋盒子', '麻辣烫', '芝士焗饭', '潮味汤粉', '梅菜饼',
              '蜜汁叉烧饭', '猪脚饭', '皮蛋瘦肉粥'],
     'classify': [2, 1, 1, 3, 2, 2, 1, 2, 3, 2],
     'youni': [3, 3, 1, 3, 2, 3, 2, 3, 3, 1],
     'hunsu': [1, 2, 2, 3, 1, 2, 1, 3, 1, 2],
     'shicai': [4, 5, 5, 2, 2, 5, 3, 4, 1, 5],
     'tiaowei': [2, 3, 3, 1, 2, 3, 3, 2, 3, 2],
     'make': [4, 4, 3, 4, 4, 5, 2, 4, 5, 1],
     'price': [14, 12, 7, 18, 13, 12, 13, 13, 16, 3],
     })
pre_data['criteria'] = pd.DataFrame(criteria)

# 剔除与对分类结果贡献较小的特征
target = pre_data['criteria']
data = pre_data.drop(['criteria', 'name'], axis=1)
data_train, data_test, target_train, target_test = train_test_split(data, target, test_size=0.2, random_state=42)
predictors = ["classify", "youni", "hunsu", "shicai", "tiaowei", "criteria", "price"]
selector = SelectKBest(f_classif, k=5)
selector.fit(data_train, target_train)
scores = -np.log10(selector.pvalues_)
for i in range(len(scores)):
    if scores[i] < 0.1 and predictors[i] != 'criteria':
        exclude.append(predictors[i])
    elif scores[i] == float(scores.max()):
        k_y.append(predictors[i])
data_ = pos_data.drop(exclude, axis=1)
data_p = data_.drop(['name'], axis=1)
predictors_best = data_p.columns

# 随机森林模型训练
data_train = data_train[predictors_best]
data_test = data_test[predictors_best]
kf = model_selection.KFold(n_splits=3)
tree_param_grid = {'min_samples_split': list((2, 3, 4)),
                   'n_estimators': list((3, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50))}
grid = GridSearchCV(RandomForestClassifier(), param_grid=tree_param_grid, cv=kf)
grid.fit(data_train, target_train)
rf = RandomForestClassifier(random_state=1, n_estimators=35, min_samples_split=2, min_samples_leaf=2)

# 随机森林模型预测
array = grid.predict(data_p)
pos_data['predict_cri'] = pd.DataFrame(array)

# 根据特征找出最好聚类个数k
like = pos_data.loc[pos_data['predict_cri'] == 5]
if like.empty:
    like = pos_data.loc[pos_data['predict_cri'] == 4]
    print(like['name'].head(10))
    if like.empty:
        like = pos_data.loc[pos_data['predict_cri'] == 3]
        print(like['name'].head(10))
elif 0 < len(like) <= 10:
    print(like['name'])
elif len(like) > 10:
    like = like.head(10)
    print(like['name'])

# 根据特征找出最好聚类个数k
like_ = like.drop(['name', 'predict_cri'], axis=1)
featureList = like_.columns
mdl = pd.DataFrame.from_records(data, columns=featureList)
for k in range(1, 9):
    estimator = KMeans(n_clusters=k)
    estimator.fit(np.array(mdl[featureList]))
    SSE.append(estimator.inertia_)
for i in range(len(SSE)):
    if i + 1 < len(SSE):
        if SSE[i] - SSE[i + 1] <= 20:
            k_.append(i + 1)

# 对于最喜欢的菜名进行分词预处理
file_userDict = ['石锅拌饭', '焗饭', '意面', '猪排饭', '牙签肉', '蔬菜卷', '鸡饭', '照烧', '烤肉拌饭', '鸡排饭']
jieba.load_userdict(file_userDict)
name = like['name']
name = list(name)
for na in name:
    text_split = jieba.cut(na)
    FullMode = ' '.join(text_split)
    doc_clean.append(FullMode)

for doc in doc_clean:
    doc_ = doc.split()
    d_c.append(doc_)

dictionary = corpora.Dictionary(d_c)
doc_term_matrix = [dictionary.doc2bow(doc) for doc in d_c]

# 应用LDA主题模型提取k个主题关键词
Lda = gensim.models.ldamodel.LdaModel
ldamodel = Lda(doc_term_matrix, num_topics=k_[0], id2word=dictionary, passes=50)
result = ldamodel.print_topics(num_topics=k_[0], num_words=1)
for i in range(len(result)):
    print('第{}个喜好关键词为{}'.format(i + 1, result[i]))
