function [R,M,Ke, Mye, Ks, theta_C] = get_Model_EEPC_ANN_MIMO(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf)

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


load ANN_EEPC_MIMO.mat

X = [(ANN.inputMins(1,1))/(ANN.inputMaxs(1,1)-ANN.inputMins(1,1)) (StiffC-ANN.inputMins(1,2))/(ANN.inputMaxs(1,2)-ANN.inputMins(1,2)) (pt-ANN.inputMins(1,3))/(ANN.inputMaxs(1,3)-ANN.inputMins(1,3)) (g-ANN.inputMins(1,4))/(ANN.inputMaxs(1,4)-ANN.inputMins(1,4)) (tep-ANN.inputMins(1,5))/(ANN.inputMaxs(1,5)-ANN.inputMins(1,5)) (tcf-ANN.inputMins(1,6))/(ANN.inputMaxs(1,6)-ANN.inputMins(1,6)) (tcw-ANN.inputMins(1,7))/(ANN.inputMaxs(1,7)-ANN.inputMins(1,7)) (hb-ANN.inputMins(1,8))/(ANN.inputMaxs(1,8)-ANN.inputMins(1,8)) (hc-ANN.inputMins(1,9))/(ANN.inputMaxs(1,9)-ANN.inputMins(1,9)) (d_b-ANN.inputMins(1,10))/(ANN.inputMaxs(1,10)-ANN.inputMins(1,10)) (fyP-ANN.inputMins(1,11))/(ANN.inputMaxs(1,11)-ANN.inputMins(1,11)) (fyC-ANN.inputMins(1,12))/(ANN.inputMaxs(1,12)-ANN.inputMins(1,12)) (fub-ANN.inputMins(1,13))/(ANN.inputMaxs(1,13)-ANN.inputMins(1,13))];

Y = ANN.net(X');
Y = Y';

for i = 1:4
    y(1,i) = Y(1,i) * ANN.targetStd(1,i) + ANN.targetMean(1,i);
end

Ke    = exp(y(1,1));
Mye   = exp(y(1,2));
Ks    = exp(y(1,3));
theta_C = exp(y(1,4));

Mc   = Mye+Ks*(theta_C);
Mres = 0.2 * Mc;


if Layout == "8-bolt"
    
    R = [0  Mye/Ke  theta_C    theta_C+0.005           theta_C+0.02];
    M = [0  Mye       Mye+Ks*(theta_C)  0.2*(Mye+Ks*(theta_C))   0.2*(Mye+Ks*(theta_C))];
    
elseif Layout == "10-bolt"
    R = [0  Mye/Ke  theta_C    theta_C+0.005           2*theta_C          2*theta_C   2*theta_C+0.01];
    M = [0  Mye       Mye+Ks*(theta_C)  (hb/2+pt/2)/hb*Mc   (hb/2+pt/2)/hb*Mc  Mres       Mres];
    
end

end

