AM = metricGet_Alcubierre(0,100,10,0.5,[50 50 50]);

gl = AM;
gu = c4Inv(gl);

disp("christoffel")

tic
c1 = christoffelS(gu,gl);
toc
tic
c2 = christoffelS2(gu,gl);
toc
tic
c3 = christoffelS3(gu,gl);
toc
tic
c4 = christoffelS4(gu,gl);
toc

disp("ricci")

tic
r{1} = ricciT(c1,gu); % same as T3, T5, just plain wrong, 0.194906 seconds
toc
tic
r{2} = ricciT2(gu,gl); % same as T6, T4, 70.172968 seconds
toc
tic
r{1} = ricciT3(c1,gu); % same as T5, T1, just plain wrong, 0.207172 seconds
toc
tic
r{4} = ricciT4(gu,gl); % same as T6, T2, 35.206944 seconds
toc
tic
r{5} = ricciT5(c1,gu); % same as T3, T1, just plain wrong, 0.204823 seconds
toc
tic
r{6} = ricciT6(gu,gl); % same as T4, T2, 3.944807 seconds
toc
tic
r{7} = ricciT7(c1,gu); % same as T9, 0.209476 seconds
toc
%r{8} = ricciT8(gu,gl); % just plain wrong
tic
r{9} = ricciT9(c1,gu); % same as T7, 0.210155 seconds
toc
%r{10} = ricciT11(c1,gu); % just plain wrong

for k = [1,2,5,6,7]
    for l = [1,2,5,6,7]
        t(k,l)=0;
        for i = 1:4
            for j = 1:4
                t(k,l)=t(k,l)+(2*sum(sum(sum(sum(abs(r{k}{i,j}-r{l}{i,j})))))/(sum(sum(sum(sum(abs(r{k}{i,j})))))+sum(sum(sum(sum(abs(r{l}{i,j})))))))/16
                
            end
        end
        fprintf("%i,%i,%i\n",k,l,t(k,l))
    end
end


