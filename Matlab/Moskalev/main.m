%% Построение графика сигнала

% Исходные параметры
A = 1;
tau1 = 16;
tau2 = 5;
t = -10:1:100;% массив времени
y = exponent_func(t, A, tau1, tau2);% вызов функции

% График
figure(1);
plot(t, y, 'b.-','LineWidth', 2,'MarkerSize', 12);
grid on;
xlabel('t');
ylabel('A(t)');
title('Cигнал');

%% Применение фильтра
% Исходные параметры
l = 6;
k = 13;
m1 = 16;
m2 = 1;

y_filter = cusp_like_filter(y, l, k, m1, m2);% вызов функции

% График
figure(2);
subplot(2, 1, 1);% исходный график сигнала
plot(t, y, 'b.-', 'LineWidth', 2, 'MarkerSize', 10);
xlabel('t');
ylabel('A(t)');
title('Исходный сигнал');
grid on;

subplot(2, 1, 2);% график после фильтра
plot(t, y_filter, 'r.-', 'LineWidth', 2, 'MarkerSize', 10);
xlabel('t');
ylabel('A(t)');
title('Сusp-like фильтр');
grid on;







