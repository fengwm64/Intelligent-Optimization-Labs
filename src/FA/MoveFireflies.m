% 萤火虫移动
% ======================================================================= %
function x_t1 = MoveFireflies(x_t,I,beta,alpha,lb,ub)
    x_t1 = x_t;

    for i=1:length(x_t)
         for j=1:length(x_t)
            % 如果个体j比i更加亮，则i被j吸引
            if I(j) > I(i)
                x_t1(i,:) = x_t1(i,:) + ...
                                    beta(i,j).*(x_t(j,:) - x_t1(i,:)) + ...
                                    alpha.*(rand(1,length(x_t1(i,:)))-0.5);
            end
        end
    end
    
    % 最亮的萤火虫随机移动
    [~,idx] = max(I);
    x_t1(idx,:) = x_t1(idx,:) + rand(size(x_t1(idx,:))) - 0.5;
    
    % 应用边界约束
    % 应用约束
    for i = 1:size(x_t1,2)
        x_t1(x_t1(:, i) < lb(i), i) = lb(i) + rand;  % 将小于下限的值设为下限
        x_t1(x_t1(:, i) > ub(i), i) = ub(i) - rand;  % 将大于上限的值设为上限
    end
end