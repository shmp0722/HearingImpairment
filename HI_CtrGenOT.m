function HI_CtrGenOT

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

%% Take subject names
[dMRI, List] = SubJect;

% % pick up your interesting subject
% if notDefined('nums'),
%     nums = [1:8];
% end
% 
% for ii = 1:length(nums)
%     Subs{ii} = List{nums(ii)};
% end

%% Optic Tract
% Create params structure
ctrParams = ctrInitBatchParams;

% set params
ctrParams.projectName = 'OT_5K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = 'ROIs';
ctrParams.subs = {'HI-SM-20151121','HI-KI-20151121'};

% set parameter
ctrParams.roi1 = {'85_Optic-Chiasm','85_Optic-Chiasm'};
ctrParams.roi2 = {'Rt-LGN4','Lt-LGN4'};

% ctrParams.roi1 = {'85_Optic-Chiasm'};
% ctrParams.roi2 = {'Rt-LGN4'};

ctrParams.nSamples = 5000;  % number of fibers 
ctrParams.maxNodes = 100;   % longest fiber length(mm) 
ctrParams.minNodes = 20;    % shortest fiber length(mm) 
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;

%% generate optic tract
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams

end
