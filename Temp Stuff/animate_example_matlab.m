figure()
load wind
[sx sy sz] = meshgrid(100,20:2:50,5);
% scale = 1/10;
u = u*scale;
v = v*scale;
w = w*scale;

mag = (u.^2+v.^2+w.^2).^0.5
u = u./mag;
v = v./mag;
w = w./mag;
verts = stream3(x,y,z,u,v,w,sx,sy,sz);
sl = streamline(verts);

view(-10.5,18)
daspect([2 2 0.125])
axis tight;
set(gca,'BoxStyle','full','Box','on')

iverts = interpstreamspeed(x,y,z,u,v,w,verts,0.01);
set(gca,'SortMethod','childorder');
streamparticles(iverts,15,...
	'Animate',1000,...
	'ParticleAlignment','on',...
	'MarkerEdgeColor','none',...
	'MarkerFaceColor','red',...
	'Marker','o');