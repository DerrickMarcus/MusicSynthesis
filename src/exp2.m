close all;
clc;

freq = GetFrequency();

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

for i = 1:size(DongFangHong, 1)
    duration = DongFangHong(i, 2) * beat;

    if i ~= 1
        shiftTime = beat / 5;
        shiftLen = shiftTime * Fs;
        t = linspace(-shiftTime, duration, duration * Fs + shiftLen)';
        sub_melody = sin(2 * pi * DongFangHong(i, 1) .* t);
        scale = AdjustEnvelope(sub_melody);
        sub_melody = sub_melody .* scale';

        if max(sub_melody) ~= 0
            sub_melody = sub_melody / max(sub_melody);
        end

        melLen = length(melody);
        subLen = length(sub_melody);
        melody = [
                  melody(1:melLen - shiftLen);
                  melody(melLen - shiftLen + 1:melLen) + sub_melody(1:shiftLen);
                  sub_melody(shiftLen + 1:subLen)
                  ];
    else
        t = linspace(0, duration, duration * Fs)';
        sub_melody = sin(2 * pi * DongFangHong(i, 1) .* t);
        scale = AdjustEnvelope(sub_melody);
        sub_melody = sub_melody .* scale';

        if max(sub_melody) ~= 0
            sub_melody = sub_melody / max(sub_melody);
        end

        melody = [melody; sub_melody];
    end

end

plot((0:length(melody) - 1) / Fs, melody);
sound(melody, Fs);
audiowrite('./exp2.wav', melody, Fs);
