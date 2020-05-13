%% 
% For every subject
% Load ROI file 
% Loop for each region 1 - 5
% Find Fixation betas and one back betas
% Plot their Mean and SE

nsubj = 8;
load repindexoutput.mat
totimg = 284;
b =3;
num_roi = 5;
grp_size = 4;
num_group = totimg./grp_size;
roi = {'IOG','pFUS','mFUS','mTL','aTL'};
dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
dir_beta = '/home/surly-raid4/kendrick-data/nsd/nsddata_betas';
hemis = ['l','r'];

for subjix = 1 : nsubj,subjix
    
    for hemi = 1 : 2,hemi
        
        a1 = load_untouch_nii(sprintf('%s/ppdata/subj%02d/func1mm/roi/%ch.floc-faces.nii.gz',dir_roi,subjix,hemis(hemi))); % Load mask
        
        for i = 1 : num_roi,i
            
            ix=find((a1.img>i-1) & (a1.img<i+1)); % Find required voxels by limiting the threshold
            % Create a binary mask with the voxels we want set to 1
            
            vol = zeros(size(a1.img));
            
            vol(ix) = 1;
            
            [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii
            
            if (isempty(d1)~=1)
                
                a3a = h5read(sprintf('%s/ppdata/subj%02d/func1mm/nsdsyntheticbetas_fithrf_GLMdenoise_RR/betas_nsdsynthetic.hdf5',dir_beta,subjix),'/betas',[d1(1) d2(1) d3(1) 1],[range(d1)+1 range(d2)+1 range(d3)+1 Inf]);
                betas = squish(a3a,3);
                betas = single(betas(ii,:))/300;  % voxels x trials
                
                
                % Fixation Task
                
                
                for j = 1:num_group
                    
                    m = [];
                    s = [];
                    temp4 = [];
                    
                    
                    for l = 1:grp_size
                        
                        y = (j-1)*grp_size + l;
                        temp3 = cell2mat(output_fix(y,:));
                        temp4 = [temp4,betas(:,temp3)]; % check how its getting concatenated
                        
                    end
                    
                    temp5 = mean(temp4,1);
                    [m,s] = meanandse(temp5,2);
                    meanse(subjix,hemi,i,1,j,1) = m;
                    meanse(subjix,hemi,i,1,j,2) = s;
                end
                
                % Memory Task
                
                for k = 1: num_group
                    
                    m2 = [];
                    s2 = [];
                    temp7 = [];
                    
                    for l = 1:grp_size
                        
                        v = (k-1)*grp_size + l;
                        temp6 = cell2mat(output_mem(v,:));
                        temp7 = [temp7,betas(:,temp6)];
                        
                    end
                    
                    temp8 = mean(temp7,1);
                    [m2,s2] = meanandse(temp8,2);
                    meanse(subjix,hemi,i,2,k,1) = m2;
                    meanse(subjix,hemi,i,2,k,2) = s2;
                end
                
            end
        end
    end
    
    
    
end
%% Viz 1
count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20])  
setfigurepos([0 0 2500 1500])
totimg = 284;
lbl = {'WN','BWN','PN','NI1','NI1-1','MO','LD','NI2','50%C','10%C','6%C','4%C','75%PC','50%PC','25%PC','0%PC','WL1-P1','WL1-P2','WL1-P3','WL1-P4','WL1-P5','WL2-P1','WL2-P2','WL2-P3','WL2-P4','WL2-P5','SF1-R','SF2-R','SF3-R','SF4-R','SF5-R','SF6-R','SF1-CW','SF2-CW','SF3-CW','SF4-CW','SF5-CW','SF6-CW','SF1-CIR','SF2-CIR','SF3-CIR','SF4-CIR','SF5-CIR','SF6-CIR','SF1-CCW','SF2-CCW','SF3-CCW','SF4-CCW','SF5-CCW','SF6-CCW','SC','LCW','LCCW','SCCW','A-C','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16'};

for a = 1:nsubj
    for c = 1:2
     for b = 1:num_roi
       subplot(8,10,count)
       errorbar3(1:num_group,reshape(meanse(a,c,b,1,:,1),1,num_group),reshape(meanse(a,c,b,1,:,2),1,num_group),1,[1 0.5 0.5])
       hold on
       errorbar3(1:num_group,reshape(meanse(a,c,b,2,:,1),1,num_group),reshape(meanse(a,c,b,2,:,2),1,num_group),1,[0.5 0.5 1])
       straightline(0,'h','-k')
       hold off
       count = count + 1;
       xlim([0 72])
       title(sprintf('Subj %02d - %ch : ROI %s',a,hemis(c),roi{b}));
       xticks([0:1:72])
       xticklabels(lbl)
       xtickangle(90)
     end
     end
