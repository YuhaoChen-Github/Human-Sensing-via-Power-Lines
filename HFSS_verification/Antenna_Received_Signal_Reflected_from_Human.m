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

clc; clear; close all;
tic;

%% frequency parameters
% constant
c=3*1e8;        % speed of light

%% Human
% Parameters of Human
H=1.8;              % height of human
a=0.2;              % radius of human

% position and velocity of human 
Px_human=H/2;       % heihgt of human
Py_human=1;         % distance between human and powerline
Pz_human=10;         % coordinate value along powerline
human_loc=[Px_human,Py_human,Pz_human];

%% Antenna
% Parameters of antenna
L=0.06;
r_a=0.002;
mu=4*pi*1e-7;
sigma=5.8*1e7;
% Position of transmitting antenna
transmit_loc=[1,0,0];
% Position of receiving antenna
receive_loc=[1,0,20];


%% Analytical Calculation
% Frequency
F=1*1e9:0.01*1e9:4*1e9;

Vout=0;
for i=1:length(F)
    f=F(i);
    lamda=c/f;            % wavelength
    % input impedance of small antenna
    Rrad=20*pi^2*(L/lamda)^2;
    Rloss=sqrt(pi*f*mu/sigma)*L/2/pi/r_a;
    Xin=120*(log(L/2/a)-1)/(2*pi/lamda)/L;
    Zin=Rrad+Rloss+1i*Xin;

    % current of transmitting antenna
    Vin=1;
    I=Vin/Zin;
    transmit_d='z';

    % receiving voltage from real dipole
    [Vr]=Func_Reflection_Dipole(human_loc,transmit_loc,receive_loc,f,I,L,transmit_d,H,a);
    Vout=Vout+Vr;

    % receiving voltage from mirror dipole
    transmit_loc=[-transmit_loc(1),transmit_loc(2),transmit_loc(3)];
    I=-I;
    [Vr]=Func_Reflection_Dipole(human_loc,transmit_loc,receive_loc,f,I,L,transmit_d,H,a);
    Vout=Vout+Vr;

    S21=20*log10(abs(Vout/Vin));
    S21_Analysis(i)=S21;
end

%% HFSS Calculation
S21_HFSS=importdata("HFSS\S Parameter Plot_t0r20_no_human.csv");
S21_HFSS=S21_HFSS.data;
F_HFSS=S21_HFSS(:,1);
S21_HFSS=S21_HFSS(:,2);

S21_HFSS_2=importdata("HFSS\S Parameter Plot_t0r20_with_human.csv");
S21_HFSS_2=S21_HFSS_2.data;
F_HFSS_2=S21_HFSS_2(:,1);
S21_HFSS_2=S21_HFSS_2(:,2);

S21_HFSS_Human=20*log10(abs(10.^(S21_HFSS/20)-10.^(S21_HFSS_2/20)));

%% Figure
plot(F/1e9,S21_Analysis,"Color",'r','LineWidth',2.4); hold on;
plot(F_HFSS,S21_HFSS_Human,"Color",'b','LineWidth',2.4);
legend('Analytical Method','HFSS Simulation');
xlim([1,2]);
ylim([-150,0]);
xlabel('Frequnecy (GHz)','FontName','Time New Roman');
ylabel('S_{21}/dB','FontName','Time New Roman');
box on; 
set(gca,'FontName','Times New Roman','FontSize',28,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
set (gca,'position',[0.18,0.19,0.8,0.78] );%axis位置，最下角，宽高

toc;