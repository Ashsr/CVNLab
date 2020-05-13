load mean_std_exploration.mat
for i=1:subjix
    figure
    subj=sprintf('Subject_%02d',i);
    title(subj)
    for j=1:nsess
        for k=1:nsess
            if (j~=k)
                c1=reshape(mean_eachvox(i,j,:),[1000 1]);
                c2=reshape(mean_eachvox(i,k,:),[1000 1]);
                no=(j-1)*7+k;
                cor_mean(i,j,k)=corr(c1,c2);
                xl=sprintf('Session %02d',j);
                yl=sprintf('Session %02d',k);
                subplot(7,7,no);
                scatter(c1,c2,'.b')
                text(-40,85,num2str(cor_mean(i,j,k)));
                xlabel(xl);
                ylabel(yl);
                ylim([-100 100]);
                xlim([-100 100]);
            end
        end
    end
    toc
    print(subj,'-dpng');
end

%% Std correlation plots
load mean_std_exploration.mat
for i=1:subjix
    figure
    subj=sprintf('Subject_%02d',i);
    title(subj);
    tic
    for j=1:nsess
        for k=1:nsess
            if (j~=k)
                c1=reshape(std_eachvox(i,j,:),[1000 1]);
                c2=reshape(std_eachvox(i,k,:),[1000 1]);
                no=(j-1)*7+k;
                cor_std(i,j,k)=corr(c1,c2);
                xl=sprintf('Session %02d',j);
                yl=sprintf('Session %02d',k);
                subplot(7,7,no);
                scatter(c1,c2,'.b')
                text(0,40,num2str(cor_std(i,j,k)));
                xlabel(xl);
                ylabel(yl);
                ylim([0 50]);
                xlim([0 50]);
            end
        end
    end
    toc
    print(subj,'-dpng');
end

%% Mean/std Correlation Plots
load mean_std_exploration.mat
for i=1:subjix
    figure
    subj=sprintf('Subject_%02d',i);
    title(subj);
    for j=1:nsess
        for k=1:nsess
            if (j~=k)
                c1m=reshape(mean_eachvox(i,j,:),[1000 1]);
                c1s=reshape(std_eachvox(i,j,:),[1000 1]);
                c1=c1m./c1s;
                c2m=reshape(mean_eachvox(i,k,:),[1000 1]);
                c2s=reshape(std_eachvox(i,k,:),[1000 1]);
                c2=c2m./c2s;
                no=(j-1)*7+k;
                cor_ratio(i,j,k)=corr(c1,c2);
                xl=sprintf('Session %02d',j);
                yl=sprintf('Session %02d',k);
                subplot(7,7,no);
                scatter(c1,c2,'.b')
                text(-4,4,num2str(cor_ratio(i,j,k)));
                xlabel(xl);
                ylabel(yl);
                ylim([-5 5]);
                xlim([-5 5]);
            end
        end
    end
    print(subj,'-dpng');
end

%% Correlation amongst the subjects for a session - Can't be done

figure

    for j=2:subjix
        c1=reshape(mean_eachvox(j,1,:),[1000 1]);
        c2=reshape(mean_eachvox(1,1,:),[1000 1]);
        str='Session 01 Correlation amongst subjects';
        subplot(4,2,j-1)
        scatter(c1,c2);
        sub=sprintf('Subject %02d',j);
        xlabel(sub);
        ylabel('Subject 01');
        xlim([-100 100]);
        ylim([-50 50]);
        cr=corr(c1,c2);
        text(-90,30,num2str(cr));
    end
        
    