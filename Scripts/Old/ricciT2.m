function [R_munu] = ricciT2(gu,gl)
%RICCI calculates the Ricci tensor for a given metric tensor and its
%inverse

% Form from (https://en.wikipedia.org/wiki/Ricci_curvature) introduction section
% Same as T4 and T6, Very slow
[t,x,y,z] = size(gl{1,1});

% Ricci tensor
R_munu = cell(4,4);

for i = 0:3
    for j = 0:3
        
        R_munu{i+1,j+1} = 0;
        
        % First term
        term1 = zeros(t,x,y,z);
        for a = 0:3
            for b = 0:3
                if t > 2 || (a~=0 && b~=0)
                    term1 = term1 + 1/2 .* ( padDiff(diff(padDiff(diff(gl{i+1,j+1},1,(a+1)),(a+1)),1,(b+1)),(b+1)) ) .* gu{a+1,b+1};
                end
                if t > 2 || (i~=0 && j~=0)
                    term1 = term1 + 1/2 .* ( padDiff(diff(padDiff(diff(gl{a+1,b+1},1,(i+1)),(i+1)),1,(j+1)),(j+1)) ) .* gu{a+1,b+1};
                end
                if t > 2 || (j~=0 && a~=0)
                    term1 = term1 + 1/2 .* (-padDiff(diff(padDiff(diff(gl{i+1,b+1},1,(j+1)),(j+1)),1,(a+1)),(a+1)) ) .* gu{a+1,b+1};
                end
                if t > 2 || (i~=0 && a~=0)
                    term1 = term1 + 1/2 .* (-padDiff(diff(padDiff(diff(gl{j+1,b+1},1,(i+1)),(i+1)),1,(a+1)),(a+1)) ) .* gu{a+1,b+1};
                end
            end
        end
        
        R_munu{i+1,j+1} = R_munu{i+1,j+1} + term1;

        % Second term
        term2 = zeros(t,x,y,z);
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        if t > 2 || (i~=0 && j~=0)
                            term2 = term2 + 1/2 .* ( 1/2.*padDiff(diff(gl{a+1,c+1},1,(i+1)),(i+1)).*padDiff(diff(gl{b+1,d+1},1,(j+1)),(j+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (a~=0 && b~=0)
                            term2 = term2 + 1/2 .* (      padDiff(diff(gl{i+1,c+1},1,(a+1)),(a+1)).*padDiff(diff(gl{j+1,d+1},1,(b+1)),(b+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (a~=0 && d~=0)
                            term2 = term2 + 1/2 .* (    - padDiff(diff(gl{i+1,c+1},1,(a+1)),(a+1)).*padDiff(diff(gl{j+1,b+1},1,(d+1)),(d+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                    end
                end
            end
        end
        
        R_munu{i+1,j+1} = R_munu{i+1,j+1} + term2;

        % Third Term
        term3 = zeros(t,x,y,z);
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        if t > 2 || (i~=0 && a~=0)
                            term3 = term3 - 1/4 .* ( padDiff(diff(gl{j+1,c+1},1,(i+1)),(i+1)) ) .* ( 2.*padDiff(diff(gl{b+1,d+1},1,(a+1)),(a+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (j~=0 && a~=0)
                            term3 = term3 - 1/4 .* ( padDiff(diff(gl{i+1,c+1},1,(j+1)),(j+1)) ) .* ( 2.*padDiff(diff(gl{b+1,d+1},1,(a+1)),(a+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (c~=0 && a~=0)
                            term3 = term3 - 1/4 .* (-padDiff(diff(gl{i+1,j+1},1,(c+1)),(c+1)) ) .* ( 2.*padDiff(diff(gl{b+1,d+1},1,(a+1)),(a+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (i~=0 && d~=0)
                            term3 = term3 - 1/4 .* ( padDiff(diff(gl{j+1,c+1},1,(i+1)),(i+1)) ) .* (  - padDiff(diff(gl{a+1,b+1},1,(d+1)),(d+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (j~=0 && d~=0)
                            term3 = term3 - 1/4 .* ( padDiff(diff(gl{i+1,c+1},1,(j+1)),(j+1)) ) .* (  - padDiff(diff(gl{a+1,b+1},1,(d+1)),(d+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                        if t > 2 || (c~=0 && d~=0)
                            term3 = term3 - 1/4 .* (-padDiff(diff(gl{i+1,j+1},1,(c+1)),(c+1)) ) .* (  - padDiff(diff(gl{a+1,b+1},1,(d+1)),(d+1)) ) .* gu{a+1,b+1} .* gu{c+1,d+1};
                        end
                    end
                end
            end
        end
        
        R_munu{i+1,j+1} = R_munu{i+1,j+1} + term3;
        
    end
end



end
