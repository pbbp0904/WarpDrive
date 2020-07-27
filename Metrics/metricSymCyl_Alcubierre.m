clear
clc

syms beta x y z vs zs sigma rs R dx dy dz r p dr dp dt ds2

x = r*cos(p);
y = r*sin(p);
z = z; %#ok<ASGSL>

dx = cos(p)*dr - r*sin(p)*dp;
dy = sin(p)*dr + r*cos(p)*dp;
dz = dz; %#ok<ASGSL>

rs = (x^2+y^2+(z-zs)^2)^(1/2);

f = (tanh(sigma*(rs+R))-tanh(sigma*(rs-R)))/(2*tanh(sigma*R));
beta = -vs*f;
beta2 = beta*beta;

ds2 = -(1-beta^2)*dt^2 + 2*beta*dz*dt + dx^2 + dy^2 + dz^2;
%ds2 = combine(ds2);

% 
% simplify(subs(ds2, {dt, dz, dr, dp},{1,0,0,0}))
% simplify(subs(ds2, {dt, dz, dr, dp},{0,1,0,0}))
% simplify(subs(ds2, {dt, dz, dr, dp},{0,0,1,0}))
% simplify(subs(ds2, {dt, dz, dr, dp},{0,0,0,1}))
% combine(subs(ds2, {dr, dp},{0,0}))
% combine(subs(ds2, {dz, dp},{0,0}))
% combine(subs(ds2, {dz, dr},{0,0}))
% expand(subs(ds2, {dt, dp},{0,0}))
% expand(subs(ds2, {dt, dr},{0,0}))
% expand(subs(ds2, {dt, dz},{0,0}))



% dtdt        = (vs^2*sinh(2*R*sigma)^2)/(tanh(R*sigma)^2*(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))^2) - 1
% dzdz        = 1
% drdr        = 1
% dpdp        = r^2
% dtdz = dzdt = -(2*vs*(cosh(2*R*sigma) + 1))/(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))
% dtdr = drdt = 0
% dtdp = dpdt = 0
% dzdr = drdz = 0
% dzdp = dpdz = 0
% drdp = dpdr = 0
