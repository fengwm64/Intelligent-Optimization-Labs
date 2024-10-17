% 选择算子
% 输入：
%   Chrom   初始种群
%   fit     种群适应度值
%   parm    选择算子的参数
%       method  选择算子的算法
%       q       非线性排序选择方法定义的一个常数
% 输出：
%   sel     被选中的个体
function sel_Chrom = Select(Chrom,fit,parm)
    method = parm.method;
    
    switch method
        % ----------------- 轮盘赌算法 -----------------
        case "RWS"   
            % 每个个体的被选中概率p
            p = fit./sum(fit);
            % 每个部分的累积概率q
            q = size(p);
            for i=1:length(p)
                q(i)=sum(p(1:i));
            end
            % 模拟轮盘赌
            r = rand(1,length(fit));
            sel_n = 1;  % sel_Chrom下标
            for i=1:length(q)
                if r(i)<q(i)
                    sel_Chrom(sel_n,:) = Chrom(i,:);
                    sel_n = sel_n+1;
                end
            end
        % ---------------- 非线性排序选择 ----------------
        case "NRS"  
            % 对个体适应值降序排序，获取排名
            [~, sort_idx] = sort(fit, 'descend');
    
            % 计算&&定义一些参数
            q = parm.q;
            n = length(Chrom);
            q_= q/(1-(1-q)^n);      % q_(q')为最佳个体被选择概率
            % 计算个体i的选择概率P
            P = zeros(1,n);
            for i=1:n
                r = sort_idx(i);    % r为个体序列号
                P(i) = q_*(1-q)^(r-1);
            end
            % 模拟轮盘赌
            rn = rand(1,length(Chrom));
            rn = rn./sum(rn);   % 归一化
            sel_Chrom = Chrom(rn<P,:);
        % -----------------------------------------------
    end
end