
% Function defined in a different file for CORA

dim = 12;

dim1 = 1;
dim2 = 2;
% Change default options
options.timeStep = 0.01;
options.taylorTerms = 4;
options.zonotopeOrder = 20;
options.alg = 'lin';
options.tensorOrder = 2;

% Initial states
%x0 = [1, 0.001, 0.001, 0.001,0.001, 0.001, 0.001,0.001, 0.001,0.001,0.001, 0.001]';% This is like the initial input to the ODEblock (initial state)
x0=ones(12,1);
Initial_radius = 5*1e-3; % Uncertainty in dynamics (initial states)
lb = x0 - Initial_radius;
ub = x0 + Initial_radius;
% init_set = Star(lb,ub);
% input_set = Star(0,0); % No inputs, but need to define it

R0 = interval(lb,ub);
U = zonotope([0,0]);

params.R0=zonotope(R0);
params.U=U;
params.timeStep=0.01;
params.tFinal=1.5;

 sys = nonlinearSys(@CartpoleCTRNN, 12, 1); % CORA nonlinearSys class

 R = reach(sys, params, options); % CORA reach method using zonotope and conservative linearization R = reach(sys, obj.params, obj.options); % CORA reach method using zonotope and conservative linearization
 
 %plot(R,[1,2],'FaceColor','r','EdgeColor','k');
%   Star.plotBoxes_2D(Rall,dim1,dim2,'k');
%   hold on;
 plot(R,[1,2],'r');
%    for j =1:params.tFinal/params.timeStep +1
%        hold on;
%        plot(R.timePoint.set{j},[dim1,dim2],'r');
%    end
 for i=1:dim
    mintemp = R0.inf;
    maxtemp = R0.sup;
    mintemp(i) = R0.sup(i);
    R0B{i}= interval(mintemp,maxtemp);
    params.R0=zonotope(R0B{i});
    RB{i} = reach(sys, params, options);
 end

 for i=1:dim
    mintemp = R0.inf;
    maxtemp = R0.sup;
    maxtemp(i) = R0.inf(i);
    R0B{i+dim}= interval(mintemp,maxtemp);
    params.R0=zonotope(R0B{i+dim});
    RB{i+dim} = reach(sys, params, options);
 end

 for i=1:2*dim
     %hold on;
     %plot(RB{i},[1,2],'b');
%         for j =1:params.tFinal/params.timeStep +1
%             hold on;
%        plot(RB{i}.timePoint.set{j},[dim1,dim2],'b');
%         end
    plot(RB{i},[dim1,dim2],'b');
 end 
 
 steps = 110;
 for j =1:steps
      hold on;
       plot(R.timePoint.set{j},[dim1,dim2],'FaceColor','r','EdgeColor','none');
  end
for i=1:2*dim
     %hold on;
     %plot(RB{i},[1,2],'b');
        for j =1:steps
            hold on;
        plot(RB{i}.timePoint.set{j},[dim1,dim2],'FaceColor','b','EdgeColor','none');
        end
end

%plot(R.timePoint.set{steps},[dim1,dim2],'FaceColor','r','EdgeColor','none');

% for i=1:2*dim
% 
%             hold on;
%         plot(RB{i}.timePoint.set{steps},[dim1,dim2],'FaceColor','b','EdgeColor','none');
% 
% end

saferegion = interval([0.0545;0.145],[0.1465;0.725]);

%plot(saferegion,[1,2],'g','Linewidth',2.5);
