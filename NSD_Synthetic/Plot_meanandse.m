load meanandse_rhlh.mat


nsubj = 8;
count = 1;
figure
set(gcf, 'PaperPosition', [0 0 20 20])  
totimg = 284;

for subj = 1: nsubj
    subplot(8,2,count)
    errorbar3(1:totimg,lh_vals(subj,:,1),lh_vals(subj,:,2),1,[1 0.5 0.5])
    count = count + 1;
    title(sprintf('Subject %02d - LH',subj))
    subplot(8,2,count)
    errorbar3(1:totimg,rh_vals(subj,:,1),rh_vals(subj,:,2),1,[0.5 0.5 1])
    count = count + 1;
    title(sprintf('Subject %02d - RH',subj))
    
end

saveas(gcf,'FFA_NSD_synth_meanandse_2.png','png');

%% Mean

for subj = 1: nsubj
    subplot(8,2,count)
    plot(lh_vals(subj,:,1),'Color','red')
    count = count + 1;
    title(sprintf('Subject %02d - LH',subj))
    subplot(8,2,count)
    plot(rh_vals(subj,:,1),'Color','blue')
    count = count + 1;
    title(sprintf('Subject %02d - RH',subj))
    
end

saveas(gcf,'FFA_NSD_synth_mean.png','png');