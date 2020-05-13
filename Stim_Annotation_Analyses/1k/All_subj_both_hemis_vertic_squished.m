load box_dim.mat

nsubj = 8;
count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20])  
for i = 1:nsubj
    rh_t = rh_tval(:,:,i);
    rh_t_img = rh_tval_img(:,:,:,i);
    lh_t = lh_tval(:,:,i);
    lh_t_img = lh_tval_img(:,:,:,i);
    subplot(8,8,count)
    imagesc(rh_t_img)
    title(sprintf('Subj%02d : RH - Box crop',i))
    subplot(8,8,count + 1)
    plot(nanmean(rh_t,1))
    hold on
    plot(1:size(nanmean(rh_t,1),2),mean(nanmean(rh_t,1)),'-k')
    hold off
    %ylim([-10 10])
    title( sprintf('Subj%02d : RH - \n Vertically Squished',i))
   
    subplot(8,8,count+2)
    imagesc(rh_t_img(:,1:10:end,:))
    title(sprintf('Subj%02d : RH - Box crop \n (skipping 10 pixels)',i))
    subplot(8,8,count + 3)
    plot(nanmean(rh_t(:,1:10:end),1))
    hold on
    plot(1:0.1:size(nanmean(rh_t(:,1:10:end),1),2),mean(nanmean(rh_t(:,1:10:end),1)),'-k')
    hold off
    %ylim([-10 10])
    title( sprintf('Subj%02d : RH - \n Vertically Squished \n (skipping every 10 pixels)',i))
    
    subplot(8,8,count+4)
    imagesc(lh_t_img)
    title(sprintf('Subj%02d : LH - Box crop',i))
    subplot(8,8,count + 5)
    plot(nanmean(lh_t,1))
    hold on
    plot(1:size(nanmean(lh_t,1),2),mean(nanmean(lh_t,1)),'-k')
    hold off
    %ylim([-10 10])
    title( sprintf('Subj%02d : LH - \n Vertically Squished',i))
    
     subplot(8,8,count+6)
    imagesc(lh_t_img(:,1:10:end,:))
    title(sprintf('Subj%02d : LH - Box crop \n (skipping every 10 pixels)',i))
    subplot(8,8,count + 7)
    plot(nanmean(lh_t(:,1:10:end),1))
        hold on
    plot(1:0.1:size(nanmean(lh_t(:,1:10:end),1),2),mean(nanmean(lh_t(:,1:10:end),1)),'-k')
    hold off
    %ylim([-10 10])
    title( sprintf('Subj%02d : LH - \n Vertically Squished \n (skipping every 10 pixels)',i))
    count = count + nsubj;
end

saveas(gcf,'Allsubjs_both_hemis_squished_along_vertical_axis.png','png');