function drawWarpFieldPW(shiftMatrix)
%surf(cSM{end},'FaceColor','interp','FaceLighting','gouraud')
[h,w] = size(shiftMatrix);
surf(shiftMatrix,'FaceColor',[0,0,0],'EdgeColor','interp','FaceLighting','gouraud')
set(gca,'DataAspectRatio',[min(h,w) min(h,w) max(max(shiftMatrix))])
view(215,30)
xlabel('Z')
ylabel('R')
zlabel('\beta')

drawnow


end
