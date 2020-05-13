global nsubj;
nsubj = 8;

global totimg; 
totimg = 284;
b =3;
global num_roi ;
num_roi = 5;
global grp_size ;
grp_size = 4;
global num_group ;
num_group = totimg./grp_size;
global roi ;
roi = {'IOG','pFUS','mFUS','mTL','aTL'};
dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';
hemis = ['l','r'];
global betas ;
tot_task = 2;

meanse = [];

% Base script

for subjix = 1 : nsubj,subjix
    for hemi = 1 : 2,hemi
        a1 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/roi/%ch.floc-faces.nii.gz',dir_roi,subjix,hemis(hemi))); % Load ROI
        for i = 1 : num_roi,i
            
            ix=find(a1.img == i); % Find required voxels by limiting the threshold
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

function meanse = calculatemeanse(task)

load repindexoutput.mat
global totimg;

global betas
meanse = [];

for j = 1:totimg
    
    m = [];
    s = [];
    temp4 = [];
    

        if task == 1
            temp3 = cell2mat(output_fix(j,:));
        else
            temp3 = cell2mat(output_mem(j,:));
        end
        temp4 = betas(:,temp3);
    
    temp5 = mean(temp4,1);
    [m,s] = meanandse(temp5,2);
    meanse(j,1) = m;
    meanse(j,2) = s;
end
end