function [Model,Sind,Tind,Xind,Train,Test,W,B,C,P] = Low_dim_RBF(S,n,d,Cr,T)

X = S(:,1:d); %��Ⱥ��������ֵ�ľ���N��D��
Y = S(:,d+1); %��Ⱥ�����������ӦֵN��1��
t = 3/4; %ѡ����Ϊѵ��RBF�ĸ���ĸ���
Train = cell(1,T); %����һ��1��T�е�Ԫ������
Test = cell(1,T); 
Sind = cell(1,T);
Tind = cell(1,T);
Xind = cell(1,T);
Model = cell(1,T);
if n < 400, ClusterNum = ceil(n*0.60); else, ClusterNum = 150; end %200;  if n < 400, ClusterNum = ceil(n*0.375);
% ClusterNum = ceil(n*0.375);
nc0 = ClusterNum;
% t=0.5;%probability of out-of-bag
W=zeros(T,nc0);
B=zeros(1,T);
C=cell(1,T);
P=zeros(nc0,T);
for i = 1 : T
    
    %Random Sampling  ����
    ind = rand(n,T);
    I1 = ind<t;
    I0 = ind>=t;
    ind(I1) = 1;
    ind(I0) = 0;
    I = ind(:,i)==1;  %��ѡ�е�Ϊ1��û��ѡ��0 �Ǹ�logi����
    
    xind = roulette(Cr,d); %�±�������������������ѡ�е������������±꣩
        
%     [RBFmodel, time] = rbfbuild(X(I,xind),Y(I,1), 'TPS');  % RBF surrogate
%     Model{i} = RBFmodel;
    [ W2,B2,Centers,Spreads ] = RBF1( X(I,xind),Y(I,1),nc0);
    W(i,:)=W2; 
    B(i)=B2;
    C{i}=Centers;
    P(:,i)=Spreads;
    Sind{i} = find(I == true);     %��ѡ�е����������±�
    Tind{i} = find(I == false);   
    Xind{i} = xind;      %��ѡ�е������±�
    Train{i} = [X(I,xind),Y(I,1)];  %��T��ģ�͵�ѵ����
    Test{i} = [X(~I,xind),Y(~I,1)];  %���Լ�  
     
end

end

function index = roulette(Cr,dim)  %���̶�

% rng('shuffle');
% rn = randperm(dim,1);  %�������ѵ����ά��
rn = dim;  %���������ά��
% rn = 100;  %�̶�Ϊ100
Cr = reshape(Cr,1,[]);  %������������ri���������
Cr = Cr + max(min(Cr),0); % ��û��
% Cr = cumsum(1./Cr);  %ֵԽС��ѡ�����Խ��
Cr = cumsum(Cr);  %ֵԽ��ѡ�����Խ��
Cr = Cr./max(Cr); %��Cr���ֵ��Ϊ0,1֮�䣬������0,1֮����������бȽ�
index   = arrayfun(@(S)find(rand<=Cr,1),1:rn); 
[~,uni] = unique(index);
index = index(sort(uni));
end

