load av_ffa.mat
nsubj = 8;
numbins = 4;
reqbins = [1,2,3,5];
f1 = figure 
cmap0 = jet(8);
cmp2 = ['y', 'r','m','c','k','g','b','w'];
hold on
for subj =1:nsubj
    for i = 1:numbins
     min_num(i) = size(cell2mat(av_ffa(8,1,reqbins(i))),2);
     temp = cell2mat(av_ffa(subj,1,reqbins(i)));
     mn_lh(subj,i) = mean(temp(1:min_num(i)));
     stde_lh(subj,i) = std(temp(1:min_num(i)))./sqrt(min_num(i));
    end
    e = errorbar(1:1:numbins,mn_lh(subj,:),stde_lh(subj,:),cmp2(subj));
    set(e, 'Color',cmap0(subj,:));
     t2(subj) = {sprintf('Subject %02d',subj)};
end
  legend(t2(:),'Location','NorthEast');
  hold off

  axis tight
  xlabel('Bin levels','FontSize',20);
  ylabel('Mean FFA Percentage Signal Values','FontSize',20);
    %ylim([0 2.3])
  xlim([1 4])
  ylim([0 3])
   title('Mean FFA Left Hemisphere of all subjects with errorbar','FontSize',20);
           
     
  f2 = figure 
cmap0 = jet(8);
hold on
for subj =1:nsubj
    for i = 1:numbins
     min_num(i) = size(cell2mat(av_ffa(8,2,reqbins(i))),2);
     temp = cell2mat(av_ffa(subj,2,reqbins(i)));
     mn_rh(subj,i) = mean(temp(1:min_num(i)));
     stde_rh(subj,i) = std(temp(1:min_num(i)))./sqrt(min_num(i));
    end
   e2 = errorbar(1:1:numbins,mn_rh(subj,:),stde_rh(subj,:));
   set(e2,'Color',cmap0(subj,:)); 
     t2(subj) = {sprintf('Subject %02d',subj)};
end
  legend(t2(:),'Location','NorthEast');
  hold off
  axis tight
  xlabel('Bin levels','FontSize',20);
   ylim([0 3])
  xlim([1 4])
  ylabel('Mean FFA Percentage Signal Values','FontSize',20);

   title('Mean FFA Right Hemisphere of all subjects with errorbar','FontSize',20);
   
   f3 = figure 
cmap0 = jet(8);
hold on
for subj =1:nsubj
    
    plot(mn_lh(subj,:),'-','Color',cmap0(subj,:),'LineWidth',3);
     t2(subj) = {sprintf('Subject %02d',subj)};
end
  legend(t2(:),'Location','NorthEast');
  hold off

  axis tight
  xlabel('Bin levels','FontSize',20);
  ylabel('Mean FFA Percentage Signal Values','FontSize',20);
    %ylim([0 2.3])
  xlim([1 4])
  ylim([0 4])
   title('Mean FFA Left Hemisphere of all subjects','FontSize',20);
           
     
  f4 = figure 
cmap0 = jet(8);
hold on
for subj =1:nsubj
    
    plot(mn_rh(subj,:),'-','Color',cmap0(subj,:),'LineWidth',3);
     t2(subj) = {sprintf('Subject %02d',subj)};
end
  legend(t2(:),'Location','NorthEast');
  hold off
  axis tight
  xlabel('Bin levels','FontSize',20);
   ylim([0 4])
  xlim([1 4])
  ylabel('Mean FFA Percentage Signal Values','FontSize',20);

   title('Mean FFA Right Hemisphere of all subjects','FontSize',20);
              
  saveas(f1,'MeanFFA_LeftHemisphere_allsubjects_witherrorbar.png');
  saveas(f2,'MeanFFA_RightHemisphere_allsubjects_witherrorbar.png');
  saveas(f3,'MeanFFA_LeftHemisphere_allsubjects_withouterrorbar.png');
  saveas(f4,'MeanFFA_RightHemisphere_allsubjects_withouterrorbar.png');
  
  
  %% As subplots
  
  nsubj = 8;
count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20]) 

for subj = 1:nsubj
    subplot(8,2,count)
    for i = 1:numbins
     min_num(i) = size(cell2mat(av_ffa(8,1,reqbins(i))),2);
     temp = cell2mat(av_ffa(subj,1,reqbins(i)));
     mn_lh(subj,i) = mean(temp(1:min_num(i)));
     stde_lh(subj,i) = std(temp(1:min_num(i)))./sqrt(min_num(i));
    end
    errorbar3(1:numbins,mn_lh(subj,:),stde_lh(subj,:),1,[1 0.5 0.5])
    title(sprintf('Subject %02d - LH',subj));
    count = count + 1;
    subplot(8,2,count)
    for i = 1:numbins
     min_num(i) = size(cell2mat(av_ffa(8,2,reqbins(i))),2);
     temp = cell2mat(av_ffa(subj,2,reqbins(i)));
     mn_rh(subj,i) = mean(temp(1:min_num(i)));
     stde_rh(subj,i) = std(temp(1:min_num(i)))./sqrt(min_num(i));
    end
    errorbar3(1:numbins,mn_rh(subj,:),stde_rh(subj,:),1,[0.5 0.5 1])
    title(sprintf('Subject %02d - RH',subj));
    count = count + 1;
    
    
    
    
end

saveas(gcf,'FFA_NSD_facebin_subplot.png','png');