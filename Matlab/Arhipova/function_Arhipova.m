function [ y ] = function_Arhipova( A, t, tau1, tau2 )
% Генерирует массив чисел согласно формуле из Задания 1.

% Входные параметры:
%   t      - вектор времени 
%   A      - амплитуда сигнала
%   tau1, tau2 - постоянные времени
%
% Выходные параметры:
%   y      - массив значений функции/

y = zeros(size(t)); 
% Учитываем условие y=0 при t<0

idx_positive = (t >= 0);
% Находим индексы, где время неотрицательно (t >= 0)

y(idx_positive) = A * (exp(-t(idx_positive)/tau1) - exp(-t(idx_positive)/tau2));
% Формула: y = A * (exp(-t/tau1) - exp(-t/tau2))

end
