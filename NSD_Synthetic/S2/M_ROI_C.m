%% Massive ROI Compression
thresh = input('Enter the tval threshold');
types = {'Thk','pRF ecc','pRF x','pRF y','pRF size','ff tval','ff angle','fw tval','fw angle'};
for count = 1:2
    if count == 1
        ROI_name = 'floc-faces';
        ROI_name2 = 'flocfaces';
    else
        ROI_name = 'floc-words';
        ROI_name2 = 'flocword';
    end
    
    nsubj = 8;
    dir_roi = '/home/surly-raid4/kendrick-data/nsd/nsddata';
    file0 = sprintf('%s/freesurfer/subj01/label/%s.mgz.ctab',dir_roi,ROI_name);
    roi_description = read_ctab(file0);
    num_roi = roi_description.numEntries - 1;
    roi = roi_description.struct_names;
    hemis = ['l','r'];
    
    for subjix = 1:nsubj, subjix
        for hemi = 1:2
          a1 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.%s.mgz',dir_roi,subjix,hemis(hemi),ROI_name));
          %a2 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.%stval.mgz',dir_roi,subjix,hemis(hemi),ROI_name2));
          for i = 1:num_roi
              ix = find((a1 == i)); % the required vertices
              
              % Thickness
              thk = cvnreadsurfacemetric(sprintf('subj%02d',subjix), sprintf('%ch',hemis(hemi)), 'thickness', '', 'orig');
              roi_compression(count,subjix,hemi,i,1) = median(thk(ix));
              
              % pRF eccentricity
              a3 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.prfeccentricity.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,2) = median(a3(ix));
              
              % pRF x
              a4 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.prfangle.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,3) = median(a3(ix).*cosd(a4(ix)));
              
              % pRF y
              roi_compression(count,subjix,hemi,i,4) = median(a3(ix).*sind(a4(ix)));
              
              %pRF Size
              a5 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.prfsize.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,5) = median(a5(ix));
              
              % floc face tval
              a6 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.flocfacestval.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,6) = median(a6(ix));
              
              % floc face angle
              a7 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.flocfacesanglemetric.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,7) = median(a7(ix));
              
              % floc word tval
              a8 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.flocwordtval.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,8) = median(a8(ix));
              
              % floc word angle
              a9 = cvnloadmgz(sprintf('%s/freesurfer/subj%02d/label/%ch.flocwordanglemetric.mgz',dir_roi,subjix,hemis(hemi)));
              roi_compression(count,subjix,hemi,i,9) = median(a9(ix));


          end
        end
    end
    

end

drop0 = '/home/stone/generic/Dropbox/nsdanalysis/asha/NSD_Synth/M_ROI_C_nothresh';
mkdir(drop0)

save(sprintf('%s/roi_compression.mat',drop0),'roi_compression');

ylims = {[2,3.5],[1.5,3.5];[0,6],[0,5];[-2,3],[-1,1.5];[-3,2],[-3,1];[0,5],[0,6];[1,7],[-6,4];[5,45],[-120,30];[-3,4],[0,10];[-40,20],[4,70]};
chk = 1;

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
    f1 = figureprep([0 0 3500 2500]);
    for type = 1:9
      for i = 1:num_roi
        for hemi = 1:2
          subplot(9,10,p)
          plot(reshape(roi_compression(count,:,hemi,i,type),nsubj,1),'-*')
          title(sprintf('%s ROI %s - %ch',types{type},roi{i+1},hemis(hemi)))
          p = p + 1; 
          xlim([0,9])
          ylim(ylims{type,count})
        end
      end
    end
    filename0 = sprintf('Massive_ROI_C_%s',ROI_name);
    figurewrite(filename0,f1,[],drop0);
end
%%                
grp_avg = nanmean(roi_compression,2);
grp_std = nanstd(roi_compression,[],2);
grp_se  = grp_std./sqrt(sum(~isnan(roi_compression),2));

xlbl = ['lh - OFA','rh - OFA','lh - FFA1','rh - FFA1','lh - FFA2','rh - FFA2','lh - mTL Faces','rh - mTL Faces','lh - aTL Faces','rh - aTL Faces','lh - OWFA','rh - OWFA','lh - VWFA1', 'rh - VWFA1','lh - VWFA2','rh - VWFA2','lh - mFS words','rh - mFS words','lh - mTL words','rh - mTL words'];
    
cmap0 = {[1 0.5 0.5],[0.5 0.5 1];[0.25 0.75 0.75],[0.75 0.75 0.25]};
f2 = figureprep([0 0 3500 2500]);
for type = 1:9
    subplot(9,1,type)
    hold on 
    chk = 1;
    for count = 1:2
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
        for i = 1:num_roi
            for hemi = 1:2
              xl = categorical({sprintf('%ch - %s',hemis(hemi),roi{i+1})}); 
             bar(xl,reshape(grp_avg(count,1,hemi,i,type),[1,1]),'FaceColor',cmap0{count,hemi})
             errorbar(chk,reshape(grp_avg(count,1,hemi,i,type),[1,1]),reshape(grp_se(count,1,hemi,i,type),[1,1]),'k')
             chk = chk + 1;
             
            end
        end
    end
    %bar(reshape(permute(grp_avg(:,:,:,:,type),[5,2,3,4,1]),20,1),'FaceColor','r'); %hard code 20
    
    ylabel(types{type})
    
   % straightline(10.5,'v','--k')
    %xlabel(xlbl);
    
end

 filename0 = sprintf('Group_plot');
 figurewrite(filename0,f2,[],drop0);  
