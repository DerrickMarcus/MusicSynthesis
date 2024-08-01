t = linspace(0, 1, 400);

envelope = zeros(size(t));

t_begin = t(1);
t_len = t(end) - t(1);
result = ...
    (t_begin <= t & t < t_begin + t_len / 6) .* (6 / t_len * (t - t_begin)) + ...
    (t_begin + t_len / 6 <= t & t < t_begin + t_len / 3) .* (1 - 1.2 / t_len * (t - t_begin - t_len / 6)) + ...
    (t_begin + t_len / 3 <= t & t < t_begin + t_len * 2/3) .* 0.8 + ...
    (t_begin + t_len * 2/3 <= t & t <= t_begin + t_len) .* (-2.4 / t_len * (t - t_begin - t_len));

figure;
plot(t, result);
title('Envelope Shape of the Adjusted Linear Function');
xlabel('Time (s)');
ylabel('Envelope Value');
grid on;
hold on;

A = 1.5;
B = 8;
C = 1;
result = t .^ A .* exp(-B * t + C);
result = result / max(result);
plot(t, result);
saveas(gcf, '../report/envelope.png');
