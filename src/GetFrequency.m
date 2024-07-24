function freq = GetFrequency()
    f_A = [220; 440];
    freq = f_A * 2 .^ (0:1/12:1 -1/12);
end
