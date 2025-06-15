% 假设有两个变量：X和Y
X = [1, 2, 3, 4, 5];
Y = [2, 3, 5, 7, 11];

figure;
scatter(X, Y, 'filled');
title('Scatter Plot Example');
xlabel('X');
ylabel('Y');

% 假设有三个类别的数量
categories = {'A', 'B', 'C'};
values = [10, 20, 15];

figure;
bar(values);
set(gca, 'XTickLabel', categories);
title('Bar Chart Example');
xlabel('Category');
ylabel('Values');

% 假设有一组数据
data = [1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 10, 10, 11];

figure;
boxplot(data);
title('Box Plot Example');
ylabel('Values');


% 假设有一组数据
data = [1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10, 10, 10, 11];

figure;
histogram(data, 5);
title('Histogram Example');
xlabel('Values');
ylabel('Frequency');

% 假设有一个相关性矩阵
data = rand(10, 10);

figure;
imagesc(data);
colorbar;
title('Heatmap Example');

% 假设有一组时间序列数据
time = [1, 2, 3, 4, 5];
values = [2, 3, 5, 7, 11];

figure;
plot(time, values, '-o');
title('Line Plot Example');
xlabel('Time');
ylabel('Values');




