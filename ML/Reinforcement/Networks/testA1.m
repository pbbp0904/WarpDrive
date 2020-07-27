function [actorNetwork] = testA1(actInfo)
actorNetwork = [imageInputLayer([96 1 1],'Normalization','none','Name','state')
    convolution2dLayer([1 1],1,"Name","Final-ConvolutionLayer_1","Padding","same","WeightsInitializer","he")
    tanhLayer("Name","tanh")
    scalingLayer("Name","scaling",'Scale',actInfo.UpperLimit)];

end

