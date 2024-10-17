% 创建初始种群（实数编码）
% 输入：
%   PopSize 种群大小
%   lb      自变量下界
%   ub      自变量上界
% 输出：
%   Chrom   初始种群
function Chrom = createPop(PopSize,lb,ub)
    % 检查lb ub维度的一致性
    if length(lb)==length(ub)
        n = length(lb);
    else
        fprintf("请检查lb与ub维度是否匹配，lb：%d  ub：%d\n",length(lb),length(ub));
    end
    
    % 随机生成种群
    Chrom = zeros(PopSize,n);
    
    for i=1:PopSize
        Chrom(i,:) = (lb + (ub - lb) .* rand(1,n));
    end
end
    