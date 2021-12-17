function E = Analytic_Alcubierre_Energy_backup(sig,vs,R,xcord,ycord,zcord)
% Takes the Alcubierre analytic result from his paper can returns total
% energy with c = G = 1.

fun = @(x,y,z) -1/(8*pi)*vs/4*(y.^2+z.^2)./(x.^2+y.^2+z.^2).*(-1/2*sig*tanh(sig*R)*(sech(sig*((x.^2+y.^2+z.^2).^0.5-R)).^2-sech(sig*((x.^2+y.^2+z.^2).^0.5+R)).^2)).^2;
E = integral3(fun,min(xcord),max(xcord),min(ycord),max(ycord),min(zcord),max(zcord));

end
