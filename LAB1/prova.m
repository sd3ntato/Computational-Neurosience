% for each neuro-computational feature i create a neuron n=neuron(l,tau) object with
% parameters specified in line l of the pars features of the class neuron
% and time constant for the simulation by euler's method tau.

% the method neuron.update(dI) updates the external current injection doing
% n.I = n.I + dI,
% then computes a time-step by euler's method.


steps = 1000;
tau = 0.1;

%% tonic spiking
l=1; % line in the matrix n.pars that specified the desired parameters for this feature
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps
    n = n.update(0);
end
n.plot( 'tonic spiking');

%% phasic spiking
l=2;
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps
    n = n.update(0);
end
n.plot( 'phasic spiking');

%% tonic bursting
l=3;
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps
    n = n.update(0);
end
n.plot( 'tonic bursting');

%% phasic bursting
l=4;
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps+300
    n = n.update(0);
end
n.plot( 'phasic bursting');

%% mixed mode
l=5;
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps
    n = n.update(0);
end
n.plot( 'mixed mode');

%% spike freq. adapt
l=6;
n = neuron(l,tau);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps
    n = n.update(0);
end
n.plot( 'spike freq adapt');

%% Class 1 exc
l=7;
n = neuron(l,tau);
for t=0:10
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps*1.4
    n = n.update(0.06);
end
n.plot('Class 1 exc');

%% Class 2 exc
l=8;
n = neuron(l,tau);
n = n.update(-0.5);
for t=0:20
    n = n.update(0);
end
n = n.update(n.pars(l,5));
for t=0:steps*1.4
    n = n.update(0.01);
end
n.plot('Class 2 exc');

steps = 100000;
tau = 0.001;

%% spike latency
l=9;
n = neuron(l,tau);
for t=0:1000
    n = n.update(0);
end

n = n.update(7);
for t=0:2850
    n = n.update(0);
end
n = n.update(-7);

for t=0:steps*0.4
    n = n.update(0);
end
n.plot('spike latency');

%% subthresh. osc.
l=10;
n = neuron(l,tau);
for t=0:1000
    n = n.update(0);
end

n = n.update(2);
for t=0:2000
    n = n.update(0);
end
n = n.update(-2);

for t=0:steps
    n = n.update(0);
end
n.plot( 'subthresh osc');

%% resonator
l=11;
n = neuron(l,tau);
for t=0:4000
    n = n.update(0);
end

p = 1.4;

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:1000
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:40000
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:5000
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);


for t=0:steps/4
    n = n.update(0);
end
n.plot('resonator');


%% integrator
l=12;
n = neuron(l,tau);
for t=0:4000
    n = n.update(0);
end

p = 50;

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:5000
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:40000
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:300
    n = n.update(0);
end

n = n.update(p);
for t=0:1000
    n = n.update(0);
end
n = n.update(-p);

for t=0:steps/4
    n = n.update(0);
end
n.plot('integrator');

%% rebound spike
l=13;
n = neuron(l,tau);
for t=0:1000
    n = n.update(0);
end

n = n.update(-15);
for t=0:4000
    n = n.update(0);
end
n = n.update(15);

for t=0:steps
    n = n.update(0);
end
n.plot( 'rebound spike');

%% rebound burst
l=14;
n = neuron(l,tau);
for t=0:1000
    n = n.update(0);
end

n = n.update(-15);
for t=0:4000
    n = n.update(0);
end
n = n.update(15);

for t=0:steps
    n = n.update(0);
end
n.plot( 'rebound burst');

%% thresh variability
l=15;
n = neuron(l,tau);
for t=0:15000
    n = n.update(0);
end

n = n.update(1);
for t=0:4500
    n = n.update(0);
end
n = n.update(-1);

for t=0:30000
    n = n.update(0);
end

n = n.update(-6);
for t=0:4500
    n = n.update(0);
end
n = n.update(6);
for t=0:4500
    n = n.update(0);
end
n = n.update(1);
for t=0:4500
    n = n.update(0);
end
n = n.update(-1);

for t=0:steps/2.5
    n = n.update(0);
end

n.plot('thresh variability');

%% bistability
l=16;
n = neuron(l,tau);
n = n.update(0.24);

for t=0:40000
    n = n.update(0);
end

n = n.update(1);
for t=0:3000
    n = n.update(0);
end
n = n.update(-1);

for t=0:90000
    n = n.update(-0);
end

n = n.update(1);
for t=0:5000
    n = n.update(0);
end
n = n.update(-1);

for t=0:50000
    n = n.update(-0);
end

n.plot('bistability');

%% DAP
l=17;
n = neuron(l,0.1);

for t=0:100
    n = n.update(0);
end

n = n.update(20);
for t=0:10
    n = n.update(0);
end
n = n.update(-20);

for t=0:100
    n = n.update(-0);
end

n.plot('DAP');

%% accomodation
l=18;
tau = 0.1;
n = neuron(l,tau);
n.w = -16;

for t=0:tau:400
    if (t < 200)
        n.I=t/25;
    elseif t < 300
        n.I=0;
    elseif t < 312.5
        n.I=(t-300)/12.5*4;
    else
        n.I=0;
    end
    n = n.update_accomodation(0);
end
n.plot('accomodation');

%% inhibition induced spiking
l=19;
tau = 0.1;
n = neuron(l,tau);
n = n.update(80);

for t=0:500
    n = n.update(0);
end

n = n.update(-5);
for t=0:1500
    n = n.update(0);
end
n = n.update(5);

for t=0:1500
    n = n.update(0);
end

n.plot('inhibition induced spiking');


%% inhibition induced bursting
l=20;
n = neuron(l,tau);
n = n.update(80);

for t=0:3000
    n = n.update(0);
end

n = n.update(-5);
for t=0:5000
    n = n.update(0);
end
n = n.update(5);

for t=0:3000
    n = n.update(0);
end

n.plot('inhibition induced bursting');


