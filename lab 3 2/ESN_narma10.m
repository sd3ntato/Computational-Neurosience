%% HYPER-PARAMETERS SETTING
rho_desired = 0.9; % [ 0.7 , 0.8, 0.9 ]
inputScaling = 0.1; % [ 0.1 , 0.3, 0.5 ]
r_density = 0.1; % [ 0.1 , 0.3, 0.5 ]
lambda_r = 0; % [ 0.01 , 0.001, 1e-03, 1e-05, 1e-012 ]
Nr = 100; % [ 50, 100, 250, 300, 500 ]
Nu = 1;
Ny = 1;

fid = fopen('numerical results.txt','w');

%% READ DATA
m = load('NARMA10timeseries.mat');

in = cell2mat(m.NARMA10timeseries.input);
out_d = cell2mat(m.NARMA10timeseries.target);

data = [in;out_d];

%% SETUP, TRAINING AND EVALUATION ON VALIDATION DATA
train_data = data(:,1:4000);
valid_data = data(:,4001:5000);

[Wout,Win,Wr,x] = train(train_data, Nr, Nu, lambda_r, inputScaling, rho_desired, r_density);

MSE_valid = evaluate(Wr, Win, Wout, x, valid_data);
saveas(gcf, 'ESN signals comparison valid.jpg') ;

fprintf(fid, 'MSE: \n');
fprintf(fid,' validation error: %0.00005f \n', MSE_valid);

%% ASSESSMENT
train_data = [ train_data, valid_data ]; 
test_data = data(:,5001:end);

[Wout,Win,Wr,x] = train(train_data, Nr, Nu, lambda_r, inputScaling, rho_desired, r_density);


MSE_train = evaluate(Wr, Win, Wout, x, train_data);
saveas(gcf, 'ESN signals comparison train.jpg') 

MSE_test = evaluate(Wr, Win, Wout, x, test_data);
fprintf(fid,' training error: %0.00005f, test error: %0.00005f \n', MSE_train, MSE_test);

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


