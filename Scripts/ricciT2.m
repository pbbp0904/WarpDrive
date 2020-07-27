function [R_munu] = ricciT2(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

[t,x,y,z] = size(gu{1,1});
skipTdiff = 0;
if t == 1
   skipTdiff = 1; 
end


for mu = 1:4
    for nu = 1:4
        R_munu{mu,nu} = 0; %#ok<AGROW>
        for rho = 1:4
            
            if ~(skipTdiff && rho == 1)
                [gt, gx, gy, gz] = gradient(G{rho,mu,nu});
                g = {gt, gx, gy, gz};
                R_munu{mu,nu} = R_munu{mu,nu} + g{rho};
            end
            if ~(skipTdiff && nu == 1)
                [gt, gx, gy, gz] = gradient(G{rho,mu,rho});
                g = {gt, gx, gy, gz};
                R_munu{mu,nu} = R_munu{mu,nu} - g{nu};
            end
            
            for lambda = 1:4
                R_munu{mu,nu} = R_munu{mu,nu} + G{rho,lambda,rho}.*G{lambda,mu,nu} - G{rho,lambda,nu}.*G{lambda,mu,rho};
            end
        end
    end
end

end

