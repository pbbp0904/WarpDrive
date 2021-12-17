
%%%%% TODO: use flatten in output because MATLAB only supports single channel outputs


%%%%% ENVIRONMENT %%%%%

% Adds Environment\ to the path
addpath Environment\

% Create a predefined environment interface.

% Needs to test 16x32 with R=4
rDim = 10;
zDim = 20;

goalHeight = 10;
innerR = 3;

[shiftMatrixStart, mask] = makeInitialShiftMatrix(rDim,zDim,innerR,goalHeight);
env = warpDriveEnv(shiftMatrixStart, mask, rDim, zDim, innerR, goalHeight);

% Change Environment Options


% Obtain the observation and action information from the environment interface.
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

% Fix the random generator seed for reproducibility.
rng(0)

% Removes Environment\ from the path
%rmpath Environment\



%%%%% ACTOR/CRITIC %%%%%

% Adds Networks\ to the path
addpath Networks\

% An AC agent decides which action to take, given observations, using an actor representation. 
% To create the actor, create a deep neural network with one input (the observation) and one output (the action).
% The output size of the actor network is 4608 by 1 since the agent can
% apply changes to all values in space and MATLAB's reinforcment learning
% toolbox can only handle single channel outputs
actorNetwork = WDRL_actor3(rDim, zDim);
%actorNetwork = testA1(actInfo);
actorOpts = rlRepresentationOptions('LearnRate',2e-1,'UseDevice',"gpu",'Optimizer','adam');
%actorOpts.OptimizerParameters.Epsilon = 1e-2;
actor = rlStochasticActorRepresentation(actorNetwork,obsInfo,actInfo,...
    'Observation',{'state'},actorOpts);


% An AC agent approximates the long-term reward, given observations and actions, using a critic value function representation. 
% To create the critic, first create a deep neural network with one input (the observation) and one output (the state value). 
% The input size of the critic network is [48 96 1] since the environment is 48 by 96. 
% For more information on creating a deep neural network value function representation, see Create Policy and Value Function Representations.
criticNetwork = WDRL_critic1(rDim, zDim);
%criticNetwork = testC1();
criticOpts = rlRepresentationOptions('LearnRate',5e-4,'UseDevice',"gpu",'Optimizer','adam');
critic = rlValueRepresentation(criticNetwork,obsInfo,'Observation',{'state'},criticOpts);

% Removes Networks\ from the path
rmpath Networks\



%%%%% AGENT %%%%%
% To create the AC agent, first specify the AC agent options using rlACAgentOptions.
agentOpts = rlACAgentOptions(...
    'NumStepsToLookAhead',1,...
    'EntropyLossWeight',0.01,...
    'DiscountFactor',1);

% Then create the agent using the specified actor representation and agent options. 
% For more information, see rlACAgent.
agent = rlACAgent(actor,critic,agentOpts);


%%%%% TRAINING %%%%%
% To train the agent, first specify the training options. For this example, use the following options.
% Run each training for at most 1000 episodes, with each episode lasting at most 500 time steps.
% Display the training progress in the Episode Manager dialog box (set the Plots option) and disable the command line display (set the Verbose option).
% Stop training when the agent receives an average cumulative reward greater than 500 over 10 consecutive episodes. 
% At this point, the agent can balance the pendulum in the upright position.
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',100000,...
    'MaxStepsPerEpisode', 1,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',10000000000,...
    'ScoreAveragingWindowLength',100,...
    'SaveAgentDirectory', 'C:\Users\chris\Documents\MATLAB\WarpDrive\ML\Reinforcement\Checkpoints\',...
    'SaveAgentCriteria', 'EpisodeReward',...
    'SaveAgentValue', 10000000);


% The warp field can be visualized with plot(env) during training or simulation.
trainingVis = false;
if trainingVis
    plot(env)
end

% To train the agent using parallel computing, specify the following training options.
% Set the UseParallel option to True.
% Train the agent in parallel asynchronously by setting the ParallelizationOptions.Mode option to "async".
% After every so many steps, each worker computes gradients from experiences and send them to the host.
% The AC agent requires workers to send "gradients" to the host.
% The AC agent requires 'StepsUntilDataIsSent' to be equal to agentOptions.NumStepsToLookAhead.
% For more information, see rlTrainingOptions.
trainOpts.UseParallel = true;
trainOpts.ParallelizationOptions.Mode = "async";
trainOpts.ParallelizationOptions.DataToSendFromWorkers = "gradients";
trainOpts.ParallelizationOptions.StepsUntilDataIsSent = agentOpts.NumStepsToLookAhead;

% Train the agent using the train function. 
% Training the agent is a computationally intensive process that takes several minutes to complete. 
% To save time while running this example, load a pretrained agent by setting doTraining to false. 
% To train the agent yourself, set doTraining to true. 
% Due to randomness in the asynchronous parallel training, you can expect different training results.
doTraining = true;

if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load the pretrained agent for the example.
    %load(,'agent');
end

% The warp field can be visualized with plot(env) during training or simulation.
simVis = true;
if simVis
    plot(env)
end

% To validate the performance of the trained agent, simulate it within the environment. 
% For more information on agent simulation, see rlSimulationOptions and sim.
disp("Simulating Experience...")
simOptions = rlSimulationOptions('MaxSteps',1);
experience = sim(env,agent,simOptions);

% View the total reward
totalReward = sum(experience.Reward)
surf(env.loggedShiftMatrix,'FaceColor',[0,0,0],'EdgeColor','interp','FaceLighting','gouraud')
view(215,30)
drawnow