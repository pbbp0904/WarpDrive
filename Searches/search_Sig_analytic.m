sig = linspace(0.01,5,30);
vs = 10;
R = 1;

xcord = [-15 15];
ycord = [-15 15];
zcord = [-15 15];

parfor i = 1:length(sig)
    E(i) = Analytic_Alcubierre_Energy(sig(i),vs,R,xcord,ycord,zcord);
    disp(i)
end

figure(1)
plot(sig,E)
xlabel('\sigma')
ylabel('Energy')