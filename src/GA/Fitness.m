% 计算种群适应度值
% 输入：
%   Pop     种群
%   ObjFun  目标函数
% 输出：
%   fit     种群适应度值
function fit = Fitness(Pop, ObjFun,target)
    fit = zeros(length(Pop),1);
    % 计算函数值
    for i=1:length(fit)
        fit(i) = ObjFun(Pop(i,:));
    end
    % 如果是max型，适应度值=函数值
    % 如果是min型，适应度值=当前种群最大函数值-函数值（正向化处理）
    if target == "min"||target == "MIN"
        fit = max(fit) - fit;
    end
end
