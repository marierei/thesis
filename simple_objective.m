function y = simple_objective(x)
%SIMPLE_OBJECTIVE Objective function for PATTERNSEARCH solver
global arr_x1;
global arr_x2;
global arr_y;
%   Copyright 2004 The MathWorks, Inc.  

x1 = x(1);
x2 = x(2);
y = (4-2.1.*x1.^2+x1.^4./3).*x1.^2+x1.*x2+(-4+4.*x2.^2).*x2.^2;

arr_x1 = [arr_x1 x1];
arr_x2 = [arr_x2 x2];
arr_y = [arr_y y];
end