function [G] = christoffelS2(gu, gl)
%CHRISTOFFEL calculates the christoffel symbols for a 4x4 cell array metric
%tensor

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

G = cell(4,4,4);
parfor c = 1:4
    for a = 1:4
        for b = 1:4
            G{c, a, b} = zeros(t,x,y,z); 
            for d = 1:4
                if s(a)>=3
                    G{c, a, b} = G{c, a, b} + 0.5 .* padDiff(diff(gl{b,d},1,a),a) .* gu{c,d};
                end
                if s(b)>=3
                    G{c, a, b} = G{c, a, b} + 0.5 .* padDiff(diff(gl{a,d},1,b),b) .* gu{c,d};
                end
                if s(d)>=3
                    G{c, a, b} = G{c, a, b} - 0.5 .* padDiff(diff(gl{a,b},1,d),d) .* gu{c,d};
                end
            end
        end
    end
end


end
