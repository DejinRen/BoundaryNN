
% Function defined in a different file for CORA


% Change default options
options.timeStep = 0.01;
options.taylorTerms = 2;
options.zonotopeOrder = 20;
options.alg = 'lin';
options.tensorOrder = 2;

% Initial states
x0 = [2.0;0.0]; % This is like the initial input to the ODEblock (initial state)
Initial_radius = 0.2; % Uncertainty in dynamics (initial states)
lb = x0 - Initial_radius;
ub = x0 + Initial_radius;
% init_set = Star(lb,ub);
% input_set = Star(0,0); % No inputs, but need to define it

R0 = interval(lb,ub);
U = zonotope([0,0]);

params.R0=zonotope(R0);
params.U=U;
params.timeStep=0.01;
params.tFinal=4;

 sys = nonlinearSys(@spiral_non, 2, 1); % CORA nonlinearSys class

 R = reach(sys, params, options); % CORA reach method using zonotope and conservative linearization R = reach(sys, obj.params, obj.options); % CORA reach method using zonotope and conservative linearization
 

 %plot(R,[1,2],'FaceColor','r','EdgeColor','none');
   %plot(R,[1,2],'r');
  %Star.plotBoxes_2D(Rall,1,2,'k');
  
  %steps=600;
  steps = 410;
   for j =1:steps
       hold on;
       plot(R.timePoint.set{j},[1,2],'r');
   end
 for i=1:2
    mintemp = R0.inf;
    maxtemp = R0.sup;
    mintemp(i) = R0.sup(i);
    R0B{i}= interval(mintemp,maxtemp);
    params.R0=zonotope(R0B{i});
    RB{i} = reach(sys, params, options);
 end

 for i=1:2
    mintemp = R0.inf;
    maxtemp = R0.sup;
    maxtemp(i) = R0.inf(i);
    R0B{i+2}= interval(mintemp,maxtemp);
    params.R0=zonotope(R0B{i+2});
    RB{i+2} = reach(sys, params, options);
 end

 for i=1:4
     %hold on;
     %plot(RB{i},[1,2],'b');
        for j =1:steps
            hold on;
       plot(RB{i}.timePoint.set{j},[1,2],'b');
   end
 end 
% for i =1:4
%  plot(RB{i},[1,2],'FaceColor','b','EdgeColor','none');
% end
grid on;
xlabel('y_{1}');
ylabel('y_{2}');

plot(R.timePoint.set{steps},[1,2],'FaceColor','r');
hold on;
 for i=1:4
       hold on;
       plot(RB{i}.timePoint.set{steps},[1,2],'FaceColor','b');
 end 
 
 saferegion=interval([0.36;-1.2],[0.8;-0.6]);
 
 plot(saferegion,[1,2],'g','Linewidth',2.5);