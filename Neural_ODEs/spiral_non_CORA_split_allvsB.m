
% Function defined in a different file for CORA
clc;clear;
Neh=2;
% Change default options
options.timeStep = 0.01;
options.taylorTerms = 2;
options.zonotopeOrder = 20;
options.alg = 'lin';
options.tensorOrder = 2;

% Initial states
x0 = [2.0;0.0]; % This is like the initial input to the ODEblock (initial state)
Initial_radius = 0.5; % Uncertainty in dynamics (initial states)
lb = x0 - Initial_radius;
ub = x0 + Initial_radius;

% init_set = Star(lb,ub);
% input_set = Star(0,0); % No inputs, but need to define it

R0 = interval(lb,ub);
U = zonotope([0,0]);

params.R0=zonotope(R0);
params.U=U;
params.timeStep=0.01;
params.tFinal=6
 sys = nonlinearSys(@spiral_non, 2, 1); % CORA nonlinearSys class

 %R = reach(sys, params, options); % CORA reach method using zonotope and conservative linearization R = reach(sys, obj.params, obj.options); % CORA reach method using zonotope and conservative linearization
 

 %plot(R,[1,2],'FaceColor','r','EdgeColor','none');
   %plot(R,[1,2],'r');
  %Star.plotBoxes_2D(Rall,1,2,'k');
  
 
  steps=600+1;
    
SplitsAll =6;
  SplitsB = 4;
intervalStep(1) = (ub(1)-lb(1))/SplitsAll;
  intervalStep(2) = (ub(2)-lb(2))/SplitsAll;
  for i=1:SplitsAll
      for j =1:SplitsAll
             lbsplit(1) = lb(1) + (i-1)*intervalStep(1);
             lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
             ubsplit(1) = lb(1) + i*intervalStep(1);
             ubsplit(2) = lb(2) + j*intervalStep(2);

          
      R0_splits{(i-1)*SplitsAll+j} = interval(lbsplit', ubsplit');
 
        params.R0=zonotope(R0_splits{(i-1)*SplitsAll+j});
      R_splits{(i-1)*SplitsAll+j} = reach(sys, params, options);
      end
  end
  
  count =1;
  intervalStep(1) = (ub(1)-lb(1))/SplitsB;
  intervalStep(2) = (ub(2)-lb(2))/SplitsB;
for i=1:Neh
    mintemp = R0.inf;
    maxtemp = R0.sup;
    mintemp(i) = R0.sup(i);
    R0B{i}= interval(mintemp,maxtemp);
    if i==1
        lbsplit(i) = R0.sup(i);
        ubsplit(i) = R0.sup(i);
       for j=1:SplitsB
      lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
      ubsplit(2) = lb(2) + j*intervalStep(2);          
      R0B_splits{count} = interval(lbsplit', ubsplit');
      count =count+1;
       end
    else
        lbsplit(i) = R0.sup(i);
        ubsplit(i) = R0.sup(i);
       for j=1:SplitsB
      lbsplit(1) = lb(1) + (j-1)*intervalStep(2);
      ubsplit(1) = lb(1) + j*intervalStep(2);          
      R0B_splits{count} = interval(lbsplit', ubsplit');
      count =count+1;
       end
    end
end

for i=1:Neh
    mintemp = R0.inf;
    maxtemp = R0.sup;
    maxtemp(i) = R0.inf(i);
    R0B{i+Neh}= interval(mintemp,maxtemp);
        if i==1
        lbsplit(i) = R0.inf(i);
        ubsplit(i) = R0.inf(i);
       for j=1:SplitsB
      lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
      ubsplit(2) = lb(2) + j*intervalStep(2);          
      R0B_splits{count} = interval(lbsplit', ubsplit');
      count =count+1;
       end
    else
        lbsplit(i) = R0.inf(i);
        ubsplit(i) = R0.inf(i);
       for j=1:SplitsB
      lbsplit(1) = lb(1) + (j-1)*intervalStep(2);
      ubsplit(1) = lb(1) + j*intervalStep(2);          
      R0B_splits{count} = interval(lbsplit', ubsplit');
      count =count+1;
       end
    end
end

% for i=1:SplitsB*4
%     hold on
%     plot(zonotope(R0B_splits{i}),[1,2],'FaceColor',[rand(1),rand(1),rand(1)]);
% end
% 
% for i=1:SplitsAll^2
%   hold on
%     plot(zonotope(R0_splits{i}),[1,2],'FaceColor',[rand(1),rand(1),rand(1)]);
% end  

grid on;
xlabel('y_{1}');
ylabel('y_{2}');

%plot(R.timePoint.set{steps},[1,2],'FaceColor','r');

 for i =1:SplitsAll^2
    hold on;
    %plot(pZB{i},[1,2],'y','Splits',2);
    plot(R_splits{i}.timePoint.set{steps},[1,2],'FaceColor','r');
end

for i=1:4*SplitsB
    params.R0=zonotope(R0B_splits{i});
    RB_splits{i} = reach(sys, params, options);
    hold on;
    plot(RB_splits{i}.timePoint.set{steps},[1,2],'FaceColor','b');
end
 
saferegion=interval([-0.08;-1.50],[0.90;-0.30]);
 hold on;
plot(saferegion,[1,2],'g','Linewidth',2);