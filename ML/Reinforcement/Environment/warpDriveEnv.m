classdef warpDriveEnv < rl.env.MATLABEnvironment
    
    properties
        % Warp Field properties
        
        % Fitness properties
        previousFitness;
        spaceShipRadius;
        
        % Training properties
        adjustmentMaximum;
        changeMask;
        
        % Warp Field States
        startingShiftMatrix;
        shiftMatrix;
        
        loggedShiftMatrix;
        
    end
    
    properties (Transient,Access = private)
        Visualizer = []
    end
    
    methods
        
        
        %%%% CONSTRUCTOR
        function this = warpDriveEnv(shiftMatrixStart, mask, rDim, zDim, innerR, goalHeight)
            ActionInfo = rlNumericSpec([rDim*zDim 1 1],...
                'LowerLimit',0,'UpperLimit',1);
            ActionInfo.Name = 'adjustmentMatrix';
            ObservationInfo(1) = rlNumericSpec([rDim zDim 1],'LowerLimit',0,'UpperLimit',100);
            ObservationInfo(1).Name = 'shiftMatrix';
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
            
            this.previousFitness = 0;
            this.spaceShipRadius = innerR;
            
            this.adjustmentMaximum = goalHeight;
            this.changeMask = mask;
            
            this.startingShiftMatrix = shiftMatrixStart;
            this.shiftMatrix = shiftMatrixStart;
            
        end
        
        
        %%%% PLOTTING
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

        function varargout = plot(this)
            surf(this.loggedShiftMatrix,'FaceColor',[0,0,0],'EdgeColor','interp','FaceLighting','gouraud')
            view(215,30)
            drawnow
            envUpdatedCallback(this)
        end


        %%%% STEPPING FUNCTION
        function [nextobs,rwd,isdone,loggedSignals] = step(this,action)
            
            % Load Variables
            sSR = this.spaceShipRadius;
            pSM = this.shiftMatrix;
            adM = this.adjustmentMaximum;
            pF = this.previousFitness;
            mask = this.changeMask;
            
            [h,w] = size(pSM);
            
            % Update State
            cSM = pSM + mask.*(reshape(action,h,w)./max(abs(action)).*adM);
            cM = makeMetric(this, cSM);
            cED = calcEnDen(this, cM);
            cF = calculateFitness(this, cSM, cED,sSR);
            
            % Set the State
            %this.shiftMatrix = cSM;
            this.loggedShiftMatrix = cSM;
            %this.previousFitness = cF;
            
            % Generate Observation
            % Done in Update State

            % Assign to the Next Observations
            nextobs = pSM;
            
            % Decide Termination
            isdone = 0;
            
            % Calculate Reward
            %rwd = 10*(cF-pF);
            rwd = 10^8*cF;
            
            % Log signals
            loggedSignals = [cSM];
            %surf(cSM,'FaceColor',[0,0,0],'EdgeColor','interp','FaceLighting','gouraud')
            %view(215,30)
            %drawnow
            %notifyEnvUpdated(this);
            
        end
        
        
        %%%% RESET FUNCTION
        function obs = reset(this)
            sSM = this.startingShiftMatrix;
            obs = {sSM};
            
            %Set the State
            this.shiftMatrix = sSM;
            this.previousFitness = 0;
        end
        
        
        %%%% HELPER FUNCTIONS
        function metric = makeMetric(this, shiftMatrix)
            
            s = length(shiftMatrix);
            
            sM = [];
            sM(1,1,:,:) = shiftMatrix;
            
            metric = {};
            metric{1,1} = cyl2rec(sM.*sM-1,[s/2, s/2],-1);
            metric{1,2} = zeros(1,s,s,s);
            metric{2,1} = metric{1,2};
            metric{1,3} = zeros(1,s,s,s);
            metric{3,1} = metric{1,3};
            metric{1,4} = cyl2rec(2.*sM,[s/2, s/2],0);
            metric{4,1} = metric{1,4};
            metric{2,3} = zeros(1,s,s,s);
            metric{3,2} = metric{2,3};
            metric{2,4} = zeros(1,s,s,s);
            metric{4,2} = metric{2,4};
            metric{3,4} = zeros(1,s,s,s);
            metric{4,3} = metric{3,4};
            metric{2,2} = ones(1,s,s,s);
            metric{3,3} = ones(1,s,s,s);
            metric{4,4} = ones(1,s,s,s);
        end
        
        function enDen = calcEnDen(this, metric)
            enDen = met2den(metric);
        end
        
        
        
        
        
        
        function fitness = calculateFitness(this, currentShiftMatrix, currentEnDen, keepoutRadius)
            % Height and Smoothness of inner area
            %[metricHeight, metricSmoothness] = calHeightSmooth(this,currentShiftMatrix,keepoutRadius);
            % Total Energy and Max Energy Density
            [metricEnergy, metricMaxDen] = calTotEnergyMaxDen(this,currentEnDen);
            
            fitness = 1/(metricEnergy*metricMaxDen);
            %fitness = metricHeight*metricSmoothness/(metricEnergy*metricMaxDen);
        end
        
        
        function [metricHeight, smoothness] = calHeightSmooth(this,inputShiftMatrix,radius)
            inputMetric = inputShiftMatrix;
            [r,z] = size(inputMetric);

            points = [];

            for i = 1:r
                for j = 1:z
                    if sqrt(i^2+(j-z/2)^2) <= radius
                        points = [points inputMetric(i,j)];
                    end
                end
            end
            
            metricHeight = mean(points);

            roughness = sum(abs(points-mean(points)));
            smoothness = 1/roughness;
        end
        
        
        function [metricEnergy, metricMaxDen] = calTotEnergyMaxDen(this,energyDensity)
            energyDensity = energyDensity{1,1};
            metricEnergy = sum(sum(sum(abs(energyDensity))));
            metricMaxDen = max(max(max(abs(energyDensity))));
        end
        
    end
    
    methods (Access = protected)
        % (optional) update visualization everytime the environment is updated 
        % (notifyEnvUpdated is called)
        function envUpdatedCallback(this)
        end
    end
end

