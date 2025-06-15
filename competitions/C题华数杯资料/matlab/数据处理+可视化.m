% 读取数据
data = readtable('merged_data_with_source.csv', 'PreserveVariableNames', true);

% 将中文列名转换为英文
data.Properties.VariableNames{'名字'} = 'Name';
data.Properties.VariableNames{'链接'} = 'Link';
data.Properties.VariableNames{'地址'} = 'Address';
data.Properties.VariableNames{'介绍'} = 'Introduction';
data.Properties.VariableNames{'开放时间'} = 'OpenTime';
data.Properties.VariableNames{'图片链接'} = 'ImageLink';
data.Properties.VariableNames{'评分'} = 'Rating';
data.Properties.VariableNames{'建议游玩时间'} = 'SuggestedPlayTime';
data.Properties.VariableNames{'建议季节'} = 'SuggestedSeason';
data.Properties.VariableNames{'门票'} = 'Ticket';
data.Properties.VariableNames{'小贴士'} = 'Tips';
data.Properties.VariableNames{'Page'} = 'Page';
data.Properties.VariableNames{'来源城市'} = 'SourceCity';

% 显示清理前评分列的值分布
figure;
subplot(1, 2, 1);
before_cleaning_counts = countcats(categorical(data.Rating));
before_cleaning_categories = categories(categorical(data.Rating));
bar(before_cleaning_counts);
set(gca, 'XTickLabel', before_cleaning_categories);
title('Before Cleaning');
xlabel('Rating');
ylabel('Frequency');

% 删除评分列中包含空缺值、0 和 -- 标记的行
cleanedData = data(~(ismissing(data.Rating) | data.Rating == 0 | strcmp(data.Rating, '--')), :);

% 显示清理后评分列的值分布
subplot(1, 2, 2);
after_cleaning_counts = countcats(categorical(cleanedData.Rating));
after_cleaning_categories = categories(categorical(cleanedData.Rating));
bar(after_cleaning_counts);
set(gca, 'XTickLabel', after_cleaning_categories);
title('After Cleaning');
xlabel('Rating');
ylabel('Frequency');


% 保存图表为图片文件
saveas(gcf, 'cleaning_process.png');

% 将清理后的数据写入新的文件
writetable(cleanedData, 'cleaned_data.csv');

