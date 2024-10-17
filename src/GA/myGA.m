% 该函数实现了遗传算法（GA），用于在定义的边界约束内优化一个用户定义的
% 多变量目标函数。目标是找到能够最大化或最小化目标函数的最优解。
% 
% 语法：
%   best = myGA(N, pc, pm, Gmax, f, lb, ub, target)
% 
% 输入参数：
%   N      - 种群规模，即每代个体的数量，为整数。
%   pc     - 交叉概率，介于0和1之间的标量，定义了个体之间发生交叉（重组）
%            的频率。
%   pm     - 变异概率，介于0和1之间的标量，定义了种群中个体发生变异的频率。
%   Gmax   - 最大迭代代数，为整数，表示遗传算法迭代的最大代数。
%   f      - 目标函数句柄，函数的输入为一个n维向量，输出为标量。
%            例如：@(x) 21.5 + x(1) * sin(4 * pi * x(1)) + x(2) * sin(20 * pi * x(2))
%   lb     - 自变量的下界向量，与自变量维度相同。
%   ub     - 自变量的上界向量，与自变量维度相同。
%   target - 优化目标类型，"max" 表示最大化，"min" 表示最小化。
% 
% 输出参数：
%   best   - 一个cell数组，存储每一代的最优个体及其适应度值。
%            best{gen,1} - 第gen代的最优个体。
%            best{gen,2} - 第gen代最优个体的适应度值。
% 
% 描述：
%   myGA函数执行遗传算法优化，用户可以自定义目标函数、自变量上下界以及
%   优化目标（最大化或最小化）。函数在给定的最大代数内迭代种群，经过选择、
%   交叉、变异等操作，逐步接近目标函数的最优解。
% 
% 示例：
%   % 定义目标函数
%   f = @(x) 21.5 + x(1) * sin(4 * pi * x(1)) + x(2) * sin(20 * pi * x(2));
%   
%   % 定义自变量的上下界
%   lb = [-3.0, 4.1];
%   ub = [12.4, 5.8];
%   
%   % 运行遗传算法，最大化目标函数
%   best = myGA(100, 0.8, 0.1, 50, f, lb, ub, "max");

function best = myGA(N, pc, pm, Gmax, f, lb, ub, target) 
    % 初始化种群（实数编码）
    Chrom = createPop(N,lb,ub);
    
    % 计算初始化种群的适应度（利用目标函数）
    fit = Fitness(Chrom,f,target);
    
    % genBest记录每一代最优个体与适应度值
    genBest = cell(Gmax,2);
    genBest{1,1} = Chrom(find(fit == max(fit), 1), :);
    genBest{1,2} = max(fit);
    
    % 启动计时器
    tic;  
    
    % 开始迭代
    for gen = 2:Gmax
        % 选择
        parm = struct();    % 定义一个结构体传递参数
        parm.method = "NRS";% 平均值0
        parm.q = 0.1;       % 参考文献[2]选择算子定义的一个参数
        sel_Chrom = Select(Chrom,fit(1:N),parm);
    
        % 交叉
        parm.gamma = 0.1;   % 改进参数
        sel_Chrom = Crossover(sel_Chrom,pc,parm);
    
        % 变异
        parm = struct();    % 定义一个结构体传递正态（高斯）分布的参数
        parm.mu = 0;        % 平均值0
        parm.sigma = 0.2;   % 标准差0.1
        sel_Chrom = Mutation(sel_Chrom,pm,parm,lb,ub);
    
        % 合并新旧种群
        merge_Chrom = vertcat(Chrom,sel_Chrom);
    
        % 重新计算适应度值
        fit = Fitness(merge_Chrom,f,target);
    
        % 根据适应度值排序
        sort_fit = sort(fit,"descend");
        [~, idx] = ismember(sort_fit, fit);
    
        % 得到第gen代的种群
        new_Chrom = merge_Chrom(idx(1:N),:);
    
        % 更新父代
        Chrom = new_Chrom;
    
        % 记录每代最佳
        genBest{gen,1} = Chrom(find(sort_fit == max(fit), 1), :);
        genBest{gen,2} = max(fit);
    end
    genFitness = cell2mat(genBest(:, 2));
    [maxFitness, maxIndex] = max(genFitness);
    bestIdx = genBest(maxIndex, 1);
    
    fprintf("最优适应度为：%f\n", maxFitness);
    fprintf("个体为：%s\n", mat2str(cell2mat(bestIdx(:))));
    fprintf("经过时间：%s 秒\n", num2str(toc));
    
    best = maxFitness;
end