syms beta x y z vs xs sigma rs R
rs = ((x-xs)^2+y^2+z^2)^(1/2);


f = (tanh(sigma*(rs+R))-tanh(sigma*(rs-R)))/(2*tanh(sigma*R));
beta = -vs*f;
beta2 = beta*beta;
