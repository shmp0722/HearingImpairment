function HI_CleanUpTract_OT5K(subJect)
% To get the Optic Tract is able to analyse.

%%
[homeDir ,subDir] = HI;

% if notDefined('subID'),
%     subID = 1:length(subDir);
% end

%% Set directory
% [homeDir ,subDir] = SubJect;

if notDefined('subJect'),
    [~, subJect] = fileparts(pwd);
end

%% dtiIntersectFibers
% exclude fibers using waypoint ROI
% for ii = subJect
    % INPUTS
    SubDir=fullfile(homeDir,subJect);
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
    roiDir = fullfile(SubDir,'ROIs');
    
    % load fg
    fgf = {'*fg_OT_5K_*Lt*.pdb', '*fg_OT_5K_*Rt*.pdb'};
    % way point ROI. Oposit side WM
    roif= {'41_Right-Cerebral-White-Matter','2_Left-Cerebral-White-Matter'};
    
    for j = 1:2
        % load roi
        roi = dtiReadRoi(fullfile(roiDir,roif{j}));
        % load fg
        fgF = dir(fullfile(fgDir,fgf{j}));
        if length(fgF)==1,
            fg = fgRead(fullfile(fgDir,fgF.name));
        else
            fg = fgRead(fullfile(fgDir,fgF(end).name));
        end
        
        % remove fibers using waypoit ROI 
        [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'not',[],roi,fg);
        
        % keep pathwayInfo and Params.stat for contrack scoring
        keep = ~keep;
        for l = 1:length(fgOut.params)
            fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep);
        end
        fgOut.pathwayInfo = fgOut.pathwayInfo(keep);
        
        % save the fiber tract
        fgOutname = sprintf('%s.pdb',fgOut.name);
        mtrExportFibers(fgOut, fullfile(fgDir,fgOutname),[],[],[],2)      
        fgWrite(fgOut,fullfile(fgDir,[fgOut.name,'.mat']),'mat')

        
        % Pick .txt and .pdb filename
        dTxtF = {'*ctrSampler_OT_5K*Lt-LGN4*.txt'
            '*ctrSampler_OT_5K_*Rt-LGN4*.txt'};
        dTxt = dir(dTxtF{j});
        dPdb = fullfile(fgDir,fgOutname);
        
        % give a filename to the output fiber group
        nFiber=100;
        outputfibername = fullfile(fgDir, sprintf('%s_Ctrk%d.pdb',fgOut.name,nFiber));
        
        % score the fibers to particular number
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt(end).name, outputfibername, nFiber, dPdb);
        %         contrack_score.glxa64 -i ctrSampler.txt -p scoredFgOut_top5000.pdb --thresh 5000 --sort fgIn.pdb
        % run contrack
        system(ContCommand);
        %     end
        % end
        clear fg;
        
        %% AFQ_removeoutlier       
        fgfiles = {...
            '*fg_OT_5K*Lt*_Ctrk100.pdb'
            '*fg_OT_5K*Rt*_Ctrk100.pdb'};
        fgF = dir(fullfile(fgDir,fgfiles{j}));
        fg  = fgRead(fullfile(fgDir,fgF.name));
        
        if ~isempty(fg.fibers)
            % remove outlier
            [fgclean, ~]=AFQ_removeFiberOutliers(fg,4,4,25,'mean',1, 5,[]);
            %         % keep pathwayInfo and Params.stat for contrack scoring
            %         for l = 1:length(fgclean.params)
            %             fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep2);
            %         end
            %         fgclean.pathwayInfo = fgclean.pathwayInfo(keep2);
            fgclean.name = sprintf('%s_AFQ_%d',fgclean.name,length(fgclean.fibers));
            
            %% align fiber direction
            fgclean = SO_AlignFiberDirection(fgclean,'AP');
            % save final fg
%             mtrExportFibers(fgclean, fullfile(fgDir,fgclean.name),[],[],[],2)
            fgWrite(fgclean,fullfile(fgDir,[fgclean.name,'.mat']),'mat')
        end
        clear fg fgclean;
    end
end
