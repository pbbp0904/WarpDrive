% Alcubierre form: dg^{ij}/dx^k = - g^{im} g^{jn} d g_{mn}/dx^k
% Wolfram form  : g_{il} dg^{lk}/dx^m = - g^{lk} d g_{il}/dx^m

% Seems to only be vaid for 'flat' space...
AM = metricGet_Alcubierre(0,100,10,100,[50 50 50]);
%AM = metricGet_Schwarzschild(0.4,50);

gl = AM;
gu = c4Inv(gl);

% Alcubierre
eq = cell(4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for j = 1:4
        eq{i,j} = zeros(t,x,y,z);
        for k = 1:4
            eq{i,j} = eq{i,j} + gl{i,k}.*gu{k,j};
        end
    end
end

t=[];
for i = 1:4
    for j = 1:4
        t(i,j) = sum(sum(sum(sum(abs(eq{i,j})))));
    end
end

t
