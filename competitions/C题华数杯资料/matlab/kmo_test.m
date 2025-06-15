function kmoValue = kmo_test(data)
    [~, p] = corrcoef(data);
    n = size(data, 1);
    r = corr(data);
    kmoNum = sum(sum((r - diag(diag(r))).^2));
    kmoDen = kmoNum + sum(sum((1 - r).^2));
    kmoValue = kmoNum / kmoDen;
end
