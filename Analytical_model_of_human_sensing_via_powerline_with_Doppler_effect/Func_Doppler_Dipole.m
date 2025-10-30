% --------------------------------------------------------------------------------------------------
%
%    Analytical Model of Reflected Signal Amplitude and Frequency based on Dipole Model. 
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

function [Vs,Doppler]=Func_Doppler_Dipole(human_loc,transmit_loc,receive_loc,f,lamda,I,l,dr,gamma,Zc,transmit_d,H,a,v)
% radiated E-field from transmiting dipole
trans_dir=human_loc-transmit_loc;
[Exr,Eyr,Ezr]=Func_Radiation_Dipole(trans_dir,f,I,dr,transmit_d);

% RCS calculation
sqrt_sigma=Func_RCS(human_loc,transmit_loc,receive_loc,f,H,a);

% attenuation to receiving dipole
receive_dir=human_loc-receive_loc;
atten=norm(receive_dir);

% response at the USRP
Vr=Ezr*sqrt_sigma/atten*dr;
Vs=Func_Response_TL(receive_loc(3),Vr,l,gamma,Zc);

% Doppler frequency
Cos_t=dot(v,-trans_dir)/(norm(v)*norm(-trans_dir));
Cos_r=dot(v,-receive_dir)/(norm(v)*norm(-receive_dir));
Doppler=norm(v)*(Cos_t+Cos_r)/lamda;
end