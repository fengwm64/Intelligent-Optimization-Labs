% 交叉算子
% 输入：
%   sel_Chrom   选择后的种群
%   pc          交叉率
%   gamma       随机参数alpha浮动范围（0.1 这是一个改进）
% 输出：
%   Cro_Chrom   完成交叉的种群
function Cro_Chrom = Crossover(sel_Chrom,pc,parm)
    % 处理长度为奇数的情况
    start = 1;
    if mod(length(sel_Chrom), 2) == 1
        start = 2;
    end
    
    % 生成随机参数alpha
    gamma = parm.gamma;
    alpha = -gamma + (1+gamma+gamma) * rand(1, length(sel_Chrom));
    
    % 每两个一组
    for i=start:2:length(sel_Chrom)
        if rand() < pc
            Cro_Indiv1 = alpha(i).*sel_Chrom(i,:)+(1-alpha(i)).*sel_Chrom(i+1,:);
            Cro_Indiv2 = alpha(i).*sel_Chrom(i+1,:)+(1-alpha(i)).*sel_Chrom(i,:);
            sel_Chrom(i,:) = Cro_Indiv1;
            sel_Chrom(i+1,:) = Cro_Indiv2;
        end
    end
    Cro_Chrom = sel_Chrom;
end