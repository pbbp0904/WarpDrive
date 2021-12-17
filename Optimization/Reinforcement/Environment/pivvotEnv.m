classdef pivvotEnv < rl.env.MATLABEnvironment
    
    properties
        % Pivvot properties
        pivvotLineLength = 6;
        pivvotLineWidth = 0.5;
        pivvotDotSize = 1;
        
        % Circle properties
        circleMaxSize = 4;
        circleMinSize = 2;
        circleSpread = 12;
        Circles = [53,5,4];
        
        % Dynamic Properties
        forwardSpeed = 10;
        rotationSpeed = 10;
        
        % Other Properties
        centerLineWidth = 0.25;
        
        
        
        % Sample Time
        Ts = 0.025;
        
        % State
        State = 0;
        
        % Saved Images
        Image1 = [];
        Image2 = [];
        Image3 = [];
        Image4 = [];
        Image5 = [];
        

    end
    
    properties (Transient,Access = private)
        Visualizer = []
    end
    
    methods
        function this = pivvotEnv()
            ActionInfo = rlFiniteSetSpec([-1 0 1]);
            ActionInfo.Name = 'rotation';
            ObservationInfo(1) = rlNumericSpec([100 100 6],'LowerLimit',0,'UpperLimit',1);
            ObservationInfo(1).Name = 'pivvotImage';
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
        end
%         function varargout = plot(this)
%             if isempty(this.Visualizer) || ~isvalid(this.Visualizer)
%                 this.Visualizer = EnvVis(this);
%             else
%                 bringToFront(this.Visualizer);
%             end
%             if nargout
%                 varargout{1} = this.Visualizer;
%             end
%         end
        function [nextobs,rwd,isdone,loggedSignals] = step(this,action)
            
            loggedSignals = [];
            
            % load in params
            ts = this.Ts;
            theta = this.State;
            rotSpeed = this.rotationSpeed;
            img1 = this.Image1;
            img2 = this.Image2;
            img3 = this.Image3;
            img4 = this.Image4;
            img5 = this.Image5;
            
            % update state
            thetaPrime = theta + action*ts*rotSpeed;
            thetaPrime = mod(thetaPrime,2*pi);
            
            % set the state
            this.State = thetaPrime;
            
            % set circles
            circs = genCircles(this);
            this.Circles = circs;
            
            % generate the output image
            img = generateImage(this);
            % assign to the observations
            nextobs = {cat(3, img, img1, img2, img3, img4, img5)};
            
            % cycle images
            this.Image1 = img;
            this.Image2 = img1;
            this.Image3 = img2;
            this.Image4 = img3;
            this.Image5 = img4;

            % terminate when bob collides with circle
            isdone = checkCollision(this);
            
            % calculate reward
            if isdone
                rwd = -20;
            else
                rwd = 1;
            end
            
            

        end
        
        function obs = reset(this)
            x = 0;
            CirclesInit = [53,this.circleMaxSize+1,this.circleMaxSize];
            this.State = x;
            this.Circles = CirclesInit;
            img = generateImage(this);
            obs = {cat(3,img,img,img,img,img,img)};
            this.Image1 = img;
            this.Image2 = img;
            this.Image3 = img;
            this.Image4 = img;
            this.Image5 = img;
        end
        
        function img = generateImage(this)
            x = this.State;
            len = this.pivvotLineLength;
            psz = this.pivvotDotSize;
            circs = this.Circles;
            
            oinfo = getObservationInfo(this);
            sz = oinfo.Dimension;
            center = ceil(sz(1)/2);
            
            s = sin(x);
            c = cos(x);
            x_ = -round(len*s) + center + (-psz+1:psz-1);
            y_ = -round(len*c) + center + (-psz+1:psz-1);
            
            img = zeros(sz(1));
            img(y_,x_) = 1;
            
            for circ = circs'
                x_ = round(circ(1)) + (-circ(3)+1:circ(3)-1);
                y_ = round(circ(2)) + (-circ(3)+1:circ(3)-1);
                img(y_,x_) = 1;
            end
            h =  findobj('type','figure');
            n = length(h);
            if n > 0
                imshow(imresize(img,10,'nearest'));
                colormap(gray(2))
                drawnow();
            end
        end
        
        function Circles = genCircles(this)
            Circles = this.Circles;
            ts = this.Ts;
            speed = this.forwardSpeed;
            circMax = this.circleMaxSize;
            circMin = this.circleMinSize;
            circSpread = this.circleSpread;
            lineLength = this.pivvotLineLength;
            
            % Shifting Circles
            [h,~] = size(Circles);
            circShift = ones(h,1)*ts*speed;
            Circles(:,2) = Circles(:,2) + circShift;
            
            % Delete circles out of range
            Circles(Circles(:,2)>=100-Circles(:,3),:) = [];
            
            % Spawn new cirlces
            if min(Circles(:,2))-2*circMax>circSpread
                circSize = max(ceil(rand()*circMax),circMin);
                circX = (rand()-0.5)*2*(lineLength+circMax)+100/2;
                Circles = [Circles; [circX, circSize+1, circSize]];
            end
        end
        function collision = checkCollision(this)
            x = this.State;
            len = this.pivvotLineLength;
            psz = this.pivvotDotSize;
            circs = this.Circles;
            
            collision = false;
            
            oinfo = getObservationInfo(this);
            sz = oinfo.Dimension;
            center = ceil(sz(1)/2);
            
            s = sin(x);
            c = cos(x);
            x = -round(len*s) + center;
            y = -round(len*c) + center;
            
            if sum(sqrt((circs(:,1)-x).^2+(circs(:,2)-y).^2)<psz+circs(:,3)) > 0
                collision = true;
            end
        end
    end
end

