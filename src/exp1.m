clear;

% store all frequencies in a vector
f_A = [220, 440]';
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

fs = 8e3;
beat = 0.5;

num_samples = 0;

% calculate total number of samples
for i = 1:size(DongFangHong, 1)
    num_samples = num_samples + round(DongFangHong(i, 2) * fs * beat);
end

% initialize melody array
melody = zeros(num_samples, 1);

cur_index = 1;

for i = 1:size(DongFangHong, 1)
    t = linspace(0, DongFangHong(i, 2) * beat, round(DongFangHong(i, 2) * fs * beat))';
    sub_melody = sin(2 * pi * DongFangHong(i, 1) .* t);
    melody(cur_index:cur_index + length(sub_melody) - 1) = sub_melody;
    cur_index = cur_index + length(sub_melody);
end

% plot melody waveform and save
plot((0:length(melody) - 1) / fs, melody);
sound(melody, fs);
audiowrite('exp1.wav', melody, fs);
