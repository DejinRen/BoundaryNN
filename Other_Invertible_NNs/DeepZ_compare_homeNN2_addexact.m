Neh =3;

dim1 = 1;
dim2 = 2;

grid on;
xlabel('y_{1}');
ylabel('y_{2}');
hold on;
eps = 0.125;
margin = 0.05;
R0 = interval(-eps*ones(Neh,1),eps*ones(Neh,1));

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
   
plot(Z,[dim1,dim2],'FaceColor','r');
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

hold on;
for x=-eps: margin : eps
    for y =-eps: margin : eps
        for z=-eps: margin : eps
        vec = [x;y;z];
         for i=1:Len+1
            vec= sigmoid(W{i}*vec + b{i});
         end

         plot(vec(dim1),vec(dim2),'y.');
         hold on;
        end
    end
end


 intervaldim1= [0.2884;0.465;0.5752];
 intervaldim2= [0.289;0.466;0.5762];

saferegion = interval(intervaldim1,intervaldim2);

 plot(zonotope(saferegion),[dim1,dim2],'g','Linewidth', 2.5);


function output = sigmoid(x)
output =1./(1+exp(-x));
 end