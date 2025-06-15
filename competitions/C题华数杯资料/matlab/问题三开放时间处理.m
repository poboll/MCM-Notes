% 读取数据
data = readtable('门票处理后的数据导入.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 提取开放时间列
open_time_strings = data.("开放时间");

% 初始化有效性标志向量
is_valid = true(height(data), 1);
standard_open_times = strings(height(data), 1);

% 遍历所有开放时间字符串并进行处理
for i = 1:length(open_time_strings)
    open_time_str = open_time_strings{i};
    
    % 检查是否包含暂时停业信息
    if contains(open_time_str, '已关') || contains(open_time_str, '暂停营业')
        is_valid(i) = false;
        continue;
    end
    
    % 检查是否包含月份信息
    if ~isempty(regexp(open_time_str, '\d{1,2}/\d{1,2}', 'once'))
        is_valid(i) = false;
        continue;
    end
    
    % 检查是否包含一周开放时间有差异的信息
    if contains(open_time_str, '周一') || contains(open_time_str, '周二') || ...
       contains(open_time_str, '周三') || contains(open_time_str, '周四') || ...
       contains(open_time_str, '周五') || contains(open_time_str, '周六') || ...
       contains(open_time_str, '周日')
        is_valid(i) = false;
        continue;
    end
    
    % 匹配每天开放时间范围
    tokens = regexp(open_time_str, '(\d{1,2}[:：]?\d{2})[^\d]*(\d{1,2}[:：]?\d{2})', 'tokens');
    if ~isempty(tokens)
        start_time = tokens{1}{1};
        end_time = tokens{1}{2};
        % 格式化为统一格式
        start_time = strrep(start_time, '：', ':');
        end_time = strrep(end_time, '：', ':');
        standard_open_times(i) = start_time + "-" + end_time;
    else
        % 无法解析的行标记为无效
        is_valid(i) = false;
    end
end

% 过滤数据，只保留有效行
filtered_data = data(is_valid, :);
filtered_data.("开放时间") = standard_open_times(is_valid);

% 保存处理后的数据
writetable(filtered_data, '开放时间处理后的数据.csv');

% 显示前几行以验证结果
disp(filtered_data(1:10, :));

