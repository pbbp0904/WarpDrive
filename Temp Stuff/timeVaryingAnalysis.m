%%

for i = 1:11
    disp(i)
    isosurface(squeeze(enDenM{1,1}(i,:,:,:)),-10^39)
    pause
end


%%

for i = 1:4
    for j = i:4
        sS = sum(abs(squeeze(enDenS{i,j}(1,:,:,:))),"all");
        sM = sum(abs(squeeze(enDenM{i,j}(round((end+1)/2),:,:,:))),"all");
        fprintf("%i, %i, %i, %i, %i, %2.3f%%\n",i,j,sS,sM,sS-sM,sum(abs(squeeze(enDenS{i,j}(1,:,:,:))-squeeze(enDenM{i,j}(round((end+1)/2),:,:,:))),'all')/sS*100)
    end
end


%%

for i = 1:4
    for j = i:4
        disp(i)
        disp(j) 
        sliceomatic(squeeze(enDenS{i,j}(1,:,:,:)))
        sliceomatic(squeeze(enDenM{i,j}(round((end+1)/2),:,:,:)))
        pause
    end
end


%% Diagonalization
EpS(1,1,1,1,:,:) = enDenS;
ES = cell2mat(EpS);

for t = 1:1
    for x = 1:99
        for y = 1:99
            for z = 1:99
                [~,D] = eig(squeeze(ES(t,x,y,z,:,:)),'matrix');
                [d,ind] = sort(diag(D));
                EDiagS(t,x,y,z,:,:) = D(ind,ind);
            end
        end
    end
end

disp('Single Timestep Undiagonalized')
disp(squeeze(ES(1,30,45,65,:,:)))

disp('Single Timestep Diagonalized')
disp(squeeze(EDiagS(1,30,45,65,:,:)))


EpM(1,1,1,1,:,:) = enDenM;
EM = cell2mat(EpM);

for t = 1:11
    for x = 1:99
        for y = 1:99
            for z = 1:99
                [~,D] = eig(squeeze(EM(t,x,y,z,:,:)),'matrix');
                [d,ind] = sort(diag(D));
                EDiagM(t,x,y,z,:,:) = D(ind,ind);
            end
        end
    end
end

disp('Multi Timestep Undiagonalized')
disp(squeeze(EM(round((end+1)/2),30,45,65,:,:)))

disp('Multi Timestep Diagonalized')
disp(squeeze(EDiagM(round((end+1)/2),30,45,65,:,:)))




%%
Point = [30, 45, 60];

eta = [-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
MpM(1,1,1,1,:,:) = metric;
MM = cell2mat(MpM);
MP = squeeze(MM(1,Point(1),Point(2),Point(3),:,:));
[V,D] = eig(squeeze(MM(1,Point(1),Point(2),Point(3),:,:)),'matrix');

ESP = squeeze(ES(1,Point(1),Point(2),Point(3),:,:));



