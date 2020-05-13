
T = readtable('annotationsfi.csv',...
    'Delimiter',',');
nfcount = 1;
fcount = 1;
prev = 0;


nsubj = 8;
ntps = 750;
nvertex = 327684;

for i = 1:size(T,1)
    temp = cell2mat(table2cell(T(i,1)));
    if cell2mat(table2cell(T(i,4))) == 0
    
     nonface1(nfcount) = str2num(temp(4:8));
     nfcount = nfcount + 1;
    else
        if prev ~= str2num(temp(4:8))
         face1(fcount) = str2num(temp(4:8));
         fcount = fcount + 1;
         prev = str2num(temp(4:8));
        end
    end
end


 repindmat(nsubj,40,ntps);
 load repmat.mat

 nsess = [40,40,32,30,40,32,40,30];
for subj = 1:nsubj, subj

 face = cell(size(face1,2),5);
 nonface = cell(size(nonface1,2),5);
 face(:,1) = num2cell(face1);
 nonface(:,1) = num2cell(nonface1);



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
 for sess=1:nsess(subj), sess
  data = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/fsaverage/betas_fithrf/*.betas_session%02d.mgz',subj,sess));
  alldata = cat(2,alldata,permute(data,[1 4 2 3]));
 end
 clear data;

 for i = 1: size(face1,2)
     
  if (isempty(cell2mat(face(i,2))) == 0) && (isempty(cell2mat(face(i,3))) == 0) && (isempty(cell2mat(face(i,4))) == 0)
   if (cell2mat(face(i,2)) < (1 + nsess(subj)*ntps)) && (cell2mat(face(i,3)) < (1 + nsess(subj)*ntps)) &&  (cell2mat(face(i,4)) < (1 + nsess(subj)*ntps))
    temp = (alldata(:,cell2mat(face(i,2))) + alldata(:,cell2mat(face(i,3))) + alldata(:,cell2mat(face(i,4))))./3;
    face(i,5) = {temp};
   end
  end
 end



 for i = 1: size(nonface1,2)
  if (isempty(cell2mat(nonface(i,2))) == 0) && (isempty(cell2mat(nonface(i,3))) == 0) && (isempty(cell2mat(nonface(i,4))) == 0)
   if (cell2mat(nonface(i,2)) < (1 + nsess(subj)*ntps)) && (cell2mat(nonface(i,3)) < (1 + nsess(subj)*ntps)) &&  (cell2mat(nonface(i,4)) < (1 + nsess(subj)*ntps))  
    temp = (alldata(:,cell2mat(nonface(i,2))) + alldata(:,cell2mat(nonface(i,3))) + alldata(:,cell2mat(nonface(i,4))))./3;
    nonface(i,5) = {temp};
   end
  end
 end
 clear i; 
 count = 1;
 count2 = 1;
% Do only 10k not 73ktionn
 for j = 1:size(face1,2)
  if isempty(cell2mat(face(j,5))) ==0
    face_val(:,count) = cell2mat(face(j,5));
    count = count + 1;
  end
 end

%face_val = reshape(cell2mat(face(:,5)),nvertex,size(face1,2));
 face_val(isnan(face_val)) = 0;

 for j = 1:size(nonface1,2)
  if isempty(cell2mat(nonface(j,5))) ==0
    nonface_val(:,count2) = cell2mat(nonface(j,5));
    count2 = count2 + 1;
  end
 end

%nonface_val = reshape(cell2mat(nonface(:,5)),nvertex,size(nonface1,2));
 nonface_val(isnan(nonface_val)) = 0;

 mn1 = mean(face_val,2);

  se1 = std(face_val,[],2)/sqrt(size(face_val,2));

  mn2 = mean(nonface_val,2);
  se2 = std(nonface_val,[],2)/sqrt(size(nonface_val,2));
  
  tvals = (mn1 - mn2) ./ sqrt(se1.^2 + se2.^2);
  angvals = circulardiff(pi/4,atan2(mn2,mn1),2*pi)/pi*180;
  
  tvalthresh = [10,10,10,10,10,10,10,10];
  Lookup = [];
  mn = max(abs(tvals));
  mkdir (sprintf('Subject%02d',subj))
  cvnlookup('fsaverage',13,tvals,[-mn mn],[],tvalthresh(subj)*i);
  imwrite(rgbimg,sprintf('Subject%02d/face_nonface_13_tvals_thresh%02di_10k_subj%02d.png',subj,tvalthresh(subj),subj));
  cvnlookup('fsaverage',13,angvals,[-45,45]);
  imwrite(rgbimg,sprintf('Subject%02d/face_nonface_13_angvals_10k_subj%02d.png',subj,subj));
 
   cvnlookup('fsaverage',13,angvals,[-45 45],[],[],[],1,{'overlayalpha' abs(tvals)>tvalthresh(subj)});
   imwrite(rgbimg,sprintf('Subject%02d/face_nonface_13_tval_overlay_angmet_10k_subj%02d.png',subj,subj));
end