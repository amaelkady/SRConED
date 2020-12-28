clc;clear all;clear variables;
load FPC1.mat
load FPC2.mat


figure('Color','w','Position', [500 200 450 350]);

plot(x(:,1),x(:,2),'-k','LineWidth',1.2);
set(gca,'fontweight','bold', 'fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation [rad]','FontName','Times New Roman','fontsize',12);
ylabel('Moment [kNm]','FontName','Times New Roman','fontsize',12);
set(gca,'Xlim',[-0.08 0.08]);
set(gca,'Ylim',[-80 80]);
box on;
legend('FPC1');

figure('Color','w','Position', [500 200 450 350]);
plot(y(:,1),y(:,2),'-k','LineWidth',1.2);
set(gca,'fontweight','bold', 'fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation [rad]','FontName','Times New Roman','fontsize',12);
ylabel('Moment [kNm]','FontName','Times New Roman','fontsize',12);
set(gca,'Xlim',[-0.08 0.08]);
set(gca,'Ylim',[-80 80]);
box on;
legend('FPC2');


