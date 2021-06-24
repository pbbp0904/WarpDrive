syms g_00 g_01 g_11 g_22 g_33
g_02 = 0; g_20 = 0; g_03 = 0; g_30 = 0; g_12 = 0; g_21 = 0; g_13 = 0; g_31 = 0; g_23 = 0; g_32 = 0;
g_11 = 0; g_22 = 0; g_33 = 0; % Only valid when looking at R_ij
%syms beta
%g_00 = -(1-beta^2); g_01 = -beta; g_10 = -beta; g_11 = 1; g_22 = 1; g_33 = 1;

syms  g00 g01 g11 g22 g33
g02 = 0; g20 = 0; g03 = 0; g30 = 0; g12 = 0; g21 = 0; g13 = 0; g31 = 0; g23 = 0; g32 = 0;
%g00 = -1; g22 = 1; g33 = 1;
%g00 = -1; g01 = -beta; g10 = -beta; g11 = 1-beta^2; g22 = 1; g33 = 1;

syms d_0 d_1 d_2 d_3
d_0 = 0; % Only valid when looking at R_ij

gl = [g_00, g_01, g_02, g_03;  g_01, g_11, g_12, g_13;  g_20, g_21, g_22, g_23;  g_30, g_31, g_32, g_33];
gu = [g00, g01, g02, g03;  g01, g11, g12, g13;  g20, g21, g22, g23;  g30, g31, g32, g33];
dr = [d_0, d_1, d_2, d_3];

R = cell(4,4);

for i = 0:3
    for j = 0:3
        
        R{i+1,j+1} = 0;
        
        % First term
        for a = 0:3
            for b = 0:3
                R{i+1,j+1} = R{i+1,j+1} + 1/2 * ( dr(a+1)*dr(b+1)*gl(i+1,j+1) + dr(i+1)*dr(j+1)*gl(a+1,b+1) - dr(i+1)*dr(a+1)*gl(i+1,b+1) - dr(i+1)*dr(a+1)*gl(j+1,b+1) ) * gu(a+1,b+1);
            end
        end

        % Second term
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        R{i+1,j+1} = R{i+1,j+1} + 1/2 * ( 1/2*dr(i+1)*dr(j+1)*gl(i+1,c+1)*gl(b+1,d+1) + dr(a+1)*dr(b+1)*gl(i+1,c+1)*gl(j+1,d+1) - dr(a+1)*dr(d+1)*gl(i+1,c+1)*gl(j+1,b+1) ) * gu(a+1,b+1) * gu(c+1,d+1);
                    end
                end
            end
        end

        % Third Term
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        R{i+1,j+1} = R{i+1,j+1} - 1/4 * ( dr(i+1)*gl(j+1,c+1) + dr(j+1)*gl(i+1,c+1) - dr(c+1)*gl(i+1,j+1) ) * ( 2*dr(a+1)*gl(b+1,d+1) - dr(d+1)*gl(a+1,b+1) ) * gu(a+1,b+1) * gu(c+1,d+1);
                    end
                end
            end
        end
    
    end
end


% Ricci scalar calculation
Rs = gu(0+1,0+1)*R{0+1,0+1} + gu(1+1,1+1)*R{1+1,1+1} + gu(2+1,2+1)*R{2+1,2+1} + gu(3+1,3+1)*R{3+1,3+1} + gu(0+1,1+1)*R{0+1,1+1} + gu(1+1,0+1)*R{1+1,0+1};

% Einstein tensor
G = cell(4,4);

for i = 0:3
    for j = 0:3
        G{i+1,j+1} = R{i+1,j+1} - 1/2*Rs*gl(i+1,j+1);
    end
end




