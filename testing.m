global arr_x1;
global arr_x2;
global arr_y;
arr_x1 = [];
arr_x2 = [];
arr_y = [];


ObjectiveFunction = @simple_objective;
x0 = [0.5 0.5];   % Starting point
rng default % For reproducibility
lb = [-10 -10];
ub = [10 10];
[x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,x0,lb,ub)

x

fval
figure(1);
plot(arr_x1);
hold on;
figure(2);
plot(arr_x2);
hold on;