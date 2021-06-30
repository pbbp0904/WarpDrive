syms x y z R rs sig vs
load('T')

enDenSym = T{1,1};

%enDenSym = x^2*((4*sig*tanh(rs*sig)*vs^2*(tanh(rs*sig)^2 - 1)^2*(tanh(R*sig)^2 - 1))/(rs^3*(tanh(rs*sig)^2*tanh(R*sig)^2 - 1)^3)) + (y^2 + z^2)*((2*sig*tanh(rs*sig)*vs^2*(tanh(rs*sig)^2 - 1)^2*(tanh(R*sig)^2 - 1))/(rs^3*(tanh(rs*sig)^2*tanh(R*sig)^2 - 1)^3) * (1 - (sig*rs/(2*tanh(rs*sig))*(5*tanh(rs*sig)*(tanh(rs*sig)^2 - 1)^2*(tanh(R*sig)^2 - 1)*vs^2 - (tanh(rs*sig)^2*tanh(R*sig)^2 - 1)^2*(tanh(rs*sig)^2*((2*tanh(rs*sig)^2 - 5)*tanh(R*sig)^2 + 5) - 2))/(tanh(rs*sig)^2*tanh(R*sig)^2 - 1)^3)));
%enDenSym = -1/(8*pi)*vs/4*(y.^2+z.^2)./(x.^2+y.^2+z.^2).*(-1/2*sig*tanh(sig*R)*(sech(sig*((x.^2+y.^2+z.^2).^0.5-R)).^2-sech(sig*((x.^2+y.^2+z.^2).^0.5+R)).^2)).^2;
gridSize = 41;

xx = linspace(-100,100,gridSize);
yy = linspace(-100,100,gridSize);
zz = linspace(-100,100,gridSize);

R = 50;
sig = 0.1;
vs = 10;
enDen = [];
enDenSym = subs(enDenSym);

for i = 1:length(xx)
    x = xx(i);
    enDenSymx = subs(enDenSym);
    for j = 1:length(yy)
        y = yy(j);
        enDenSymy = subs(enDenSymx);
        for k = 1:length(zz)
            z = zz(k);
            
            rs = sqrt(x^2 + y^2 + z^2);
            if ~(x==0 && y==0 && z==0)
                enDen(i,j,k) = subs(enDenSymy);
            else
                enDen(i,j,k) = 0;
            end
            
        end
        fprintf('Done with: %i,%i\n',xx(i), yy(j));
        clear z
        clear rs
    end
    clear y
end

% Change to Z direction
G = 6.674*10^-11;
c = 2.99792*10^8;
enDen = c^4./(8.*pi.*G).*permute(enDen,[3,2,1]);




