% src/exp3.m

close all;
clc;

% adjust the envelope by expotential function
function result = Adjust_Exp(t)
    A = 1.5;
    B = 8;
    C = 1;
    result = t .^ A .* exp(-B * t + C);
    result = result / max(result);
end

f_A = [220; 440];
freq = f_A * 2 .^ (0:1/12:1 -1/12);

DongFangHong = [
                freq(2, 4), 1;

                freq(2, 4), 0.5;
                freq(2, 6), 0.5;

                freq(1, 11), 2;
                freq(1, 9), 1;

                freq(1, 9), 0.5;
                freq(1, 6), 0.5;

                freq(1, 11), 2;
                ];

Fs = 8e3;
beat = 0.5;

melody = [];

overlap_len = 0;

for i = 1:size(DongFangHong, 1)
    self_time = DongFangHong(i, 2) * beat;
    overlap_time = self_time / 10;
    duration = self_time + overlap_time;

    t = linspace(0, duration, duration * Fs)';
    sub_melody = sin(2 * pi * DongFangHong(i, 1) .* t) .* Adjust_Exp(t / duration);

    melody = [
              melody(1:end - overlap_len);
              melody(end - overlap_len + 1:end) + sub_melody(1:overlap_len);
              sub_melody(overlap_len + 1:end)
              ];

    overlap_len = overlap_time * Fs; % used in next loop

end

% plot((0:length(melody) - 1) / Fs, melody);
% sound(melody, Fs);
% audiowrite('../results/exp3_1.wav', melody, Fs);

% raise an octave
sound(melody, Fs * 2);
audiowrite('../results/exp3_1.wav', melody, Fs * 2);

% lower an octave
sound(melody, Fs / 2);
audiowrite('../results/exp3_2.wav', melody, Fs / 2);

% raise a scale
new_melody = resample(melody, Fs, round(Fs * 2 ^ (1/12)));
sound(new_melody, Fs);
audiowrite('../results/exp3_3.wav', new_melody, Fs);
