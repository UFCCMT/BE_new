load V3;load BE_L;

x1=V3(:,1);
x3=V3(:,2);
x2=V3(:,3);

xp=[x1,x2,x3];

mbe=BE_L;
mbbe=V3(:,4);

prank=frank(mbbe,mbe);
figure;scatter3(xp(:,1),xp(:,2),xp(:,3))
xlabel('Element size');ylabel('Element per processor');zlabel('Number of cores');
set(gca, 'ZScale', 'log')

diff=(mbbe-mbe)./mbbe*100;
dx = 0.1; dy = 0.1; 

figure; 
scatter(mbbe(1:25,:),diff(1:25,:));hold on
scatter(mbbe(26:50,:),diff(26:50,:));hold on
scatter(mbbe(51:75,:),diff(51:75,:));hold on
scatter(mbbe(76:100,:),diff(76:100,:));hold on
scatter(mbbe(101:125,:),diff(101:125,:));hold on
legend('Element size=5','Element size=7','Element size=9','Element size=11','Element size=13')
% text(mbbe+dx, diff+dy, num2str(x1),'FontSize',15);
xlabel('f_{CMT-bone-BE}');ylabel('(f_{CMT-bone-BE}-f_{BE}) /f_{CMT-bone-BE}×100');box on
[M,I]=min(diff);
[min(diff),max(diff),median(diff)];xlim([0,12])