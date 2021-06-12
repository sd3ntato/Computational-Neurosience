%% READ DATA
m = load('NARMA10timeseries.mat');

in = cell2mat(m.NARMA10timeseries.input);
out_d = cell2mat(m.NARMA10timeseries.target);

data = [in;out_d];

% this section of the data will be initially split into train and
% validation data, the used as a whole to train the final model
train_data1 = data(:,1:5000); 

% this other section of data will be used to do model assessment (estimate
% generalization capability)
test_data = data(:,5001:end);

selecting_parameters = true;
testing = true;

% this file is used to report MSE on train, validation and test data
fid = fopen('numerical results.txt','w');

%% PARAMETER SELECTION (BY HAND)
if selecting_parameters == true
    split_point = 4000;
    
    % split training data into training and validation
    valid_data = train_data1(:,split_point+1:end);
    train_data = train_data1(:,1:split_point);

    % split training and validation data into input and desired output
    tx = train_data(1,:); tx = num2cell(tx);
    ty = train_data(2,:); ty = num2cell(ty);
    vx = valid_data(1,:); vx = num2cell(vx);
    vy = valid_data(2,:); vy = num2cell(vy);

    % create the network and setup hyper-parametes. model selection is made
    % testing various configurations by hand. Tested hyper-parameters are
    % reported in the comments
    net = layrecnet(1:2,10,'traingdx'); %[ 2, 5, 10, 50, 64, [64,32] ]
    net.divideFcn = 'dividetrain';
    net.trainParam.lr = 0.05; % [ 0.1, 0.05, 0.01, 0.005, 0.001 ]
    net.trainParam.mc = 0.9; % [ 0.9, 0.5, 0.1]
    net.trainParam.epochs = 500; % [ 500, 1000 ]
    net.performParam.regularization = 1e-4; % [ 1e-12, 1e-9, 1e-5 ]
    net = closeloop(net); % do not put output-feedback connections

    % prepare the data to be used by the model
    [txs,txi,~,tys] = preparets(net,tx,ty);
    [vxs,vxi,~,vys] = preparets(net,vx,vy);
    
    % train the network
    net_v = train(net,txs,tys,txi);
    
    % evaluate performance on validation set
    Yv = net_v(vxs,vxi);
    perf_v = perform(net_v,Yv,vys);
    
    % write down performance on validation set
    fprintf(fid, 'MSE: \n');
    fprintf(fid,'validation error: %0.005f \n', perf_v);
end

%% MODEL ASSESSMENT

if testing == true
    
    % use the whole training set this time (no validation split), separate
    % input from desired output
    tx = train_data1(1,:); tx = num2cell(tx);
    ty = train_data1(2,:); ty = num2cell(ty);
    test_x = test_data(1,:); test_x = num2cell(test_x);
    test_y = test_data(2,:); test_y = num2cell(test_y);
    
    % prepare data for usage with the model
    [txs,txi,~,tys] = preparets(net,tx,ty);
    [test_xs,test_xi,~,test_ys] = preparets(net,test_x,test_y);

    % train the network on the whole training dataset
    [net_t,training_record] = train(net,txs,tys,txi); % net_t is the network used for testing (model assessment)
    save net_t % save the network
    save training_record % save the training record
    
    % evaluate the performance of the network on the training set: write
    % the MSE on the file and compare signals in a plot
    Yt = net_t(txs,txi);
    perf_t = perform(net_v,Yt,tys);
    fprintf(fid,'train error: %0.005f \n', perf_t);
    
    plotresponse(tys(10:100),Yt(10:100));
    saveas(gcf, 'signals comparison train.jpg') ;

    % evaluate the performance of the network on the test set as before
    Yt = net_t(test_xs,test_xi);
    perf_t = perform(net_t,Yt,test_ys);
    fprintf(fid,'test error: %0.005f \n',perf_t);
    
    plotresponse(test_ys(10:100),Yt(10:100));
    saveas(gcf, 'signals comparison test.jpg') ;
    
    plotperf(training_record);
    saveas(gcf, 'learning curve.jpg') ;
end


fclose(fid);





