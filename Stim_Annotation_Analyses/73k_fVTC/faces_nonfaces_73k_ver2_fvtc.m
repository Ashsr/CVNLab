% T-test and angle metric for faces - non face in 73k stimulus images for
% the whole of fVTC - beta 2

clear all
filename = '/home/surly-raid4/kendrick-data/nsd/nsdextensions/NSD_Annotation_Efforts_1.0/Automated/Faces/binaryimage_mode2.mat';

% General variables
ntps = 750; % no. of trials per session

hemis = ['l','r'];
nsubj = 8; % total number of subjects
totimg1 = 73000; % total number of images seen by all the subjects
totimg = [10000,10000,9411,9209,10000,9411,10000,9209]; % distinct images seen by each subject
load repmat.mat % indexing
nsess = [40, 40, 32, 30, 40, 32, 40, 30]; % total no. of sessions

% Prepare binary images
sz = [50,50];
load (filename)
bmaps = binaryimagemat>0; % binary mask of the positions
bmaps2 = zeros(sz(1),sz(2),totimg1);
fix = [];
nfix = [];
for i = 1:totimg1 % tot shared images
    bmaps2(:,:,i) = normalizerange(imresize(double(bmaps(:,:,i)),sz,'cubic'),0,1,0,1);
    if nnz(bmaps2(:,:,i))
        fix = [fix,i];
    else
        nfix = [nfix,i];
    end
    
end


% Load data

for subjix = 1:nsubj, subjix % Loop over subjects
    hem_tval = [];
    hem_angmet = [];
    for hem = 1:length(hemis), hem % Loop over hemis
        roimask = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/%ch.fVTC.mgz',subjix,hemis(hem))); % load roi mask
        
        vert_no  = find(roimask>0); % vertices corresponding to fVTC
        
        allbetas = single([]);
        v2 = vert_no - min(vert_no) + 1; % find vertices that correspond to the ordering in the h5read out
        b_sess = [];
        
        for sess = 1:nsess(subjix) 
            fprintf('.');
            betas = h5read(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/nativesurface/betas_fithrf/%ch.betas_session%02d.hdf5',subjix,hemis(hem),sess),'/betas',[min(vert_no) 1],[range(vert_no)+1 inf]);
            betas = single(betas(v2,:))./300; % convert to single, divide by 300 and select the subset of req vertices
            b_sess(:,sess) = - nanmean(betas,2)./nanstd(betas,[],2); % find b
            betas = calczscore(betas,2); % zscore
            allbetas = cat(2,allbetas,betas); % concatenate
        end
        
        % add in b_sessmean
        
        b_sessm = mean(b_sess,2); % take mean across sessions
        allbetas = allbetas - b_sessm;
        
        % get the trial averaged responses of the special 1k - check execution from here
        
        tr_avg = zeros([length(vert_no),totimg(subjix)]);
        fix_data = []; % To store the averaged values for images with faces
        
        nfix_data = []; % To store the averaged values for images without faces
       
        
        for i = 1:totimg(subjix), fprintf('*'); % tot images
            
            if (rept(subjix,4,i)<(nsess(subjix)*ntps))
                tr_avg(:,i) = (allbetas(:,rept(subjix,2,i)) + allbetas(:,rept(subjix,3,i)) + allbetas(:,rept(subjix,4,i)))./3;
            else if (rept(subjix,3,i)<(nsess(subjix)*ntps))
                    tr_avg(:,i) = (allbetas(:,rept(subjix,2,i)) + allbetas(:,rept(subjix,3,i)))./2;
                else if (rept(subjix,2,i)<(nsess(subjix)*ntps))
                        tr_avg(:,i) = allbetas(:,rept(subjix,2,i));
                    end
                end
            end
        end
        
        chk = ismember(rept(subjix,1,1:totimg(subjix)),fix);
        fix_data = tr_avg(:,chk);
        nfix_data = tr_avg(:,~chk);
        
        data(subjix,hem) = {tr_avg};
        mn1 = [];
        se1 = [];
        mn2 = [];
        se2 = [];
        tvals = [];
        angvals = [];
        
        mn1 = mean(fix_data,2);
        
        se1 = std(fix_data,[],2)/sqrt(size(fix_data,2));
        
        mn2 = mean(nfix_data,2);
        se2 = std(nfix_data,[],2)/sqrt(size(nfix_data,2));
        
        tvals = (mn1 - mn2) ./ sqrt(se1.^2 + se2.^2);
        angvals = circulardiff(pi/4,atan2(mn2,mn1),2*pi)/pi*180;
        tvals2 = zeros(size(roimask));
        angvals2 = zeros(size(roimask));
        tvals2(vert_no) = tvals;
        angvals2(vert_no) = angvals;
        %%%%% Concat it with the other hemi for each subj
        
        hem_tval = cat(1,hem_tval,tvals2);
        hem_angmet = cat(1,hem_angmet,angvals2);
        
    end
    am_tvals(subjix,1) = {hem_tval};
    am_tvals(subjix,2) = {hem_angmet};
    
    Lookup = [];
    
    mkdir (sprintf('Subject%02d',subjix))
    cvnlookup(sprintf('subj%02d',subjix),3,hem_tval,[-10 10],cmapsign4(256));
    imwrite(rgbimg,sprintf('Subject%02d/face_nonface_3_tvals_10k_subj%02d.png',subjix,subjix));
    Lookup = [];
    cvnlookup(sprintf('subj%02d',subjix),3,hem_angmet,[-90,90], cmapsign4(256));
    imwrite(rgbimg,sprintf('Subject%02d/face_nonface_3_angvals_10k_subj%02d.png',subjix,subjix));
    
    close all
end
save('faces_nonfaces_73k_fVTC_full.mat','data','fix','nfix','am_tvals','-v7.3')
