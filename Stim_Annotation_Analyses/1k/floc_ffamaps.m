% make comparable tval plots
nsubj = 8;
for subj = 1:nsubj,subj
 rh_subj_tval = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/rh.flocfacestval.mgz',subj));

 req_subj_rh_tval = rh_subj_tval>3;
 
 rh_subj_amet = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/rh.flocfacesanglemetric.mgz',subj));
 
  lh_subj_tval = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/lh.flocfacestval.mgz',subj));
  
  lh_subj_amet = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/lh.flocfacesanglemetric.mgz',subj));

  req_subj_lh_tval = lh_subj_tval>3;
   
  rh = -1000*ones(size(rh_subj_tval));
   
  rh(req_subj_rh_tval) = rh_subj_amet(req_subj_rh_tval);
  
  lh = -1000*ones(size(lh_subj_tval));
   
  lh(req_subj_lh_tval) = lh_subj_amet(req_subj_lh_tval);
  
  rh_vert_fsa = nsd_mapdata(subj,'rh.white','fsaverage',rh);
  
  lh_vert_fsa = nsd_mapdata(subj,'lh.white','fsaverage',lh);
  
  temp = single(cat(1,lh_vert_fsa,rh_vert_fsa));
  
  mn = max(temp);
  
  cvnlookup('fsaverage',3,temp,[-45,45],[],-100)
  imwrite(rgbimg,sprintf('Floc_Subject%02d_3_thresh3_amet.png',subj))
end