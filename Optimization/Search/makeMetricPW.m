function metric = makeMetricPW(shiftMatrix, padding)
    
    [h,w] = size(shiftMatrix);
    h = 2*h+2*padding;
    w = w+2*padding;

    sM = [];
    sM(1,1,:,:) = shiftMatrix;

    metric = {};
    metric{1,1} = cyl2rec(sM.*sM-1,[(h+1-2*padding)/2, (h+1-2*padding)/2],-1,padding);
    metric{1,2} = zeros(1,h,h,w);
    metric{2,1} = metric{1,2};
    metric{1,3} = zeros(1,h,h,w);
    metric{3,1} = metric{1,3};
    metric{1,4} = cyl2rec(-2.*sM,[(h+1-2*padding)/2, (h+1-2*padding)/2],0,padding);
    metric{4,1} = metric{1,4};
    metric{2,3} = zeros(1,h,h,w);
    metric{3,2} = metric{2,3};
    metric{2,4} = zeros(1,h,h,w);
    metric{4,2} = metric{2,4};
    metric{3,4} = zeros(1,h,h,w);
    metric{4,3} = metric{3,4};
    metric{2,2} = ones(1,h,h,w);
    metric{3,3} = ones(1,h,h,w);
    metric{4,4} = ones(1,h,h,w);
end
