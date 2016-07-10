function HI_CreateNifti

% Transforming dicom files to nii.gz file obtained by SIEMENS 3T scanner in
% Tamagawa University, Machida, JAPAN
%
%  INPUTS:
%   subDir: subject directory name
%   (ex. 'Ctl-SO-20150426')
%   option:  0: default (single masurement. analyzing 'dwi.nii.gz')
%            1: analyzing first diffusion measure 'dwi1st.nii.gz'
%            2: analyzing second diffusion measure 'dwi2nd.nii.gz'
%
%
% (c) SO 2015 @ACH

%% change file format 

% if notDefined('SUBJECT')
 [Home, subDir] = fileparts(pwd);
 SUBJECT = fullfile(Home,subDir);
 T1dir = dir(fullfile(SUBJECT,'*T1*'));
 T1 = dir(fullfile(SUBJECT,T1dir.name,'*iso.nii.gz'));
 t1 = fullfile(SUBJECT,  T1dir.name, T1.name);
 dwi1st = fullfile(SUBJECT,'*DTI1*');
 dwi2nd = fullfile(SUBJECT,'*DTI2*');

% end

% outFormat = 'nii.gz';

% % create nii.gz files 
% if ~exist(fullfile(SUBJECT,'t1.nii.gz'))
%  dicm2nii(T1, SUBJECT, outFormat)
% end
% 
% dicm2nii(dwi1st, dwi1st, outFormat)
% dicm2nii(dwi2nd, dwi2nd, outFormat)

%% make raw foldef under SUBJECT folder

RawFolder = fullfile(SUBJECT,'raw');
if ~exist(RawFolder)
 mkdir(fullfile(SUBJECT,'raw'))
end

%% change file names 

% dwi1st
Bvec = dir(fullfile(dwi1st,'*.bvec')); 
Bval = dir(fullfile(dwi1st,'*.bval'));
Dwi1st = dir(fullfile(dwi1st,'*iso.nii.gz'));
copyfile(fullfile(dwi1st,Bvec.name),fullfile(RawFolder,'dwi1st.bvec'));
copyfile(fullfile(dwi1st,Bval.name),fullfile(RawFolder,'dwi1st.bval'));
copyfile(fullfile(dwi1st,Dwi1st.name),fullfile(RawFolder,'dwi1st.nii.gz'));
clear Bval Bvec

% dwi2nd
if ~exist('Bval') % waiting for finishing previous step completely 
    Bvec = dir(fullfile(dwi2nd,'*.bvec'));
    Bval = dir(fullfile(dwi2nd,'*.bval'));
    Dwi2nd = dir(fullfile(dwi2nd,'*iso.nii.gz'));
    copyfile(fullfile(dwi2nd,Bvec.name),fullfile(RawFolder,'dwi2nd.bvec'));
    copyfile(fullfile(dwi2nd,Bval.name),fullfile(RawFolder,'dwi2nd.bval'));
    copyfile(fullfile(dwi2nd,Dwi2nd.name),fullfile(RawFolder,'dwi2nd.nii.gz'));
    clear Bval Bvec
end
% T1
if ~exist(fullfile(SUBJECT,'t1.nii.gz'))
 T1 = dir(fullfile(SUBJECT,'t1*iso.nii.gz'));
 copyfile(T1.name,'t1.nii.gz');
end
% See also ACH_Preprocess