end

saveas(gcf,'Test2_BHGroup.png','png')


%% Subjectwise Hemiwise ROIwise plot


for subjix = 1:nsubj
 for a = 1:2    
    for i = 1:5
        %f1 = figure('visible','off');
        figureprep([0 0 3500 500]);
        mkdir(sprintf('Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s',subjix,hemis(a),roi{i}));
        %set(gcf, 'PaperPosition', [0 0 20 20])  
        %setfigurepos([0 0 2500 1500])
        lbl = {'0','WN','BWN','PN','NI1','NI1-1','MO','LD','NI2','50%C','10%C','6%C','4%C','75%PC','50%PC','25%PC','0%PC','WL1-P1','WL1-P2','WL1-P3','WL1-P4','WL1-P5','WL2-P1','WL2-P2','WL2-P3','WL2-P4','WL2-P5','SF1-R','SF2-R','SF3-R','SF4-R','SF5-R','SF6-R','SF1-CW','SF2-CW','SF3-CW','SF4-CW','SF5-CW','SF6-CW','SF1-CIR','SF2-CIR','SF3-CIR','SF4-CIR','SF5-CIR','SF6-CIR','SF1-CCW','SF2-CCW','SF3-CCW','SF4-CCW','SF5-CCW','SF6-CCW','SC','LCW','LCCW','SCCW','A-C','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16'};
        errorbar3(1:num_group,reshape(meanse(subjix,a,i,1,:,1),1,num_group),reshape(meanse(subjix,a,i,1,:,2),1,num_group),1,[1 0.5 0.5])
        hold on
        errorbar3(1:num_group,reshape(meanse(subjix,a,i,2,:,1),1,num_group),reshape(meanse(subjix,a,i,2,:,2),1,num_group),1,[0.5 0.5 1])
        straightline(0,'h','-k')
        hold off
        xlim([0 72])
        title(sprintf('Subj %02d - %ch : ROI %s',subjix,hemis(a),roi{i}));
        xticks([0:1:72])
        xticklabels(lbl)
        xtickangle(90)
        %nam = sprintf('/Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s/NSDSyn_%02d%02d%02d_Group.png',subjix,hemis(a),roi{i},subjix,a,i);
        %print(f1,'-dpng',[pwd nam]);
        drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/newfigs';
        nam = sprintf('%s/Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s/',drop0,subjix,hemis(a),roi{i});
        filename0 = sprintf('NSDSyn_%02d%02d%02d_Group',subjix,a,i);
%        print(f1,'-dpng',[pwd nam]);
        figurewrite(filename0,f1,[],nam);
        unix(sprintf('chmod -R g+w %s',drop0));
    end
 end
end


%% Viz 2

lbl = {'0','WN','BWN','PN','NI1','NI1-1','MO','LD','4%C','6%C','10%C','50%C','NI2','0%PC','25%PC','50%PC','75%PC','NI2','WL1-P1','WL1-P2','WL1-P3','WL1-P4','WL1-P5','WL2-P1','WL2-P2','WL2-P3','WL2-P4','WL2-P5','SF1-R','SF2-R','SF3-R','SF4-R','SF5-R','SF6-R','SF1-CW','SF2-CW','SF3-CW','SF4-CW','SF5-CW','SF6-CW','SF1-CIR','SF2-CIR','SF3-CIR','SF4-CIR','SF5-CIR','SF6-CIR','SF1-CCW','SF2-CCW','SF3-CCW','SF4-CCW','SF5-CCW','SF6-CCW','SC','LCW','LCCW','SCCW','A-C','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16'};
order = [1,2,3,4,5,6,7,12,11,10,9,8,16,15,14,13,8,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71];
req = meanse(:,:,:,:,order,:);
save('NSDSynth_8subj2hemi5roi2tasks72groupsmnandse_b3.mat','req');
for subjix = 1:nsubj
 for a = 1:2    
    for i = 1:5
  
        f1 = figureprep([0 0 3500 500]);
        mkdir(sprintf('Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s',subjix,hemis(a),roi{i}));
        
        errorbar3(1:num_group+1,reshape(req(subjix,a,i,1,:,1),1,num_group+1),reshape(req(subjix,a,i,1,:,2),1,num_group+1),1,[1 0.5 0.5])
        hold on
        errorbar3(1:num_group+1,reshape(req(subjix,a,i,2,:,1),1,num_group+1),reshape(req(subjix,a,i,2,:,2),1,num_group+1),1,[0.5 0.5 1])
        plot(1:num_group+1,reshape(req(subjix,a,i,1,:,1),1,num_group+1),'r','LineWidth',2)
        plot(1:num_group+1,reshape(req(subjix,a,i,2,:,1),1,num_group+1),'b','LineWidth',2)
        hold off
        xticks(0:1:73)
        xticklabels(lbl)
        xtickangle(90)
        ax = axis;
        ylim(max(abs(ax(3:4)))*[-1 1]);
        xlim([0 73])
        straightline([3.5,7.5,12.5,17.5,22.5,27.5,33.5,39.5,45.5,51.5,55.5,72.5],'v','--k')
        straightline(0,'h','-k')
        title(sprintf('Subj %02d - %ch : ROI %s',subjix,hemis(a),roi{i}));

        drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/newfigs2';
        nam = sprintf('%s/Image_Group_Plots/Subject_%02d/%ch_Hemisphere/%s/',drop0,subjix,hemis(a),roi{i});
        filename0 = sprintf('NSDSyn_%02d%02d%02d_Group',subjix,a,i);

        figurewrite(filename0,f1,[],nam);
        unix(sprintf('chmod -R g+w %s',drop0));
    end
 end
