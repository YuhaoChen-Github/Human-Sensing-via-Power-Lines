% --------------------------------------------------------------------------------------------------
%
%    Calculate Terminal Response When There Is a Voltage Source based on Transmission Line Theory. 
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


function [Vs]=Func_Response_TL(x,Vr,l,gamma,Zc)

% reflection coefficient
Zs=50;
rou1=(Zs-Zc)/(Zs+Zc);
rou2=-1;

% voltage at source end
Vs=(exp(-gamma*l)+rou1*exp(-gamma*l))/2/(1-rou1*rou2*exp(-2*gamma*l))*[-(exp(gamma*(l-x))-rou2*exp(-gamma*(l-x)))]*Vr;

end