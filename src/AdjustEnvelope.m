function envelope = AdjustEnvelope(t, shiftLen)
    len = length(t);
    li = linspace(-shiftLen + 1, len, len) / len * 20/3;
    exp_a = 1;
    exp_b = 4;
    exp_c = 0.5;
    envelope = (exp_b * li) .^ exp_c .* exp(-exp_a * li);
    envelope = envelope / max(envelope);
end
