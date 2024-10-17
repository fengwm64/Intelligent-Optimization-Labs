% 计算个体之间吸引度
% ======================================================================= %
function beta = Attraction(r, gamma, beta_0)
    beta = beta_0.*exp(-gamma.*r.^2);
end