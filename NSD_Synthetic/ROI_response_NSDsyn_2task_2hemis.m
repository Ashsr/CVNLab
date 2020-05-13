% For every subject
% Load ROI file 
% Loop for each region 1 - 5
% Find Fixation betas and one back betas
% Plot their Mean and SE

nsubj = 8;
load repindexoutput.mat
totimg = 284;
num_roi = 5;
grp_size = 4;
num_group = totimg./grp_size;
roi = {'IOG','pFUS','mFUS','mTL','aTL'};
dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';
hemis = ['l','r'];

for subjix = 1: nsubj,subjix
    
    %a3 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf_GLMdenoise_RR/betas_nsdsynthetic.nii.gz',dir_beta,subjix));
    %temp2 = a3.img;
    
    for hemi = 1:2,hemi
      a1 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/roi/%ch.floc-faces.nii.gz',dir_roi,subjix,hemis(hemi))); % Load mask
      for i = 1:num_roi,i
       ix=find((a1.img>i-1) & (a1.img<i+1)); % Find required voxels by limiting the threshold
       % Create a binary mask with the voxels we want set to 1
       vol = zeros(size(a1.img));
       %volsize{subjix} = size(a1.img); % Save volume size
       vol(ix) = 1;
       %nvox(subjix) = size(ix,1); % Save number of voxels  
       %ixval{subjix} = ix; % Save voxel indices

       [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii
       
       if (isempty(d1)~=1)
       
           a3a = h5read(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf_GLMdenoise_RR/betas_nsdsynthetic.hdf5',dir_beta,subjix),'/betas',[d1(1) d2(1) d3(1) 1],[range(d1)+1 range(d2)+1 range(d3)+1 Inf]);
           betas = squish(a3a,3);
           betas = single(betas(ii,:))/300;  % voxels x trials

    %       vol = int16(vol);

       
       % Fixation Task
       
       for j = 1:totimg
           m = [];
           s = [];
           temp3 = cell2mat(output_fix(j,:));
           temp4 = betas(:,temp3);
           no_vox = size(temp4,1);
           no_div = nnz(vol);
           temp5 = mean(temp4,1);
           temp5 = temp5.*(no_vox./no_div);
           [m,s] = meanandse(temp5,2);
           meanse(subjix,hemi,i,1,j,1) = m;
           meanse(subjix,hemi,i,1,j,2) = s;
       end
       
       % Memory Task
       
       for k = 1:totimg
           m2 = [];
           s2 = [];
           temp6 = cell2mat(output_mem(k,:));
           temp7 = betas(:,temp6);
           no_vox = size(temp7,1);
           no_div = nnz(vol);
           temp8 = mean(temp7,1);
           temp8 = temp8.*(no_vox./no_div);
           [m2,s2] = meanandse(temp8,2);
           meanse(subjix,hemi,i,2,k,1) = m2;
           meanse(subjix,hemi,i,2,k,2) = s2;
       end
       
      end
    end    
           
    end 
end

save('meanse_5roi_2hemi.mat','meanse')

      count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20])  
setfigurepos([0 0 2500 1500])
totimg = 284;

for a = 1:nsubj
    for c = 1:2
     for b = 1:num_roi
       subplot(8,10,count)
       errorbar3(1:totimg,reshape(meanse(a,c,b,1,:,1),1,totimg),reshape(meanse(a,c,b,1,:,2),1,totimg),1,[1 0.5 0.5])
       hold on
       errorbar3(1:totimg,reshape(meanse(a,c,b,2,:,1),1,totimg),reshape(meanse(a,c,b,2,:,2),1,totimg),1,[0.5 0.5 1])
       straightline(0,'h','-k')
       hold off
       count = count + 1;
       xlim([0 285])
       title(sprintf('Subj %02d - %ch : ROI %s',a,hemis(c),roi{b}));
       %legend('Fixation Task', 'One-back Task');
     end
     end
end

saveas(gcf,'Test1_BH.png','png')

count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20]) 
setfigurepos([0 0 2500 1500])
totimg = 284;

for a = 1:nsubj
    for c = 1:2
     for b = 1:num_roi
       subplot(8,10,count)
       plot(reshape(meanse(a,c,b,1,:,1),1,totimg),'r')
       hold on
       plot(reshape(meanse(a,c,b,2,:,1),1,totimg),'b')
       straightline(0,'h','-k')
       hold off
       count = count + 1;
       xlim([0 285])
       title(sprintf('Subj %02d - %ch : ROI %s',a,hemis(c),roi{b}));
       %legend('Fixation Task', 'One-back Task');
     end
     end
end

saveas(gcf,'Test2_BH.png','png')



%% Correlation Plots

figure
set(gcf, 'PaperPosition', [0 0 20 20]) 
setfigurepos([0 0 2500 1500])

fixtask = meanse(:,:,:,1,:,1);
fixtask = permute(fixtask,[2,3,1,4,5]);
fixtask = reshape(fixtask,[hemi*num_roi*nsubj,totimg]);
memtask = meanse(:,:,:,2,:,1);
memtask = permute(memtask,[2,3,1,4,5]);
memtask = reshape(memtask,[hemi*num_roi*nsubj,totimg]);
tottask = [fixtask,memtask];
X = corr(tottask');
imagesc(X)
colormap(hot)
colorbar
caxis([0 1])
hold on
for g = 1: nsubj
      for t = 1:10
       straightline(10*(g-1)+t,'h','-c')

       straightline(10*(g-1) + t,'v','-c')
      end  
     for s = 1: 5
         straightline((g-1)*10 +2*s,'h','-g')
         straightline((g-1)*10 + 2*s, 'v', '-g')
     end
 straightline(10*g,'h','-m')

 straightline(10*g,'v','-m')
end

saveas(gcf,'Test2_corr.png','png')