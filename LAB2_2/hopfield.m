global W;
global b;
global M;
global N;
global m;

m = load('lab2_2_data.mat');
%m1 = load('digits.mat');
%m.p3 = reshape( cell2mat(m1.dataset(4)), 32*32,1);

% plot the fundamental memories
subplot(3,3,1);
imagesc( reshape( xi(1), 32, 32) );
title('Pattern 0')
subplot(3,3,2);
imagesc( reshape( xi(2), 32, 32) );
title('Pattern 1')
subplot(3,3,3);
imagesc( reshape( xi(3), 32, 32) );
title('Pattern 2')

% matrix of fundamental memories. xi(mu) is a function that returns desired
% patterns
XI = [ xi(1)' ; xi(2)' ; xi(3)']' ;
N = size(XI,1);
M = size(XI,2);

%% STORAGE PHASE
W = ( ( XI * XI') - M * eye(N,N) )/N ;

% values of bias found by trial and error. I started from b = sum(XI,2)/N.
b = -sum(XI,2)/M;

%% RETRIEVAL PHASE
probe = distort_image( xi(1), 0.05);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,1,'pattern 0 distorted 0.05' )

probe = distort_image( xi(1), 0.1);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,1,'pattern 0 distorted 0.1')

probe = distort_image( xi(1), 0.25);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,1,'pattern 0 distorted 0.25')

probe = distort_image( xi(2), 0.05);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,2,'pattern 1 distorted 0.05')

probe = distort_image( xi(2), 0.1);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,2,'pattern 1 distorted 0.1')

probe = distort_image( xi(2), 0.25);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,2,'pattern 1 distorted 0.25')

probe = distort_image( xi(3), 0.05);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,3,'pattern 3 distorted 0.05')

probe = distort_image( xi(3), 0.1);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,3,'pattern 3 distorted 0.1')

probe = distort_image( xi(3), 0.25);
[x,j,E,O] = retrieve(probe,10);
plot_results(probe,x,E,O,3,'pattern 3 distorted 0.25')

%% AUXILIARY FUNCTIONS
function plot_results(probe,x,E,O,mu,filename)
    subplot(3,3,4);
    imagesc( reshape( probe, 32, 32) );
    title('Probe')
    subplot(3,3,5);
    imagesc( reshape( x, 32, 32) );
    title('Reconstruted')
    subplot(3,3,6);
    plot( E )
    title('Energy')
    subplot(3,3,7);
    plot(O(:,1))
    ylim([0,1])
    title('Overlap 0')
    subplot(3,3,8);
    plot(O(:,2))
    ylim([0,1])
    title('Overlap 1')
    subplot(3,3,9);
    plot(O(:,3))
    ylim([0,1])
    title('Overlap 2')
    
    t = [filename, sprintf(' - discr: %0.1f',norm(x-xi(mu)))];
    sgtitle(t)
    saveas(gcf, append('imgs/' ,filename, '.jpg') );
end

function psi = xi(mu)
    global m
    if mu == 1
        psi = m.p0;
    elseif mu == 2
        psi = m.p1;
    elseif mu == 3
        psi = m.p2;
    %elseif mu == 4
    %    psi = m.p3;
    end
end

function [x,j,E,O] = retrieve(probe, max)
    global N;
    global W;
    global b;
    
    E = NaN(max*N,1);
    O = NaN(max*N,3);
    x = probe;
    order = randperm(N);
    i = 1;
    for ii=1:max
        for j = order
            x(j) = sign( W(j,:) * x + b(j) );
            E(i) = energy(x);
            O(i,1) = overlap(x,1); O(i,2) = overlap(x,2); O(i,3) = overlap(x,3);
            i = i+1;
        end
        if abs( E(i-1) - E(i-1000) )<1e-01
            break
        end
        fprintf('epoca finita, %d, %0.5f \n',i, E(i-1) );
    end
end

function E = energy(x)
    global W;
    X = x*x';
    E = -1/2 .* sum( W .* X, 'all' ) ;
end

function m = overlap(x,mu)
    global N;
    m = (xi(mu)' * x) / N;
end





