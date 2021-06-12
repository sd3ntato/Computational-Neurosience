function [Wout,Win,Wr,x] = train(train_data, Nr, Nu, lambda_r, inputScaling, rho_desired, r_density)
    N = size(train_data,2);
    U = train_data(1,:);
    Ytarget = train_data(2,:);
    X = [];
    
    x = zeros(Nr,1); 
    Win = inputScaling*(2*rand(Nr,Nu+1)-1);
    Wrandom = 2*sprand(Nr,Nr,r_density);
    Wr = Wrandom * (rho_desired/max(abs(eigs(Wrandom))));
    
    %for each pattern: submit the pattern and collect the state
    for i = 1:N
        u = U(1,i);
        x = tanh( Win * [u;1] + Wr * x );
        X = [X,[x;1]];
    end
    
    X = X(:,500:end);
    Yt = Ytarget(500:end);
    
    if lambda_r<1e-16
        Wout = Yt * pinv(X);
    else
        Wout = Yt * X'*inv(X*X'+lambda_r*eye(Nr+1));
    end