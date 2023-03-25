
function eff=evaluation(pop,X,k)  %pop�ǽ⼯��X�����ݼ���k������ά��

eff=pop;  
ss=size(pop,1);  %��С=����
for(i=1:ss)
    eff(i,k+1)=100*kmean_res(pop(i,:),X);  %�����ڶ��зŵ÷֣�
    eff(i,k+2)=sum(pop(i,2:k));    %������һ�з���������
end

function ary=kmean_res(par,X) %par��һ�зű�ǩ

nx=size(X,1);  %��С=���ݼ�������
np=size(par,2);  %��С=������+1
sel=[];
for(i=2:np)
    if par(i)==1
        sel=[sel,i];  %����ѡ�е������Ķ�Ӧ���ֵ
    end
end
Y=X(:,sel);  %Y�Ǿ���ѡ�������ݼ�
cn=size(sel,2);  %ѡ��������������
class=[];
for(i=1:nx)  %�������±���data���ݼ���������
    nearest=10e100;  %��ʼ��
    for(j=1:nx)  %�������±���data���ݼ����ڲ����
        if(i~=j)
            dist=0;
            for(jj=1:cn)  %ֻ����ѡ�������������Ӧ�ľ����
                if(Y(i,jj)~=inf && Y(j,jj)~=inf)  %�����ֵ�Ļ�
                    dist=dist+abs(Y(i,jj)-Y(j,jj));   %�����پ���
                end      
            end
            if dist<nearest
                class(i)=X(j,1);  %��ǩֵΪ��ǰ��������ĵ�ı�ǩ
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



