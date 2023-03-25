%substitute：使某一个元素翻转
%  稳定性与全局性

function State = op_fast(Best,SE,Iter,i,weight,w1,w2)  %Best为当前最优解
n = length(Best);  %87
State = zeros(SE,n);  %初始化状态  20行87列，每一行存一个状态（解）
for ii = 1:SE        %每次改变至多改变两个元素   
    temp = Best;
    j=ceil(rand()*n);  
    if weight(j)<=w1
        if rand()<0.5
            temp(j)=1-temp(j);
        end
    else
        if rand()<0.5
            temp(j)=1-temp(j);
        end
    end
    
    if rand()>(i/Iter)
        jj=ceil(rand()*n);
        if jj~=j
            if weight(jj)<=w2  
                if rand()<0.5
                    temp(jj)=1-temp(jj);
                end
            end
        end
    end         
    State(ii,:) = temp;
end



