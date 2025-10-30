% --------------------------------------------------------------------------------------------------
%
%    HFSS Verification of Analytical Model for Antenna Transmission and Reception. 
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

function sqrt_sigma=Func_RCS(P_human,P_tra,P_rec,f,l,a)

c=3*1e8;
lamda=c/f;
k=2*pi/lamda;

inc=P_human-P_tra;                 
i0=inc/norm(inc,2);                 % unit vector along the incidence direction
sca=P_rec-P_human;
s0=sca/norm(sca,2);                 % unit vector along the scattering direction
r=P_human;                          % position vector
yoz=[0,1,1];
n0=(-inc.*yoz)/norm(-inc.*yoz,2);   % outward surface normal erected anywhere along the specular line
z0=[1,0,0];                         % unit vector along the cylinder axis
er=[0,0,1];                         % unit vector along the electric polarization of a farfield receiver
hi=[-1,0,0];                        % unit vector along the magnetic polarization of incident wave


sqrt_sigma=-1i*l*sqrt(2*k*a/dot(n0,(i0-s0)))*sin(1/2*k*l*dot(z0,(i0-s0)))/(0.5*k*l*dot(z0,(i0-s0)));
sqrt_sigma=sqrt_sigma*(dot(n0,cross(er,hi)))*exp(1i*k*dot(r,(i0-s0)))*exp(1i*k*a*dot(n0,(i0-s0)))*exp(-1i*pi/4);





