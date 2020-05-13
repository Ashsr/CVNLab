% For every subject
% Load ROI file 
% Loop for each region 1 - 5
% Find Fixation betas and one back betas
% Plot their Mean and SE

nsubj = 8;
load repindexoutput.mat
totimg = 284;
num_roi = 5;
roi = {'IOG','pFUS','mFUS','mTL','aTL'};
dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';

for subjix = 1: nsubj,subjix
      a1 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1mm/roi/floc-faces.nii.gz',dir_roi,subjix))); % Load mask
      for i = 1:num_roi,i
       ix=find(a1.img>i-1 & a1.img<i+1); % Find required voxels by limiting the threshold
       % Create a binary mask with the voxels we want set to 1
       vol = zeros(size(a1.img));
       volsize{subjix} = size(a1.img); % Save volume size
       vol(ix) = 1;
       nvox(subjix) = size(ix,1); % Save number of voxels  
       ixval{subjix} = ix; % Save voxel indices

       [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii

       a3 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf_GLMdenoise_RR/betas_nsdsynthetic.nii.gz',dir_beta,subjix)));
       temp2 = a3.img;
       vol = int16(vol);
       betas = bsxfun(@times,vol,temp2);
       temp = single(squish(betas(d1,d2,d3,:),3))./300;
       
       
       % Fixation Task
       
       for j = 1:totimg
           m = [];
           s = [];
           temp3 = cell2mat(output_fix(j,:));
           temp4 = temp(:,temp3);
           no_vox = size(temp4,1);
           no_div = nnz(vol);
           temp5 = mean(temp4,1);
           temp5 = temp5.*(no_vox./no_div);
           [m,s] = meanandse(temp5,2);
           meanse(subjix,i,1,j,1) = m;
           meanse(subjix,i,1,j,2) = s;
       end
       
       % Memory Task
       
       for k = 1:totimg
           m = [];
           s = [];
           temp6 = cell2mat(output_mem(k,:));
           temp7 = temp(:,temp6);
           no_vox = size(temp7,1);
           no_div = nnz(vol);
           temp8 = mean(temp7,1);
           temp8 = temp8.*(no_vox./no_div);
           [m2,s2] = meanandse(temp8,2);
           meanse(subjix,i,2,j,1) = m2;
           meanse(subjix,i,2,j,2) = s2;
       end
      end
           
           
       
end

      count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20])  
totimg = 284;

for a = 1:nsubj
    for b = 1:num_roi
    subplot(8,5,count)
    errorbar3(1:totimg,reshape(meanse(a,b,1,:,1),1,totimg),reshape(meanse(a,b,1,:,2),1,totimg),1,[1 0.5 0.5])
    hold on
    errorbar3(1:totimg,reshape(meanse(a,b,2,:,1),1,totimg),reshape(meanse(a,b,2,:,2),1,totimg),1,[0.5 0.5 1])
    hold off
    count = count + 1;
    title(sprintf('Subject %02d - ROI %s',a,cell2str(roi(b))));
    legend('Fixation Task', 'One-back Task');
    end
end

saveas(gcf,'Test1.png','png')