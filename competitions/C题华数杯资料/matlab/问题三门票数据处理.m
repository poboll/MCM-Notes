% 读取数据
data = readtable('游玩时间处理后的数据.csv', 'TextType', 'string', 'VariableNamingRule', 'preserve');

% 检查列名
disp(data.Properties.VariableNames);

% 提取门票列
ticket_strings = data.("门票");

% 初始化门票价格向量
ticket_prices = zeros(height(data), 1);

% 遍历所有门票字符串并进行处理
for i = 1:length(ticket_strings)
    ticket_str = ticket_strings{i};
    
    % 检查是否包含价格数字
    has_price = ~isempty(regexp(ticket_str, '\d+\.?\d*元?', 'once'));
    
    % 检查是否为免费
    is_free = contains(ticket_str, '免费');
    
    if ~has_price && is_free
        ticket_prices(i) = 0;
    else
        % 优先匹配成人票价格
        tokens = regexp(ticket_str, '成人票[:：]?\s*¥?(\d+\.?\d*)元?', 'tokens');
        if isempty(tokens)
            % 匹配票价
            tokens = regexp(ticket_str, '票价[:：]?\s*¥?(\d+\.?\d*)元?', 'tokens');
        end
        if isempty(tokens)
            % 尝试提取所有价格中的第一个
            tokens = regexp(ticket_str, '¥?(\d+\.?\d*)元?', 'tokens');
        end
        
        if ~isempty(tokens)
            ticket_prices(i) = str2double(tokens{1}{1});
        else
            ticket_prices(i) = NaN; % 若未找到价格，则设为NaN
        end
    end
end

% 将提取出的门票价格添加到表格中
data.("门票") = ticket_prices;

% 删除包含NaN值的行
data = data(~isnan(data.("门票")), :);

% 保存处理后的数据
writetable(data, '门票处理后的数据.csv');

% 显示前几行以验证结果
disp(data(1:10, :));

