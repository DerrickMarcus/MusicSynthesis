% src/Adjust_Exp.m

% adjust the envelope by expotential function
function result = Adjust_Exp(t)
    A = 1;
    B = 8;
    C = 1;
    result = t .^ A .* exp(-B * t + C);
    result = result / max(result);
end
