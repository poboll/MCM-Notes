% 定义文件夹路径和输出文件路径
folderPath = '附件'; % 你的文件夹路径
outputFile = 'merged_data.csv'; % 合并后的输出文件

% 定义文件夹路径和输出文件路径
folderPath = '附件'; % 你的文件夹路径
outputFile = 'merged_data_with_source.csv'; % 合并后的输出文件

% 获取文件夹中的所有CSV文件
files = dir(fullfile(folderPath, '*.csv'));

% 打开输出文件
fid_out = fopen(outputFile, 'w');

% 读取第一个文件并写入表头到输出文件，并增加一列用于区分来源
firstFile = fullfile(folderPath, files(1).name);
fid_in = fopen(firstFile, 'r');
header = fgetl(fid_in);
fprintf(fid_out, '%s,来源城市\n', header);
fclose(fid_in);

% 遍历所有文件并合并内容
for i = 1:length(files)
    % 构建文件路径
    filePath = fullfile(folderPath, files(i).name);
    
    % 提取文件名（不包括扩展名）作为城市名
    [~, cityName, ~] = fileparts(files(i).name);
    
    % 打开文件
    fid_in = fopen(filePath, 'r');
    
    % 跳过表头
    fgetl(fid_in);
    
    % 读取文件内容并写入输出文件，同时添加城市名列
    while ~feof(fid_in)
        line = fgetl(fid_in);
        fprintf(fid_out, '%s,%s\n', line, cityName);
    end
    
    % 关闭文件
    fclose(fid_in);
end

% 关闭输出文件
fclose(fid_out);

disp('文件合并完成。');


