% 随机生成萤火虫个体的初始位置
% ======================================================================= %
function Fireflies = InitFireflies(n,d,lb,ub)
    Fireflies = zeros(n,d);
    for i=1:d
        Fireflies(:,i) = lb(i) + (ub(i) - lb(i)) * rand(n, 1);
    end
end
