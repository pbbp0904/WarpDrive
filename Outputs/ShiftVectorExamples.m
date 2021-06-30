

s = 1000;
A = zeros(s);
for i = 1:s
for j = 1:s
if sqrt((i-(s-1)/2)^2 + (j-(s-1)/2)^2) < s/5
A(i,j) = 10;
end
end
end

figure()
surf(A,'FaceColor','interp','EdgeColor','none','FaceLighting','gouraud')
view(-45,30)
xlabel('Z')
ylabel('\rho')
zlabel('\beta')
colormap turbo





s = 1000;
sig = 0.02;
R = s/5;
A = zeros(s);
for i = 1:s
for j = 1:s
r = sqrt((i-(s-1)/2)^2 + (j-(s-1)/2)^2);
A(i,j) = 5*(tanh(sig*(r+R))-tanh(sig*(r-R)))/tanh(sig*R);
end
end

figure()
surf(A,'FaceColor','interp','EdgeColor','none','FaceLighting','gouraud')
view(-45,30)
xlabel('Z')
ylabel('\rho')
zlabel('\beta')
colormap turbo