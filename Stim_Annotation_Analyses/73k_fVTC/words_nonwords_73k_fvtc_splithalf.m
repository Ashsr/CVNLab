% Split half tvals and angmet for gVTC all 10k images
load repmat.mat
load words_nonwords_73k_fVTC_full

% General variables
ntps = 750; % no. of trials per session
hemis = ['l','r'];
nsubj = 8; % total number of subjects
totimg1 = 73000; % total number of images seen by all the subjects
totimg = [10000,10000,9411,9209,10000,9411,10000,9209]; % total number of images viewed by each subjects
nsess = [40, 40, 32, 30, 40, 32, 40, 30]; % total number of sessions
for subjix = 1:nsubj, subjix
    sp1 = sort(randperm(totimg(subjix),round(totimg(subjix)./2))); % Pick random image indices for half the size
    sp2 = sort(setdiff(randperm(totimg(subjix)),sp1));  
    hem_tval_sp1 = [];
    hem_tval_sp2 = [];
    hem_angmet_sp1 = [];
    hem_angmet_sp2 = [];
    
    for hem = 1:2, hem
        roimask = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/%ch.fVTC.mgz',subjix,hemis(hem))); % load roi mask
        vert_no  = find(roimask>0); % vertices corresponding to fVTC
        sp1_fix_data = [];
        sp2_fix_data = [];
        sp1_nfix_data = [];
        sp2_nfix_data = [];
        sp1_data = [];
        sp2_data = [];
        chk = [];
        chk2 = [];
        tr_avg = data{subjix,hem};
        sp1_data = tr_avg(:,sp1);
        sp2_data = tr_avg(:,sp2);
        chk = ismember(rept(subjix,1,sp1),wix);
        sp1_fix_data = sp1_data(:,chk);
        sp1_nfix_data = sp1_data(:,~chk);
        chk2 = ismember(rept(subjix,1,sp2),wix);
        sp2_fix_data = sp2_data(:,chk2);
        sp2_nfix_data = sp2_data(:,~chk2);
        
        %%%% sp1
        mn1sp1 = [];
        se1sp1 = [];
        mn2sp1 = [];
        se2sp1 = [];
        tvals_sp1 = [];
        angvals_sp1 = [];
        
        %%% t test
        mn1sp1 = mean(sp1_fix_data,2);
        
        se1sp1 = std(sp1_fix_data,[],2)/sqrt(size(sp1_fix_data,2));
        
        mn2sp1 = mean(sp1_nfix_data,2);
        se2sp1 = std(sp1_nfix_data,[],2)/sqrt(size(sp1_nfix_data,2));
        
        tvals_sp1 = (mn1sp1 - mn2sp1) ./ sqrt(se1sp1.^2 + se2sp1.^2);
        angvals_sp1 = circulardiff(pi/4,atan2(mn2sp1,mn1sp1),2*pi)/pi*180;
        tvals2_sp1 = zeros(size(roimask));
        angvals2_sp1 = zeros(size(roimask));
        
        tvals2_sp1(vert_no) = tvals_sp1;
        angvals2_sp1(vert_no) = angvals_sp1;
        %%%%% Concat it with the other hemi for each subj
        
        hem_tval_sp1 = cat(1,hem_tval_sp1,tvals2_sp1);
        hem_angmet_sp1 = cat(1,hem_angmet_sp1,angvals2_sp1);
        
        %%% sp2
        mn1sp2 = [];
        se1sp2 = [];
        mn2sp2 = [];
        se2sp2 = [];
        tvals_sp2 = [];
        angvals_sp2 = [];
        
        
        %%% t test and anglemet
        mn1sp2 = mean(sp2_fix_data,2);
        
        se1sp2 = std(sp2_fix_data,[],2)/sqrt(size(sp2_fix_data,2));
        
        mn2sp2 = mean(sp2_nfix_data,2);
        se2sp2 = std(sp2_nfix_data,[],2)/sqrt(size(sp2_nfix_data,2));
        
        tvals_sp2 = (mn1sp2 - mn2sp2) ./ sqrt(se1sp2.^2 + se2sp2.^2);
        angvals_sp2 = circulardiff(pi/4,atan2(mn2sp2,mn1sp2),2*pi)/pi*180;
        tvals2_sp2 = zeros(size(roimask));
        angvals2_sp2 = zeros(size(roimask));
        tvals2_sp2(vert_no) = tvals_sp2;
        angvals2_sp2(vert_no) = angvals_sp2;
        %%%%% Concat it with the other hemi for each subj
        
        hem_tval_sp2 = cat(1,hem_tval_sp2,tvals2_sp2);
        hem_angmet_sp2 = cat(1,hem_angmet_sp2,angvals2_sp2);
        
        
    end
    am_tvals_sp(1,subjix,1) = {hem_tval_sp1};
    am_tvals_sp(1,subjix,2) = {hem_angmet_sp1};
    
    am_tvals_sp(2,subjix,1) = {hem_tval_sp2};
    am_tvals_sp(2,subjix,2) = {hem_angmet_sp2};
    
    Lookup = [];
    
    mkdir (sprintf('sp1/Subject%02d',subjix))
    mkdir (sprintf('sp2/Subject%02d',subjix))
    cvnlookup(sprintf('subj%02d',subjix),3,hem_tval_sp1,[-10,10],cmapsign4(256));
    imwrite(rgbimg,sprintf('sp1/Subject%02d/word_nonword_3_tvals_10k_subj%02d_sp1.png',subjix,subjix));
    Lookup = [];
    cvnlookup(sprintf('subj%02d',subjix),3,hem_tval_sp2,[-10,10],cmapsign4(256));
    imwrite(rgbimg,sprintf('sp2/Subject%02d/word_nonword_3_tvals_10k_subj%02d_sp2.png',subjix,subjix));
    Lookup = [];
    cvnlookup(sprintf('subj%02d',subjix),3,hem_angmet_sp1,[-90,90],cmapsign4(256));
    imwrite(rgbimg,sprintf('sp1/Subject%02d/word_nonword_3_angvals_10k_subj%02d_sp1.png',subjix,subjix));
    Lookup = [];
    cvnlookup(sprintf('subj%02d',subjix),3,hem_angmet_sp2,[-90,90],cmapsign4(256));
    imwrite(rgbimg,sprintf('sp2/Subject%02d/word_nonword_3_angvals_10k_subj%02d_sp2.png',subjix,subjix));
    
    close all
end
save('words_nonwords_73k_fVTC_sp1_sp2.mat','am_tvals_sp','-v7.3')
            
            