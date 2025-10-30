% --------------------------------------------------------------------------------------------------
%
%    Calculate Radiation of Small Dipole. 
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

function [Ex,Ey,Ez]=Func_Radiation_Dipole(trans_dir,f,I,dl,transmit_d)

Px=trans_dir(1);
Py=trans_dir(2);
Pz=trans_dir(3);

% electrical parameters
c=3*1e8;
k=2*pi*f/c;
Z0=120*pi;

if transmit_d=='z'
    r=sqrt(Px^2+Py^2+Pz^2);
    u=sqrt(Px^2+Py^2);
    U=1/k^2/r^2+1i/k/r;

    % electrical field
    A=-1i*k*I*dl*Z0*exp(-1i*k*r)/4/pi/r^3;
    Ex=A*(Px*Pz)*(3*U-1);
    Ey=A*(Py*Pz)*(3*U-1);
    Ez=A*((2*Pz^2-u^2)*U+u^2);
end

if transmit_d=='x'
    r=sqrt(Px^2+Py^2+Pz^2);
    u=sqrt(Py^2+Pz^2);
    U=1/k^2/r^2+1i/k/r;

    % electrical field
    A=-1i*k*I*dl*Z0*exp(-1i*k*r)/4/pi/r^3;
    Ey=A*(Py*Px)*(3*U-1);
    Ez=A*(Pz*Px)*(3*U-1);
    Ex=A*((2*Px^2-u^2)*U+u^2);
end
end



