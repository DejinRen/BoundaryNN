
% Function defined in a different file for CORA
clc;clear;

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

Splits = 2;
% init_set = Star(lb,ub);
% input_set = Star(0,0); % No inputs, but need to define it

R0 = interval(lb,ub);
U = zonotope([0,0]);

params.R0=zonotope(R0);
params.U=U;
params.timeStep=0.01;
params.tFinal=6
 sys = nonlinearSys(@spiral_non, 2, 1); % CORA nonlinearSys class

 R = reach(sys, params, options); % CORA reach method using zonotope and conservative linearization R = reach(sys, obj.params, obj.options); % CORA reach method using zonotope and conservative linearization
 

 %plot(R,[1,2],'FaceColor','r','EdgeColor','none');
   %plot(R,[1,2],'r');
  %Star.plotBoxes_2D(Rall,1,2,'k');
  
 
  steps=600;
    
  intervalStep(1) = (ub(1)-lb(1))/Splits;
  intervalStep(2) = (ub(2)-lb(2))/Splits;
  for i=1:Splits
      for j =1:Splits
             lbsplit(1) = lb(1) + (i-1)*intervalStep(1);
             lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
             ubsplit(1) = lb(1) + i*intervalStep(1);
             ubsplit(2) = lb(2) + j*intervalStep(2);

          
      R0_splits{(i-1)*Splits+j} = interval(lbsplit', ubsplit');
      
%       hold on;
%       plot(interval(lbsplit', ubsplit'),[1,2],'b');
      params.R0= zonotope(R0_splits{(i-1)*Splits+j});
      R_splits{(i-1)*Splits+j} = reach(sys, params, options);
      end
  end
  
% for i =1:4
%  plot(RB{i},[1,2],'FaceColor','b','EdgeColor','none');
% end
grid on;
xlabel('y_{1}');
ylabel('y_{2}');

plot(R.timePoint.set{steps},[1,2],'FaceColor','r');

 for i=1:size(R_splits,2)
       hold on;
       plot(R_splits{i}.timePoint.set{steps},[1,2],'FaceColor','b');
 end 
 
 saferegion=interval([0.36;-1.2],[0.8;-0.6]);
 
 plot(saferegion,[1,2],'g','Linewidth',2.5);