load Outputbigmat_mode1v5_f.mat
output = sum(outputmat(:,1:4),2);

faceind = [];
nonfaceind = [];
nsubj = 1;
nsess = 40;
ntps = 750;
fcount = 1;
nfcount = 1;
nvertex = 327684;

for i = 1:1000
 if output(i) == 0 
     nonfaceind = [nonfaceind,i];
 else
     faceind = [faceind,i];
 end 
end 


repindmat(nsubj,nsess,ntps);
load repmat.mat

face = cell(size(faceind,2),5);
nonface = cell(size(nonfaceind,2),5);

for i = 1:size(faceind,2)
 face(i,1) = {sharedix(faceind(i))};
end

for i = 1:size(nonfaceind,2)
    nonface(i,1) = {sharedix(nonfaceind(i))};
end

for j = 1:10000
 [loc,val] = ismember(cell2mat(face(:,1)),rept(nsubj,1,j));
 [loc2,val2] = ismember(cell2mat(nonface(:,1)),rept(nsubj,1,j));
 if sum(val) == 1
     face(loc,2) = {rept(nsubj,2,j)};
     face(loc,3) = {rept(nsubj,3,j)};
     face(loc,4) = {rept(nsubj,4,j)};
 end
     
  if sum(val2) == 1
         nonface(loc2,2) = {rept(nsubj,2,j)};
         nonface(loc2,3) = {rept(nsubj,3,j)};
         nonface(loc2,4) = {rept(nsubj,4,j)};
         
  end
end
 
% Load all 40 sessions 


alldata = single([]);
for sess=1:nsess, sess
  data = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/fsaverage/betas_fithrf/*.betas_session%02d.mgz',nsubj,sess));
  alldata = cat(2,alldata,permute(data,[1 4 2 3]));
end
clear data;

for i = 1: size(faceind,2)
    temp = (alldata(:,cell2mat(face(i,2))) + alldata(:,cell2mat(face(i,3))) + alldata(:,cell2mat(face(i,4))))./3;
    face(i,5) = {temp};
end



for i = 1: size(nonfaceind,2)
    temp = (alldata(:,cell2mat(nonface(i,2))) + alldata(:,cell2mat(nonface(i,3))) + alldata(:,cell2mat(nonface(i,4))))./3;
    nonface(i,5) = {temp};
end
         

face_val = reshape(cell2mat(face(:,5)),nvertex,size(faceind,2));
face_val(isnan(face_val)) = 0;
nonface_val = reshape(cell2mat(nonface(:,5)),nvertex,size(nonfaceind,2));
nonface_val(isnan(nonface_val)) = 0;

mn1 = mean(face_val,2);

  se1 = std(face_val,[],2)/sqrt(size(faceind,2));

  mn2 = mean(nonface_val,2);
  se2 = std(nonface_val,[],2)/sqrt(size(nonfaceind,2));
  
  tvals = (mn1 - mn2) ./ sqrt(se1.^2 + se2.^2);
  
  Lookup = [];

  cvnlookup('fsaverage',3,tvals,[-12 21],cmapsign4(256));
  imwrite(rgbimg,sprintf('hface_nonhfacesubj1.png'));