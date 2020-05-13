%% Beta version 2 calculate Mean and SE in PSC

function B2_MeanPSC(ROI_name)
%Define variables
nsubj = 8;
load repindexoutput.mat
totimg = 284;
b = 2;

grp_size = 4;
hemi = 2;
num_group = totimg./grp_size;

dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';

file0 = sprintf('%s/freesurfer/subj01/label/%s.mgz.ctab',dir_roi,ROI_name);
roi_description = read_ctab(file0);

num_roi = roi_description.numEntries - 1;
roi = roi_description.struct_names;

hemis = ['l','r'];
mn = zeros(nsubj,hemi,num_roi);

drop0 = sprintf('/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/Beta_3/%s',ROI_name); %dir to save out files
mkdir (drop0)

for subjix = 1 : nsubj,subjix % Loop over Subjects

  for hemi = 1 : 2,hemi % For both hemis
    
      a1 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/roi/%ch.%s.nii.gz',dir_roi,subjix,hemis(hemi),ROI_name)); % Load mask
    
      for i = 1 : num_roi,i % Loop over ROIs
      
          ix=find((a1.img>i-1) & (a1.img<i+1)); % Find required voxels by limiting the threshold
       % Create a binary mask with the voxels we want set to 1
      
          vol = zeros(size(a1.img));
       %volsize{subjix} = size(a1.img); % Save volume size
          vol(ix) = 1;
       
          [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii
       
          if (isempty(d1)~=1) % While ROI exists
        
              a3a = h5read(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf/betas_nsdsynthetic.hdf5',dir_beta,subjix),'/betas',[d1(1) d2(1) d3(1) 1],[range(d1)+1 range(d2)+1 range(d3)+1 Inf]);
              betas = squish(a3a,3);       
              betas = single(betas(ii,:))/300;  % voxels x trials
              mn(subjix,hemi,i) = mean(mean(betas)); % one mean value for one ROI in each hemi
          else
              mn(subjix,hemi,i) = nan; % Fill with NaN if ROI doesn't exists
              
          end
      end
  end
end

mn2 = reshape(nanmean(mn,2),nsubj,num_roi); % Average across hemis

mn3 = reshape(nanmean(mn2,1),1,num_roi); % Average across subjects

std3 = reshape(nanstd(mn2,0,1),1,num_roi); % Find standard deviation across subjects
for i = 1:num_roi
  sz = sum(~isnan(mn2(:,i)));
  se3(i) = std3(i)./(sqrt(sz));  % Find SE
end


save(sprintf('NSDSynth_8subj_%dROI_MeanPSC_Beta_ver2_%s.mat',num_roi,ROI_name),'mn2'); % Save out hemi averaged means (subj x ROI)
save(sprintf('NSDSynth_Grandmean_%dROI_Beta_ver2_%s.mat',num_roi,ROI_name),'mn3','se3'); % Save out group average and se
end
  