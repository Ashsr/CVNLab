clear all
ROI_name = input('Enter ROI name ','s');

B2_MeanPSC(ROI_name)

% For every subject
% Load ROI file 
% Loop for each region 1 - 5
% Find Fixation betas and one back betas
% Plot their Mean and SE

global nsubj;
nsubj = 8;

dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';

global totimg; 
totimg = 284;
b =3;
file0 = sprintf('%s/freesurfer/subj01/label/%s.mgz.ctab',dir_roi,ROI_name);
roi_description = read_ctab(file0);
global num_roi ;
num_roi = roi_description.numEntries - 1;
global grp_size ;
grp_size = 4;
global num_group ;
num_group = totimg./grp_size;
global roi ;
roi = roi_description.struct_names;

hemis = ['l','r'];
global betas ;
tot_task = 2;

drop0 = sprintf('/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/Beta_3/%s',ROI_name); %dir to save out files
%mkdir (drop0)
meanse = [];

% Base script

for subjix = 1 : nsubj,subjix
    for hemi = 1 : 2,hemi
        a1 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/roi/%ch.%s.nii.gz',dir_roi,subjix,hemis(hemi),ROI_name)); % Load ROI
        for i = 1 : num_roi,i
            
            ix=find((a1.img>i-1) & (a1.img<i+1)); % Find required voxels by limiting the threshold
            % Create a binary mask with the voxels we want set to 1
            vol = zeros(size(a1.img));
            vol(ix) = 1;            
            [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii
            
            if (isempty(d1)~=1)
                
                a3a = h5read(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf_GLMdenoise_RR/betas_nsdsynthetic.hdf5',dir_beta,subjix),'/betas',[d1(1) d2(1) d3(1) 1],[range(d1)+1 range(d2)+1 range(d3)+1 Inf]);
                betas = squish(a3a,3);
                betas = single(betas(ii,:))/300;  % voxels x trials
                
                for task = 1:tot_task                                           
                 meanse(subjix,hemi,i,task,:,:) = calculatemeanse(task);
                end
            else
                meanse(subjix,hemi,i,:,:,:) = NaN;
                                                                               
            end
        end
    end            
end

lbl = {'0','WN','BWN','PN','NI1','NI1-1','MO','LD','4%C','6%C','10%C','50%C','NI2','0%PC','25%PC','50%PC','75%PC','NI2','WL1-P1','WL1-P2','WL1-P3','WL1-P4','WL1-P5','WL2-P1','WL2-P2','WL2-P3','WL2-P4','WL2-P5','SF1-R','SF2-R','SF3-R','SF4-R','SF5-R','SF6-R','SF1-CW','SF2-CW','SF3-CW','SF4-CW','SF5-CW','SF6-CW','SF1-CIR','SF2-CIR','SF3-CIR','SF4-CIR','SF5-CIR','SF6-CIR','SF1-CCW','SF2-CCW','SF3-CCW','SF4-CCW','SF5-CCW','SF6-CCW','SCW','LCW','LCCW','SCCW','A-C','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16'};
order = [1,2,3,4,5,6,7,12,11,10,9,8,16,15,14,13,8,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71];
req = meanse(:,:,:,:,order,:);

save(sprintf('%s/NSDSynth_8subj2hemi%droi2tasks72groupsmnandse_b3_%s.mat',drop0,num_roi,ROI_name),'req');

%% Visualise the Mean and SE for each subject

for subjix = 1:nsubj
  for hemi = 1:2    
    for i = 1:num_roi
        f1 = figureprep([0 0 3500 500]);
               
        errorbar3(1:num_group+1,reshape(req(subjix,hemi,i,1,:,1),1,num_group+1),reshape(req(subjix,hemi,i,1,:,2),1,num_group+1),1,[1 0.5 0.5])
        hold on
        errorbar3(1:num_group+1,reshape(req(subjix,hemi,i,2,:,1),1,num_group+1),reshape(req(subjix,hemi,i,2,:,2),1,num_group+1),1,[0.5 0.5 1])
        plot(1:num_group+1,reshape(req(subjix,hemi,i,1,:,1),1,num_group+1),'r','LineWidth',2)
        plot(1:num_group+1,reshape(req(subjix,hemi,i,2,:,1),1,num_group+1),'b','LineWidth',2)
        hold off
        xticks(0:1:num_group+2)
        xticklabels(lbl)
        xtickangle(90)
        ax = axis;
        ylim(max(abs(ax(3:4)))*[-1 1]);
        xlim([0 num_group+2])
        straightline([3.5,7.5,12.5,17.5,22.5,27.5,33.5,38.5,44.5,50.5,54.5,72.5],'v','--k')
        straightline(0,'h','-k')
        title(sprintf('Subj %02d - %ch : ROI %s',subjix,hemis(hemi),roi{i+1}));

        
        nam = sprintf('%s/Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s/',drop0,subjix,hemis(hemi),roi{i+1}); % Change based on ROI
        filename0 = sprintf('NSDSyn_%02d%02d%02d_Group',subjix,hemi,i);

        figurewrite(filename0,f1,[],nam);
        %unix(sprintf('chmod -R g+w %s',drop0));
    end
  end
end

%% Group Average

grpavg1 = req(:,:,:,:,:,1); % Extract the means
hemavg = nanmean(grpavg1,2); % Average across the hemis

for subjix = 1 : nsubj % Normalise after hemi-averaged % Can this loop be avoided? - Norm must be 1D? 
        for i = 1:num_roi
            scale_val = norm(reshape(hemavg(subjix,1,i,:,:),1,(num_group+1)*2)); 
            hemavg(subjix,1,i,:,:) = hemavg(subjix,1,i,:,:)./scale_val;
        end
end

gmean = reshape(nanmean(hemavg,1),num_roi,tot_task,num_group+1);  % mean across subjects
gse = reshape(nanstd(hemavg,0,1) ./ sqrt(sum(~isnan(hemavg),1)),num_roi,tot_task,num_group+1); % se across subjects

save(sprintf('%s/NSDSynth_Groupavg_%droi_2tasks_72groups_mnandse_b3_%s.mat',drop0,num_roi,ROI_name),'gmean','gse'); 
load (sprintf('NSDSynth_Grandmean_%dROI_Beta_ver2_%s.mat',num_roi,ROI_name)) % change for every ROI

s_val = mn3./reshape(mean(reshape(permute(gmean,[1,3,2]),num_roi,2*(num_group+1)),2),size(mn3));

gmean2 = gmean.*repmat(s_val',1,2,num_group+1);
gse2 = gse.*repmat(s_val',1,2,num_group+1);
save(sprintf('%s/NSDSynth_Groupavg_%droi_2tasks_72groups_mnandse_b3_ver2_%s.mat',drop0,num_roi,ROI_name),'gmean2','gse2'); 

% Vis it

f1 = figureprep([0 0 3500 500*num_roi]);
for i = 1:num_roi
        subplot(num_roi,1,i)
        errorbar3(1:num_group+1,reshape(gmean2(i,1,:),1,num_group+1),reshape(gse2(i,1,:),1,num_group+1),1,[1 0.5 0.5])
        hold on
        errorbar3(1:num_group+1,reshape(gmean2(i,2,:),1,num_group+1),reshape(gse2(i,2,:),1,num_group+1),1,[0.5 0.5 1])
        plot(1:num_group+1,reshape(gmean2(i,1,:),1,num_group+1),'r','LineWidth',2)
        plot(1:num_group+1,reshape(gmean2(i,2,:),1,num_group+1),'b','LineWidth',2)
        straightline([3.5,7.5,12.5,17.5,22.5,27.5,33.5,39.5,45.5,51.5,55.5,72.5],'v','--k');
        straightline(0,'h','-k');
        errorbar3(1:num_group+1,ones(1,num_group+1)*mean(gmean2(i,1,:),3),ones(1,num_group+1)*(std(gmean2(i,1,:),0,3)./sqrt(num_group+1)),1,[0.75 0.25 0.75])
        errorbar3(1:num_group+1,ones(1,num_group+1)*mean(gmean2(i,2,:),3),ones(1,num_group+1)*(std(gmean2(i,2,:),0,3)./sqrt(num_group+1)),1,[0.25 0.75 0.75])
        h1 = straightline(mean(gmean2(i,1,:),3),'h','m');
        h2 = straightline(mean(gmean2(i,2,:),3),'h','c');
        
        %set(h1,'LineWidth',2);
        %set(h2,'LineWidth',2);
        xlim([0 num_group+2])
        title(sprintf('Group Average : ROI %s',roi{i + 1}));
        xticks(0:1:num_group+2)
        xticklabels(lbl)
        xtickangle(90)
        ylim([-3 3]);
end
        
        nam = sprintf('%s/Group_Average/',drop0);
        filename0 = sprintf('NSDSyn_Group_Average_b3_fixed');

        figurewrite(filename0,f1,[],nam);
%       unix(sprintf('chmod -R g+w %s',drop0));




%% Local Functions 

function meanse = calculatemeanse(task)

load repindexoutput.mat
global num_group;
global grp_size
global betas
meanse = [];

if task == 1
    indmat = output_fix;
else
    indmat = output_mem;
end

for j = 1:num_group
    
    m = [];
    s = [];
    temp4 = [];
    
    
    for l = 1:grp_size % Can this loop be avoided
        y = (j-1)*grp_size + l;        
        temp3 = cell2mat(indmat(y,:));        
        temp4 = [temp4,betas(:,temp3)];
    end
    
    temp5 = mean(temp4,1);
    [m,s] = meanandse(temp5,2);
    meanse(j,1) = m;
    meanse(j,2) = s;
end
end