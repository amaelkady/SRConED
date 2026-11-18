function [R_XG,M_XG,My_XG,Mye_XG,Ke_XG,Ks_XG,theta_C_XG] = get_Model_EEPC_XGBoost(pt,tep,tcf,tcw,hb,hc,d_b,fyP,fyC,fuC,fuP,fyb,fub,StiffC,Load,g,Layout,tbf,bbf,tweld)


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
load Model_EEPC_XGBoost.mat;

X_Ke       = [Load StiffC pt g tep tcf tcw d_b hb hc];
Ke_XG      = predict(Model_Ke,X_Ke);

X_My       = [StiffC m tep d_b g tcf hb fyP fyC];
My_XG      = predict(Model_My,X_My);

X_Mye      = [StiffC m tep d_b g tcf hb fyP fyC];
Mye_XG     = predict(Model_Mye,X_Mye);

X_Ks       = [Load StiffC m g tep tcf tcw hb hc d_b fyP fyC fub];
Ks_XG      = predict(Model_Ks, X_Ks);

X_theta_C  = [Load StiffC m g tep tcf tcw hb hc d_b fyP fyC fub];
theta_C_XG = predict(Model_theta_C,X_theta_C);

Mc_XG   = Mye_XG+Ks_XG*(theta_C_XG);
Mres_XG = 0.2 * Mc_XG;

if Layout == "8-bolt"
    
    R_XG = [0  My_XG/Ke_XG  Mye_XG/Ke_XG  theta_C_XG   theta_C_XG+0.005     theta_C_XG+0.05];
    M_XG = [0  My_XG        Mye_XG       Mye_XG+Ks_XG*(theta_C_XG)  0.2*(Mye_XG+Ks_XG*(theta_C_XG))   0.2*(Mye_XG+Ks_XG*(theta_C_XG))];
    
elseif Layout == "10-bolt"
    
    R_XG = [0 My_XG/Ke_XG  Mye_XG/Ke_XG theta_C_XG theta_C_XG+0.005        2*theta_C_XG          2*theta_C_XG   2*theta_C_XG+0.01];
    M_XG = [0 My_XG        Mye_XG    Mc_XG     (hb/2+pt/2)/hb*Mc_XG   (hb/2+pt/2)/hb*Mc_XG Mres_XG       Mres_XG];
end   

end

