% 读取数据，并保留原始列标题
data = readtable('问题三初始数据.xlsx', 'VariableNamingRule', 'preserve', 'TextType', 'string');

% 提取游玩时间列
time_strings = data.('建议游玩时间');

% 初始化游玩时间向量
play_times = zeros(height(data), 1);

% 遍历所有游玩时间字符串并进行处理
for i = 1:length(time_strings)
    time_str = time_strings{i};
    
    % 匹配时间区间
    tokens = regexp(time_str, '(\d+\.?\d*)小时?\s*-\s*(\d+\.?\d*)小时?', 'tokens');
    if ~isempty(tokens)
        time_values = str2double(tokens{1});
        avg_time = mean(time_values); % 取区间的平均值
    else
        % 匹配单个时间
        tokens = regexp(time_str, '(\d+\.?\d*)小时?', 'tokens');
        if ~isempty(tokens)
            avg_time = str2double(tokens{1});
        else
            % 处理“天”为单位的情况
            tokens = regexp(time_str, '(\d+\.?\d*)天?\s*-\s*(\d+\.?\d*)天?', 'tokens');
            if ~isempty(tokens)
                time_values = str2double(tokens{1}) * 24; % 转换为小时
                avg_time = mean(time_values);
            else
                tokens = regexp(time_str, '(\d+\.?\d*)天', 'tokens');
                if ~isempty(tokens)
                    avg_time = str2double(tokens{1}) * 24; % 转换为小时
                else
                    error('无法解析游玩时间字符串: %s', time_str);
                end
            end
        end
    end
    
    % 存储转换后的游玩时间
    play_times(i) = avg_time;
end

% 将转换后的游玩时间添加到表格中
data.('建议游玩时间') = play_times;

% 保存处理后的数据
writetable(data, '游玩时间处理后的数据.csv');

% 显示前几行以验证结果
disp(data(1:10, :));