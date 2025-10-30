% --------------------------------------------------------------------------------------------------
%
%    Calculate Current along Powerline based Transmission Line Theory. 
%
%                   Release ver. 1.0  (Oct 31, 2025)
%
% --------------------------------------------------------------------------------------------
%
% authors:        Yuhao Chen, et al.
%
% web page:       https://github.com
%
% contact:        yuhao.chen.2019@gmail.com
%
% --------------------------------------------------------------------------------------------
% Copyright (c) 2025 NTU Singapore
% Nanyang Technological University, Singapore.
% All rights reserved.
% This work should be used for nonprofit purposes only.
% --------------------------------------------------------------------------------------------

function [I_TL]=Func_Current_TL(x,Vin,l,gamma,Zc)

% reflection coefficient
Zs=50;
rou1=(Zs-Zc)/(Zs+Zc);
rou2=-1;

% currents along powerline
I_TL=(exp(-gamma*x)-rou2*exp(gamma*(x-2*l)))/(2*Zc*(1-rou1*rou2*exp(-2*gamma*l)))*(1-rou1)*Vin;

end