Neh =2;

dim1 = 1;
dim2 = 2;
eps = 0.5;
lb=-0.45; ub=0.3;
margin = 0.02;
R0 = interval(-eps*ones(Neh,1),eps*ones(Neh,1));
Rho = interval(lb*ones(Neh,1),ub*ones(Neh,1));
RNO{1}= interval([-0.5;-0.45],[-0.45;0.5]);
RNO{2}= interval([-0.45;0.3],[0.5;0.5]);
RNO{3}= interval([0.3;-0.5],[0.5;0.3]);
RNO{4}= interval([-0.5;-0.5],[0.3;-0.45]); 
%grid on;
xlabel('x_{1}');
ylabel('x_{2}');
hold on;

plot(R0,[1,2],'r');

for i =1:4
hold on;
plot(RNO{i},[1,2],'FaceColor','b');
end

hold on;
plot(Rho,[1,2],'FaceColor',[255,104,62]/255);

%    %compute image with zonotopes
%     clock = tic;
%     Z = evaluate(nn,zonotope(R0));
%     %Z = evaluate(nn,zonotope(R0),'exact','lin',100);
%     tComp = toc(clock);
%     
%     plot(Z,[dim1,dim2],'FaceColor','r');
%    for i =1:4
%        ZNO{i} = evaluate(nn,zonotope(RNO{i}));
%    end
%    
%    Zho = evaluate(nn,zonotope(Rho));
%    
% for i=1:4
%     hold on;
%     plot(ZNO{i},[1,2],'FaceColor','b');
% end
% hold on;
% 
% hold on;
% %plot(Zho,[1,2],'FaceColor','y');
%    
% for x=-eps:margin:eps
%     for y =-eps:margin:eps
%         vec = [x;y];
%          for i=1:Len+1
%             vec= sigmoid(W{i}*vec + b{i});
%          end
%     
%          plot(vec(1),vec(2),'y.');
%          hold on;
%     end
% end
% saferegion = interval([0.06546;0.07828],[0.06555;0.07832]);
% 
%  plot(zonotope(saferegion),[1,2],'g','Linewidth', 2.5);
% grid on;
% xlabel('y_{1}');
% ylabel('y_{2}');

 function output = sigmoid(x)
output =1./(1+exp(-x));
 end
