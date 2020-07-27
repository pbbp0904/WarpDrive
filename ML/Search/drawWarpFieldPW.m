function drawWarpFieldPW(shiftMatrix)
%surf(cSM{end},'FaceColor','interp','FaceLighting','gouraud')
surf(shiftMatrix,'FaceColor',[0,0,0],'EdgeColor','interp','FaceLighting','gouraud')
view(215,30)
xlabel('Z')
ylabel('R')
zlabel('\beta')
drawnow

end
