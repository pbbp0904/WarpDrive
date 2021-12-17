% Alcubierre form: dg^{ij}/dx^k = - g^{im} g^{jn} d g_{mn}/dx^k
% Wolfram form  : g_{il} dg^{lk}/dx^m = - g^{lk} d g_{il}/dx^m

% Seems to only be vaid for 'flat' space...
%AM = metricGet_Alcubierre(0,100,10,0.5,[50 50 50]);
AM = metricGet_Schwarzschild(0.4,50);

gl = AM;
gu = c4Inv(gl);

% Alcubierre
eq1 = cell(4,4,4);
eq2 = cell(4,4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for j = 1:4
        for k = 1:4
            eq1{i,j,k} = zeros(t,x,y,z);
            if s(k)>=3
                eq1{i,j,k} = padDiff(diff(gu{i,j},1,k),k);
            end
            
            eq2{i,j,k} = zeros(t,x,y,z);
            for m = 1:4
                for n = 1:4
                    if s(k)>=3
                        eq2{i,j,k} = eq2{i,j,k} + (-gu{i,m}).*gu{j,n}.*padDiff(diff(gl{m,n},1,k),k);
                    end
                end
            end
        end
    end
end

t1 = [];
for i = 1:4
    for j = 1:4
        for k = 1:4
            t1(i,j,k)=2*round(sum(sum(sum(sum(abs(eq1{i,j,k}-eq2{i,j,k}))))),4)/(round(sum(sum(sum(sum(abs(eq1{i,j,k}))))),4)+round(sum(sum(sum(sum(abs(eq2{i,j,k}))))),4));
        end
    end
end

t1(:,:,1)
t1(:,:,2)
t1(:,:,3)
t1(:,:,4)





% Wolfram form
eq3 = cell(4,4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for k = 1:4
        for m = 1:4
            eq3{i,k,m} = zeros(t,x,y,z);
            for l = 1:4
                if s(m)>=3
                    eq3{i,k,m} = eq3{i,k,m} + gu{l,k}.*padDiff(diff(gl{l,i},1,m),m) + gl{l,i}.*padDiff(diff(gu{l,k},1,m),m);
                end
            end
        end
    end
end

t2 = [];
for i = 1:4
    for j = 1:4
        for k = 1:4
            t2(i,j,k)=sum(sum(sum(sum(abs(eq3{i,j,k})))));
        end
    end
end

t2(:,:,1)
t2(:,:,2)
t2(:,:,3)
t2(:,:,4)




% Wolfram exact form
eq5 = cell(4,4,4);
eq6 = cell(4,4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for k = 1:4
        for m = 1:4
            eq5{i,k,m} = zeros(t,x,y,z);
            for l = 1:4
                if s(m)>=3
                    eq5{i,k,m} = eq5{i,k,m} + gl{i,l}.*padDiff(diff(gu{l,k},1,m),m);
                end
            end
            
            eq6{i,k,m} = zeros(t,x,y,z);
            for l = 1:4
                if s(m)>=3
                    eq6{i,k,m} = eq6{i,k,m} - gu{l,k}.*padDiff(diff(gl{i,l},1,m),m);
                end
            end
        end
    end
end

t3 = [];
for i = 1:4
    for j = 1:4
        for k = 1:4
            t3(i,j,k)=2*round(sum(sum(sum(sum(abs(eq5{i,j,k}-eq6{i,j,k}))))),4)/(round(sum(sum(sum(sum(abs(eq5{i,j,k}))))),4)+round(sum(sum(sum(sum(abs(eq6{i,j,k}))))),4));
        end
    end
end

t3(:,:,1)
t3(:,:,2)
t3(:,:,3)
t3(:,:,4)




% Wolfram form gradient
eq7 = cell(4,4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for k = 1:4
        for m = 1:4
            eq7{i,k,m} = zeros(t,x,y,z);
            for l = 1:4
                [al,bl,cl,dl] = gradient(gl{l,i});
                lowerInd = {bl,al,cl,dl};
                
                [au,bu,cu,du] = gradient(gu{l,k});
                upperInd = {bu,au,cu,du};
                
                eq7{i,k,m} = eq7{i,k,m} + gu{l,k}.*lowerInd{m} + gl{l,i}.*upperInd{m};
            end
        end
    end
end

t4 = [];
for i = 1:4
    for j = 1:4
        for k = 1:4
            t4(i,j,k)=sum(sum(sum(sum(abs(eq7{i,j,k})))));
        end
    end
end

t4(:,:,1)
t4(:,:,2)
t4(:,:,3)
t4(:,:,4)


% Wolfram form 1 before product rule
eq8 = cell(4,4,4);
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];
for i = 1:4
    for k = 1:4
        for m = 1:2
            eq8{i,k,m} = zeros(t,x,y,z);
            for l = 1:4
                if s(m)>=3
                    eq8{i,k,m} = eq8{i,k,m} + padDiff(diff(gu{l,k}.*gl{i,l},1,m),m);
                end
            end
        end
    end
end

t5 = [];
for a = 1:4
    for b = 1:4
        for c = 1:4
            t5(a,b,c)=sum(sum(sum(sum(abs(eq8{a,b,c})))));
        end
    end
end

t5(:,:,1)
t5(:,:,2)
t5(:,:,3)
t5(:,:,4)


