%substitute��ʹĳһ��Ԫ�ط�ת
%  �ȶ�����ȫ����

function State = op_substitute(Best,SE,Iter,i,weight,w2,w3)  %BestΪ��ǰ���Ž�
n = length(Best);  %87
State = zeros(SE,n);  %��ʼ��״̬  20��87�У�ÿһ�д�һ��״̬���⣩
for ii = 1:SE        %ÿ�θı�����ı�����Ԫ��   
    temp = Best;
    if rand()<((i)/(Iter))^2
        j=ceil(rand()*n);  %������ɣ�ǰ�ڵĿ�����
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
        if weight(jjj)<w3  %��������ȨֵС��Ȩֵ���ϵ���λ��
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
