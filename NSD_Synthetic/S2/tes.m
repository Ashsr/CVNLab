%% t - test for angle metric

vals2 = reshape(nanmean(vals,2), nsubj,num_roi); % vals from previous script

for i = 1:num_roi
    for j = 1:num_roi
        [h,pval] = ttest(reshape(vals2(:,i),nsubj,1),reshape(vals2(:,j),nsubj,1));
        p(i,j) = log10(pval);
    end
end

figure
heatmap(roi,roi,p,'Colormap',hot)
%xlabel(roi);
%ylabel(roi);
caxis([-3 0])


%%
drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/M_ROI_C_nothresh';
load (sprintf('%s/roi_compression.mat',drop0))

% Angle mets are 7 (ff) and 9 (fw)
vals2 = reshape(nanmean(roi_compression,3), 2,nsubj,num_roi,9);
for count = 1:2
    p = 1;
    if count == 1
        ROI_name = 'floc-faces';
        ROI_name2 = 'flocfaces';
    else
        ROI_name = 'floc-words';
        ROI_name2 = 'flocword';
    end
    file0 = sprintf('%s/freesurfer/subj01/label/%s.mgz.ctab',dir_roi,ROI_name);
    roi_description = read_ctab(file0);
    num_roi = roi_description.numEntries - 1;
    
    roi = roi_description.struct_names;
    type_no = [7,9];
    for a = 1:2
    for i = 1:num_roi
        for j = 1:num_roi
            [h,pval] = ttest(reshape(vals2(count,:,i,type_no(a)),nsubj,1),reshape(vals2(count,:,j,type_no(a)),nsubj,1));
            p(i,j) = log10(pval);
        end
    end
    
    
    f1 = figure
    heatmap(roi(2:6),roi(2:6),p,'Colormap',hot)
    caxis([-6 0])
    filename0 = sprintf('ttest_%s_Angmet_%d',ROI_name,type_no(a));
    figurewrite(filename0,f1,[],drop0);
    end
end