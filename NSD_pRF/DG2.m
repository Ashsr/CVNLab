% All subjix, bvoth hemis, all vertices in faces ROIs coefs and R2 for
% position - Demeaned version for 10k
tic
clear all

% Paths
filename = '/home/surly-raid4/kendrick-data/nsd/nsdextensions/NSD_Annotation_Efforts_1.0/Automated/Faces/binaryimage_mode2.mat';


% General variables 
ntps = 750; % no. of trials per session
nsess = [40, 40, 32, 30, 40, 32, 40, 30]; % total no. of sessions
hemis = ['l','r'];
roi_c = 5; % roi count
roi_type ={'faces','words'};
type = 1; % faces only
nsubj = 8; % total number of subjects 
totimg1 = 73000; % total number of images seen by all the subjects
totimg = [10000,10000,9411,9209,10000,9411,10000,9209]; % distinct images seen by each subject
load repmat.mat % indexing 

% Prepare binary images
    sz = [10,10];
    load (filename)
    bmaps = binaryimagemat>0; % binary mask of the positions
    bmaps2 = zeros(sz(1),sz(2),totimg1);
    for i = 1:totimg1 % tot shared images
        bmaps2(:,:,i) = imresize(double(bmaps(:,:,i)),sz,'cubic');
    end
    bmaps2 = bmaps2>0.1;

% Load data
for subjix = 1:nsubj, subjix % Loop over subjects
     for hem = 1:length(hemis), hem % Loop over hemis
        roimask = cvnloadmgz(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata/freesurfer/subj%02d/label/%ch.floc-%s.mgz',subjix,hemis(hem),roi_type{type})); % load roi mask
        for roi = 1:roi_c,roi % Loop over ROIs
            vert_no  = find(roimask == roi);
            if (~isempty(vert_no))
                allbetas = single([]);
                v2 = vert_no - min(vert_no) + 1; % find vertices that correspond to the ordering in the h5read out
                b_sess = [];
                
                for sess = 1:nsess(subjix), fprintf('.');
                    betas = h5read(sprintf('/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj%02d/nativesurface/betas_fithrf_GLMdenoise_RR/%ch.betas_session%02d.hdf5',subjix,hemis(hem),sess),'/betas',[min(vert_no) 1],[range(vert_no)+1 inf]);
                    betas = single(betas(v2,:))./300; % convert to single, divide by 300 and select the subset of req vertices           
                    b_sess(:,sess) = - nanmean(betas,2)./nanstd(betas,[],2); % find b
                    betas = calczscore(betas,2); % zscore
                    allbetas = cat(2,allbetas,betas); % concatenate
                end
                
                % add in b_sessmean
                
                b_sessm = mean(b_sess,2); % take mean across sessions
                allbetas = allbetas - b_sessm;
                
                % get the trial averaged responses of the special 1k
               
                tr_avg = zeros([length(vert_no),totimg(subjix)]);
                
                for i = 1:totimg(subjix) % tot images
                    
                    if ( (rept(subjix,2,i)<(nsess(subjix)*ntps)) && (rept(subjix,3,i)<(nsess(subjix)*ntps)) && (rept(subjix,4,i)<(nsess(subjix)*ntps)))
                        tr_avg(:,i) = (allbetas(:,rept(subjix,2,i)) + allbetas(:,rept(subjix,3,i)) + allbetas(:,rept(subjix,4,i)))./3;
                    else if((rept(subjix,2,i)<(nsess(subjix)*ntps)) && (rept(subjix,3,i)<(nsess(subjix)*ntps)))
                            tr_avg(:,i) = (allbetas(:,rept(subjix,2,i)) + allbetas(:,rept(subjix,3,i)))./2;
                        else if ((rept(subjix,2,i)<(nsess(subjix)*ntps)))
                                tr_avg(:,i) = allbetas(:,rept(subjix,2,i));
                            end
                        end
                    end
                end
                
                %tr_avg = mean(tr_avg,1);
                tr_avg = tr_avg - mean(tr_avg,2); % demean y
                data(subjix,type,hem,roi) = {tr_avg};
                
                %% Ridge Regression
                 
                 trainix = 1:.7*(size(tr_avg,2)); % 70 % train
                 devix = (fix(.7*(size(tr_avg,2)))) + 1:.9*(size(tr_avg,2)); % 71 - 90 % to choose lambda
                 testix = (fix(.9*(size(tr_avg,2)))) + 1:size(tr_avg,2); % 91 - 100 % to test the fit
                
                
                X = squish(bmaps2(:,:,rept(subjix,1,1:totimg(subjix))),2); % features x images
                X(isnan(X)) = 0;
                Xstd = std(X,[],2);
                X = X - mean(X,2); % demean X
                X = X./Xstd; % zscore
                xstd(subjix) = {Xstd};
                x(subjix) = {X};
                 X1 = double(X(:,trainix));
                 Y1 = tr_avg(:,trainix);
                
                
                [Coef,alpha] = fracridge(X1',0.05:.05:1,Y1');
                
                deverror = [];
                for l = 1: size(alpha,1)
                    deverror(l,:) = mean((X(:,devix)'*reshape(Coef(:,l,:),[sz(1)*sz(2),length(vert_no)]) - tr_avg(:,devix)').^2);
                end
                
                [~,minix] = min(deverror,[],1);
                coef_fin = [];
                for i = 1:length(vert_no)
                    coef_fin(:,i) = Coef(:,minix(i),i);
                end
                
                testerror = [];
                testerror = mean((X(:,testix)'*coef_fin - tr_avg(:,testix)').^2);
                
                R2 = [];
                R2 = calccod(X(:,testix)'*coef_fin,tr_avg(:,testix)',1,0,1);% wantmeansub 1 - when you demean y,X
                
                CoefsR2_val(subjix,type,hem,roi,1) = {coef_fin./Xstd};
                CoefsR2_val(subjix,type,hem,roi,2) = {R2};
                
                %% Analyze pRF
                results = [];
                results = analyzePRF(bmaps2(:,:,rept(subjix,1,1:totimg(subjix))), ...
                    tr_avg,1,struct('hrf',1,'maxpolydeg',0,'seedmode',-2,'typicalgain',0.01));
                Analyzeprf_results(subjix,type,hem,roi) = {results};
                
            end
        end
    end
end

toc
save('RR&Aprf_quick.mat','bmaps2','x','xstd','data','CoefsR2_val','Analyzeprf_results','-v7.3')

