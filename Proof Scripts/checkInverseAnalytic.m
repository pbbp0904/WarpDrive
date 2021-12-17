syms x y z R sig vs
rs = sqrt(x^2+y^2+z^2);
beta = -vs*(tanh(sig*(rs+R)) - tanh(sig*(rs-R)))/(2*tanh(sig*R));
g00 =  beta.^2-1;
g00i =  1-beta.^2;
g01 = beta;
g10 = g01;
g11 = 1; g22 = 1; g33 = 1; g11i = -1;
g02 = 0;   g03 = 0;   g12 = 0;   g13 = 0;   g23 = 0;
g20 = g02; g30 = g03; g21 = g12; g31 = g13; g32 = g23;
gl = {g00, g01, g02, g03;  g10, g11, g12, g13;  g20, g21, g22, g23;  g30, g31, g32, g33};
gu = {g11i,g01, g02, g03;  g10, g00i,g12, g13;  g20, g21, g22, g23;  g30, g31, g32, g33};
A = gl;
Ai = gu;
a = sym(zeros(4,4,3));
b = sym(zeros(4,4,3));

coords = [x, y, z];
for i = 1:4
    for k = 1:4
        for m = 1:3
            for l = 1:4
                a(i,k,m) = a(i,k,m) + A{i,l}*diff(Ai{l,k},coords(m));
                b(i,k,m) = b(i,k,m) - Ai{l,k}*diff(A{i,l},coords(m));
            end
        end
    end
end
simplify(a,100);
simplify(b,100);
isequal(a,b)




% dg^{ij}/dx^k = - g^{im} g^{jn} d g_{mn}/dx^k
a = sym(zeros(4,4,3));
b = sym(zeros(4,4,3));
for i = 1:4
    for j = 1:4
        for k = 1:3
            a(i,j,k) = a(i,j,k) + diff(Ai{i,j},coords(k));
            for m = 1:4
                for n = 1:4
                    b(i,j,k) = b(i,j,k) - Ai{i,m}*Ai{j,n}*diff(A{m,n},coords(k));
                end
            end
        end
    end
end
c = simplify(a-b,100);
isequal(c,sym(zeros(4,4,3)))


