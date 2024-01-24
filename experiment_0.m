function [] = experiment_0(D) %D为问题维数个数

warning off
path = 'D:\研一课程\计算机前沿\ESCO\昂贵大规模ECSO - 副本\5times结果D1000\result1\'; %最优值
path2 = 'D:\研一课程\计算机前沿\ESCO\昂贵大规模ECSO - 副本\5times结果D1000\data1\'; %收敛数据
% path = 'D:\1Single\1Results_Data\'; %收敛图相关最优解
Times = 5;  Pron = 1;


Pro = 1:Pron; 
for j = 1 : Times %运行次数

    for i = 1 : Pron %length(Pro) %问题个数
        K = Pro(i);
        [Problem,bu,bd] = SetPro(D,K); %SetPro函数：对问题定义，函数定义在此脚本
        disp('Problem:  '); disp(Problem);
        disp('Times:  '); disp(j);
        if D <500, N = 200; else, N = 400; end   %根据问题的维度，设置种群规模
        POP = initialize_pop(N,D,bu,bd);   %初始化种群，initialize_pop函数，函数定义另起脚本
        obj = compute_objective(POP,D,Problem); %计算目标函数（fitness）值，函数定义另起脚本
        Data = [POP,obj]; %将种群和其个体对应的适应值合并Data是N行D+1列的矩阵
        
        [Fitness_CEA(K,j),Data1,time1] = exper_CEA(Data,bu,bd,Problem);
        save(strcat(path,'CEA_D',int2str(D)),'Fitness_CEA');
        
         s = strcat(path2,Problem,'_',int2str(D),'_',int2str(j));
         save(s,'Data1')
%         save(s,'Data1','Data2','Data3','Data4','Data5');
%         save([s '_Time'],'time1','time2','time3','time4','time5');

    end
end

Fitness_CEA(:,Times+1) = mean(Fitness_CEA(:,1:end),2);
save(strcat(path,'CEA_D',int2str(D)),'Fitness_CEA');

end

function [Fitness,Data,time] = exper_CEA(Data,bu,bd,Problem)
t1=clock;

[Best,Data] = CEA(Data,bu,bd,Problem);
Fitness = Best;

t=etime(clock, t1);
time=t;
end


function [Problem,bu,bd] = SetPro(D,K)  %问题定义（选择），返回问题以及问题变量的维度，以及各个变量的上下限
switch K
    case 1
        Problem = 'Ellipsoid';
        base = ones(1,D);
        bu = base*5.12 ; bd = base*-5.12;
    case 2
        Problem = 'Rosenbrock';
        base = ones(1,D);
        bu = base*2.048 ; bd = base*-2.048;
    case 3
        Problem = 'Rastrigin';
        base = ones(1,D);
        bu = base*5 ; bd = base*-5;
    case 4
        Problem = 'Ackley';
        base = ones(1,D);
        bu = base*32.768 ; bd = base*-32.768;      
    case 5
        Problem = 'Griewank';
        base = ones(1,D);
        bu = base*600 ; bd = base*-600;
    case 6
        Problem = 'rastrigin_rot_func';
        base = ones(1,D);
        bu = base*5 ; bd = base*-5;
    case 7
        Problem = 'hybrid_rot_func1';
         base = ones(1,D);
        bu = base*5 ; bd = base*-5;
    case 8
        Problem = 'hybrid_rot_func2_narrow';
        base = ones(1,D);
        bu = base*5 ; bd = base*-5;
end
end
