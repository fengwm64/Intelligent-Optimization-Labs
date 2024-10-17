% 计算两只萤火虫之间的距离
% ======================================================================= %
function r = Distance(Fireflies)
    r= zeros(length(Fireflies));
    
    for i = 1:length(Fireflies)
        for j = 1:length(Fireflies)
            % 计算欧几里得范数
            r(i,j) = norm(Fireflies(i,:)-Fireflies(j,:),2);
        end
    end
end