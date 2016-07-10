function HI_CleanUpTract_OR100K(subJect)

%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set directory
[homeDir ,subDir] = SubJect;

if notDefined('subID'),
    [~, subJect] = fileparts(pwd);
end


%% Merging waypoint ROIs
% for ii = subJect
    %% make NOT ROI
    
    SubDir = fullfile(homeDir,subJect);
    roiDir = fullfile(SubDir,'ROIs');
    %     cd(roiDir)
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        %         if ii<22
        switch(hemisphere)
            case  1 % Left-WhiteMatter
                roiname = {...
                    '*Right-Cerebellum-White-Matter*'
                    '*Right-Cerebellum-Cortex*'
                    '*Left-Cerebellum-White-Matter*'
                    '*Left-Cerebellum-Cortex*'
                    '*Left-Hippocampus*'
                    '*Right-Hippocampus*'
                    '*Left-Lateral-Ventricle*'
                    '*Right-Lateral-Ventricle*'
                    '*Left-Cerebral-White-Matter*'};
            case 2 % Right-WhiteMatter
                roiname = {...
                    '*Right-Cerebellum-White-Matter*'
                    '*Right-Cerebellum-Cortex*'
                    '*Left-Cerebellum-White-Matter*'
                    '*Left-Cerebellum-Cortex*'
                    '*Left-Hippocampus*'
                    '*Right-Hippocampus*'
                    '*Left-Lateral-Ventricle*'
                    '*Right-Lateral-Ventricle*'
                    '*Right-Cerebral-White-Matter*'};
        end
        
        % load all ROIs
        for j = 1:length(roiname)
            RoiFile = dir(fullfile(roiDir,roiname{j}));
            roi{j} = dtiReadRoi(fullfile(roiDir,RoiFile(1).name));
        end
        
        
        % Merge ROI one by one
        newROI = roi{1,1};
        for kk=2:length(roiname)
            if ~isempty(roi{kk}.coords)
                newROI = dtiMergeROIs(newROI,roi{1,kk});
            end;
        end
        
        % Save the new NOT ROI
        % define file name
        
        switch(hemisphere)
            case 1 % Left-WhiteMatter
                newROI.name = 'Lh_NOT';
            case 2 % Right-WhiteMatter
                newROI.name = 'Rh_NOT';
        end
        % Save Roi
        dtiWriteRoi(newROI,fullfile(roiDir,newROI.name),1)
        clear roi newROI
    end
% end

%% remove fibers from raw conTrack fibers
% for ii = subJect
    SubDir = fullfile(homeDir,subJect);
    fgDir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_100K');
    roiDir = fullfile(SubDir,'/ROIs');
    %     newDir = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_1130');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_1st');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
                
        fgF = {'*Rt-LGN4_rh_V1_smooth3mm_Half*.pdb'
            '*Lt-LGN4_lh_V1_smooth3mm_Half*.pdb'};
        
        % load fg and ROI
        fg  = dir(fullfile(fgDir,fgF{hemisphere}));
        fg  = fgRead(fullfile(fgDir,fg.name));
        
        % Load a waypoint ROI
        ROIname = {'Lh_NOT.mat','Rh_NOT.mat'};
        ROIf = fullfile(roiDir, ROIname{hemisphere});
        ROI = dtiReadRoi(ROIf);
        
        % Remove fibers going through a waypoint ROI
        [fgOut1,~, keep1, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
        keep = ~keep1;
        for l =1:length(fgOut1.params)
            fgOut1.params{1,l}.stat=fgOut1.params{1,l}.stat(keep);
        end
        fgOut1.pathwayInfo = fgOut1.pathwayInfo(keep);
        
        % correct fiber direction anterior to posteror
        [fgOut1] = SO_AlignFiberDirection(fgOut1,'AP');
        
        % remove outlier fiber
        for k=4:5; % max distance
            maxDist = k;
            maxLen = 4;
            numNodes = 25;
            M = 'mean';
            count = 1;
            show = 1;
            
            [fgclean ,keep] =  AFQ_removeFiberOutliers(fgOut1,maxDist,maxLen,numNodes,M,count,show);
            
            for l =1:length(fgclean.params)
                fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep);
            end
            fgclean.pathwayInfo = fgclean.pathwayInfo(keep);
            
            % save new fg.pdb file
            fibername       = sprintf('%s_MD%d.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fullfile(fgDir,fibername),[],[],[],2);
            clear fgclean
        end
    end
% end
return

