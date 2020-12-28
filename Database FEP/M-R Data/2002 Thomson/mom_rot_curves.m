clc;clear all;clear variables;
load EP3.mat
load EP6.mat
load EP2.mat
load EP4.mat
load EP7.mat
load EP8.mat
% 
figure('Color','w','Position', [500 200 450 350]);
plot(x(:,1),x(:,2),'-r','LineWidth',1.2);
hold on
plot(y(:,1),y(:,2),'-g','LineWidth',1.2);
hold off
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[0 0.08]);
set(gca,'Ylim',[0 60]);
box on;
grid on;
legend({'EP3','EP6'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

figure('Color','w','Position', [500 200 450 350]);
plot(z(:,1),z(:,2),'-k','LineWidth',1.2);
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[-0.080 0.08]);
set(gca,'Ylim',[-80 80]);
box on;
grid on;
legend({'EP2'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

figure('Color','w','Position', [500 200 450 350]);
plot(za(:,1),za(:,2),'-k','LineWidth',1.2);
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[-0.080 0.08]);
set(gca,'Ylim',[-60 60]);
box on;
grid on;
legend({'EP4'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

figure('Color','w','Position', [500 200 450 350]);
plot(zb(:,1),zb(:,2),'-k','LineWidth',1.2);
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[-0.080 0.08]);
set(gca,'Ylim',[-50 50]);
box on;
grid on;
legend({'EP7'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

figure('Color','w','Position', [500 200 450 350]);
plot(zc(:,1),zc(:,2),'-k','LineWidth',1.2);
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[-0.080 0.08]);
set(gca,'Ylim',[-50 50]);
box on;
grid on;
legend({'EP8'},'fontweight','bold','FontName','Times New Roman','fontsize',14);