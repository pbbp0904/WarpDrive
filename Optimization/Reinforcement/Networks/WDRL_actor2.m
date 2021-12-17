function [actorNetwork] = WDRL_actor2(actInfo)
lgraph = layerGraph();

%Add Layer Branches
%Add the branches of the network to the layer graph. Each branch is a linear array of layers.
tempLayers = imageInputLayer([10 20 1],"Name","state","Normalization","none");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","Conv_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","ReLU_1_1")
    fullyConnectedLayer(64,'Name','fc_1_1')
    reluLayer('Name','ReLU_1_2')
    fullyConnectedLayer(200,"Name","fc_1_2")
    tanhLayer("Name","tanh")
    scalingLayer("Name","scaling",'Scale',actInfo.UpperLimit)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","Conv_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","ReLU_2_1")
    fullyConnectedLayer(64,'Name','fc_2_1')
    reluLayer('Name','ReLU_2_2')
    fullyConnectedLayer(200,"Name","fc_2_2")
    softplusLayer("Name","softplus")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = concatenationLayer(3,2,"Name","gaussPars");
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

%Connect Layer Branches
%Connect all the branches of the network to create the network graph.
lgraph = connectLayers(lgraph,"state","Conv_1");
lgraph = connectLayers(lgraph,"state","Conv_2");
lgraph = connectLayers(lgraph,"scaling","gaussPars/in1");
lgraph = connectLayers(lgraph,"softplus","gaussPars/in2");

actorNetwork = lgraph;
end

