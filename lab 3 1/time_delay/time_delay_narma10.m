%% READ DATA
m = load('NARMA10timeseries.mat');

in = cell2mat(m.NARMA10timeseries.input);
out_d = cell2mat(m.NARMA10timeseries.target);

data = [in;out_d];

train_data1 = data(:,1:5000);
test_data = data(:,5001:end);

selecting_parameters = true;
testing = true;
fid = fopen('numerical results.txt','w');

%% PARAMETER SELECTION (BY HAND)
if selecting_parameters == true
    split_point = 4000;
    valid_data = train_data1(:,split_point+1:end);
    train_data = train_data1(:,1:split_point);

    tx = train_data(1,:); tx = num2cell(tx);
    ty = train_data(2,:); ty = num2cell(ty);

    vx = valid_data(1,:); vx = num2cell(vx);
    vy = valid_data(2,:); vy = num2cell(vy);

    net = timedelaynet(1:9,[10],'traingdx'); %[ 2, 5, 10, 50, 64, [64,32] ]
    net.divideFcn = 'dividetrain';
    net.trainParam.lr = 0.1; % [ 0.1, 0.05, 0.01, 0.005, 0.001 ]
    net.trainParam.mc = 0.9; % [ 0.9, 0.5, 0.1]
    net.trainParam.epochs = 500; % [ 500, 1000 ]
    net.performParam.regularization = 1e-4; % [ 1e-12, 1e-9, 1e-5 ]
    net = closeloop(net);

    [txs,txi,~,tys] = preparets(net,tx,ty);
    [vxs,vxi,~,vys] = preparets(net,vx,vy);
    net_v = train(net,txs,tys,txi);
    Yt = net_v(txs,txi);
    perf_t = perform(net_v,Yt,tys);
    
    plotresponse(tys(10:100),Yt(10:100));
    saveas(gcf, 'signals comparison train.jpg') ;

    Yv = net_v(vxs,vxi);
    perf_v = perform(net_v,Yv,vys);
    
    fprintf(fid, 'MSE: \n');
    fprintf(fid,'train error: %0.005f , validation error: %0.005f \n',perf_t, perf_v);
end

%% MODEL ASSESSMENT

if testing == true
    tx = train_data1(1,:); tx = num2cell(tx);
    ty = train_data1(2,:); ty = num2cell(ty);
    [txs,txi,~,tys] = preparets(net,tx,ty);

    test_x = test_data(1,:); test_x = num2cell(test_x);
    test_y = test_data(2,:); test_y = num2cell(test_y);
    [test_xs,test_xi,~,test_ys] = preparets(net,test_x,test_y);

    [net_t,training_record] = train(net,txs,tys,txi);
    save net_t
    save training_record

    Yt = net_v(test_xs,test_xi);
    perf_t = perform(net_v,Yt,test_ys);
    fprintf(fid,'test error: %0.005f \n',perf_t);
    
    plotresponse(test_ys(10:100),Yt(10:100));
    saveas(gcf, 'signals comparison test.jpg') ;
    
    plotperf(training_record);
    saveas(gcf, 'learning curve.jpg') ;
end


fclose(fid);





