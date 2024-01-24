function [] = experiment_0(D) %DΪ����ά������

warning off
path = 'D:\��һ�γ�\�����ǰ��\ESCO\������ģECSO - ����\5times���D1000\result1\'; %����ֵ
path2 = 'D:\��һ�γ�\�����ǰ��\ESCO\������ģECSO - ����\5times���D1000\data1\'; %��������
% path = 'D:\1Single\1Results_Data\'; %����ͼ������Ž�
Times = 5;  Pron = 1;


Pro = 1:Pron; 
for j = 1 : Times %���д���

    for i = 1 : Pron %length(Pro) %�������
        K = Pro(i);
        [Problem,bu,bd] = SetPro(D,K); %SetPro�����������ⶨ�壬���������ڴ˽ű�
        disp('Problem:  '); disp(Problem);
        disp('Times:  '); disp(j);
        if D <500, N = 200; else, N = 400; end   %���������ά�ȣ�������Ⱥ��ģ
        POP = initialize_pop(N,D,bu,bd);   %��ʼ����Ⱥ��initialize_pop������������������ű�
        obj = compute_objective(POP,D,Problem); %����Ŀ�꺯����fitness��ֵ��������������ű�
        Data = [POP,obj]; %����Ⱥ��������Ӧ����Ӧֵ�ϲ�Data��N��D+1�еľ���
        
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


function [Problem,bu,bd] = SetPro(D,K)  %���ⶨ�壨ѡ�񣩣����������Լ����������ά�ȣ��Լ�����������������
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
