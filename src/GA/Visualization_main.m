% Visualization_main - 遗传算法可视化主程序
%
% 该脚本用于运行遗传算法（GA），并通过图形界面动态展示优化过程中种群的演化以及最优个体适应度的变化。
% 该程序针对特定的优化问题，提供遗传算法的解空间搜索过程的可视化。
%
% 主要步骤：
% 1. 定义目标函数、约束条件以及遗传算法的基本参数。
% 2. 初始化种群并计算初始适应度。
% 3. 绘制目标函数的三维曲面图，并动态展示种群在解空间中的位置变化。
% 4. 迭代更新种群，通过选择、交叉和变异操作，逐步优化解。
% 5. 在每代迭代中，展示种群适应度的变化情况，并绘制最优适应度随迭代次数的变化曲线。
%
% 目标函数：
%   f(x) = 21.5 + x(1) * sin(4 * pi * x(1)) + x(2) * sin(20 * pi * x(2))
%   优化目标为最大化。
%
% 约束条件：
%   lb - 自变量的下界为 [-3.0, 4.1]。
%   ub - 自变量的上界为 [12.4, 5.8]。
%
% 遗传算法参数：
%   N      - 种群大小为 100。
%   pc     - 交叉率为 0.7。
%   pm     - 变异率为 0.07。
%   Gmax   - 最大迭代次数为 2000。
%
% 可视化内容：
% 1. 三维曲面图展示目标函数的形状。
% 2. 动态展示种群个体在每代迭代中的分布变化（scatter3 图）。
% 3. 最优个体的适应度随迭代次数的变化曲线。
%
% 输出结果：
%   在所有迭代完成后，输出最优适应度值及其对应的个体，并显示运行时间。
%
% 示例：
%   直接运行该脚本，遗传算法将开始迭代，并动态展示种群演化过程以及最优适应度的变化情况。

%% 清理工作区
clc
clear
close all
 
%% --------------遗传算法参数--------------
N = 100;        % 种群大小
pc = 0.7;      % 交叉率
pm = 0.07;     % 变异率
Gmax = 2000;    % 最大迭代次数
 
% 目标函数
f = @(x) 21.5+x(1).*sin(4*pi().*x(1))+x(2).*sin(20.*pi().*x(2));
target = "max";
% 约束条件
lb = [-3.0,4.1];    % 自变量下界
ub = [12.4,5.8];    % 自变量上界
 
%% ------------初始化种群（实数编码）------------
Chrom = createPop(N,lb,ub);
 
% 计算初始化种群的适应度（利用目标函数）
fit = Fitness(Chrom,f,target);
 
% genBest记录每一代最优个体与适应度值
genBest = cell(Gmax,2);
genBest{1,1} = Chrom(find(fit == max(fit), 1), :);
genBest{1,2} = max(fit);
 
% 绘制函数图像
subplot(1,2,1)
fsurf(@(x1,x2) 21.5+x1.*sin(4*pi().*x1)+x2.*sin(20.*pi().*x2), ...
    [lb(1),ub(1),lb(2),ub(2)]);
% colorbar
hold on
% 绘制种群变化图
sca = scatter3(Chrom(:,1),Chrom(:,2),fit,'r*');
 
% 绘制最优适应度随迭代次数变化图
subplot(1,2,2)
p = plot(1,max(fit),'LineWidth',2,'LineStyle','-');
xlabel('迭代次数');
ylabel('适应度值');
set(gcf,'Color',[1 1 1])
set(gca, 'Box', 'off', ...                           % 边框
    'LineWidth', 1.4,...                             % 线宽
    'XGrid', 'off', 'YGrid', 'on', ...               % 网格
    'TickDir', 'out', 'TickLength', [.01 .01], ...   % 刻度
    'XMinorTick', 'off', 'YMinorTick', 'off')

%% ---------------开始迭代---------------
tic;  % 启动计时器
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
 
    % 更新种群分布图
    sca.XData=Chrom(:,1);
    sca.YData=Chrom(:,2);
    sca.ZData=sort_fit(1:N);
    % 更新最优适应度随迭代次数变化图
    p.XData = 1:gen;
    p.YData = cell2mat(genBest(:,2));
    pause(0.1)          % 暂停0.1s
end
  
genFitness = cell2mat(genBest(:, 2));
[maxFitness, maxIndex] = max(genFitness);
bestIdx = genBest(maxIndex, 1);
 
fprintf("最优适应度为：%f\n", maxFitness);
fprintf("个体为：%s\n", mat2str(cell2mat(bestIdx(:))));
fprintf("经过时间：%s 秒\n", num2str(toc));