function data1=jisuan(data,zhibiao_label)
if isa(data,'double')
    for i=1:length(zhibiao_label)
        if (zhibiao_label(i)==1)
            data1(:,i)=zheng1(data(:,i));
        elseif (zhibiao_label(i)==2)
            data1(:,i)=zheng2(data(:,i));
    elseif (zhibiao_label(i)==3)
            data1(:,i)=fu3(data(:,i));
    elseif (zhibiao_label(i)==4)
            data1(:,i)=fu4(data(:,i));
   elseif (zhibiao_label(i)==5)
            data1(:,i)=fu5(data(:,i));
  elseif (zhibiao_label(i)==6)
      prompt = '这是单点最优，请输入单点最优值 ';
       a = input(prompt);
           data1(:,i)=qu6(data(:,i),a);
  elseif (zhibiao_label(i)==7)
     prompt = '这是区间最优，请输入单点最区间如[5,10] ';
      aa=input(prompt);
           data1(:,i)=qu7(data(:,i),aa(1),aa(2));
    end
    end
elseif isa(data,'cell')
%     data2=data;
    for j=1:length(data)
        data2=data{j};
        if size(zhibiao_label,1)==1
            zhibiao_label1=repmat(zhibiao_label,3,1);
        else
            zhibiao_label1=zhibiao_label;
       end
        for i=1:length(zhibiao_label1(j,:))
               if (zhibiao_label(i)==1)
            data1{j}(:,i)=zheng1(data2(:,i));
        elseif (zhibiao_label(i)==2)
            data1{j}(:,i)=zheng2(data2(:,i));
       elseif (zhibiao_label(i)==3)
            data1{j}(:,i)=fu3(data2(:,i));
       elseif (zhibiao_label(i)==4)
            data1{j}(:,i)=fu4(data2(:,i));
      elseif (zhibiao_label(i)==5)
            data1{j}(:,i)=fu5(data2(:,i));
     elseif (zhibiao_label(i)==6)
      prompt = '这是单点最优，请输入单点最优值 ';
       a = input(prompt);
           data1{j}(:,i)=qu6(data2(:,i),a);
    elseif (zhibiao_label(i)==7)
     prompt = '这是区间最优，请输入单点最区间如[5,10] ';
      aa=input(prompt);
           data1{j}(:,i)=qu7(data2(:,i),aa(1),aa(2));
    end
        end
    end
end
end
function data=zheng1(data1)
%正向指标1
% 填1的时候选择
data=(data1-min(data1))./(max(data1)-min(data1));
end
function data=zheng2(data1)
%正向指标2
% 填2的时候选择
data=data1;
end
function data=fu3(data1)
%负向指标1
% 填3的时候选择
data=(max(data1)-data1)./(max(data1)-min(data1));
end
function data=fu4(data1)
%负向指标2
% 填4的时候选择
data=(max(data1)-data1);
end
function data=fu5(data1)
%负向指标3
% 填5的时候选择
data=1./(max(abs(data1))+data1);
end
function data=qu6(data1,a)
%某点最优
% 填6的时候选择
data=1-(abs(data1-a)/max(abs(data1-a)));
end
function data=qu7(data1,a,b)
%区间指标1
% 填7的时候选择
data=data1;
data((data1>=a)&(data1<=b),1)=1;
data((data1<a),1)=data1((data1<a),1)/(a+0.0001);
data((data1>b),1)=b/(data1((data1>b),1)+0.0001);
% for i=1:size(data1,1)
%     if(data1(i,1)>=a)&&(data1(i,1)<=b)
%         data(i,1)=1;
%     elseif (data1(i,1)<a)
%         data(i,1)=data1(i,1)/(a+0.0001);
%     elseif (data1(i,1)>b)
%         data(i,1)=b/(data1(i,1)+0.0001);
%     end
% end
end
%%

