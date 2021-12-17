function [K] = beta2K(beta)
%beta2K calculates the expansion and contraction of the volume elements
%given a beta

s = size(beta);
d = length(s);


if d == 2
    [Kx,Ky] = gradient(beta);
    K = (Kx + Ky);
elseif d == 3
    [Kx,Ky,Kz] = gradient(beta);
    K = (Kx + Ky + Kz);
end

end

