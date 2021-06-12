%% HYPER-PARAMETERS SETTING

% largest modulus eigenvalue of the recurrent weight matrix
rho_desired = 0.9; % [ 0.7 , 0.8, 0.9 ]

% range of values for weights in input matrix: 
% Win(i,j) \in [-inputScaling, inputScaling]
inputScaling = 0.1; % [ 0.1 , 0.3, 0.5 ]

% density of the recurrent matrix
r_density = 0.1; % [ 0.1 , 0.3, 0.5 ]

% ridge-regression hyper-parameter
lambda_r = 0; % [ 0.01 , 0.001, 1e-03, 1e-05, 1e-012 ]

% number of recurrent, input and output units
Nr = 100; % [ 50, 100, 250, 300, 500 ]
Nu = 1;
Ny = 1;

% fid points to the file in wich i write MSE on training, validation and
% test set
fid = fopen('numerical results.txt','w');

%% READ DATA
m = load('NARMA10timeseries.mat');

in = cell2mat(m.NARMA10timeseries.input);
out_d = cell2mat(m.NARMA10timeseries.target);

data = [in;out_d];

%% SETUP, TRAINING AND EVALUATION ON VALIDATION DATA

% split data into training and validation sets
train_data = data(:,1:4000);
valid_data = data(:,4001:5000);

% average performance on validation data
errors = NaN(1,50);
for i = 1:50
    % train the network on training set.
    [Wout,Win,Wr,x] = train(train_data, Nr, Nu, lambda_r, inputScaling, rho_desired, r_density);

    % evaluate performance of the network on validation data, then write it on
    % the file
    MSE_valid = evaluate(Wr, Win, Wout, x, valid_data);
    
    errors(i) = MSE_valid;
end
mean_error = mean(errors);
fprintf(fid, 'MSE: \n');
fprintf(fid,'mean validation error: %0.00005f \n', mean_error);


%% ASSESSMENT

% reassemble training and validation data into a single training set, then
% train the network on this whole training data and do model assessment
% with test data
train_data = [ train_data, valid_data ]; 
test_data = data(:,5001:end);

% train the network
[Wout,Win,Wr,x] = train(train_data, Nr, Nu, lambda_r, inputScaling, rho_desired, r_density);

% assess training MSE and plot signal comparison on the first 100 elements
% in the training set
MSE_train = evaluate(Wr, Win, Wout, x, train_data);
saveas(gcf, 'ESN signals comparison train.jpg') 

% assess test MSE and plot signal comparison on the first 100 elements
% in the test set
MSE_test = evaluate(Wr, Win, Wout, x, test_data);
saveas(gcf, 'ESN signals comparison test.jpg') ;

% write down training and test MSE
fprintf(fid,' training error: %0.00005f, test error: %0.00005f \n', MSE_train, MSE_test);

% save network and hyperparameters
save Wout
save Win
save Wr

hyperparameters.rho_desired = 0.9; % [ 0.7 , 0.8, 0.9 ]
hyperparameters.inputScaling = 0.1; % [ 0.1 , 0.3, 0.5 ]
hyperparameters.r_density = 0.1; % [ 0.1 , 0.3, 0.5 ]
hyperparameters.lambda_r = 0; % [ 0.01 , 0.001, 1e-03, 1e-05, 1e-012 ]
hyperparameters.Nr = 100; % [ 50, 100, 250, 300, 500 ]
hyperparameters.Nu = 1;
hyperparameters.Ny = 1;

save hyperparameters


