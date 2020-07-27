function [actorNetwork] = WDRL_actor1(actInfo)
lgraph = layerGraph();

%Add Layer Branches
%Add the branches of the network to the layer graph. Each branch is a linear array of layers.
tempLayers = imageInputLayer([48 96 1],"Name","state","Normalization","none");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],64,"Name","Encoder-Stage-1-Conv-1_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-1-ReLU-1_2")
    convolution2dLayer([3 3],64,"Name","Encoder-Stage-1-Conv-2_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-1-ReLU-2_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],64,"Name","Encoder-Stage-1-Conv-1_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-1-ReLU-1_1")
    convolution2dLayer([3 3],64,"Name","Encoder-Stage-1-Conv-2_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-1-ReLU-2_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    maxPooling2dLayer([2 2],"Name","Encoder-Stage-1-MaxPool_2","Stride",[2 2])
    convolution2dLayer([3 3],128,"Name","Encoder-Stage-2-Conv-1_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-2-ReLU-1_2")
    convolution2dLayer([3 3],128,"Name","Encoder-Stage-2-Conv-2_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-2-ReLU-2_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    maxPooling2dLayer([2 2],"Name","Encoder-Stage-1-MaxPool_1","Stride",[2 2])
    convolution2dLayer([3 3],128,"Name","Encoder-Stage-2-Conv-1_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-2-ReLU-1_1")
    convolution2dLayer([3 3],128,"Name","Encoder-Stage-2-Conv-2_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Encoder-Stage-2-ReLU-2_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    dropoutLayer(0.5,"Name","Encoder-Stage-2-DropOut_1")
    maxPooling2dLayer([2 2],"Name","Encoder-Stage-2-MaxPool_1","Stride",[2 2])
    convolution2dLayer([3 3],256,"Name","Bridge-Conv-1_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Bridge-ReLU-1_1")
    convolution2dLayer([3 3],256,"Name","Bridge-Conv-2_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Bridge-ReLU-2_1")
    dropoutLayer(0.5,"Name","Bridge-DropOut_1")
    transposedConv2dLayer([2 2],128,"Name","Decoder-Stage-1-UpConv_1","BiasLearnRateFactor",2,"Stride",[2 2],"WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-UpReLU_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","Decoder-Stage-1-DepthConcatenation_1")
    convolution2dLayer([3 3],128,"Name","Decoder-Stage-1-Conv-1_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-ReLU-1_1")
    convolution2dLayer([3 3],128,"Name","Decoder-Stage-1-Conv-2_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-ReLU-2_1")
    transposedConv2dLayer([2 2],64,"Name","Decoder-Stage-2-UpConv_1","BiasLearnRateFactor",2,"Stride",[2 2],"WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-UpReLU_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","Decoder-Stage-2-DepthConcatenation_1")
    convolution2dLayer([3 3],64,"Name","Decoder-Stage-2-Conv-1_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-ReLU-1_1")
    convolution2dLayer([3 3],64,"Name","Decoder-Stage-2-Conv-2_1","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-ReLU-2_1")
    convolution2dLayer([1 1],1,"Name","Final-ConvolutionLayer_1","Padding","same","WeightsInitializer","he")
    fullyConnectedLayer(4608,"Name","fc_1")
    tanhLayer("Name","tanh")
    scalingLayer("Name","scaling",'Scale',actInfo.UpperLimit)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    dropoutLayer(0.5,"Name","Encoder-Stage-2-DropOut_2")
    maxPooling2dLayer([2 2],"Name","Encoder-Stage-2-MaxPool_2","Stride",[2 2])
    convolution2dLayer([3 3],256,"Name","Bridge-Conv-1_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Bridge-ReLU-1_2")
    convolution2dLayer([3 3],256,"Name","Bridge-Conv-2_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Bridge-ReLU-2_2")
    dropoutLayer(0.5,"Name","Bridge-DropOut_2")
    transposedConv2dLayer([2 2],128,"Name","Decoder-Stage-1-UpConv_2","BiasLearnRateFactor",2,"Stride",[2 2],"WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-UpReLU_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","Decoder-Stage-1-DepthConcatenation_2")
    convolution2dLayer([3 3],128,"Name","Decoder-Stage-1-Conv-1_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-ReLU-1_2")
    convolution2dLayer([3 3],128,"Name","Decoder-Stage-1-Conv-2_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-1-ReLU-2_2")
    transposedConv2dLayer([2 2],64,"Name","Decoder-Stage-2-UpConv_2","BiasLearnRateFactor",2,"Stride",[2 2],"WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-UpReLU_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","Decoder-Stage-2-DepthConcatenation_2")
    convolution2dLayer([3 3],64,"Name","Decoder-Stage-2-Conv-1_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-ReLU-1_2")
    convolution2dLayer([3 3],64,"Name","Decoder-Stage-2-Conv-2_2","Padding","same","WeightsInitializer","he")
    reluLayer("Name","Decoder-Stage-2-ReLU-2_2")
    convolution2dLayer([1 1],1,"Name","Final-ConvolutionLayer_2","Padding","same","WeightsInitializer","he")
    fullyConnectedLayer(4608,"Name","fc_2")
    softplusLayer("Name","softplus")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = concatenationLayer(3,2,"Name","gaussPars");
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

%Connect Layer Branches
%Connect all the branches of the network to create the network graph.
lgraph = connectLayers(lgraph,"state","Encoder-Stage-1-Conv-1_2");
lgraph = connectLayers(lgraph,"state","Encoder-Stage-1-Conv-1_1");
lgraph = connectLayers(lgraph,"Encoder-Stage-1-ReLU-2_2","Encoder-Stage-1-MaxPool_2");
lgraph = connectLayers(lgraph,"Encoder-Stage-1-ReLU-2_2","Decoder-Stage-2-DepthConcatenation_2/in2");
lgraph = connectLayers(lgraph,"Encoder-Stage-1-ReLU-2_1","Encoder-Stage-1-MaxPool_1");
lgraph = connectLayers(lgraph,"Encoder-Stage-1-ReLU-2_1","Decoder-Stage-2-DepthConcatenation_1/in2");
lgraph = connectLayers(lgraph,"Encoder-Stage-2-ReLU-2_1","Encoder-Stage-2-DropOut_1");
lgraph = connectLayers(lgraph,"Encoder-Stage-2-ReLU-2_1","Decoder-Stage-1-DepthConcatenation_1/in2");
lgraph = connectLayers(lgraph,"Decoder-Stage-1-UpReLU_1","Decoder-Stage-1-DepthConcatenation_1/in1");
lgraph = connectLayers(lgraph,"Decoder-Stage-2-UpReLU_1","Decoder-Stage-2-DepthConcatenation_1/in1");
lgraph = connectLayers(lgraph,"scaling","gaussPars/in1");
lgraph = connectLayers(lgraph,"Encoder-Stage-2-ReLU-2_2","Encoder-Stage-2-DropOut_2");
lgraph = connectLayers(lgraph,"Encoder-Stage-2-ReLU-2_2","Decoder-Stage-1-DepthConcatenation_2/in2");
lgraph = connectLayers(lgraph,"Decoder-Stage-1-UpReLU_2","Decoder-Stage-1-DepthConcatenation_2/in1");
lgraph = connectLayers(lgraph,"Decoder-Stage-2-UpReLU_2","Decoder-Stage-2-DepthConcatenation_2/in1");
lgraph = connectLayers(lgraph,"softplus","gaussPars/in2");

actorNetwork = lgraph;
end

