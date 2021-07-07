function [G] = christoffelS4(gu, gl)
%CHRISTOFFEL calculates the christoffel symbols for a 4x4 cell array metric
%tensor

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

G = cell(4,4,4);
parfor alpha = 1:4
    for beta = 1:4
        for gamma = 1:4
            G{alpha, beta, gamma} = zeros(t,x,y,z); 
            for delta = 1:4
                if s(gamma)>=3
                    G{alpha, beta, gamma} = G{alpha, beta, gamma} + 0.5 .* padDiff(diff(gl{delta,beta},1,gamma),gamma) .* gu{alpha,delta};
                end
                if s(beta)>=3
                    G{alpha, beta, gamma} = G{alpha, beta, gamma} + 0.5 .* padDiff(diff(gl{delta,gamma},1,beta),beta) .* gu{alpha,delta};
                end
                if s(delta)>=3
                    G{alpha, beta, gamma} = G{alpha, beta, gamma} - 0.5 .* padDiff(diff(gl{beta,gamma},1,delta),delta) .* gu{alpha,delta};
                end
            end
        end
    end
end


end

