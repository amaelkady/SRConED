function [R_ANN_MISO,M_ANN_MISO,My_A, Mye_A,Ke_A,Ks_A,theta_C_A] = get_Model_EEPC_ANN_MISO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf, tweld)

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

%%
load  Model_EEPC_ANN_MISO.mat;

X_My = [(StiffC-ANN_My.inputMean(1,1))/ANN_My.inputStds(1,1) (m-ANN_My.inputMean(1,2))/ANN_My.inputStds(1,2) (tep-ANN_My.inputMean(1,3))/ANN_My.inputStds(1,3) (d_b-ANN_My.inputMean(1,4))/ANN_My.inputStds(1,4) (g-ANN_My.inputMean(1,5))/ANN_My.inputStds(1,5) (tcf-ANN_My.inputMean(1,6))/ANN_My.inputStds(1,6) (hb-ANN_My.inputMean(1,7))/ANN_My.inputStds(1,7) (fyP-ANN_My.inputMean(1,8))/ANN_My.inputStds(1,8) (fyC-ANN_My.inputMean(1,9))/ANN_My.inputStds(1,9)];
My_A = ANN_My.net(X_My');
My_A = My_A*ANN_My.targetStd + ANN_My.targetMean;
My_A = exp(My_A);

X_Mye = [(StiffC-ANN_Mye.inputMean(1,1))/ANN_Mye.inputStds(1,1) (m-ANN_Mye.inputMean(1,2))/ANN_Mye.inputStds(1,2) (tep-ANN_Mye.inputMean(1,3))/ANN_Mye.inputStds(1,3) (d_b-ANN_Mye.inputMean(1,4))/ANN_Mye.inputStds(1,4) (g-ANN_Mye.inputMean(1,5))/ANN_Mye.inputStds(1,5) (tcf-ANN_Mye.inputMean(1,6))/ANN_Mye.inputStds(1,6) (hb-ANN_Mye.inputMean(1,7))/ANN_Mye.inputStds(1,7) (fyP-ANN_Mye.inputMean(1,8))/ANN_Mye.inputStds(1,8) (fyC-ANN_Mye.inputMean(1,9))/ANN_Mye.inputStds(1,9)];
Mye_A = ANN_Mye.net(X_Mye');
Mye_A = Mye_A*ANN_Mye.targetStd + ANN_Mye.targetMean;
Mye_A = exp(Mye_A);

X_Ks = [(Load-ANN_Ks.inputMins(1,1))/(ANN_Ks.inputMaxs(1,1)-ANN_Ks.inputMins(1,1)) (StiffC-ANN_Ks.inputMins(1,2))/(ANN_Ks.inputMaxs(1,2)-ANN_Ks.inputMins(1,2)) (m-ANN_Ks.inputMins(1,3))/(ANN_Ks.inputMaxs(1,3)-ANN_Ks.inputMins(1,3)) (g-ANN_Ks.inputMins(1,4))/(ANN_Ks.inputMaxs(1,4)-ANN_Ks.inputMins(1,4)) (tep-ANN_Ks.inputMins(1,5))/(ANN_Ks.inputMaxs(1,5)-ANN_Ks.inputMins(1,5)) (tcf-ANN_Ks.inputMins(1,6))/(ANN_Ks.inputMaxs(1,6)-ANN_Ks.inputMins(1,6)) (tcw-ANN_Ks.inputMins(1,7))/(ANN_Ks.inputMaxs(1,7)-ANN_Ks.inputMins(1,7)) (hb-ANN_Ks.inputMins(1,8))/(ANN_Ks.inputMaxs(1,8)-ANN_Ks.inputMins(1,8)) (hc-ANN_Ks.inputMins(1,9))/(ANN_Ks.inputMaxs(1,9)-ANN_Ks.inputMins(1,9)) (d_b-ANN_Ks.inputMins(1,10))/(ANN_Ks.inputMaxs(1,10)-ANN_Ks.inputMins(1,10)) (fyP-ANN_Ks.inputMins(1,11))/(ANN_Ks.inputMaxs(1,11)-ANN_Ks.inputMins(1,11)) (fyC-ANN_Ks.inputMins(1,12))/(ANN_Ks.inputMaxs(1,12)-ANN_Ks.inputMins(1,12)) (fub-ANN_Ks.inputMins(1,13))/(ANN_Ks.inputMaxs(1,13)-ANN_Ks.inputMins(1,13))];
Ks_A = ANN_Ks.net(X_Ks');
Ks_A = Ks_A*ANN_Ks.targetStd + ANN_Ks.targetMean;
Ks_A = exp(Ks_A);

X_Ke = [(Load-ANN_Ke.inputMins(1,1))/(ANN_Ke.inputMaxs(1,1)-ANN_Ke.inputMins(1,1)) (StiffC-ANN_Ke.inputMins(1,2))/(ANN_Ke.inputMaxs(1,2)-ANN_Ke.inputMins(1,2)) (m-ANN_Ke.inputMins(1,3))/(ANN_Ke.inputMaxs(1,3)-ANN_Ke.inputMins(1,3)) (g-ANN_Ke.inputMins(1,4))/(ANN_Ke.inputMaxs(1,4)-ANN_Ke.inputMins(1,4)) (tep-ANN_Ke.inputMins(1,5))/(ANN_Ke.inputMaxs(1,5)-ANN_Ke.inputMins(1,5)) (tcf-ANN_Ke.inputMins(1,6))/(ANN_Ke.inputMaxs(1,6)-ANN_Ke.inputMins(1,6)) (tcw-ANN_Ke.inputMins(1,7))/(ANN_Ke.inputMaxs(1,7)-ANN_Ke.inputMins(1,7)) (d_b-ANN_Ke.inputMins(1,8))/(ANN_Ke.inputMaxs(1,8)-ANN_Ke.inputMins(1,8)) (hb-ANN_Ke.inputMins(1,9))/(ANN_Ke.inputMaxs(1,9)-ANN_Ke.inputMins(1,9)) (hc-ANN_Ke.inputMins(1,10))/(ANN_Ke.inputMaxs(1,10)-ANN_Ke.inputMins(1,10))];
Ke_A = ANN_Ke.net(X_Ke');
Ke_A = Ke_A*ANN_Ke.targetStd + ANN_Ke.targetMean;
Ke_A = exp(Ke_A);

 X_theta_C = [(Load-ANN_theta_C.inputMins(1,1))/(ANN_theta_C.inputMaxs(1,1)-ANN_theta_C.inputMins(1,1)) (StiffC-ANN_theta_C.inputMins(1,2))/(ANN_theta_C.inputMaxs(1,2)-ANN_theta_C.inputMins(1,2)) (m-ANN_theta_C.inputMins(1,3))/(ANN_theta_C.inputMaxs(1,3)-ANN_theta_C.inputMins(1,3)) (g-ANN_theta_C.inputMins(1,4))/(ANN_theta_C.inputMaxs(1,4)-ANN_theta_C.inputMins(1,4)) (tep-ANN_theta_C.inputMins(1,5))/(ANN_theta_C.inputMaxs(1,5)-ANN_theta_C.inputMins(1,5)) (tcf-ANN_theta_C.inputMins(1,6))/(ANN_theta_C.inputMaxs(1,6)-ANN_theta_C.inputMins(1,6)) (tcw-ANN_theta_C.inputMins(1,7))/(ANN_theta_C.inputMaxs(1,7)-ANN_theta_C.inputMins(1,7)) (hb-ANN_theta_C.inputMins(1,8))/(ANN_theta_C.inputMaxs(1,8)-ANN_theta_C.inputMins(1,8)) (hc-ANN_theta_C.inputMins(1,9))/(ANN_theta_C.inputMaxs(1,9)-ANN_theta_C.inputMins(1,9)) (d_b-ANN_theta_C.inputMins(1,10))/(ANN_theta_C.inputMaxs(1,10)-ANN_theta_C.inputMins(1,10)) (fyP-ANN_theta_C.inputMins(1,11))/(ANN_theta_C.inputMaxs(1,11)-ANN_theta_C.inputMins(1,11)) (fyC-ANN_theta_C.inputMins(1,12))/(ANN_theta_C.inputMaxs(1,12)-ANN_theta_C.inputMins(1,12)) (fub-ANN_theta_C.inputMins(1,13))/(ANN_theta_C.inputMaxs(1,13)-ANN_theta_C.inputMins(1,13))];

theta_C_A = ANN_theta_C.net(X_theta_C');
theta_C_A = theta_C_A*ANN_theta_C.targetStd + ANN_theta_C.targetMean;
theta_C_A = exp(theta_C_A);

Mc   = Mye_A+Ks_A*(theta_C_A);
Mres = 0.2 * Mc;

if Layout == "8-bolt"
    
    R_ANN_MISO = [0  My_A/Ke_A  Mye_A/Ke_A  theta_C_A   theta_C_A+0.005           theta_C_A+0.02];
    M_ANN_MISO = [0  My_A       Mye_A       Mye_A+Ks_A*(theta_C_A)  0.2*(Mye_A+Ks_A*(theta_C_A))   0.2*(Mye_A+Ks_A*(theta_C_A))];
    
elseif Layout == "10-bolt"
    
    R_ANN_MISO = [0 My_A/Ke_A Mye_A/Ke_A theta_C_A theta_C_A+0.005        2*theta_C_A          2*theta_C_A   2*theta_C_A+0.01];
    M_ANN_MISO = [0 My_A      Mye_A    Mc     (hb/2+pt/2)/hb*Mc   (hb/2+pt/2)/hb*Mc  Mres       Mres];
end   
    

