Neh =2;

epsilon = 0.425;
R0 = scale*interval(-epsilon*ones(Neh,1),epsilon*ones(Neh,1));

for i=1:Neh
    mintemp = R0.inf;
    maxtemp = R0.sup;
    mintemp(i) = R0.sup(i);
    R0B{i}= interval(mintemp,maxtemp);
end

for i=1:Neh
    mintemp = R0.inf;
    maxtemp = R0.sup;
    maxtemp(i) = R0.inf(i);
    R0B{i+Neh}= interval(mintemp,maxtemp);
end


    
   % compute image with zonotopes
    clock = tic;
    Z = evaluate(nn,zonotope(R0));
    tComp = toc(clock);
    
    for j=1:2*Neh
        ZB{j} = evaluate(nn,zonotope(R0B{j}));
    end
   
plot(Z,[1,2],'FaceColor','r');

for i =1:2*Neh
    hold on;
    %plot(pZB{i},[1,2],'y','Splits',2);
    plot(ZB{i},[1,2],'FaceColor','b');
end

%saferegion = interval([0.45834;0.4575],[0.45862;0.45783]);
saferegion = interval([0.9143;0.95085],[0.91435;0.9509]);

plot(zonotope(saferegion),[1,2],'g','Linewidth', 2);
grid on;
%set (gca,'XTick', 0914:0.9147/0.001:0.007)
%set (gca,'YTick', 09506:0.9512/0.001:0.006)
xlabel('y_{1}');
ylabel('y_{2}');