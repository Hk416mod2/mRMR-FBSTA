clear;
clc;
tic;

 tic;
data1 =load('721.csv');
[num1,dim1]=size(data1);  %行数，列数
data = [data1(:,dim1) data1(:,1:(dim1-1))];  %第一列存放标签，剩下的存放数值
[num,dim]=size(data);  %大小同10，data跟data1区别在于标签放第一列了
[~, WEIGHT] = mRMR( data(:,2:dim), data(:,1), dim-1);
weight = mapminmax(WEIGHT, 0, 1);  % 权值归一化区间[-1,1]
[w,i] = sort(weight);  %w是按权值排序后的向量，i是排序后的值在原向量中的序号
fprintf('过滤式完成，开始进行包裹式\n')
SE=20;  %候选解集的大小
X=zeros(1,dim-1);  %1行，特征数列
X1=zeros(1,dim-1);
lab=zeros(1,1);
w1=w(int16(dim*0.8));  %过滤式初步挑选前20%
w2=w(int16(dim*0.3));  %包裹式传入的参数
w3=w(int16(dim*0.5)); 

AC=[];
Iter=50;

for i=1:dim-1
    if weight(i)>w1  
        X(i)=1;
    end
end

X=[lab X];  %经过过滤式预处理后的解
Fx=evaluation(X,data,dim);  %包裹式的基于KNN的评价函数，返回最后一列为特征个数，倒数第二列为得分，KNN中K=1
[~,index]=max(Fx(:,dim+1));
Fbest=Fx(index(1),:);  %初始解

fprintf('fast part\n');
for i=1:Iter*0.8
    fprintf('epoc:%d',i);
    label=zeros(SE,1);  
    %substitute
    State=op_fast(Fbest(1,2:dim),SE,Iter*0.8,i,weight,w1,w2);  %20行，每一行存放一个候选解
    State=[label State];
    FState=evaluation(State,data,dim);  %对State中的每一行状态进行评估
    [~,index]=max(FState(:,dim+1));  %找出最好的一个状态
    %多目标：得分与特征个数
    if FState(index(1),dim+1)>Fbest(dim+1) || (FState(index(1),dim+2)<Fbest(dim+2) && FState(index(1),dim+1)==Fbest(dim+1))
        Fbest=FState(index(1),:);
    end
    AC=[AC;Fbest];  %存放最好的解的集合，-1列存放特征数目，-2列存放准确率
    fprintf(' best acc:%0.3f%%\n',AC(i,dim+1))
end


for i=Iter*0.8+1:2*Iter
    fprintf('epoc:%d',i);
    label=zeros(SE,1);  
    State=op_standard(Fbest(1,2:dim),SE,Iter*1.2,i-40,weight,w3);  %20行，每一行存放一个候选解
    State=[label State];
    FState=evaluation(State,data,dim);  %对State中的每一行状态进行评估
    [~,index]=max(FState(:,dim+1));  %找出最好的一个状态
    if FState(index(1),dim+1)>Fbest(dim+1) || (FState(index(1),dim+2)<Fbest(dim+2) && FState(index(1),dim+1)==Fbest(dim+1))
        Fbest=FState(index(1),:);  %得分高或者得分相同下特征个数小：更新
    end

    AC=[AC;Fbest];  %存放最好的解的集合，-1列存放特征数目，-2列存放准确率
    fprintf(' best acc:%0.3f%%\n',AC(i,dim+1))

    [AC,~]=sortrows(AC,dim+1);

end
[AC,~]=sortrows(AC,dim+1);

fprintf('准确率：%0.3f%% ',AC(2*Iter,dim+1))
fprintf(' 保留特征数：%d\n',AC(2*Iter,dim+2))
Time = toc;
fprintf('%0.3fs\n', Time)
%绘图部分
% TT=1:size(AC,1);
% [AX,H1,H2]=plotyy(TT,AC(:,dim+1),TT,AC(:,dim+2));
% set(AX,'FontSize',10,'FontWeight','bold');
% set(get(AX(1),'ylabel'),'string', 'Classification accuracy(%)');
% set(get(AX(2),'ylabel'),'string', '# of selected features');
% xlabel('Iterations');
% set(H1,'Linestyle','--','marker','o','Linewidth',2);
% set(H2,'Linestyle',':','marker','x','Linewidth',2);
% legend('Classification accuracy(%)','# of selected features');
% title('362');
