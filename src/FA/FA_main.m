%% 基本萤火虫算法实现
clc
clear
close all
rand('state', 0);

%% 测试函数与约束条件
% 目标函数
% f = @(x) 21.5+x(1).*sin(4*pi().*x(1))+x(2).*sin(20.*pi().*x(2));
f = @(x) exp(-(x(1)-4).^2-(x(2)-4).^2)+exp(-(x(1)+4).^2-(x(2)-4).^2)+2.*exp(-x(1).^2-(x(2)+4).^2)+2.*exp(-x(1).^2-x(2).^2);
target = "max";
% 约束条件
% lb = [-3.0,4.1];    % 自变量下界
% ub = [12.4,5.8];    % 自变量上界
lb = [-5.0,-5.0];    % 自变量下界
ub = [5,5];    % 自变量上界

%% 绘制测试函数曲面图
% 创建一些 x1 和 x2 的值
x1 = linspace(lb(1), ub(1), 3000);
x2 = linspace(lb(2), ub(2), 3000);

% 创建网格
% f_ = @(x1,x2) 21.5+x1.*sin(4*pi().*x1)+x2.*sin(20.*pi().*x2);
f_ = @(x,y) exp(-(x-4).^2-(y-4).^2)+exp(-(x+4).^2-(y-4).^2)+2.*exp(-x.^2-(y+4).^2)+2.*exp(-x.^2-y.^2);
[x1Grid, x2Grid] = meshgrid(x1, x2);
z = f_(x1Grid, x2Grid);

% 绘制
figure
mesh(x1Grid,x2Grid,z)
colorbar
xlabel('X1');
ylabel('X2');
zlabel('f(x1,x2)')

%% 绘制测试函数等高线图
figure
contour(x1Grid, x2Grid, z, 10);
% 添加标签和标题
xlabel('X1');
ylabel('X2');
title('等高线图');
colorbar
clear x1 x2 x1Grid x2Grid z f_
% 坐标区域修饰
ax=gca;
ax.LineWidth=1.4;
ax.Box='on';
ax.TickDir='in';
ax.XMinorTick='on';
ax.YMinorTick='on';
ax.XGrid='on';
ax.YGrid='on';
ax.GridLineStyle='--';
ax.XColor=[.3,.3,.3];
ax.YColor=[.3,.3,.3];
ax.FontWeight='bold';
ax.FontName='YaHei';
ax.FontSize=11;
hold on

%% 基本萤火虫算法
% 参数的经验值来自论文《萤火虫算法的改进及其在物流中心选址中的应用_毛艺楠》
% 设置萤火虫算法参数
MaxG = 50;      % 最大进化代数
n = 12;        % 种群中个体数量
d = 2;          % 维度
alpha = 0.2;    % 步长因子α
beta_0 = 1.0;   % 最大吸引度β_0
delta = 0.97;
gamma = 1;      % 光吸引系数γ

%% Step1：随机生成萤火虫个体的初始位置
Fireflies = InitFireflies(n,d,lb,ub);
% 绘制萤火虫个体位置
sca = scatter(Fireflies(:,1),Fireflies(:,2), 40, ...
    'MarkerFaceColor', 'g', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
hold on;

%% Step2：计算萤火虫个体的亮度
bright = Brightness(Fireflies,f,target);

%% Step3：计算两只萤火虫之间的距离
distance = Distance(Fireflies);

%% Step4：计算个体之间吸引度
attraction = Attraction(distance, gamma, beta_0);

%% Step5：萤火虫移动
new_Fireflies = MoveFireflies(Fireflies,bright,attraction,alpha,lb,ub);

%% 输出该代萤火虫最佳个体信息
disp("------------- 初始化完毕 -------------")
[bright_GMAX, idx_GMAX] = max(bright);
GenBest = sprintf('%d.   %.6f    %.5f    ' ,1,Fireflies(idx_GMAX,:), bright_GMAX);
disp(GenBest);

%% 算法主循环
GenBestTab = table( 'VariableNames', {'x1', 'x2', 'f(x)'}, ...
                    'Size', [MaxG, d + 1], ...
                    'VariableTypes', {'double','double','double'});
GenBestTab{1,:} = [Fireflies(idx_GMAX,:), bright_GMAX];
disp("-------------- 开始迭代 --------------")

for gen = 2:MaxG
    Fireflies = new_Fireflies;
    % 计算萤火虫个体的亮度
    bright = Brightness(Fireflies,f,target);
    % 计算两只萤火虫之间的距离
    distance = Distance(Fireflies);
    % 计算个体之间吸引度
    attraction = Attraction(distance, gamma, beta_0);
    % 萤火虫移动
    new_Fireflies = MoveFireflies(Fireflies,bright,attraction,alpha,lb,ub);
    % 更新随机步长
    alpha=newalpha(alpha,delta);
    % 输出该代萤火虫最佳个体信息
    [bright_GMAX, idx_GMAX] = max(bright);
    GenBest = sprintf('%d.   %.6f    %.5f    ' ,gen, Fireflies(idx_GMAX,:), bright_GMAX);
    disp(GenBest);
    GenBestTab{gen,:} = [Fireflies(idx_GMAX,:), bright_GMAX];
    % 更新群体位置
    sca.XData = Fireflies(:,1);
    sca.YData = Fireflies(:,2);
    pause(1);
    hold on
end

%% 算法
[bright_Best, idx_Best] = max(GenBestTab.("f(x)"));
disp("----------------------------------------------------------------")
disp("找到最优解：")
disp(GenBestTab{idx_Best,:})