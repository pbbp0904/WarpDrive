function [criticNetwork] = WDRL_critic1(rDim,zDim)
criticNetwork = [
    imageInputLayer([rDim zDim 1],'Normalization','none','Name','state')
    fullyConnectedLayer(32,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(32,'Name','CriticStateFC2')
    reluLayer('Name','CriticRelu2')
    fullyConnectedLayer(1, 'Name', 'CriticFC')];
end

