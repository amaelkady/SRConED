function [R_ANN_MIMO,M_ANN_MIMO,Ke_A_All, My_A_All, Mye_A_All, Ks_A_All, theta_A_All] = get_Model_EEPC_ANN_MIMO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf, tweld)

%% Encoding the StiffenerC and Setup
if StiffC == "Yes"
    StiffC = 1;
else
    StiffC = 0;
end

if contains(Load,'Sym')
    Load = 0;
else
    Load = 1;
end

m = (pt-tbf)/2-0.8*tweld;


load  Model_EEPC_ANN_MIMO.mat;

X = [(Load-ANN_All.inputMins(1,1))/(ANN_All.inputMaxs(1,1)-ANN_All.inputMins(1,1)) (StiffC-ANN_All.inputMins(1,2))/(ANN_All.inputMaxs(1,2)-ANN_All.inputMins(1,2)) (m-ANN_All.inputMins(1,3))/(ANN_All.inputMaxs(1,3)-ANN_All.inputMins(1,3)) (g-ANN_All.inputMins(1,4))/(ANN_All.inputMaxs(1,4)-ANN_All.inputMins(1,4)) (tep-ANN_All.inputMins(1,5))/(ANN_All.inputMaxs(1,5)-ANN_All.inputMins(1,5)) (tcf-ANN_All.inputMins(1,6))/(ANN_All.inputMaxs(1,6)-ANN_All.inputMins(1,6)) (tcw-ANN_All.inputMins(1,7))/(ANN_All.inputMaxs(1,7)-ANN_All.inputMins(1,7)) (hb-ANN_All.inputMins(1,8))/(ANN_All.inputMaxs(1,8)-ANN_All.inputMins(1,8)) (hc-ANN_All.inputMins(1,9))/(ANN_All.inputMaxs(1,9)-ANN_All.inputMins(1,9)) (d_b-ANN_All.inputMins(1,10))/(ANN_All.inputMaxs(1,10)-ANN_All.inputMins(1,10)) (fyP-ANN_All.inputMins(1,11))/(ANN_All.inputMaxs(1,11)-ANN_All.inputMins(1,11)) (fyC-ANN_All.inputMins(1,12))/(ANN_All.inputMaxs(1,12)-ANN_All.inputMins(1,12)) (fub-ANN_All.inputMins(1,13))/(ANN_All.inputMaxs(1,13)-ANN_All.inputMins(1,13))];

Y = ANN_All.net(X');
Y = Y';

for i = 1:5
    y(1,i) = Y(1,i) * ANN_All.targetStd(1,i) + ANN_All.targetMean(1,i);
end

Ke_A_All      = exp(y(1,1));
My_A_All      = exp(y(1,2));
Mye_A_All     = exp(y(1,3));
Ks_A_All      = exp(y(1,4));
theta_A_All = exp(y(1,5));

Mc   = Mye_A_All+Ks_A_All*(theta_A_All);
Mres = 0.2 * Mc;


if Layout == "8-bolt"
    
    R_ANN_MIMO = [0  My_A_All/Ke_A_All Mye_A_All/Ke_A_All  theta_A_All    theta_A_All+0.005           theta_A_All+0.02];
    M_ANN_MIMO = [0  My_A_All          Mye_A_All       Mye_A_All+Ks_A_All*(theta_A_All)  0.2*(Mye_A_All+Ks_A_All*(theta_A_All))   0.2*(Mye_A_All+Ks_A_All*(theta_A_All))];
    
elseif Layout == "10-bolt"
    R_ANN_MIMO = [0  My_A_All/Ke_A_All Mye_A_All/Ke_A_All  theta_A_All    theta_A_All+0.005           2*theta_A_All          2*theta_A_All   2*theta_A_All+0.01];
    M_ANN_MIMO = [0  My_A_All          Mye_A_All       Mye_A_All+Ks_A_All*(theta_A_All)  (hb/2+pt/2)/hb*Mc   (hb/2+pt/2)/hb*Mc  Mres       Mres];
    
end

end

