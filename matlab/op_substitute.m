%substitute：使某一个元素翻转
%  稳定性与全局性

function State = op_substitute(Best,SE,Iter,i,weight,w2,w3)  %Best为当前最优解
n = length(Best);  %87
State = zeros(SE,n);  %初始化状态  20行87列，每一行存一个状态（解）
for ii = 1:SE        %每次改变至多改变两个元素   
    temp = Best;
    if rand()<((i)/(Iter))^2
        j=ceil(rand()*n);  %随机生成，前期的快速性
        if weight(j)<w2  
            if rand()<0.5
                temp(j)=1-temp(j);
            end
        else
            if rand()<0.5
                temp(j)=1-temp(j);
            end
        end
        if rand()>0.5+0.5*(i/Iter)
            jj=ceil(rand()*n);
            if jj~=j
                if weight(jj)<w2  
                    temp(jj)=1;
                end
            end
        end

    else
      r1=0.1+(-0.1)*(i)/(Iter);
      r2=0.2+(-0.2)*(i)/(Iter);
      for jjj=1:n;
        if weight(jjj)<w3  %该特征的权值小于权值集合的中位数
            if rand()<r2
            temp(jjj)=1-temp(jjj);
            end
        else
            if rand()<r1
            temp(jjj)=1-temp(jjj);
            end
        end
      end
    end
    State(ii,:) = temp;
end
