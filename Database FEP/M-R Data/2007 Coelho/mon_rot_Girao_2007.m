clc;clear all;clear variables;
load F1EP_15_2.mat
load F2EP_15_2.mat
load F1EP_10_2.mat
load F2EP_10_2.mat

% 
figure('Color','w','Position', [500 200 450 350]);
ax.YAxisLocation = 'origin';
ax.XAxisLocation = 'origin';
plot(x(:,1),x(:,2),'-r','LineWidth',1.2);
hold on
plot(y(:,1),y(:,2),'-g','LineWidth',1.2);
hold on
plot(z(:,1),z(:,2),'-k','LineWidth',1.2);
hold on
plot(za(:,1),za(:,2),'-b','LineWidth',1.2);
hold off
set(gca, 'fontweight','bold','fontname', 'Times New Roman', 'fontsize',14);
hold on; grid on; box on;
xlabel('Rotation  [Rad]','fontweight','bold','FontName','Times New Roman','fontsize',15);
ylabel('Moment [kN-m]','fontweight','bold','FontName','Times New Roman','fontsize',15);
set(gca,'Xlim',[0 0.1]);
set(gca,'Ylim',[0 250]);
box on;
grid on;
legend({'F1EP_15_2','F2EP_15_2','F1EP_10_2','F2EP_10_2'},'fontweight','bold','FontName','Times New Roman','fontsize',14);

