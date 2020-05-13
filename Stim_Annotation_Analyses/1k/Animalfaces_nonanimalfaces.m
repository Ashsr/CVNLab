load Outputbigmat_mode1v5_f.mat
animalface = sum(outputmat(:,5:8),2);
humanface = sum(outputmat(:,1:4),2);

nsubj = 8;
nsess = 40;
ntps = 750;
fcount = 1;
nfcount = 1;
nvertex = 327684;
shared = [1000,1000,614,515,1000,614,1000,515];
totsess = [40,40,32,30,40,32,40,30];


repindmat(nsubj,nsess,ntps);
load repmat.mat

for subj = 1:nsubj,subj
    
faceind = [];
nonfaceind = [];

for i = 1:1000
 if animalface(i) ~= 0 && humanface(i) == 0
     faceind = [faceind,i];
 else
     nonfaceind = [nonfaceind,i];
 end 
end 



face = cell(size(faceind,2),5);
nonface = cell(size(nonfaceind,2),5);

for i = 1:size(faceind,2)
 face(i,1) = {sharedix(faceind(i))};
end

for i = 1:size(nonfaceind,2)
    nonface(i,1) = {sharedix(nonfaceind(i))};
end

for j = 1:10000
 [loc,val] = ismember(cell2mat(face(:,1)),rept(subj,1,j));
 [loc2,val2] = ismember(cell2mat(nonface(:,1)),rept(subj,1,j));
 if sum(val) == 1
     face(loc,2) = {rept(subj,2,j)};
     face(loc,3) = {rept(subj,3,j)};
     face(loc,4) = {rept(subj,4,j)};
 end
     
  if sum(val2) == 1
         nonface(loc2,2) = {rept(subj,2,j)};
         nonface(loc2,3) = {rept(subj,3,j)};
         nonface(loc2,4) = {rept(subj,4,j)};
         
  end
end
 
% Load all 40 sessions 


alldata = single([]);
for sess=1:totsess(subj), sess
  data = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/fsaverage/betas_fithrf/*.betas_session%02d.mgz',subj,sess));
  alldata = cat(2,alldata,permute(data,[1 4 2 3]));
end
clear data;

for i = 1: size(faceind,2)
    if (isempty(cell2mat(face(i,2))) == 0) && (isempty(cell2mat(face(i,3))) == 0) && (isempty(cell2mat(face(i,4))) == 0)
   if (cell2mat(face(i,2)) < (1 + totsess(subj)*ntps)) && (cell2mat(face(i,3)) < (1 + totsess(subj)*ntps)) &&  (cell2mat(face(i,4)) < (1 + totsess(subj)*ntps))
    temp = (alldata(:,cell2mat(face(i,2))) + alldata(:,cell2mat(face(i,3))) + alldata(:,cell2mat(face(i,4))))./3;
    face(i,5) = {temp};
   end
    end
end



for i = 1: size(nonfaceind,2)
    if (isempty(cell2mat(nonface(i,2))) == 0) && (isempty(cell2mat(nonface(i,3))) == 0) && (isempty(cell2mat(nonface(i,4))) == 0)
   if (cell2mat(nonface(i,2)) < (1 + totsess(subj)*ntps)) && (cell2mat(nonface(i,3)) < (1 + totsess(subj)*ntps)) &&  (cell2mat(nonface(i,4)) < (1 + totsess(subj)*ntps))
    temp = (alldata(:,cell2mat(nonface(i,2))) + alldata(:,cell2mat(nonface(i,3))) + alldata(:,cell2mat(nonface(i,4))))./3;
    nonface(i,5) = {temp};
   end
    end
end
         
 clear i; 
 count = 1;
 count2 = 1;
 face_val = [];
 nonface_val = [];
% Do only 10k not 73ktionn
 for j = 1:size(faceind,2)
  if isempty(cell2mat(face(j,5))) ==0
    face_val(:,count) = cell2mat(face(j,5));
    count = count + 1;
  end
 end

face_val(isnan(face_val)) = 0;


 for j = 1:size(nonfaceind,2)
  if isempty(cell2mat(nonface(j,5))) ==0
    nonface_val(:,count2) = cell2mat(nonface(j,5));
    count2 = count2 + 1;
  end
 end


nonface_val(isnan(nonface_val)) = 0;

mn1 = mean(face_val,2);

  se1 = std(face_val,[],2)/sqrt(size(faceind,2));

  mn2 = mean(nonface_val,2);
  se2 = std(nonface_val,[],2)/sqrt(size(nonfaceind,2));
  
  tvals = (mn1 - mn2) ./ sqrt(se1.^2 + se2.^2);
  angvals = circulardiff(pi/4,atan2(mn2,mn1),2*pi)/pi*180;
  
  mkdir (sprintf('Subject%02d',subj))
  
  Lookup = [];
  mn = max(abs(tvals));
  cvnlookup('fsaverage',13,tvals,[-mn mn]);
  imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_13_tvals_subj%02d.png',subj,subj));
  cvnlookup('fsaverage',13,angvals,[-45,45]);
  imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_13_angvals_subj%02d.png',subj,subj));
 
   cvnlookup('fsaverage',13,angvals,[-45 45],[],[],[],1,{'overlayalpha' abs(tvals)>3});
   imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_13_tval_overlay_angmet_subj%02d.png',subj,subj));
   
  cvnlookup('fsaverage',3,tvals,[-mn mn]);
  imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_3_tvals_subj%02d.png',subj,subj));
  cvnlookup('fsaverage',3,angvals,[-45,45]);
  imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_3_angvals_subj%02d.png',subj,subj));
 
  cvnlookup('fsaverage',3,angvals,[-45 45],[],[],[],1,{'overlayalpha' abs(tvals)>3});
  imwrite(rgbimg,sprintf('Subject%02d/animalface_nonanimalface_3_tval_overlay_angmet_subj%02d.png',subj,subj));
  
  figure 
  imagesc(rand(1000))
  colormap(jet(256))
  caxis([-mn mn])
  imwrite(rgbimg,sprintf('Subject%02d/colorbar_t_test.png',subj));
  
    figure 
  imagesc(rand(1000))
  colormap(jet(256))
  caxis([-45 45])
  imwrite(rgbimg,sprintf('Subject%02d/colorbar_angmet.png',subj));
  close all
end