function y = exponent_func(t, A, tau1, tau2)
    
    y = zeros(size(t));% Создание массива 

    % Для t >= 0
    x = (t >= 0);

    % Значения функции
    y(x) = A .*(exp(-t(x) ./ tau1) - exp(-t(x) ./ tau2));
end

