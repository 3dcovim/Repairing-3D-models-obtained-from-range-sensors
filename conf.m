function [c, ceq] = conf(x)
% Nonlinear inequality constraints
c = [(x(1,1)^2+x(2,1)^2+x(3,1)^2)-1-eps;...
    (x(1,2)^2+x(2,2)^2+x(3,2)^2)-1-eps];
% Nonlinear equality constraints
ceq = [x(1,1)*x(1,2)+x(2,1)*x(2,2)+x(3,1)*x(3,2)];