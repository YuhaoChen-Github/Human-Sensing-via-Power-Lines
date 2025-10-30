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


clear all; clc; close all;
tic;

%% observation point
PX=1;
PY=2;
PZ=2;

%% TL Calculation using Analytical Model
n=2.2*1e3;
for i=1:n
    f=i*1e6;

    % parameters of powerline
    h=1;
    a=0.565*1e-3;
    l=3;
    Vin=1;

    dl=1e-3;

    z=0:dl:l;
    for j=1:length(z)
        % calculate current along the powerline
        I=Func_Current_TL(z(j),Vin,f,l,h,a);

        % calculate radiated field of real powerline
        Px_real=PX-h;
        Py_real=PY-0;
        Pz_real=PZ-z(j);
        Idl_real=I;
        [Exr(j),Eyr(j),Ezr(j)]=Func_Radiation_Dipole(Px_real,Py_real,Pz_real,f,Idl_real,dl);

        % calculate radiated field of image powerline
        Px_imag=PX-(-h);
        Py_imag=PY-0;
        Pz_imag=PZ-z(j);
        Idl_imag=-I;
        [Exi(j),Eyi(j),Ezi(j)]=Func_Radiation_Dipole(Px_imag,Py_imag,Pz_imag,f,Idl_imag,dl);
    end

    x=-h:dl:h;
    for k=1:length(x)
        % calculate raidated field of source end
        Px_se=PY-0;
        Py_se=PZ-0;
        Pz_se=PX-x(k);
        Idl_se=Func_Current_TL(0,Vin,f,l,h,a);
        [Eyse(k),Ezse(k),Exse(k)]=Func_Radiation_Dipole(Px_se,Py_se,Pz_se,f,Idl_se,dl);

        % calculate raidated field of load end
        Px_le=PY-0;
        Py_le=PZ-l;
        Pz_le=PX-x(k);
        Idl_le=-Func_Current_TL(l,Vin,f,l,h,a);
        [Eyle(k),Ezle(k),Exle(k)]=Func_Radiation_Dipole(Px_le,Py_le,Pz_le,f,Idl_le,dl);
    end

    EX(i)=sum(Exr)+sum(Exi)+sum(Exse)+sum(Exle);
    EY(i)=sum(Eyr)+sum(Eyi)+sum(Eyse)+sum(Eyle);
    EZ(i)=sum(Ezr)+sum(Ezi)+sum(Ezse)+sum(Ezle);
end
EXYZ=sqrt(EX.^2+EY.^2+EZ.^2);
F=1:n;
F=F/1e3;
%% CST Simulation
DataAbs=importdata("CST_X1_Y2_Z2_abs.txt");
DataAbs_CST=DataAbs.data;
F_cst=DataAbs_CST(:,1);
EAbs_cst=DataAbs_CST(:,2)+1i*DataAbs_CST(:,3);

%% Plot
figure()
plot(F,abs(EXYZ),'color','b','LineWidth',1.8,'LineStyle','-');hold on;
plot(F_cst/1e3,abs(EAbs_cst),'Linewidth',1.8,'Color','r','LineStyle','--');hold on;
xlabel('Frequency (GHz)');
ylabel('Electric Field (V/m)');
xlim([0.1 2]);
ylim([0 4]);
legend('Hertzian Dipole Approximation','CST Simulation')
box on; 
set(gca,'FontName','Times New Roman','FontSize',28,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
set (gca,'position',[0.1,0.19,0.86,0.78] );%axis位置，最下角，宽高

toc
