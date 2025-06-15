% 读取问题三数据清洗结果表格
data = readtable('问题三数据清洗结果.xlsx', 'TextType', 'string', 'VariableNamingRule', 'preserve');


% 定义常见的山景关键词
mountain_keywords = ["山", "峰", "岭", "崖", "峪", "岩", "峦", "寨", "嶂", "谷"];

% 初始化空表格
mountain_data = data(1:0, :);

% 遍历每一个关键词进行筛选
for k = 1:length(mountain_keywords)
    keyword = mountain_keywords(k);
    temp_data = data(contains(data.("名字"), keyword), :);
    mountain_data = [mountain_data; temp_data];
end

% 移除重复的行
mountain_data = unique(mountain_data, 'rows');

% 将结果保存为新的表格
writetable(mountain_data, '问题五初始数据.csv');

% 显示前几行以验证结果
disp(mountain_data(1:10, :));
