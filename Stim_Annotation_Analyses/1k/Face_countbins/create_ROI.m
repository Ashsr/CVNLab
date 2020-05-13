subj = 1;
totimg = 1000;
count = 1;
nsubj = 8;
ntps = 750;
nsess = 40;
totsess = [40,40,32,30,40,32,40,30];
load Outputbigmat_mode1v5_f.mat

output = sum(outputmat(:,1:2),2);
maxfaces = max(output(1:totimg));

repindmat(nsubj,nsess,ntps);
load repmat.mat

for subj = 1:nsubj,subj
rh_subj_tval = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/rh.flocfacestval.mgz',subj));

req_subj_rh_tval = rh_subj_tval>3;

rh_subj_vs = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/rh.visualsulc.mgz',subj));

req_subj_rh_vs = zeros(size(rh_subj_vs));

for j = 1:size(rh_subj_vs)
    if (rh_subj_vs(j) == 1) || (rh_subj_vs(j) == 3) || (rh_subj_vs(j) == 4) || (rh_subj_vs(j) == 5) || (rh_subj_vs(j) == 6)
        req_subj_rh_vs(j) = 1;
    end
end

% req_subj_rh_vs = ismember(rh_subj_vs,[1 3 4 5 6]);

rh_vert = req_subj_rh_tval.*req_subj_rh_vs;
rh_vert_fsa = nsd_mapdata(subj,'rh.white','fsaverage',rh_vert);


lh_subj_tval = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/lh.flocfacestval.mgz',subj));

req_subj_lh_tval = lh_subj_tval>3;

lh_subj_vs = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/lh.visualsulc.mgz',subj));

req_subj_lh_vs = zeros(size(lh_subj_vs));

for j = 1:size(lh_subj_vs)
    if (lh_subj_vs(j) == 1) || (lh_subj_vs(j) == 3) || (lh_subj_vs(j) == 4) || (lh_subj_vs(j) == 5) || (lh_subj_vs(j) == 6)
        req_subj_lh_vs(j) = 1;
    end
end

lh_vert = req_subj_lh_tval.*req_subj_lh_vs;
lh_vert_fsa = nsd_mapdata(subj,'lh.white','fsaverage',lh_vert);


cvnlookup(sprintf('subj%02d',subj),10,cat(1,lh_vert,rh_vert),[0 1]);
imwrite(rgbimg,sprintf('Subject%02d_nativespace_ffaroi_10.png',subj));

rh_ffa_count = nnz(rh_vert_fsa);
lh_ffa_count = nnz(lh_vert_fsa);


alldata_rh = single([]);
alldata_lh = single([]);
for sess=1:totsess(subj), sess
  datarh = permute(cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/fsaverage/betas_fithrf_GLMdenoise_RR/rh.betas_session%02d.mgz',subj,sess)),[1 4 2 3]);
  datarh = bsxfun(@times,rh_vert_fsa,datarh); 
  datalh = permute(cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/fsaverage/betas_fithrf_GLMdenoise_RR/lh.betas_session%02d.mgz',subj,sess)),[1 4 2 3]);
  datalh = bsxfun(@times,lh_vert_fsa,datalh);
  %temp = cat(1,datarh,datalh);
  alldata_rh = cat(2,alldata_rh,datarh);
  alldata_lh = cat(2,alldata_lh,datalh);
end
clear datarh;
clear datalh;


alldata_rh(isnan(alldata_rh))=0;
alldata_lh(isnan(alldata_lh))=0;

counter = 1;
for i = 1:10000
[loc, val] = ismember(sharedix,rept(subj,1,i));
if sum(val) == 1
    trialval(counter,1) = rept(subj,2,i);
    trialval(counter,2) = rept(subj,3,i);
    trialval(counter,3) = rept(subj,4,i);
    counter = counter + 1;
end
end

counter = 1;
ind_count = [];
av_trial_betas_rh = [];
av_trial_betas_lh = [];
for i = 1:1000
    if trialval(i,1) < (totsess(subj)*ntps + 1) && trialval(i,2) < (totsess(subj)*ntps + 1) && trialval(i,3) < (totsess(subj)*ntps + 1)
     av_trial_betas_rh(:,counter) = (alldata_rh(:,trialval(i,1)) + alldata_rh(:,trialval(i,2)) + alldata_rh(:,trialval(i,3)))./3 ;
     av_trial_betas_lh(:,counter) = (alldata_lh(:,trialval(i,1)) + alldata_lh(:,trialval(i,2)) + alldata_lh(:,trialval(i,3)))./3 ;
     ind_count = [ind_count,i];
     counter = counter + 1;
     

    end
end
img_ind{subj} = ind_count;
av_ffa_rh = [];
av_ffa_lh = [];
av_ffa_rh = sum(av_trial_betas_rh,1)./rh_ffa_count;
av_ffa_lh = sum(av_trial_betas_lh,1)./lh_ffa_count;

startbin = 0;
numbins = 2*maxfaces + 1;
binEdges = linspace(0,maxfaces,numbins);

[h, whichbin] = histc(output(ind_count),binEdges);

for i = 1:numbins
    binmembers = (whichbin == i);
    av_ffa{subj,1,i} = av_ffa_lh(binmembers);
    av_ffa{subj,2,i} = av_ffa_rh(binmembers);
    %binmean(i) = mean(binmembers);
end

end


save('av_ffa.mat','av_ffa','maxfaces','binEdges','numbins')