% --------------------------------------------------------------------------------------------------
%
%    Calculate Characteristic Parameters of Powerline Based on Measured S-parameters Data. 
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

function [gamma_f,Zc_f] = Func_Parameters_PL(f)

% Measurement of powerline parameters 
Datas=csvread("short_VNAmaster.csv",42,1,[42,1,237,3]);
Datao=csvread("open_VNAmaster.csv",42,1,[42,1,237,3]);

Fm=Datas(:,1)*1e9;
S11s=Datas(:,2).*cos(Datas(:,3)*pi/180)+1i.*Datas(:,2).*sin(Datas(:,3)*pi/180);
S11o=Datao(:,2).*cos(Datao(:,3)*pi/180)+1i.*Datao(:,2).*sin(Datao(:,3)*pi/180);

Zs=50;
Zsc=(1+S11s)./(1-S11s)*Zs; % input impedance of short terminnal
Zoc=(1+S11o)./(1-S11o)*Zs; % input impedance of open terminnal

Z0=sqrt(Zsc.*Zoc);
phase=angle(Z0)/pi*180;

l_m=3;
gamma=atanh(sqrt(Zsc./Zoc))/l_m;
[value,index]=min(abs(f-Fm));
Zc_f=Z0(index);
gamma_f=gamma(index);

alpha=real(gamma)*8.69;
beta=imag(gamma);

