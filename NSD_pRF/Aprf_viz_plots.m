% Visualize the results from Analyze_pRF

clear all

% Load the data
a1 = loadmulti('RR&Aprf.mat','Analyzeprf_results');
% 8 subjects x 1 x 2 hemis x 5 ROIs

% LOOK AT 8 subjects

nsubj = 8;
nroi = 5;
hemis = {'lh' 'rh'};

for subjix = 1:nsubj
    mkdir(sprintf('Subject%02d',subjix))
valsFULL = [];
for hh=1:2
  roiix = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/%s.floc-faces.mgz',subjix,hemis{hh}));
  vals = zeros(length(roiix),5);
  for rr=1:5
    if ~isempty(a1{subjix,1,hh,rr})
      vals(roiix==rr,1) = a1{subjix,1,hh,rr}.ang;
      vals(roiix==rr,2) = a1{subjix,1,hh,rr}.R2;
      vals(roiix==rr,3) = a1{subjix,1,hh,rr}.ecc;
      vals(roiix==rr,4) = a1{subjix,1,hh,rr}.rfsize;
      vals(roiix==rr,5) = a1{subjix,1,hh,rr}.expt;
    end
  end
  valsFULL = cat(1,valsFULL,vals);
end


cvnlookup(sprintf('subj%02d',subjix),3,valsFULL(:,1),[0 360],hsv(256));
imwrite(rgbimg,sprintf('./Subject%02d/Subj%02d_ang.png',subjix,subjix))
cvnlookup(sprintf('subj%02d',subjix),3,valsFULL(:,2),[0 70],hot(256));
imwrite(rgbimg,sprintf('./Subject%02d/Subj%02d_R2.png',subjix,subjix))
cvnlookup(sprintf('subj%02d',subjix),3,valsFULL(:,3),[0 5],jet(256));
imwrite(rgbimg,sprintf('./Subject%02d/Subj%02d_ecc.png',subjix,subjix))
cvnlookup(sprintf('subj%02d',subjix),3,valsFULL(:,4),[0 4],copper(256));
imwrite(rgbimg,sprintf('./Subject%02d/Subj%02d_rfsize.png',subjix,subjix))
cvnlookup(sprintf('subj%02d',subjix),3,valsFULL(:,5),[0 1],jet(256));
imwrite(rgbimg,sprintf('./Subject%02d/Subj%02d_expt.png',subjix,subjix))
close all
end