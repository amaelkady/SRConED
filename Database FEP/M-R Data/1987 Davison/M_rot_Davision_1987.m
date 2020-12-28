clc;clear all;clear variables;
load JT11.mat
load JT11B.mat
load JT12.mat
figure('Color','w','Position', [500 200 450 350]);

plot(x(:,1),x(:,2),'b','LineWidth',1.2);
hold on
plot(y(:,1),y(:,2),'r','LineWidth',1.2);
hold on
plot(z(:,1),z(:,2),'k','LineWidth',1.2);
set(gca, 'fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation [rad]','fontweight','bold','FontName','Times New Roman','fontsize',16);
ylabel('Moment [kNm]','fontweight','bold','FontName','Times New Roman','fontsize',16);
set(gca,'Xlim',[0 0.03]);
set(gca,'Ylim',[0 70]);
box on;
legend({'JT11','JT11B','JT12'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

figure('Color','w','Position', [500 200 450 350]);
% scatter(x(1:30,1),x(1:30,2),'r*');
% hold on
%  scatter(y(1:7,1),y(1:7,2),'b','LineWidth',1.2);
% hold on
scatter(z(1:10,1),z(1:10,2),'k','LineWidth',1.2);
set(gca, 'fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation [rad]','fontweight','bold','FontName','Times New Roman','fontsize',16);
ylabel('Moment [kNm]','fontweight','bold','FontName','Times New Roman','fontsize',16);
set(gca,'Xlim',[0 0.03]);
set(gca,'Ylim',[0 70]);
box on;
legend({'JT11'},'fontweight','bold','FontName','Times New Roman','fontsize',14);
