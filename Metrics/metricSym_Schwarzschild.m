syms x y z dx dy dz r h p dr dh dp dt rs ds2

r = sqrt(x^2+y^2+z^2);
h = atan(sqrt(x^2+y^2)/z);

dr = (x*dx+y*dy+z*dz)/(r);
dh = (x*z*dx+y*z*dy-(x^2+y^2)*dz)/(r^2*sqrt(x^2+y^2));
dp = (-y*dx+x*dy)/(x^2+y^2);

ds2 = -(1-rs/r)*dt^2 + 1/(1-rs/r)*dr^2 + r^2*dh^2+r^2*sin(h).^2*dp^2;
ds2 = combine(ds2);
% 
% simplify(subs(ds2, {dt, dx, dy, dz},{1,0,0,0}))
% simplify(subs(ds2, {dt, dx, dy, dz},{0,1,0,0}))
% simplify(subs(ds2, {dt, dx, dy, dz},{0,0,1,0}))
% simplify(subs(ds2, {dt, dx, dy, dz},{0,0,0,1}))
% combine(subs(ds2, {dy, dz},{0,0}))
% combine(subs(ds2, {dx, dz},{0,0}))
% combine(subs(ds2, {dx, dy},{0,0}))
% expand(subs(ds2, {dt, dz},{0,0}))
% expand(subs(ds2, {dt, dy},{0,0}))
% expand(subs(ds2, {dt, dx},{0,0}))

% dtdt        = rs/(x^2 + y^2 + z^2)^(1/2) - 1
% dxdx        = 1 - (rs*x^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dydy        = 1 - (rs*y^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dzdz        = 1 - (rs*z^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dtdx = dxdt = 0
% dtdy = dydt = 0
% dtdz = dzdt = 0
% dxdy = dydx = (2*rs*x*y)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))
% dxdz = dzdx = (2*rs*x*z)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))
% dydz = dzdy = (2*rs*y*z)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))
