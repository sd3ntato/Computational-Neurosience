function MSE = evaluate(Wr, Win, Wout, x, data)
    U = data(1,:);
    Ytarget = data(2,:);
    N = size(U,2);
    Y = [];
    %for each pattern: submit the pattern and collect the state
    for i = 1:N
        u = U(i);
        x = tanh( Win * [u;1] + Wr * x );
        y = Wout * ( [x;1] );
        Y = [Y,y];
    end

    Y = Y(500:end);
    Ytarget = Ytarget(500:end);

    plot(Ytarget(11:150),'.-')
    hold on
    plot(Y(11:150),'.-')
    hold off
    legend('target', 'output')
    
    MSE = mean( (Ytarget-Y).^2 );