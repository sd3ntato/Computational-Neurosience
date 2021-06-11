classdef neuron
    
    properties
        u
        w
        u_history
        w_history
        I_history
        pars =   [0.02      0.2     -65      6       14    -70  ;...   % tonic spiking
                  0.02      0.25    -65      6       0.5   -64  ;...   % phasic spiking
                  0.02      0.2     -50      2       15    -70  ;...   % tonic bursting
                  0.02      0.25    -55     0.05     0.6   -64  ;...   % phasic bursting
                  0.02      0.2     -55     4        10    -70  ;...   % mixed mode
                  0.01      0.2     -65     8        30    -70  ;...   % spike frequency adaptation
                  0.02      -0.1    -55     6        0     -60  ;...   % Class 1
                  0.2       0.26    -65     0        0     -64  ;...   % Class 2
                  0.02      0.2     -65     6        7     -70  ;...   % spike latency
                  0.05      0.26    -60     0        0     -62  ;...   % subthreshold oscillations
                  0.1       0.26    -60     -1       0     -62  ;...   % resonator
                  0.02      -0.1    -55     6        0     -60  ;...   % integrator
                  0.03      0.25    -60     4        0     -70  ;...   % rebound spike
                  0.03      0.25    -52     0        0     -70  ;...   % rebound burst
                  0.03      0.25    -60     4        0     -64  ;...   % threshold variability
                  0.1       0.26    -60     0      -65     -61  ;...   % bistability
                  1         0.2     -60     -21      0     -70  ;...   % DAP
                  0.02      1       -55     4        0     -65  ;...   % accomodation
                 -0.02      -1      -60     8        80    -64  ;...   % inhibition-induced spiking
                 -0.026     -1      -45     0        80    -70  ];     % inhibition-induced bursting
        a,b,c,d
        tau, I
    end
    
    methods
        function obj = neuron(line,tau)
            obj.u_history = [];
            obj.w_history = [];
            obj.I_history = [];
            obj.a = obj.pars(line,1); obj.b = obj.pars(line,2);  obj.c = obj.pars(line,3);  obj.d = obj.pars(line,4);
            obj.u = obj.pars(line,6);
            obj.w = obj.b * obj.u;
            obj.tau = tau; obj.I = 0;
        end
        
        function obj = update(obj,dI)
            obj.I = obj.I + dI;
            obj.u = obj.u + obj.tau * ( 0.04 * obj.u^2 + 5 * obj.u + 140 - obj.w + obj.I );
            obj.w = obj.w + obj.tau * obj.a * ( obj.b * obj.u - obj.w );
            if obj.u > 30
                obj.u = obj.c;
                obj.w = obj.w + obj.d;
            end
            obj.u_history = [ obj.u_history, obj.u ];
            obj.w_history = [ obj.w_history, obj.w ];
            obj.I_history = [ obj.I_history, obj.I ];
        end
        
        function obj = update_accomodation(obj,dI)
            obj.I = obj.I + dI;
            obj.u = obj.u + obj.tau * ( 0.04 * obj.u^2 + 5 * obj.u + 140 - obj.w + obj.I );
            obj.w = obj.w + obj.tau * obj.a * ( obj.b * (obj.u + 65) );
            if obj.u > 30
                obj.u = obj.c;
                obj.w = obj.w + obj.d;
            end
            obj.u_history = [ obj.u_history, obj.u ];
            obj.w_history = [ obj.w_history, obj.w ];
            obj.I_history = [ obj.I_history, obj.I ];
        end
        
        function n = plot(n, filename)
            steps = size(n.I_history,2);
            subplot(4,2,[1,3,5])
            plot(n.u_history )
            axis([0 steps -90 50])
            title('u over time')
            %legend('u')

            subplot(4,2,7) 
            plot(n.I_history)
            axis([0 steps -10 max(n.I_history)])
            set(gca,'XColor', 'none','YColor','none')
            title('I over time')
            %legend('I')

            subplot(4,2,[2,4,6,8]) 
            plot(n.u_history,n.w_history)
            %axis([-5 5 -80 40])
            ylabel('w')
            xlabel('u')
            
            sgtitle(filename)
            
            saveas(gcf, append('imgs/' ,filename, '.jpg') );
        end
        
    end
end

