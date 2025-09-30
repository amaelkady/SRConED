%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the bilinear response of steel flush end-plate
% beam-to-column connections based on the ANN model developed by
% Georgiou and Elkady (2023)
%
% Input:
%---------
% tep        Endplate thickness [mm]
% tcf        Column flange thickness [mm]
% tbf        Beam flange thickness [mm]
% hb         Beam depth [mm]
% hc         Column depth [mm]
% bep  		 Endplate width [mm]
% d_b  		 Bolt nominal diameter [mm]
% et  		 Endplate extension distance on the tension side [mm]
% ert  		 Bolt vertical distance from the endplate edge on the tension side [mm]
% tcw  		 Column web thickness [mm]
% bcf  		 Column flange width [mm]
% Eb  		 Beam modulus of elasticity [MPa]
% fyP  		 Endplate yield stress [MPa]
% fuP  		 Endplate ultimate stress [MPa]
% fub  		 Bolt ultimate stress [MPa]
% IxB  		 Beam seconf moment of inertia about the strong axis [mm4]
% StiffC     Presence of column stiffener ["None": no stiffeners,  "Both": two stiffeners at compression and tension   , "Comp": one stiffener at the compression side]
% Joint      Type of joint ["Cruciform" or "Cantilever"]
%
% Output:
%---------
% Ke:       Initial rotational stiffness [kN.m/rad]
% Ks        Post-yield (strain-hardening) stiffness [kN.m/rad]
% Mye       Effective yield (i.e., plastic) moment [kN.m]
% Response  A 3x2 array containing the predicted M-R response
%
%
% Example: [Ke, Ks, Mye, Response] = Get_ANN_Model_Georgiou_Elkady(12, 15, 15, 300, 250, 120, 16, 10, 50, 12, 150, 200000, 355, 500, 800, 83560000, "None", "Cantilever")
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function    [Ke, Ks, Mye, Response] = Get_ANN_Model_Georgiou_Elkady(tep, tcf, tbf, hb, hc, bep, d_b, et, ert, tcw, bcf, Eb, fyP, fuP, fub, IxB, StiffC, Joint)

dt = ert-et-0.5*tbf;
hcw = hc-2*tcf;

if StiffC=="Both"; StiffC=0; elseif StiffC=="Comp"; StiffC=1 ; else; StiffC=2; end

if Joint=="Cruciform"; Joint=1; else; Joint=2; end

%% ------------------------------------------------------------------------------
% Predicting Mye
% ------------------------------------------------------------------------------

load ('ANN_Mye.mat');

Input=[StiffC; dt; bep; tep; hb; tbf; tcw; bcf; tcf; d_b; fub; fyP];

% Normalize the data
Input= ((Input-features.mean)./features.std);

Mye_norm = net(Input);
Mye = (Mye_norm*target.std)+target.mean;

% ------------------------------------------------------------------------------
% Predicting Ke
% ------------------------------------------------------------------------------

load ('ANN_Beta.mat')

Input=[Joint; StiffC; dt; bep; tep; hb; tbf; hcw; tcf; d_b];

% Normalize the data
Input= (Input-features.min)./(features.max-features.min);

Beta_norm = net(Input);

% Undo normalization
Beta = (Beta_norm*(target.max-target.min))+target.min;
Ke   = Beta * Eb * IxB/1000000;

%% ------------------------------------------------------------------------------
% Predicting Ks
% ------------------------------------------------------------------------------

load ('ANN_Ks.mat')

Input=[StiffC; dt; bep; tep; tbf; hcw; tcw; tcf; d_b; fyP; fuP];

Input= (Input-features.min)./(features.max-features.min);

Ks_norm = net(Input);
Ks = (Ks_norm*(target.max-target.min))+target.min;
Ks = max(Ks, 0.0001);

%% ------------------------------------------------------------------------------
% Construct Bilinear Moment-Rotation Response
% ------------------------------------------------------------------------------

Mc=Mye*1.4;

R = [0 Mye/Ke Mye/Ke+(Mc-Mye)/Ks];
M = [0 Mye    Mc];

Response=[R M];
