function [actorNetwork] = WDRL_actor3(rDim, zDim)
lgraph = layerGraph();

%Add Layer Branches
%Add the branches of the network to the layer graph. Each branch is a linear array of layers.
tempLayers = imageInputLayer([rDim zDim 1],"Name","state","Normalization","none");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    fullyConnectedLayer(64,'Name','fc_1_1','WeightsInitializer','zeros')
    reluLayer('Name','ReLU_1_2')
    fullyConnectedLayer(rDim*zDim,"Name","fc_1_2",'WeightsInitializer','zeros')
    tanhLayer("Name","tanh")
    %scalingLayer("Name","scaling",'Scale',actInfo.UpperLimit)
    ];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    %fullyConnectedLayer(64,'Name','fc_2_1')
    %reluLayer('Name','ReLU_2_2')
    fullyConnectedLayer(rDim*zDim,"Name","fc_2_2",'WeightsInitializer','zeros')
    softplusLayer("Name","softplus")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = concatenationLayer(3,2,"Name","gaussPars");
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

%Connect Layer Branches
%Connect all the branches of the network to create the network graph.
lgraph = connectLayers(lgraph,"state","fc_1_1");
lgraph = connectLayers(lgraph,"state","fc_2_2");
lgraph = connectLayers(lgraph,"tanh","gaussPars/in1");
lgraph = connectLayers(lgraph,"softplus","gaussPars/in2");

actorNetwork = lgraph;
end

