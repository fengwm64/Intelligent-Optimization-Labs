% 变异算子
% 输入：
%   Cro_Chrom   交叉后的种群
%   pm          变异率
%   parm        正态分布的参数
%   lb          自变量下界
%   ub          自变量上界
% 输出：
%   Mut_Chrom   完成变异的种群
function Mut_Chrom = Mutation(Cro_Chrom,pm,parm,lb,ub)
    % 找到需要变异个体的下标
    Cro_r = rand(1,length(Cro_Chrom));% 生成每个个体对应随机数，若该数<pm则变异

    % ---------------------------- 准备变异参数 ----------------------------
    % 1.变异方向（+还是-正态分布分布随机数）
    r1 = rand(1,length(Cro_Chrom));    % r1为[0,1]之间的均匀随机变量
    Cro_dir_plus = find(r1 < 0.5 & Cro_r < pm);
    Cro_dir_reduce = find(r1 >= 0.5 & Cro_r < pm);
    if any(ismember(Cro_dir_plus, Cro_dir_reduce))
        error('Mutation函数：变异方向计算错误！！'); % 如果有相同元素，引发错误
    end

    % 2.正态分布随机数生成
    % 正态分布参数
    mu = parm.mu;
    sigma = parm.sigma;
    r2 = mu + sigma .* randn(length(Cro_Chrom),1);
    % ---------------------------- ------------ ----------------------------

    % 开始变异
    % +
    if ~isempty(Cro_dir_plus)
        Cro_Chrom(Cro_dir_plus,:) = Cro_Chrom(Cro_dir_plus,:) + abs(r2(Cro_dir_plus).*(ub-Cro_Chrom(Cro_dir_plus,:)).*Cro_Chrom(Cro_dir_plus,:));
    end
    % -
    if ~isempty(Cro_dir_reduce)
        Cro_Chrom(Cro_dir_reduce,:) = Cro_Chrom(Cro_dir_reduce,:) + abs(r2(Cro_dir_reduce).*(Cro_Chrom(Cro_dir_reduce,:)-lb).*Cro_Chrom(Cro_dir_reduce,:));
    end

    % 应用约束
    for i = 1:size(Cro_Chrom, 2)
        Cro_Chrom(Cro_Chrom(:, i) < lb(i), i) = lb(i);  % 将小于下限的值设为下限
        Cro_Chrom(Cro_Chrom(:, i) > ub(i), i) = ub(i);  % 将大于上限的值设为上限
    end

    Mut_Chrom = Cro_Chrom;
end