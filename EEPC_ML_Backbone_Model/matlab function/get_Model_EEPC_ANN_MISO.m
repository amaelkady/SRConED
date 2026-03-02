function [R,M,Mye,Ke,Ks,theta_C] = get_Model_EEPC_ANN_MISO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf)

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



%%
load ANN_EEPC_MISO.mat

X_Mye = [(StiffC-ANN_Mye.inputMean(1,1))/ANN_Mye.inputStds(1,1) (pt-ANN_Mye.inputMean(1,2))/ANN_Mye.inputStds(1,2) (tep-ANN_Mye.inputMean(1,3))/ANN_Mye.inputStds(1,3) (d_b-ANN_Mye.inputMean(1,4))/ANN_Mye.inputStds(1,4) (g-ANN_Mye.inputMean(1,5))/ANN_Mye.inputStds(1,5) (tcf-ANN_Mye.inputMean(1,6))/ANN_Mye.inputStds(1,6) (hb-ANN_Mye.inputMean(1,7))/ANN_Mye.inputStds(1,7) (fyP-ANN_Mye.inputMean(1,8))/ANN_Mye.inputStds(1,8) (fyC-ANN_Mye.inputMean(1,9))/ANN_Mye.inputStds(1,9)];
Mye = ANN_Mye.net(X_Mye');
Mye = Mye*ANN_Mye.targetStd + ANN_Mye.targetMean;
Mye = exp(Mye);

% load ANN_Ks.mat % Ks model
X_Ks = [(Load-ANN_Ks.inputMins(1,1))/(ANN_Ks.inputMaxs(1,1)-ANN_Ks.inputMins(1,1)) (StiffC-ANN_Ks.inputMins(1,2))/(ANN_Ks.inputMaxs(1,2)-ANN_Ks.inputMins(1,2)) (pt-ANN_Ks.inputMins(1,3))/(ANN_Ks.inputMaxs(1,3)-ANN_Ks.inputMins(1,3)) (g-ANN_Ks.inputMins(1,4))/(ANN_Ks.inputMaxs(1,4)-ANN_Ks.inputMins(1,4)) (tep-ANN_Ks.inputMins(1,5))/(ANN_Ks.inputMaxs(1,5)-ANN_Ks.inputMins(1,5)) (tcf-ANN_Ks.inputMins(1,6))/(ANN_Ks.inputMaxs(1,6)-ANN_Ks.inputMins(1,6)) (tcw-ANN_Ks.inputMins(1,7))/(ANN_Ks.inputMaxs(1,7)-ANN_Ks.inputMins(1,7)) (hb-ANN_Ks.inputMins(1,8))/(ANN_Ks.inputMaxs(1,8)-ANN_Ks.inputMins(1,8)) (hc-ANN_Ks.inputMins(1,9))/(ANN_Ks.inputMaxs(1,9)-ANN_Ks.inputMins(1,9)) (d_b-ANN_Ks.inputMins(1,10))/(ANN_Ks.inputMaxs(1,10)-ANN_Ks.inputMins(1,10)) (fyP-ANN_Ks.inputMins(1,11))/(ANN_Ks.inputMaxs(1,11)-ANN_Ks.inputMins(1,11)) (fyC-ANN_Ks.inputMins(1,12))/(ANN_Ks.inputMaxs(1,12)-ANN_Ks.inputMins(1,12)) (fub-ANN_Ks.inputMins(1,13))/(ANN_Ks.inputMaxs(1,13)-ANN_Ks.inputMins(1,13))];
Ks = ANN_Ks.net(X_Ks');
Ks = Ks*ANN_Ks.targetStd + ANN_Ks.targetMean;
Ks = exp(Ks);

% load ANN_Ke.mat
X_Ke = [(Load-ANN_Ke.inputMins(1,1))/(ANN_Ke.inputMaxs(1,1)-ANN_Ke.inputMins(1,1)) (StiffC-ANN_Ke.inputMins(1,2))/(ANN_Ke.inputMaxs(1,2)-ANN_Ke.inputMins(1,2)) (pt-ANN_Ke.inputMins(1,3))/(ANN_Ke.inputMaxs(1,3)-ANN_Ke.inputMins(1,3)) (g-ANN_Ke.inputMins(1,4))/(ANN_Ke.inputMaxs(1,4)-ANN_Ke.inputMins(1,4)) (tep-ANN_Ke.inputMins(1,5))/(ANN_Ke.inputMaxs(1,5)-ANN_Ke.inputMins(1,5)) (tcf-ANN_Ke.inputMins(1,6))/(ANN_Ke.inputMaxs(1,6)-ANN_Ke.inputMins(1,6)) (tcw-ANN_Ke.inputMins(1,7))/(ANN_Ke.inputMaxs(1,7)-ANN_Ke.inputMins(1,7)) (d_b-ANN_Ke.inputMins(1,8))/(ANN_Ke.inputMaxs(1,8)-ANN_Ke.inputMins(1,8)) (hb-ANN_Ke.inputMins(1,9))/(ANN_Ke.inputMaxs(1,9)-ANN_Ke.inputMins(1,9)) (hc-ANN_Ke.inputMins(1,10))/(ANN_Ke.inputMaxs(1,10)-ANN_Ke.inputMins(1,10))];
Ke = ANN_Ke.net(X_Ke');
Ke = Ke*ANN_Ke.targetStd + ANN_Ke.targetMean;
Ke = exp(Ke);


% MinMax
 X_theta_C = [(Load-ANN_theta_C.inputMins(1,1))/(ANN_theta_C.inputMaxs(1,1)-ANN_theta_C.inputMins(1,1)) (StiffC-ANN_theta_C.inputMins(1,2))/(ANN_theta_C.inputMaxs(1,2)-ANN_theta_C.inputMins(1,2)) (pt-ANN_theta_C.inputMins(1,3))/(ANN_theta_C.inputMaxs(1,3)-ANN_theta_C.inputMins(1,3)) (g-ANN_theta_C.inputMins(1,4))/(ANN_theta_C.inputMaxs(1,4)-ANN_theta_C.inputMins(1,4)) (tep-ANN_theta_C.inputMins(1,5))/(ANN_theta_C.inputMaxs(1,5)-ANN_theta_C.inputMins(1,5)) (tcf-ANN_theta_C.inputMins(1,6))/(ANN_theta_C.inputMaxs(1,6)-ANN_theta_C.inputMins(1,6)) (tcw-ANN_theta_C.inputMins(1,7))/(ANN_theta_C.inputMaxs(1,7)-ANN_theta_C.inputMins(1,7)) (hb-ANN_theta_C.inputMins(1,8))/(ANN_theta_C.inputMaxs(1,8)-ANN_theta_C.inputMins(1,8)) (hc-ANN_theta_C.inputMins(1,9))/(ANN_theta_C.inputMaxs(1,9)-ANN_theta_C.inputMins(1,9)) (d_b-ANN_theta_C.inputMins(1,10))/(ANN_theta_C.inputMaxs(1,10)-ANN_theta_C.inputMins(1,10)) (fyP-ANN_theta_C.inputMins(1,11))/(ANN_theta_C.inputMaxs(1,11)-ANN_theta_C.inputMins(1,11)) (fyC-ANN_theta_C.inputMins(1,12))/(ANN_theta_C.inputMaxs(1,12)-ANN_theta_C.inputMins(1,12)) (fub-ANN_theta_C.inputMins(1,13))/(ANN_theta_C.inputMaxs(1,13)-ANN_theta_C.inputMins(1,13))];

theta_C = ANN_theta_C.net(X_theta_C');
theta_C = theta_C*ANN_theta_C.targetStd + ANN_theta_C.targetMean;
theta_C = exp(theta_C);

Mc   = Mye+Ks*(theta_C);
Mres = 0.2 * Mc;

if Layout == "8-bolt"
    
    R = [0  Mye/Ke  theta_C   theta_C+0.005           theta_C+0.02];
    M = [0  Mye       Mye+Ks*(theta_C)  0.2*(Mye+Ks*(theta_C))   0.2*(Mye+Ks*(theta_C))];
    
elseif Layout == "10-bolt"
    
    R = [0 Mye/Ke theta_C theta_C+0.005        2*theta_C          2*theta_C   2*theta_C+0.01];
    M = [0 Mye    Mc     (hb/2+pt/2)/hb*Mc   (hb/2+pt/2)/hb*Mc  Mres       Mres];
end   
    
end

