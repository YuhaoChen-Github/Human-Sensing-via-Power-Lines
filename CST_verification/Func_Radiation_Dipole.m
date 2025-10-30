% Start：       20 Feb 2024
% Revise 1:     01 Jul 2024
% --------------------------------------------------------------------------------------------------
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

function [Ex,Ey,Ez]=Func_Radiation_Dipole(Px,Py,Pz,f,I,dl)
% electrical parameters
c=3*1e8;
k=2*pi*f/c;

Z0=120*pi;
r=sqrt(Px^2+Py^2+Pz^2);
u=sqrt(Px^2+Py^2);
U=1/k^2/r^2+1i/k/r;

% electrical field
A=-1i*k*I*dl*Z0*exp(-1i*k*r)/4/pi/r^3;
Ex=A*(Px*Pz)*(3*U-1);
Ey=A*(Py*Pz)*(3*U-1);
Ez=A*((2*Pz^2-u^2)*U+u^2);
end



