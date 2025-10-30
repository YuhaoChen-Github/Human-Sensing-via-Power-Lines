% --------------------------------------------------------------------------------------------------
%
%    Analytical Model of Human Walking Parallelly to Powerline by Calculating Doppler Signature. 
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
c=3*1e8;                % speed of light
f=1.7*1e9;              % carrier frequency
lamda=c/f;              % wavelength
f0=100;                 % frequency range
df=0.1;                 % frequency interval
f_axis=-f0:df:f0;       % frequency vector

%% Parameters of Powerline
h=1;                                % height of powerline
l=30;                               % length of powerline
dr=0.1;                             % dipole length of powerline
[gamma,Zc]=Func_Parameters_PL(f);   % characteristic parameters of powerline

Vin_dBm=20;                                     % output power      
Z_l = Zc/(1i*tanh(gamma*l));                    % input impedance of powerline
Ref_l = (Z_l-50)/(Z_l+50);                      % refelction coefficient of input port
P_l = 10^(Vin_dBm/10)/1e3*(1-(abs(Ref_l))^2);   % corectted power
Vin = sqrt(P_l*Z_l)*sqrt(2);                    % input voltage of powerline

%% Human Movement================================
% Parameters of Human
H=1.8;              % height of human
a=0.3;              % radius of human

% movement parameters
nt=1000;            % frames per second
dt=1/nt;            % time interval
T=10;               % total time
Nt=nt*T+1;          % total steps
Vz_ave=-(l/T);      % average velocity of human in z-direction

% position of human when walk parallelly along the powerline
d = 2;                          % distance between human and powerline
Px_human=ones(1,Nt)*H/2;
Py_human=ones(1,Nt)*d;
Pz_human=abs(Vz_ave)*T:Vz_ave*dt:0;

% velocity of human
Vx=zeros(1,length(Px_human));
Vy=zeros(1,length(Py_human));
Vz=ones(1,length(Pz_human))*Vz_ave;

%% Storage Matrix==========================
nf=size(f_axis,2);
Data=zeros(nf,Nt);

%% Doppler Calculation of Parallel Power Line=========================
%%%%%%  Doppler of power line
% positions of transmiting antenna
for t_z=0:dr:l
    transmit_loc=[h,0,t_z];                     % position of transmitting antenna
    I = Func_Current_TL(t_z,Vin,l,gamma,Zc);    % current on the antenna
    I_r = I;                                    % current on the real antenna
    I_m = -I;                                   % current on the mirror antenna
    transmit_d='z';
    % positions of receiving antenna 
    for r_z=0:dr:l
        receive_loc=[h,0,r_z];                  % position of receiving antenna         
        % movement of human
        for k=1:length(Px_human)
            human_loc=[Px_human(k),Py_human(k),Pz_human(k)];    % position of human
            v=[Vx(k),Vy(k),Vz(k)];                              % velocity of human

            % doppler calculation of real dipole
            [Vs,Doppler]=Func_Doppler_Dipole(human_loc,transmit_loc,receive_loc,f,lamda,I_r,l,dr,gamma,Zc,transmit_d,H,a,v);
            % record amplitude at corresponding position
            [minVal,minIndex]=min(abs(Doppler-f_axis));     % find the position of corresponding frequency
            Data(minIndex,k)=Data(minIndex,k)+Vs;

            % doppler calculation of mirror dipole
            transmit_loc=[-transmit_loc(1),transmit_loc(2),transmit_loc(3)];
            [Vs,Doppler]=Func_Doppler_Dipole(human_loc,transmit_loc,receive_loc,f,lamda,I_m,l,dr,gamma,Zc,transmit_d,H,a,v);
            % record amplitude at corresponding position
            [minVal,minIndex]=min(abs(Doppler-f_axis));
            Data(minIndex,k) = Data(minIndex,k)+Vs;
        end
    end
    % show progress
    t_z
end

%%%%%%  Doppler of source end power line
% positions of transmiting antenna
for t_x=-h:dr:h
    transmit_loc=[t_x,0,0];                 % position of transmitting dipole
    I=Func_Current_TL(0,Vin,l,gamma,Zc);    % current amplitude
    transmit_d='x';                         % current direction
    % positions of receiving antenna
    for r_z=0:dr:l
        receive_loc=[h,0,r_z];              % position of receiving dipole
        for k=1:length(Px_human)
            human_loc=[Px_human(k),Py_human(k),Pz_human(k)];    % human position
            v=[Vx(k),Vy(k),Vz(k)];                              % human velocity

            % doppler calculation of vertical dipole at source end
            [Vs,Doppler] = Func_Doppler_Dipole(human_loc,transmit_loc,receive_loc,f,lamda,I,l,dr,gamma,Zc,transmit_d,H,a,v);
            % record amplitude at corresponding position
            [minVal,minIndex] = min(abs(Doppler-f_axis));
            Data(minIndex,k) = Data(minIndex,k)+Vs;
        end
    end
    % show progress
    t_x_s=t_x
end

%%%%%% Doppler of load end power line
% positions of transmiting antenna
for t_x=-h:dr:h
    transmit_loc=[t_x,0,l];                 % position of transmitting dipole
    I=Func_Current_TL(l,Vin,l,gamma,Zc);    % current of dipole
    I=-I;                                   % current amplitude
    transmit_d='x';                         % current direction
    for r_z=0:dr:l
        % positions of receiving antenna
        receive_loc=[h,0,r_z];              % position of receiving dipole
        for k=1:length(Px_human)
            human_loc=[Px_human(k),Py_human(k),Pz_human(k)];    % human position
            v=[Vx(k),Vy(k),Vz(k)];                              % human velocity

            % doppler calculation of vertical dipole at load end
            [Vs,Doppler]=Func_Doppler_Dipole(human_loc,transmit_loc,receive_loc,f,lamda,I,l,dr,gamma,Zc,transmit_d,H,a,v);
            % record amplitude at corresponding position
            [minVal,minIndex]=min(abs(Doppler-f_axis));
            Data(minIndex,k) = Data(minIndex,k)+Vs;
        end
    end
    % show progress
    t_x_l=t_x
end

Data=20*log10(abs(Data));

%% Figure
image(Data,'CDataMapping','scaled');
colormap(jet); 
caxis([-55,-20]);
colorbar;

yticks([1,201,401,601,801,1001,1201,1401,1601,1801,2001]);
yticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'});
xticks([1,1001,2001,3001,4001,5001,6001,7001,8001,9001,10001]);
xticklabels({'0','1','2','3','4','5','6','7','8','9','10'});

xlabel('Time (s)','FontName','Time New Roman');
ylabel('Doppler Frequency (Hz)','FontName','Time New Roman');
% title('Human with speed 2 m/s, 5 m away from powerline')
box on; 
set(gca,'FontName','Time New Roman','FontSize',16,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
set (gca,'position',[0.1,0.14,0.8,0.8] );%axis位置，最下角，宽高

toc;