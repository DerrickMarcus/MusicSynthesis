function locs = DivideBeat(wave, Fs)

    figure;

    subplot(6, 1, 1);
    plot((1:length(wave)) / Fs, wave);

    sq = wave .^ 2;
    subplot(6, 1, 2);
    plot((1:length(sq)) / Fs, sq);

    con = conv(sq, barthannwin(round(Fs / 10)));
    subplot(6, 1, 3);
    plot((1:length(con)) / Fs, con);

    dif = con(2:end) - con(1:end - 1);
    subplot(6, 1, 4);
    plot((1:length(dif)) / Fs, dif);

    dif = dif .* (dif > 0);
    subplot(6, 1, 5);
    plot((1:length(dif)) / Fs, dif);

    [peaks, locs] = findpeaks(dif, ...
        'MinPeakHeight', 0.015 * max(abs(dif)), ...
        'MinPeakDistance', Fs * 0.15);
    locs = locs / Fs;
    hold on;
    plot(locs, peaks, 'ro');

    subplot(6, 1, 6);
    plot((1:length(wave)) / Fs, wave);
    hold on;
    locs = locs - 0.05;

    for i = 1:length(locs)
        line([locs(i), locs(i)], ylim, 'Color', 'red', 'LineStyle', '-');
    end

    saveas(gcf, '../report/fig9_1.png');
end
