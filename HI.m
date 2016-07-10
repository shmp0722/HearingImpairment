function [homeDir, subJect ] =HI

homeDir='/media/HDPC-UT/dMRI_data';
All_List = dir(fullfile(homeDir,'HI*'));

for ii = 1:length(All_List)
    subJect{ii} = All_List(ii).name;
end