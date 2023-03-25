
function eff=evaluation(pop,X,k)  %pop是解集，X是数据集，k是特征维度

eff=pop;  
ss=size(pop,1);  %大小=行数
for(i=1:ss)
    eff(i,k+1)=100*kmean_res(pop(i,:),X);  %倒数第二列放得分，
    eff(i,k+2)=sum(pop(i,2:k));    %倒数第一列放特征个数
end

function ary=kmean_res(par,X) %par第一列放标签

nx=size(X,1);  %大小=数据集的行数
np=size(par,2);  %大小=特征数+1
sel=[];
for(i=2:np)
    if par(i)==1
        sel=[sel,i];  %解中选中的特征的对应序号值
    end
end
Y=X(:,sel);  %Y是经过选择后的数据集
cn=size(sel,2);  %选出来的特征个数
class=[];
for(i=1:nx)  %从上往下遍历data数据集，外层遍历
    nearest=10e100;  %初始化
    for(j=1:nx)  %从上往下遍历data数据集，内层遍历
        if(i~=j)
            dist=0;
            for(jj=1:cn)  %只计算选择出来的特征对应的距离和
                if(Y(i,jj)~=inf && Y(j,jj)~=inf)  %如果有值的话
                    dist=dist+abs(Y(i,jj)-Y(j,jj));   %曼哈顿距离
                end      
            end
            if dist<nearest
                class(i)=X(j,1);  %标签值为当前距离最近的点的标签
                nearest=dist;
            end
        end
    end
end
correct=0;
for i=1:nx
    if class(i)==X(i,1)
        correct=correct+1;
    end
end
ary=correct/nx;



