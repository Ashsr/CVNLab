%%% Summary Plots
% Mean vs Std plot
load mean_std_exploration.mat
meansess=mean(mean_eachvox,3);
stdsess=mean(std_eachvox,3);
m1=reshape(meansess',[],1);
s1=reshape(stdsess',[],1);
figure
hold on
cmap0 = jet(8);
for p=1:8
   t2(p)={sprintf('Subject %02d',p)}; 
  t(p)=plot(meansess(p,:),stdsess(p,:),'Color',cmap0(p,:),'DisplayName',t2(p));
  
  t1=plot(meansess(p,:),stdsess(p,:),'.','Color',cmap0(p,:));
  
  
end
legend([t],'Location','Best');
hold off
xlabel('Standard deviation');
ylabel('Mean');
title('Mean and standard deviation of all subjects across all sessions');
str='All_mean_std_summary';
print(str,'-dpng'); % Save figure

%% Mean bar Plots with std - all subjects, all sessions

figure
for i=1:8
    hold on
    x=(i-1)*nsess+1:i*nsess;
    bar(x,m1((i-1)*nsess+1:i*nsess),'FaceColor',cmap0(i,:));
    er=errorbar(x,m1((i-1)*nsess+1:i*nsess),s1((i-1)*nsess+1:i*nsess),'.k');
    er.Color = [0 0 0];                            
    er.LineStyle = 'none'; 
    xlabel('Sessions');
    ylabel('Mean with std');
    
     
end
hold off
str='Bar of mean with std';

print(str,'-dpng');
%% Per subject one mean,std plots
figure
for i=1:subjix
    m2(i)=mean(m1((i-1)*nsess+1:i*nsess));
    s2(i)=mean(s1((i-1)*nsess+1:i*nsess));
end
hold on
bar(m2);
errorbar(m2,s2,'.k');
xlabel('Subjects');
ylabel('Mean with std');
hold off    
str='Summary_Bar of mean with std';
print(str,'-dpng');   


%% Mean Correlation plots
for i=1:subjix
    for j=1:nsess
        for k=1:nsess
            
                c1=reshape(mean_eachvox(i,j,:),[1000 1]);
                c2=reshape(mean_eachvox(i,k,:),[1000 1]);
                cor_mean(i,j,k)=corr(c1,c2);   
        end
    end
    figure
    dat=reshape(cor_mean(i,:,:),[nsess,nsess]);
    clim=[0.8,1];
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str=sprintf('Corrplotmean_Subject_%02d',i);
    print(str, '-dpng');
end

%% Std Corr plots
for i=1:subjix
    for j=1:nsess
        for k=1:nsess
          c1=reshape(std_eachvox(i,j,:),[1000 1]);
                c2=reshape(std_eachvox(i,k,:),[1000 1]);
                cor_std(i,j,k)=corr(c1,c2);  
                 
        end
    end
    figure
    dat=reshape(cor_std(i,:,:),[nsess,nsess]);
    clim=[0.78,1];
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str=sprintf('Corrplotstd_Subject_%02d',i);
    print(str, '-dpng');
end

%% Mean by Std Corr Plots
for i=1:subjix
    for j=1:nsess
        for k=1:nsess
          c1m=reshape(mean_eachvox(i,j,:),[1000 1]);
                c1s=reshape(std_eachvox(i,j,:),[1000 1]);
                c1=c1m./c1s;
                c2m=reshape(mean_eachvox(i,k,:),[1000 1]);
                c2s=reshape(std_eachvox(i,k,:),[1000 1]);
                c2=c2m./c2s;
                cor_ratio(i,j,k)=corr(c1,c2);
        end
    end
    figure
    dat=reshape(cor_ratio(i,:,:),[nsess,nsess]);
    clim=[0.4,1];
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str=sprintf('Corrplotmeanbystd_Subject_%02d',i);
    print(str, '-dpng');
end


%% Save Workspace

save('summary_metrics','m2','s2');