% This script aims to plot scatter plots of voxelwise mean,std and their
% ratio amongst various sessions. It also makes a heat map of their
% corresponding correlation coefficents.


function DMallvoxCorr(betatype,nsess,ntps,nsubj)

  mkdir (sprintf('Correlation_Plots_%02d',betatype)) % Creates a new directory with the beta type as suffix
  filename = sprintf('beta_allvox_%02d.mat',betatype);

  % Check if the file exists or else run the DM function
  if exist(filename,'file') == 2
    disp('File exists');
    
  else
    DMallvox(betatype,nsess,ntps,nsubj);
  end


  load (filename)

  mkdir (sprintf('Correlation_Plots_%02d/Mean_corr_%02d',betatype,betatype)) % Make new directory to save plots - betaprep suffixed

  for i = 1:nsubj % Loops over each subject
    f1 = figure
    subj = sprintf('/Correlation_Plots_%02d/Mean_corr_%02d/Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    title(subj)
    for j = 1:nsess
      for k = 1:nsess
        c1 = reshape(cell2mat(mean_subj_sess_each_vox(i,j,:)),[nvox(i) 1]); % Considers voxelwise mean in the session
        c2 = reshape(cell2mat(mean_subj_sess_each_vox(i,k,:)),[nvox(i) 1]);
        no = (j-1)*nsess+k; % A counter for subplot placement
        cor_mean(i,j,k) = corr(c1,c2); % Finds their correlation coefficient
        if j ~= k % Plots the non similar sessions correlations
          xl = sprintf('S%02d',j);
          yl = sprintf('S%02d',k);
          subplot(nsess,nsess,no);
          scatter(c1,c2,'.b')
          text(-40,85,num2str(cor_mean(i,j,k)));
          xlabel(xl);
          ylabel(yl);
          ylim([-100 100]); % Setting Limits for the axes
          xlim([-100 100]);
        end
      end
    end
    print(f1,'-dpng',[pwd subj]); % Save plot
    
    %Plot the correlation coefficients
    f2 = figure
    dat = reshape(cor_mean(i,:,:),[nsess,nsess]);
    clim = [0.7,1]; % Colrbar limits
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str1 = sprintf('/Correlation_Plots_%02d/Mean_corr_%02d/Corrplotmean_Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    print(f2,'-dpng',[pwd str1])  
    end
    
    


  %% Std correlation plots
  mkdir (sprintf('Correlation_Plots_%02d/Std_corr_%02d',betatype,betatype)) % Make new directory to store new plots - beta prpe suffixed
  for i = 1:nsubj % Loops over Subjects
    f1 = figure
    subj=sprintf('/Correlation_Plots_%02d/Std_corr_%02d/Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    
    for j = 1:nsess
      for k = 1:nsess
        c1 = reshape(cell2mat(std_subj_sess_each_vox(i,j,:)),[nvox(i) 1]); % Considers voxelwise standard deviation for the session
        c2 = reshape(cell2mat(std_subj_sess_each_vox(i,k,:)),[nvox(i) 1]);
        no = (j-1)*nsess+k; % Subplot counter
        cor_std(i,j,k) = corr(c1,c2); % Correlation coefficient
        if j ~= k % Plot the correlation for dissimilar sessions
          xl = sprintf('S%02d',j);
          yl = sprintf('S%02d',k);
          subplot(nsess,nsess,no);
          scatter(c1,c2,'.b')
          text(0,40,num2str(cor_std(i,j,k)));
          xlabel(xl); % Axes labels
          ylabel(yl);
          ylim([0 50]); % Axes limits
          xlim([0 50]);
        end
      end
    end
    
    % Plot correlation coefficients
    f2 = figure
    dat = reshape(cor_std(i,:,:),[nsess,nsess]);
    clim = [0.7,1]; % Colorbar limits
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str2 = sprintf('/Correlation_Plots_%02d/Std_corr_%02d/Corrplotstd_Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    print(f2,'-dpng',[pwd str2]) % Save plot of correlation coefficients
     
    print(f1,'-dpng',[pwd subj]); % Save the scatter plot
  end
    
  %% Mean/std Correlation Plots
  mkdir (sprintf('Correlation_Plots_%02d/Mean_by_std_corr_%02d',betatype,betatype)) % Make a new directory to store the plots - betaprep suffixed

  % Loops over subjects 
  for i = 1:nsubj
    f1 = figure
    subj = sprintf('/Correlation_Plots_%02d/Mean_by_std_corr_%02d/Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    for j = 1:nsess
      for k = 1:nsess
        c1m = reshape(cell2mat(mean_subj_sess_each_vox(i,j,:)),[nvox(i) 1]); % Voxelwise mean for that session 
        c1s = reshape(cell2mat(std_subj_sess_each_vox(i,j,:)),[nvox(i) 1]); % Voxelwise std for that session
        c1 = c1m./c1s; % Their ratio
        c2m = reshape(cell2mat(mean_subj_sess_each_vox(i,k,:)),[nvox(i) 1]);
        c2s = reshape(cell2mat(std_subj_sess_each_vox(i,k,:)),[nvox(i) 1]);
        c2 = c2m./c2s;
        no = (j-1)*nsess+k; % Subplot counter
        cor_ratio(i,j,k) = corr(c1,c2); % Correlation coefficient
        if j ~= k % Scatter plot for dissimilar sessions
          xl = sprintf('S%02d',j);
          yl = sprintf('S%02d',k);
          subplot(nsess,nsess,no);
          scatter(c1,c2,'.b')
          text(-4,4,num2str(cor_ratio(i,j,k)));
          xlabel(xl); % Axes label
          ylabel(yl);
          ylim([-5 5]); % Axes limits
          xlim([-5 5]);
        end
      end
    end
    
    % Plot the correlation coefficients
    f2 = figure
    dat = reshape(cor_ratio(i,:,:),[nsess,nsess]);
    clim = [0.6,1]; % Colorbar limits
    imagesc(dat,clim);
    colorbar;
    colormap(hot);
    str3 = sprintf('/Correlation_Plots_%02d/Mean_by_std_corr_%02d/Corrplotmeanbystd_Subject_%02d_%02d.png',betatype,betatype,i,betatype);
    print(f2,'-dpng',[pwd str3]); % Save the correlation coefficient plot
    
    print(f1,'-dpng',[pwd subj]); % Save the scatter plot
  end
  close all
  disp('Correlation Plots are plotted and saved')
end    
    
