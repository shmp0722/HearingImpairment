function HI_CtrGenOR(nums)

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

% %% Take subject names
% [dMRI, List, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect;
% 
% % pick up your interesting subject
% if notDefined('nums'),
%     nums = 1:length(List);
% end
% 
% for ii = 1:length(nums)
%     Subs{ii} = List{nums(ii)};
% end

%% Optic Radiation
% Set Params for contrack fiber generation

% Create params structure
ctrParams = ctrInitBatchParams;

% params
ctrParams.projectName = 'OR_100K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = '/ROIs';

% pick up subjects
ctrParams.subs = {'HI-SM-20151121','HI-KI-20151121'};

% set parameter
ctrParams.roi1 = {'Lt-LGN4','Rt-LGN4'};
ctrParams.roi2 = {'lh_V1_smooth3mm_Half','rh_V1_smooth3mm_Half'};

% ctrParams.roi1 = {'Rt-LGN4'};
% ctrParams.roi2 = {'rh_V1_smooth3mm_Half'};

ctrParams.nSamples = 100000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 100; % defalt: 10
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Generate OR usinig Sherbondy's contrack
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams

end
