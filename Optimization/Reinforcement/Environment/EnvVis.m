classdef EnvVis < rl.env.viz.AbstractFigureVisualizer

    methods
        function this = EnvVis(env)
            this = this@rl.env.viz.AbstractFigureVisualizer(env);
        end
    end
    methods (Access = protected)
        function f = buildFigure(this)
            
            f = figure(...
                'Toolbar','none',...
                'Visible','on',...
                'HandleVisibility','off', ...
                'NumberTitle','off',...
                'Name','Pivvot Visualizer',...
                'MenuBar','none',...
                'CloseRequestFcn',@(~,~)delete(this));
            
            env = this.Environment;
            h1 = subplot(1,1,1:1,'Parent',f);
            h1.Tag = 'h1';
            
            %cla(h1);
            %pbaspect(h1,[1 1 1])
            %set(h1,'XLim',[0,100]);
            %set(h1,'YLim',[0,100]);
            
            %set(h1,'xticklabel',[]);
            %set(h1,'yticklabel',[]);
            
            %grid(h1,'on');
        end
        function updatePlot(this)
            env = this.Environment;
            f = this.Figure;
            h1 = findobj(f,'Tag','h1');
            img  = findobj(f ,'Tag','img' );
            
            if isempty(img)
                img = imshow(generateImage(env),'Parent',h1);
                img.Tag = 'img';
            else
                img.CData = generateImage(env);
            end
            drawnow();
        end
    end
end