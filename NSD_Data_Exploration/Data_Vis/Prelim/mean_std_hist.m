load mean_std_exploration.mat
for i =1:subjix
    for j=1:nsess
        figure
        subj=sprintf('Subject %02d - Session %02d',i,j);
        title(subj)
        val=reshape(mean_eachvox(i,j,:),1000,1);
        hist(val,100);
        xlabel('Mean values');
        xlim([-20 60]);
        ylim([0 140]);
        ylabel('Voxel frequency');
        print(subj,'-dpng');  
    end
end

%% Std histograms Each voxel 

load mean_std_exploration.mat
for i =1:subjix
    for j=1:nsess
        figure
        subj=sprintf('Subject %02d - Session %02d',i,j);
        title(subj)
        val=reshape(std_eachvox(i,j,:),1000,1);
        hist(val,100);
        xlabel('Mean values');
        xlim([-20 60]);
        ylim([0 160]);
        ylabel('Voxel frequency');
        print(subj,'-dpng');  
    end
end

%% Mean/Std for each voxel
load mean_std_exploration.mat
for i =1:subjix
    for j=1:nsess
%         figure
%         subj=sprintf('Subject %02d - Session %02d',i,j);
%         title(subj)
        std1=reshape(std_eachvox(i,j,:),1000,1);
        mean1=reshape(mean_eachvox(i,j,:),1000,1);
        val=mean1./std1;
        mean_val(i,j)=mean(val);
        hist(val,100);
%         xlabel('Mean values');
%         xlim([-20 60]);
%         ylim([0 160]);
%         ylabel('Voxel frequency');
%         print(subj,'-dpng');  
    end
end

figure
hold on
cmap0 = jet(8);
for p=1:subjix
  t=plot(mean_val(p,:),'-','Color',cmap0(p,:));
  ylim([0 5]);
  t2(p)={sprintf('Subject %02d',p)};
end
legend(t2(:),'Location','Best');
hold off
xlabel('Sessions');
ylabel('Mean/Std Values');
title('Mean/Std of all subjects across all sessions');
str='All_meanbystd';
print(str,'-dpng'); % Save figure