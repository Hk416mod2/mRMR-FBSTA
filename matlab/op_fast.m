%substitute��ʹĳһ��Ԫ�ط�ת
%  �ȶ�����ȫ����

function State = op_fast(Best,SE,Iter,i,weight,w1,w2)  %BestΪ��ǰ���Ž�
n = length(Best);  %87
State = zeros(SE,n);  %��ʼ��״̬  20��87�У�ÿһ�д�һ��״̬���⣩
for ii = 1:SE        %ÿ�θı�����ı�����Ԫ��   
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



