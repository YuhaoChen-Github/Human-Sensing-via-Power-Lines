% --------------------------------------------------------------------------------------------------
%
%    Plot of Analytical Doppler Signature of Human Walking parallelly or vertically to Powerline. 
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

Data=load("Analytical_Walk_Vertical_Doppler.mat");
Data=Data.Data;

%% Figure
image(Data,'CDataMapping','scaled');
colormap(jet); 
caxis([-55,-20]);
cb=colorbar;
cb.Label.String = 'dBV';

yticks([1,201,401,601,801,1001,1201,1401,1601,1801,2001]);
yticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'});
ylim([201,1801]);
xticks([1,1001,2001,3001,4001,5001,6001,7001,8001,9001,10001]);
xticklabels({'0','1','2','3','4','5','6','7','8','9','10'});

% yticks([1321,1331,1341]);
% yticklabels({'32','33','34'});
% ylim([1321,1341]);
% xticks([5501,5601,5701,5801,5901,6001]);
% xticklabels({'5.5','5.6','5.7','5.8','5.9','6'});
% xlim([5501,6001]);

xlabel('Time (s)','FontName','Times New Roman');
ylabel('Doppler Frequency (Hz)','FontName','Times New Roman');
box on; 
set(gca,'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
set (gca,'position',[0.08,0.14,0.8,0.8] );%axis位置，最下角，宽高

% set(gca,'FontName','Times New Roman','FontSize',28,'FontWeight','bold');
% set(gcf,'unit','normalized','position',[0.1,0.1,0.5,0.5]);%figture位置，最下角，宽高
% set (gca,'position',[0.14,0.19,0.68,0.78] );%axis位置，最下角，宽高

exportgraphics(gcf, 'figure.emf')

toc;