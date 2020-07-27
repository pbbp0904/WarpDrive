function [enDen] = einE(E,gu)
%EIND Calculates the Energy Tensor from the Einstien Tensor
enDen_ = cell(4,4);
for mu = 1:4
    for nu = 1:4
        enDen_{mu,nu} = 1./(8.*pi).*E{mu,nu};
    end
end

enDen = cell(4,4);
for mu = 1:4
    for nu = 1:4
        enDen{mu,nu} = 0;
        for alpha = 1:4
            for beta = 1:4
                enDen{mu,nu} = enDen{mu,nu} + enDen_{alpha,beta}.*gu{alpha,mu}.*gu{beta,nu};
            end
        end
    end
end

end

