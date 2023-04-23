Neh =2;

epsilon = 1;

ub=epsilon*ones(Neh,1);
lb=-epsilon*ones(Neh,1);
R0 = scale*interval(lb,ub);

SplitsAll =8;
  SplitsB = 5;
intervalStep(1) = (ub(1)-lb(1))/SplitsAll;
  intervalStep(2) = (ub(2)-lb(2))/SplitsAll;
  for i=1:SplitsAll
      for j =1:SplitsAll
             lbsplit(1) = lb(1) + (i-1)*intervalStep(1);
             lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
             ubsplit(1) = lb(1) + i*intervalStep(1);
             ubsplit(2) = lb(2) + j*intervalStep(2);

          
      R0_splits{(i-1)*SplitsAll+j} = interval(lbsplit', ubsplit');
      
%       hold on;
%       plot(interval(lbsplit', ubsplit'),[1,2],'b');
      R_splits{(i-1)*SplitsAll+j} = evaluate(nn,zonotope(R0_splits{(i-1)*SplitsAll+j}));
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


    
   % compute image with zonotopes
    clock = tic;
    Z = evaluate(nn,zonotope(R0));
    tComp = toc(clock);
    
    for j=1:2*Neh
        ZB{j} = evaluate(nn,zonotope(R0B{j}));
    end
   
%plot(Z,[1,2],'FaceColor','r');

% for i =1:2*Neh
%     hold on;
%     %plot(pZB{i},[1,2],'y','Splits',2);
%     plot(ZB{i},[1,2],'FaceColor','b');
% end

for i =1:SplitsAll^2
    hold on;
    %plot(pZB{i},[1,2],'y','Splits',2);
    plot(R_splits{i},[1,2],'FaceColor','r');
end

for i=1:4*SplitsB
    RB_splits{i}=evaluate(nn,zonotope(R0B_splits{i}));
    hold on;
    plot(RB_splits{i},[1,2],'FaceColor','b');
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
%saferegion = interval([0.45834;0.4575],[0.45862;0.45783]);
saferegion = interval([0.914304;0.9508425],[0.9143525;0.950896]);

plot(zonotope(saferegion),[1,2],'g','Linewidth', 2);
grid on;
%set (gca,'XTick', 0914:0.9147/0.001:0.007)
%set (gca,'YTick', 09506:0.9512/0.001:0.006)
xlabel('y_{1}');
ylabel('y_{2}');