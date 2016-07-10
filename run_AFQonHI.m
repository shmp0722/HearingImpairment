function run_AFQonHI

%% Run AFQ_run for these subjects
% set directories

[AFQdata, subs] = SubJect;

%
AMD_Ctl = 9:20;
JMD_Ctl = 38:49;
Ctl     = [24:26,28];
HI      = 35:36;

SubNumber = [HI,Ctl,AMD_Ctl,JMD_Ctl];
%% Make directory structure for each subject
for ii = 1:length(SubNumber)
    sub_dirs{ii} = fullfile(AFQdata, subs{SubNumber(ii)},'dwi_1st');
end

list = sub_dirs'

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
b= zeros(1,length(SubNumber));
b(1,1)=1; b(1,2) =1;
% a(1,1) = 1; 
sub_group = b;
% sub_group = [1,0];

% using spm8
addpath(genpath('/home/ganka/bin/spm8'))

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois',1);
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

% % To have afq overwrite the old fibers
% afq = AFQ_set(afq,'overwritesegmentation');
% afq = AFQ_set(afq,'overwritecleaning');

% % afq.params.cutoff=[5 95];
% afq.params.outdir = ...
%     fullfile(AFQdata,'/AFQ_results/6LHON_9JMD_8Ctl');
afq.params.outdir='/media/HDPC-UT/dMRI_data/Results/HI';

% afq.params.outname = 'AFQ_6LHON_9JMD_8Ctl_1015.mat';
% afq.params.run_mode = 'mrtrix';

%% Run AFQ on these subjects
afq = AFQ_runAO(sub_dirs, sub_group, afq);

afq = AFQ_SegmentCallosum(afq);
return
%% add VOF to afq atructure
% L_VOF
fgName = 'L_VOF.pdb';
roi1Name = afq.roi1names{1,19};
roi2Name = afq.roi2names{1,19};
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

% R_VOF
fgName = 'R_VOF.pdb';
roi1Name = afq.roi1names{1,20};
roi2Name = afq.roi2names{1,20};
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);




