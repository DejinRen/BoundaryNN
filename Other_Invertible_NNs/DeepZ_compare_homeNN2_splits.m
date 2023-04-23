Neh =3;

dim1 = 1;
dim2 = 2;
eps = 0.375;
lb=-eps*ones(Neh,1);
ub=eps*ones(Neh,1);
R0 = interval(lb,ub);

Splits =5;
intervalStep(1) = (ub(1)-lb(1))/Splits;
  intervalStep(2) = (ub(2)-lb(2))/Splits;
  intervalStep(3) = (ub(3)-lb(3))/Splits;
  for i=1:Splits
      for j =1:Splits
          for k =1:Splits
             lbsplit(1) = lb(1) + (i-1)*intervalStep(1);
             lbsplit(2) = lb(2) + (j-1)*intervalStep(2);
             lbsplit(3) = lb(3) + (k-1)*intervalStep(3);
             ubsplit(1) = lb(1) + i*intervalStep(1);
             ubsplit(2) = lb(2) + j*intervalStep(2);
              ubsplit(3) = lb(3) + k*intervalStep(3);

          count = (((i-1)*Splits+j)-1)*Splits+k;
      R0_splits{count} = interval(lbsplit', ubsplit');
      
%       hold on;
%       plot(interval(lbsplit', ubsplit'),[1,2],'b');
      R_splits{count} = evaluate(nn,zonotope(R0_splits{count}));
          end
      end
  end
  
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
    %Z = evaluate(nn,zonotope(R0),'exact','lin',100);
    tComp = toc(clock);
    
    for j=1:2*Neh
        %ZB{j} = evaluate(nn,zonotope(R0B{j}),'exact','lin',150);
        ZB{j} = evaluate(nn,zonotope(R0B{j}));
    end
   
%plot(Z,[dim1,dim2],'FaceColor','r');
%VZ = vertices(Z);

% for i =1:size(VZ,2)-1
%     line(VZ(:,i),VZ(:,i+1));
% end
%plot3(VZ(1,:),VZ(2,:),VZ(3,:),'-');

% DT = delaunayTriangulation(VZ');
% [K,v] = convexHull(DT);
% trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','g','FaceAlpha',.2);

for i =1:2*Neh
    hold on;
    %plot(pZB{i},[1,2],'y','Splits',2);
    
    %VZB{i} = vertices(ZB{i});
    plot(ZB{i},[dim1,dim2],'FaceColor','b');
%     DT = delaunayTriangulation(VZB{i}');
% [K,v] = convexHull(DT);
%trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','b','FaceAlpha',.2);
end

  for i=1:Splits^3
      hold on;
      plot(R_splits{i},[dim1,dim2],'FaceColor','g');
  end
%saferegion = interval([0.45834;0.4575],[0.45862;0.45783]);
saferegion = interval([0.458375;0.45764],[0.458487;0.457748]);

% plot(zonotope(saferegion),[1,2],'g','Linewidth', 2);
% for i=1:8
%     hold on;
%     plot(R0_splits{i},[1,2],'b');
% end
grid on;
xlabel('y_{1}');
ylabel('y_{2}');