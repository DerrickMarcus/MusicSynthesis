function CalculateBeat(wave, Fs)

    figure;

    subplot(6, 1, 1);
    plot((1:length(wave)) / Fs, wave);

    sq = wave .^ 2;
    subplot(6, 1, 2);
    plot((1:length(sq)) / Fs, sq);

    % get envelope
    con = conv(sq, barthannwin(round(Fs / 10)));
    subplot(6, 1, 3);
    plot((1:length(con)) / Fs, con);

    % difference operation
    dif = con(2:end) - con(1:end - 1);
    subplot(6, 1, 4);
    plot((1:length(dif)) / Fs, dif);

    dif = dif .* (dif > 0);
    subplot(6, 1, 5);
    plot((1:length(dif)) / Fs, dif);

    [peaks, locs] = findpeaks(dif, 'MinPeakHeight', 0.01 * max(abs(dif)), 'MinPeakDistance', Fs / 5);
    locs = locs / Fs;
    subplot(6, 1, 6);
    plot((1:length(dif)) / Fs, dif);
    hold on;
    plot(locs, peaks, 'ro');
end
