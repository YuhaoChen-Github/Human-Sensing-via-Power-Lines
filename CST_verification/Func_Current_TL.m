% Start：       20 Feb 2024
% Revise 1:     01 Jul 2024
% --------------------------------------------------------------------------------------------
%
%    CST Verification of Analytical Model for Powerline Radiation. 
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

function [I_TL]=Func_Current_TL(x,Vin,f,l,h,a)

% per-unit-length parameters of single powerline
epsilon_vac=1/36/pi*1e-9;
mu_vac=4*pi*1e-7;
sigma_con=5.98*1e7;
mu_con=mu_vac;

G0=0;
C0=2*pi*epsilon_vac/log(2*h/a);
Y0=G0+1i*2*pi*f*C0;

Rs=sqrt(pi*f*mu_con/sigma_con);
R0=Rs/2/pi/a;
L0=mu_vac/2/pi*log(2*h/a);
Z0=R0+1i*2*pi*f*L0;

Zc=sqrt(Z0/Y0);
gamma=sqrt(Z0*Y0);

% reflection coefficient
Zs=50;Zl=100*1e6;
rou1=(Zs-Zc)/(Zs+Zc);
rou2=(Zl-Zc)/(Zl+Zc);

% currents along powerline
I_TL=(exp(-gamma*x)-rou2*exp(gamma*(x-2*l)))/(2*Zc*(1-rou1*rou2*exp(-2*gamma*l)))*(1-rou1)*Vin;
end