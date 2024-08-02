% src/fig_harmonic.m

close all;
clc;

t = linspace(0, 1, 8000);

harmonics = [1; 0.3; 0.2; 0.1];
frequencies = (1:length(harmonics))' * 7;
% disp(frequencies);

y = zeros(size(t));

for k = 1:length(harmonics)
    y = y + harmonics(k) * sin(2 * pi * frequencies(k) * t);
end

figure;
plot(t, y);
grid on;
title('Harmonic Waveform');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '../report/harmonic.png');
