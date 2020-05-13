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
                hist2d1(c1,c2)
                %colormap(hot);
                %colorbar;
                xlabel(xl);
                ylabel(yl);
                %ylim([-100 100]);
                %xlim([-100 100]);
            end
        end
    end
    toc
    print(subj,'-dpng');
end

                