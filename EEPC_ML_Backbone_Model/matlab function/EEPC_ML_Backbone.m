%##########################################################################################################
%##########################################################################################################
%##########################################################################################################
%#
%#  This script generate a full-range moment-rotation prediction for steel extended endplate connections
%   based on machine-learning models
%#
%#  Code by:    Dr Zizhou Ding, University of Southampton, UK
%#              Prof Ahmed Elkady, University of Southampton, UK
%#
%##########################################################################################################
%##########################################################################################################
%##########################################################################################################

%% INPUT DATA

Type   = "MIMO ANN"; % Model type: MISO ANN or MIMO ANN or XGBoost

Load   = "Asym";   % Joint/load configurations: Asym or Sym
Layout = "8-bolt"; % Bolt layout: 8-bolt or 10-bolt
StiffC = "Yes";    % Presencse of column stiffeners: Yes or No

hc  =  300; % Column depth [mm]
bcf =  300; % Column flange width [mm]
tcw =  11;  % Column web thickness [mm]
tcf =  19;  % Column flange thickness [mm]

hb  =  600; % Beam depth [mm]
bbf =  220; % Beam flange width [mm]
tbw =  12;  % Beam web thickness [mm]
tbf =  19;  % Beam flange thickness [mm]

g   =  120;  % Horizontal distance between the bolt columns; i.e., bolt gauge distance [mm]
tep =  12;   % Endplate thickness [mm]
ert =  85;   % Distance from top tension bolt row center to endplate edge [mm]
pt  =  120;  % Distance between the tension bolt rows (above and below the beam flange) [mm]

d_b  = 20;  % Bolt nominal diameter [mm]
As   = 245; % Bolt stress area (threaded part) [mm2]

fyB =  355; % Yield    stress of beam [MPa]
fyC =  355; % Yield    stress of column [MPa]
fuC =  470; % Ultimate stress of column [MPa]
fyP =  355; % Yield    stress of endplate [MPa]
fuP =  470; % Ultimate stress of endplate [MPa]
fyb =  640; % Yield    stress of bolt [MPa]
fub =  800; % Ultimate stress of beam [MPa]

showUncertainty = 0; % Flag for plotting uncertainty: 0/1
z               = 1; % Number of standard deviations to be considered: 1 or 2 or 3

%##########################################################################################################
%##########################################################################################################
%##########################################################################################################

%% Check input

if g>bcf || g>bbf
    errordlg('Bolt gauge length shall be smaller than the column flange width. Please check!','Error');
    return;
end

%% Check validity range

range_flag=0;
str{1}='The connection topology is outside the model validity range for ';
count=2;

if tcf/tep > 1.8 || tcf/tep < 0.5
    str{count}='tcf/tep'; count=count+1;
    range_flag =1;
end

if hb/hc > 2.1 || hb/hc < 0.90
    str{count}='hb/hc'; count=count+1;
    range_flag =1;
end

if d_b/tep > 2 || d_b/tep < 0.55
    str{count}='db/tep'; count=count+1;
    range_flag =1;
end

if pt/tep > 13.5 || pt/tep < 3
    str{count}='pt/tep'; count=count+1;
    range_flag =1;
end

if range_flag==1
    str{count}='. Estimated response might not be accuracte!';
    str=strjoin(str);
    warndlg(str,'Warning: Outside validity range');
end

%% Define uncertainty metrics

mu_rel     = [0.08 0.06 0.15 0.12;
    0.07 0.04 0.15 0.12;
    0.06 0.06 0.12 0.11];
sigma_rel  = [0.10 0.05 0.14 0.11;
    0.07 0.04 0.11 0.10;
    0.08 0.05 0.10 0.09];

%% Compute backbone

if Type == "MISO ANN"

    [R, M, Mye, Ke, Ks,thetaC] = get_Model_EEPC_ANN_MISO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf);

elseif Type == "MIMO ANN"

    [R, M, Ke, Mye, Ks, thetaC] = get_Model_EEPC_ANN_MIMO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf);

elseif Type == "XGBoost"

    [R, M, Mye, Ke, Ks, thetaC] = get_Model_EEPC_XGBoost(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf);

end

%% Plot backbone

figure('position',[100 100 400 300],'color','white');
hold on; grid on; box on;
set(gca, 'fontname', 'times', 'fontsize',18);
plot(R*100, M,'-ok','linewidth',1,'DisplayName','XGBoost');

out{1}=['\itK\rm_{e } = ',num2str(round(Ke)), ' kN.m/rad'];
out{2}=['\itM\rm_{ye} = ',num2str(round(Mye)),' kN.m'];
out{3}=['\itM\rm_{c } = ',num2str(round(Mye+Ks*(thetaC))) ,' kN.m'];
out{4}=['\it\theta\rm_{c }  = ',num2str(round(thetaC*10000)/100) ,' % rads'];

text(1.02*R(end-1)*100, 0.75*((Mye+Ks*(thetaC))),out,'fontname','times','fontsize',13); % out

xlim([0 1.2*R(end)*100]);
ylim([0 1.2*((Mye+Ks*(thetaC)))]);

xlabel('\it\theta\rm [rads]');
ylabel('\itM\rm [kN.m]');

%% Plot uncertainty

if showUncertainty==1

    k = mu_rel(1,1) + z * sigma_rel(1,1);
    Ke_L=Ke/(1+k); Ke_U=Ke/(1-k);
    k = mu_rel(1,2) + z * sigma_rel(1,2);
    Mye_L=Mye/(1+k); Mye_U=Mye/(1-k);
    k = mu_rel(1,3) + z * sigma_rel(1,3);
    Ks_L=Ks/(1+k); Ks_U=Ks/(1-k);
    k = mu_rel(1,4) + z * sigma_rel(1,4);
    thetaC_L=thetaC/(1+k); thetaC_U=thetaC/(1-k);

    R_bound_U = [0  Mye_U/Ke_U  thetaC_U             thetaC_U+0.005              thetaC_U+0.02];
    M_bound_U = [0  Mye_U       Mye_U+Ks_U*thetaC_U  0.2*(Mye_U+Ks_U*thetaC_U)   0.2*(Mye_U+Ks_U*thetaC_U)];

    R_bound_L = [0  Mye_L/Ke_L  thetaC_L               thetaC_L+0.005                thetaC_L+0.02];
    M_bound_L = [0  Mye_L       Mye_L+Ks_L*(thetaC_L)  0.2*(Mye_L+Ks_L*(thetaC_L))   0.2*(Mye_L+Ks_L*(thetaC_L))];

    plot(R_bound_U*100, M_bound_U,'--','Color',[0.6 0.6 0.6],'linewidth',0.5,'HandleVisibility','off');
    plot(R_bound_L*100, M_bound_L,'--','Color',[0.6 0.6 0.6],'linewidth',0.5,'HandleVisibility','off');

    xlim([0 1.2*R_bound_U(end)*100]);
    ylim([0 1.2*(Mye_U+Ks_U*thetaC_U)]);

end

%% Weld failure warning

if pt/tep < 9
    deltaWeldFailure = -35+8.5*(pt/tep);
    rotWeldFailure= deltaWeldFailure/(hb-tbf);
    if rotWeldFailure < thetaC
        warndlg(['Note that this connection may be susceptible to weld failure at rotation less than ', num2str(round(rotWeldFailure*100,1)), '% (prior to bolt failure)'],'Warning: Possibility of early weld failure','replace');
    end
end