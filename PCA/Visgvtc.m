% Load the gVTC mgz mask file
% Use it to select vertices and load betas
% Sessionwise zscore
% Store in a matrix
% Do it for all sessions
% Do it for all subjects

tic
nsubj = 8;
nsess = 15;
ntps = 750;
nvertex_lh = 10353;
nvertex_rh = 11808;

data_dir = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/';
% subj01/fsaverage/betas_fithrf_GLMdenoise_RR/'

lh = 0;
lh_fin = 0;

lhm=cvnreadsurface('fsaverage','lh','gVTC.flat.patch.3d','orig');
% lhm.patchmask is a binary mask for the lh vertices
ixlh = find(lhm.patchmask>0);

rhm=cvnreadsurface('fsaverage','rh','gVTC.flat.patch.3d','orig');
% rhm.patchmask is a binary mask for the rh vertices
ixrh = find(rhm.patchmask>0);

repindmat(nsubj,nsess,ntps); % Calls the function which figures out the number of reps
load repmat.mat
 
 
for subjix = 1:nsubj, subjix
 
 for sess = 1:nsess, sess

  inpfile_lh = sprintf([data_dir 'subj%02d/fsaverage/betas_fithrf_GLMdenoise_RR/lh.betas_session%02d.mgz'],subjix,sess);   
  data_lh = cvnloadmgz(inpfile_lh);
  reqdata_lh = data_lh(ixlh,:,:,:);
  zsc_lh = reshape(calczscore(reqdata_lh,4),[nvertex_lh ntps]);
  
  inpfile_rh = sprintf([data_dir 'subj%02d/fsaverage/betas_fithrf_GLMdenoise_RR/rh.betas_session%02d.mgz'],subjix,sess);   
  data_rh = cvnloadmgz(inpfile_rh);
  reqdata_rh = data_rh(ixrh,:,:,:);
  zsc_rh = reshape(calczscore(reqdata_rh,4),[nvertex_rh ntps]);
  
  if lh == 0
      lh = zsc_lh;
      rh = zsc_rh;
      
  else
  lh = [lh,zsc_lh];
  rh = [rh,zsc_rh];
  end
 end
 
 lh_avg = zeros(nvertex_lh,t1);
 rh_avg = zeros(nvertex_rh,t1);
 lh_req = lh(:,((subjix-1)*ntps*nsess) + (1:ntps*nsess));
 rh_req = rh(:,((subjix-1)*ntps*nsess) + (1:ntps*nsess));
 for j = 1:t1
     if rept(1,4,j) ~= 0
         rep3 = rept(1,4,j);
         rep2 = rept(1,3,j);
         rep1 = rept(1,2,j);
         lh_avg(:,j) = nanmean([lh_req(:,rep1),lh_req(:,rep2),lh_req(:,rep3)]')';
         rh_avg(:,j) = nanmean([rh_req(:,rep1),rh_req(:,rep2),rh_req(:,rep3)]')';
         
%         ok = sum(~isnan(data),2)  % how many valid trials do we have
%         ok==0  <==
         
     else
         if rept(1,3,j) ~= 0
             rep2 = rept(1,3,j);
             rep1 = rept(1,2,j);
             lh_avg(:,j) = nanmean([lh_req(:,rep1),lh_req(:,rep2)]')';
             rh_avg(:,j) = nanmean([rh_req(:,rep1),rh_req(:,rep2)]')';
         else
             rep1 = rept(1,2,j);
             lh_avg(:,j) = lh_req(:,rep1);
             rh_avg(:,j) = rh_req(:,rep1);
         end
     end
 end
 if lh_fin == 0
      lh_fin = lh_avg;
      rh_fin = rh_avg;
      
  else
  lh_fin = [lh_fin,lh_avg];
  rh_fin = [rh_fin,rh_avg];
  end
end
% imwrite(uint8(255*cmaplookup(lh,-20,20,[],cmapsign4(256))),'lh.png');
% imwrite(uint8(255*cmaplookup(rh,-20,20,[],cmapsign4(256))),'rh.png');
bmat = [lh_fin;rh_fin];
%imwrite(uint8(255*cmaplookup(bmat,-5,5,[],cmapsign4(256))),'bmat.png');
save('lh_fin.mat','lh_fin','-v7.3')
save('rh_fin.mat','rh_fin','-v7.3')
save('bmat.mat','bmat','-v7.3')
toc
% 110 mins to run



bmat(isnan(bmat)) = 0;


[u,s,v] = svds(bmat,20);



helpfun = @(x) cat(1,copymatrix(zeros(size(lhm.patchmask)),ixlh,x(1:nvertex_lh)), ...
              copymatrix(zeros(size(rhm.patchmask)),ixrh,x(nvertex_lh+1:end)));

[rawimg,Lookup,rgbimg,himg] = cvnlookup('fsaverage',8,helpfun(u(:,1)));


[n,x,y] = hist2d(v(:,3),v(:,4),-.02:.001:.02);
figure;imagesc(x(1,:),y(:,1),log(n));
colormap(hot);
% figure;imagesc(x(1,:),y(:,1),log(n));
% 
figure;bar(diag(s))
%  
 figure;hist(v(:,10),100)
 figure;scatter(s(1,1)*v(:,1),s(2,2)*v(:,2))
 figure;scatter3(s(1,1)*v(:,1),s(2,2)*v(:,2),s(3,3)*v(:,3))
%% 
rr = find(v(:,1) < -0.01);
video = VideoWriter('Bottom 300_stimPC1.avi'); %create the video object
video.FrameRate = 1;
open(video); %open the file for writing
for i = 1:size(rr,1)
    if mod(rr(i),t1) ~= 0
     sub = fix(rr(i)./t1)+1;
     tr = rr(i)-((sub-1)*t1);
    else
        sub = fix(rr(i)./t1);
        tr =t1;
    end
    imgid(1,i) = sub;
    imgid(2,i) = rept(sub,1,tr);
    im(:,:,:,i) = permute(h5read('/home/surly-raid4/kendrick-data/nsd/nsddata_stimuli/stimuli/nsd/nsd_stimuli.hdf5','/imgBrick',[1 1 1 imgid(2,i)],[3 425 425 1]),[3 2 1]);
    imagesc(im(:,:,:,i)); %read the next image
    set(gca,'YDir','reverse')
    frame = getframe(gcf);
    writeVideo(video,frame); %write the image to file
    
end

close(video);    