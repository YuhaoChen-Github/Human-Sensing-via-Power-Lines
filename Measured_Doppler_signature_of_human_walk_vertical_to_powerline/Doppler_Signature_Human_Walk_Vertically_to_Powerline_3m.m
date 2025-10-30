% --------------------------------------------------------------------------------------------------
%
%    Plot of Measured Doppler Signature of Human Walking Vertically to Powerline at 3m. 
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

Data=load("3m_Human_Trans.mat");
Data=Data.data;

%% Figure
image(Data,'CDataMapping','scaled');
colormap(jet); 
caxis([-55,-20]);
cb=colorbar;
cb.Label.String = 'dBV';

yticks([1,201,401,601,801,1001,1201,1401,1601,1801,2001]);
yticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'});
ylim([201,1801]);

xticks(0:size(Data,2)/4:size(Data,2));
xticklabels({'0','1','2','3','4'});
xlim([0,size(Data,2)]);

xlabel('Time (s)','FontName','Times New Roman');
ylabel('Frequency (Hz)','FontName','Times New Roman');
box on; 
set(gca,'FontName','Times New Roman','FontSize',28,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
set (gca,'position',[0.14,0.19,0.68,0.78] );%axis位置，最下角，宽高

toc;