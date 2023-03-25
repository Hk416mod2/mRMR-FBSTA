clear;
clc;
tic;

 tic;
data1 =load('721.csv');
[num1,dim1]=size(data1);  %����������
data = [data1(:,dim1) data1(:,1:(dim1-1))];  %��һ�д�ű�ǩ��ʣ�µĴ����ֵ
[num,dim]=size(data);  %��Сͬ10��data��data1�������ڱ�ǩ�ŵ�һ����
[~, WEIGHT] = mRMR( data(:,2:dim), data(:,1), dim-1);
weight = mapminmax(WEIGHT, 0, 1);  % Ȩֵ��һ������[-1,1]
[w,i] = sort(weight);  %w�ǰ�Ȩֵ������������i��������ֵ��ԭ�����е����
fprintf('����ʽ��ɣ���ʼ���а���ʽ\n')
SE=20;  %��ѡ�⼯�Ĵ�С
X=zeros(1,dim-1);  %1�У���������
X1=zeros(1,dim-1);
lab=zeros(1,1);
w1=w(int16(dim*0.8));  %����ʽ������ѡǰ20%
w2=w(int16(dim*0.3));  %����ʽ����Ĳ���
w3=w(int16(dim*0.5)); 

AC=[];
Iter=50;

for i=1:dim-1
    if weight(i)>w1  
        X(i)=1;
    end
end

X=[lab X];  %��������ʽԤ�����Ľ�
Fx=evaluation(X,data,dim);  %����ʽ�Ļ���KNN�����ۺ������������һ��Ϊ���������������ڶ���Ϊ�÷֣�KNN��K=1
[~,index]=max(Fx(:,dim+1));
Fbest=Fx(index(1),:);  %��ʼ��

fprintf('fast part\n');
for i=1:Iter*0.8
    fprintf('epoc:%d',i);
    label=zeros(SE,1);  
    %substitute
    State=op_fast(Fbest(1,2:dim),SE,Iter*0.8,i,weight,w1,w2);  %20�У�ÿһ�д��һ����ѡ��
    State=[label State];
    FState=evaluation(State,data,dim);  %��State�е�ÿһ��״̬��������
    [~,index]=max(FState(:,dim+1));  %�ҳ���õ�һ��״̬
    %��Ŀ�꣺�÷�����������
    if FState(index(1),dim+1)>Fbest(dim+1) || (FState(index(1),dim+2)<Fbest(dim+2) && FState(index(1),dim+1)==Fbest(dim+1))
        Fbest=FState(index(1),:);
    end
    AC=[AC;Fbest];  %�����õĽ�ļ��ϣ�-1�д��������Ŀ��-2�д��׼ȷ��
    fprintf(' best acc:%0.3f%%\n',AC(i,dim+1))
end


for i=Iter*0.8+1:2*Iter
    fprintf('epoc:%d',i);
    label=zeros(SE,1);  
    State=op_standard(Fbest(1,2:dim),SE,Iter*1.2,i-40,weight,w3);  %20�У�ÿһ�д��һ����ѡ��
    State=[label State];
    FState=evaluation(State,data,dim);  %��State�е�ÿһ��״̬��������
    [~,index]=max(FState(:,dim+1));  %�ҳ���õ�һ��״̬
    if FState(index(1),dim+1)>Fbest(dim+1) || (FState(index(1),dim+2)<Fbest(dim+2) && FState(index(1),dim+1)==Fbest(dim+1))
        Fbest=FState(index(1),:);  %�÷ָ߻��ߵ÷���ͬ����������С������
    end

    AC=[AC;Fbest];  %�����õĽ�ļ��ϣ�-1�д��������Ŀ��-2�д��׼ȷ��
    fprintf(' best acc:%0.3f%%\n',AC(i,dim+1))

    [AC,~]=sortrows(AC,dim+1);

end
[AC,~]=sortrows(AC,dim+1);

fprintf('׼ȷ�ʣ�%0.3f%% ',AC(2*Iter,dim+1))
fprintf(' ������������%d\n',AC(2*Iter,dim+2))
Time = toc;
fprintf('%0.3fs\n', Time)
%��ͼ����
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
