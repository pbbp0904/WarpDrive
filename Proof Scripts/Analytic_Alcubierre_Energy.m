function E = Analytic_Alcubierre_Energy(sig,vs,R,xcord,ycord,zcord)
% Takes the Alcubierre analytic result from his paper can returns total
% energy.

G = 6.674*10^-11;
c = 2.99792*10^8;

fun = @(x,y,z) -vs^2/4*(y.^2+z.^2)./(x.^2+y.^2+z.^2).*(-1/2*sig*tanh(sig*R)*(sech(sig*((x.^2+y.^2+z.^2).^0.5-R)).^2-sech(sig*((x.^2+y.^2+z.^2).^0.5+R)).^2)).^2;
E = c^4./(8.*pi.*G).*integral3(fun,min(xcord),max(xcord),min(ycord),max(ycord),min(zcord),max(zcord));

end
