function s = cusp_like_filter(v, l, k, m1, m2)
    % v  - входной сигнал
    % l  - задержка l
    % k  - задержка k
    % m1 - коэффициент при p(n)
    % m2 - коэффициент при p(n) в рекурсии q(n)
    % s  - выходной сигнал
    
    % Вектор-столбец
    v = v(:);
    N = length(v);

    % Инициализация
    dk = zeros(N, 1);
    d1 = zeros(N, 1);
    p  = zeros(N, 1);
    q  = zeros(N, 1);
    s  = zeros(N, 1);

    % Предыдущие значения соответствуют нулевым начальным условиям
    p_prev = 0;
    q_prev = 0;
    s_prev = 0;

    for n = 1:N

        % d^k(n) = v(n) - v(n-k)
        if n > k
            dk(n) = v(n) - v(n-k);
        else
            dk(n) = v(n);
        end

        % d^1(n) = v(n) - v(n-1)
        if n > 1
            d1(n) = v(n) - v(n-1);
        else
            d1(n) = v(n);
        end

        % p(n) = p(n-1) + d^k(n) - k*d^1(n-l)
        if n > l
            delay_l = d1(n-l);
        else
            delay_l = 0;
        end
        p(n) = p_prev + dk(n) - k*delay_l;

        % q(n) = q(n-1) + m2*p(n)
        q(n) = q_prev + m2*p(n);

        % s(n) = s(n-1) + q(n) + m1*p(n)
        s(n) = s_prev + q(n) + m1*p(n);

        % Сохранение предыдущих значений
        p_prev = p(n);
        q_prev = q(n);
        s_prev = s(n);
    end
end