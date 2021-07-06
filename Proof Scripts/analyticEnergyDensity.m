syms t x y z  
syms R sig vs

coords = [t, x, y, z];
rs = sqrt(x^2+y^2+z^2);

beta = @(x,y,z,R,sig,vs) -vs*(tanh(sig*(rs+R)) - tanh(sig*(rs-R)))/(2*tanh(sig*R));

g00 = @(x,y,z,R,sig,vs) beta(x,y,z,R,sig,vs).^2-1;
g00i = @(x,y,z,R,sig,vs) 1-beta(x,y,z,R,sig,vs).^2;
g01 = beta;
g10 = g01;

g11 = 1; g22 = 1; g33 = 1; g11i = -1;

g02 = 0;   g03 = 0;   g12 = 0;   g13 = 0;   g23 = 0;
g20 = g02; g30 = g03; g21 = g12; g31 = g13; g32 = g23;

gl = {g00, g01, g02, g03;  g10, g11, g12, g13;  g20, g21, g22, g23;  g30, g31, g32, g33};
gu = {g11i,g01, g02, g03;  g10, g00i,g12, g13;  g20, g21, g22, g23;  g30, g31, g32, g33};


% Ricci tensor
R = cell(4,4);

for i = 0:3
    for j = 0:3
        
        R{i+1,j+1} = 0;
        
        % First term
        for a = 0:3
            for b = 0:3
                R{i+1,j+1} = R{i+1,j+1} + 1/2 * ( diff(diff(gl{i+1,j+1},coords(a+1)),coords(b+1)) + diff(diff(gl{a+1,b+1},coords(i+1)),coords(j+1)) - diff(diff(gl{i+1,b+1},coords(j+1)),coords(a+1)) - diff(diff(gl{j+1,b+1},coords(i+1)),coords(a+1)) ) * gu{a+1,b+1};
            end
        end

        % Second term
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        R{i+1,j+1} = R{i+1,j+1} + 1/2 * ( 1/2*diff(gl{a+1,c+1},coords(i+1))*diff(gl{b+1,d+1},coords(j+1)) + diff(gl{i+1,c+1},coords(a+1))*diff(gl{j+1,d+1},coords(b+1)) - diff(gl{i+1,c+1},coords(a+1))*diff(gl{j+1,b+1},coords(d+1)) ) * gu{a+1,b+1} * gu{c+1,d+1};
                    end
                end
            end
        end

        % Third Term
        for a = 0:3
            for b = 0:3
                for c = 0:3
                    for d = 0:3
                        R{i+1,j+1} = R{i+1,j+1} - 1/4 * ( diff(gl{j+1,c+1},coords(i+1)) + diff(gl{i+1,c+1},coords(j+1)) - diff(gl{i+1,j+1},coords(c+1)) ) * ( 2*diff(gl{b+1,d+1},coords(a+1)) - diff(gl{a+1,b+1},coords(d+1)) ) * gu{a+1,b+1} * gu{c+1,d+1};
                    end
                end
            end
        end
    
    end
end


% Ricci scalar
Rs = 0;
for i = 0:3
    for j = 0:3
        Rs = Rs + gu{i+1,j+1}*R{i+1,j+1};
    end
end


% Einstein tensor
G = cell(4,4);
for i = 0:3
    for j = 0:3
        G{i+1,j+1} = R{i+1,j+1} - 1/2*Rs*gl{i+1,j+1};
    end
end


% Stress-Energy-Momentum tensor
T = cell(4,4);
for i = 0:3
    for j = 0:3
        T{i+1,j+1} = 0;
        for k = 0:3
            for l = 0:3
                T{i+1,j+1} = T{i+1,j+1} + G{k+1,l+1}*gu{k+1,i+1}*gu{l+1,j+1};
            end
        end
    end
end



