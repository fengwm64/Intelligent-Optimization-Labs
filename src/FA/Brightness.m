% 计算每个萤火虫光源处的亮度(r = 0)
% ======================================================================= %
function bright = Brightness(Fireflies,obj_fun,target)
    bright = zeros(length(Fireflies),1);

    for i = 1:length(Fireflies)
        bright(i) = obj_fun(Fireflies(i,:));
    end
    
    % 极小型转极大型
    if target == "min" || target == "Min" || target == "MIN"
        max_bright = max(bright);
        bright = max_bright - bright;
    end
end