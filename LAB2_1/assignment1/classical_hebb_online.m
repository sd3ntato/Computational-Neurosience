% read data and put it into a matrix
m = readtable('lab2_1_data.csv');
m = m{:,:};

%hyper-parameters
eta = 0.0001; % learning rate
eps = 0.01; % stopping parameter
max_epochs = 500;

% initialization
w = rand(2,1).*2 - 1 ;
ws = [];
dws = [];
w1s = [];
w2s = [];

%%%%%%%%%%%%%%%%%%% ONLINE TRAINING %%%%%%%%%%%%%%%%%%%

for epoch = 1:max_epochs
    
    % epoch of online hebb training
    for c = 1 : size(m,2)
        u = m(:,1) ;
        v = w' * u ;
        dw = eta .* v .* u ;
        w = w + dw;
    end 
    
    % save statistics
    ws = [ ws, w ]; %#ok<AGROW>
    dws = [ dws, norm(dw) ]; %#ok<AGROW>
    w1s = [ w1s, w(1,1) ];   %#ok<AGROW>
    w2s = [ w2s, w(2,1) ];   %#ok<AGROW>
    
    if ( size(dws,1) > 2 ) && ( abs( dws(end) - dws(end-1) )/dws(1) < eps )
        break
    end
end

%%%%%%%%%%%%%%%%%%% CORR MAT %%%%%%%%%%%%%%%%%%%

c = m*m'; % correlation matrix
[v,d] = eig(c,'vector'); % d eigenvalues, v eigenvectors
[~,i] = max(d'); % i index of maximum eigenvector
e_c = v(i,:); % e_c eigenvector corresponding to maximum eigenvalue


%%%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%


subplot(3,2,1)
loglog(dws)
%legend('norm \Deltaw')
title('\Deltaw as a function of #epochs')
axis square

subplot(3,2,3)
loglog(w1s)
title('w_1 as a function of #epochs')
axis square

subplot(3,2,5)
loglog(w2s)
title('w_2 as a function of #epochs')
axis square

subplot(3,2,[2,4,6])
hold on
plot(m(1,:),m(2,:),'.');
plotv( e_c','-',2 )
plotv( ( w/norm(w) ), '-',1)
hold off
legend('data points','eigenvector','normalized w')
title('data, principal eigenvector and w')
axis square

filename = 'classical hebbian learning online';
sgtitle(filename)
saveas(gcf, append('imgs/' ,filename, '.jpg') );

save('ws.mat','ws')



