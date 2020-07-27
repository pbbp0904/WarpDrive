function [enDen] = einE2(G,gu)
%EINT2 Calculates the covarient energy density tensor from christoffel symbols
%and the metric tensor

[t,x,y,z] = size(gu{1,1});
skipTdiff = 0;
if t == 1
   skipTdiff = 1; 
end

for alpha = 1:4
    for beta = 1:4
        enDen{alpha,beta} = 0;
        for gamma = 1:4
            for zeta = 1:4
                a = 1./(8.*pi).*gu{alpha,gamma}.*gu{beta,zeta}-0.5.*gu{alpha,beta}.*gu{gamma,zeta};
                for sigma = 1:4
                    for epsilon = 1:4
                        if ~(skipTdiff && epsilon == 1)
                            [gt, gx, gy, gz] = gradient(G{epsilon,gamma,zeta});
                            g = {gt, gx, gy, gz};
                            enDen{alpha,beta} = enDen{alpha,beta} + a.*g{epsilon};
                        end
                        if ~(skipTdiff && zeta == 1)
                            [gt, gx, gy, gz] = gradient(G{epsilon,gamma,epsilon});
                            g = {gt, gx, gy, gz};
                            enDen{alpha,beta} = enDen{alpha,beta} - a.*g{zeta};
                        end
                        enDen{alpha,beta} = enDen{alpha,beta} + a.*G{epsilon,epsilon,sigma}.*G{sigma,gamma,zeta};
                        enDen{alpha,beta} = enDen{alpha,beta} - a.*G{epsilon,zeta,sigma}.*G{sigma,epsilon,gamma};
                    end
                end
            end
        end
    end
end

end