end


%% Correlation Plots

figure
f2 = figureprep([0 0 3500 500]);

fixtask = meanse(:,:,:,1,:,1);
fixtask = permute(fixtask,[2,3,1,4,5]);
fixtask = reshape(fixtask,[hemi*num_roi*nsubj,num_group]);
memtask = meanse(:,:,:,2,:,1);
memtask = permute(memtask,[2,3,1,4,5]);
memtask = reshape(memtask,[hemi*num_roi*nsubj,num_group]);
tottask = [fixtask,memtask];
X = corr(tottask');
imagesc(X)
colormap(hot)
colorbar
caxis([0 1])
hold on
for g = 1: nsubj
   for t = 1:10
      straightline(10*(g-1)+t,'h','-c')

      straightline(10*(g-1) + t,'v','-c')
 end  
    
     for s = 1: 5
         straightline((g-1)*10 +2*s,'h','-g')
         straightline((g-1)*10 + 2*s, 'v', '-g')
     end
 straightline(10*g,'h','-m')

 straightline(10*g,'v','-m')
 
 

end


        drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/Corr_Plots';
        nam = sprintf('%s/Beta_3/',drop0);
        filename0 = sprintf('NSDSyn_Corr_b3');

        figurewrite(filename0,f2,[],nam);
        unix(sprintf('chmod -R g+w %s',drop0));

%% Group average

grpavg1 = [];
for subjix = 1: nsubj
    for hem = 1:2
        for i = 1:5
            for tsk = 1:2
                
             if(~(sum(abs(req(subjix,hem,i,tsk,:,1)))>0))  
                 subjix,hem,i
              grpavg1(subjix,hem,i,tsk,:) = NaN;  
                
             else
                 grpavg1(subjix,hem,i,tsk,:) = reshape(req(subjix,hem,i,tsk,:,1),1,72);
             end
             end
        end
    end
end

grpavg1 = req(:,:,:,:,:,1);
grpavg1(repmat(all(all(grpavg1==0,5),4),[1 1 1 2 72])) = NaN;

hemavg = nanmean(grpavg1,2);

for subjix = 1 : nsubj
        for i = 1:5
            scale_val = norm(reshape(hemavg(subjix,1,i,:,:),1,(num_group+1)*2)); 
            hemavg(subjix,1,i,:,:) = hemavg(subjix,1,i,:,:)./scale_val;
        end
end



grpmean = nanmean(hemavg,1);  % mean across subjects
grpstd = nanstd(hemavg,0,1);  % std across subjects

grpse = [];
for i = 1:num_roi
  sz = sum(~isnan(hemavg(:,1,i,1,1)));
  grpse(1,1,i,:,:) = grpstd(1,1,i,:,:)./(sqrt(sz));
  
end

%FASTER:
%grpse2 = nanstd(hemavg,0,1) ./ sqrt(sum(~isnan(hemavg),1));


gmean = reshape(grpmean,num_roi,2,num_group+1);
gse = reshape(grpse,num_roi,2,num_group+1);
save('NSDSynth_Groupavg_5roi_2tasks_72groups_mnandse_b3.mat','gmean','gse'); 
load NSDSynth_Grandmean_5ROI_Beta_ver2.mat


s_val = [];
for i = 1:5
    
     s_val(i) = (mn3(i)./mean(reshape(gmean(i,:,:),1,2*(num_group+1)),2));
     
end

 
gmean2 = gmean.*repmat(s_val',1,2,num_group+1);
gse2 = gse.*repmat(s_val',1,2,num_group+1);
save('NSDSynth_Groupavg_5roi_2tasks_72groups_mnandse_b3_ver2.mat','gmean2','gse2'); 

% Viz it
count = 1;
f1 = figureprep([0 0 3500 2500]);
for i = 1:5
        
        
        subplot(5,1,count)
        errorbar3(1:num_group+1,reshape(s_val(i).*gmean(i,1,:),1,num_group+1),reshape(s_val(i).*gse(i,1,:),1,num_group+1),1,[1 0.5 0.5])
        hold on
        errorbar3(1:num_group+1,reshape(s_val(i).*gmean(i,2,:),1,num_group+1),reshape(s_val(i).*gse(i,2,:),1,num_group+1),1,[0.5 0.5 1])
        plot(1:num_group+1,reshape(s_val(i)*gmean(i,1,:),1,num_group+1),'r','LineWidth',2)
        plot(1:num_group+1,reshape(s_val(i)*gmean(i,2,:),1,num_group+1),'b','LineWidth',2)
        straightline([3.5,7.5,12.5,17.5,22.5,27.5,33.5,40.5,46.5,52.5,56.5,72.5],'v','--k');
        straightline(0,'h','-k');
%        h1 = straightline(mean(gmean(i,1,:),3),'h','m');
%        h2 = straightline(mean(gmean(i,2,:),3),'h','c');
%        set(h1,'LineWidth',2);
%        set(h2,'LineWidth',2);
        xlim([0 73])
        title(sprintf('Group Average : ROI %s',roi{i}));
        xticks(0:1:73)
        xticklabels(lbl)
        xtickangle(90)
        ylim([-3 3]);
        count = count + 1;
 

end
        drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/newfigs2';
        nam = sprintf('%s/Group_Average/',drop0);
        filename0 = sprintf('NSDSyn_Group_Average_b3_fixed');

        figurewrite(filename0,f1,[],nam);
%        unix(sprintf('chmod -R g+w %s',drop0));


%% Scatter Plots

cmap0 = jet(7);
%'ro','filled'
%'rs','filled'

grp_2 = {1:3,4:7,8:12,13:17,18:27,28:55,56:72};
%axis square;
%axis([-3 3 -3 3]);


%% FIG
count = 1;

f3 = figureprep([0 0 3500 2500]);
for i = 1:5
    
    for p = 1:5
        if p>=i
            count = count + 1;
            continue;
        end
        
        subplot(5,5,count)
        %        scatter(reshape(s_val(i).*gmean(p,1,:),1,num_group + 1), reshape(s_val(i).*gmean(i,1,:),1,num_group+1),'o','filled')
        hold on
        %        scatter(reshape(s_val(i).*gmean(p,2,:),1,num_group + 1), reshape(s_val(i).*gmean(i,2,:),1,num_group+1),'s','filled');
        hs = [];
        for ii=1:7
            htemp = scatter(reshape(s_val(p).*gmean(p,1,grp_2{ii}),1,size(grp_2{ii},2)), reshape(s_val(i).*gmean(i,1,grp_2{ii}),1,size(grp_2{ii},2)),16,'ro');
            hs(ii)=htemp;
            set(htemp,'CData',cmap0(ii,:));
            set(scatter(reshape(s_val(p).*gmean(p,2,grp_2{ii}),1,size(grp_2{ii},2)), reshape(s_val(i).*gmean(i,2,grp_2{ii}),1,size(grp_2{ii},2)),16,'rs'),'CData',cmap0(ii,:));
        end
        scatter(mean(reshape(s_val(p).*gmean(p,1,:),1,num_group+1),2),mean(reshape(s_val(i).*gmean(i,1,:),1,num_group+1),2),'rd','filled')
        scatter(mean(reshape(s_val(p).*gmean(p,2,:),1,num_group+1),2),mean(reshape(s_val(i).*gmean(i,2,:),1,num_group+1),2),'bd','filled')
        title(sprintf('%s vs %s ',roi{i},roi{p}));
        xlabel(sprintf('%s',roi{p}));
        ylabel(sprintf('%s',roi{i}));
        y = [-3:.001:3];
        plot(y,y)
        legend(hs,{'noise' 'natural' 'contrast' 'coherence' 'words' 'gratings' 'color'},'Location','EastOutside');
        axis square;
        axis([-2 2 -2 2]);
        straightline(0,'v','k:');
        straightline(0,'h','k:');
       
        count = count + 1;
    end
    
end
drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/newfigs2';
nam = sprintf('%s/Scatter/',drop0);
filename0 = sprintf('NSDSyn_Scatter_b3');

figurewrite(filename0,f1,[],nam);
unix(sprintf('chmod -R g+w %s',drop0));




%% Differences in the mean of the tasks in each ROI


for i = 1:num_roi
   
    task_ratio(i) = mean(reshape(s_val(i).*gmean(i,2,:),1,num_group+1),2)./mean(reshape(s_val(i).*gmean(i,1,:),1,num_group+1),2);
    
    
end

%ceil(rand(1,72)*72)