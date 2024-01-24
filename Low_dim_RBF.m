function [Model,Sind,Tind,Xind,Train,Test,W,B,C,P] = Low_dim_RBF(S,n,d,Cr,T)

X = S(:,1:d); %种群各个变量值的矩阵N行D列
Y = S(:,d+1); %种群各个个体的适应值N行1列
t = 3/4; %选择作为训练RBF的个体的概率
Train = cell(1,T); %构建一个1行T列的元胞数组
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
    
    %Random Sampling  抽样
    ind = rand(n,T);
    I1 = ind<t;
    I0 = ind>=t;
    ind(I1) = 1;
    ind(I0) = 0;
    I = ind(:,i)==1;  %被选中的为1，没被选的0 是个logi数组
    
    xind = roulette(Cr,d); %下标索引（行向量）（被选中的特征变量的下标）
        
%     [RBFmodel, time] = rbfbuild(X(I,xind),Y(I,1), 'TPS');  % RBF surrogate
%     Model{i} = RBFmodel;
    [ W2,B2,Centers,Spreads ] = RBF1( X(I,xind),Y(I,1),nc0);
    W(i,:)=W2; 
    B(i)=B2;
    C{i}=Centers;
    P(:,i)=Spreads;
    Sind{i} = find(I == true);     %被选中的样本个体下标
    Tind{i} = find(I == false);   
    Xind{i} = xind;      %被选中的特征下标
    Train{i} = [X(I,xind),Y(I,1)];  %第T个模型的训练集
    Test{i} = [X(~I,xind),Y(~I,1)];  %测试集  
     
end

end

function index = roulette(Cr,dim)  %轮盘赌

% rng('shuffle');
% rn = randperm(dim,1);  %随机生成训练集维数
rn = dim;  %不随机生成维数
% rn = 100;  %固定为100
Cr = reshape(Cr,1,[]);  %将各个变量的ri变成行向量
Cr = Cr + max(min(Cr),0); % ？没懂
% Cr = cumsum(1./Cr);  %值越小被选择概率越大
Cr = cumsum(Cr);  %值越大被选择概率越大
Cr = Cr./max(Cr); %将Cr里的值变为0,1之间，方便与0,1之间随机数进行比较
index   = arrayfun(@(S)find(rand<=Cr,1),1:rn); 
[~,uni] = unique(index);
index = index(sort(uni));
end

