%% Data Visualisation and Exploration

% To visualise mean, median and standard deviations for various sessions of
% different subjects computed using the function DM. 


function DMallvoxPlots(betatype,nsess,ntps,nsubj)



  % To check if DM Function has been run previously
  filename = sprintf('beta_allvox_%02d.mat',betatype);
  if exist(filename,'file') == 2
    disp('File exists');
    
  else
    DMallvox(betatype,nsess,ntps,nsubj);
  end

  load (filename) % Load the output file from DM Function
  mkdir (sprintf('Sessionwise_%02d',betatype)) %Create new directory to save the plots. The directory name has the type of beta preparation utilised for the analysis as its suffix for easy identification.

  for subjix = 1:nsubj

    mkdir (sprintf('Sessionwise_%02d/Total_Data_%02d/Subject_%02d_%02d',betatype,betatype,subjix,betatype)); % The beta preparation is suffixed after the Subject directory as well for clarity.
    mkdir (sprintf('Sessionwise_%02d/Spatially_Aggregated_Data_%02d/Subject_%02d_%02d',betatype,betatype,subjix,betatype)); % The beta preparation is suffixed after the Subject directory as well for clarity.
    mkdir (sprintf('Sessionwise_%02d/Temporally_Aggregated_Data_%02d/Subject_%02d_%02d',betatype,betatype,subjix,betatype)); % The beta preparation is suffixed after the Subject directory as well for clarity.

    

    %% Plot Mean, Standard deviation, median  

    % Session wise - Total Data

    for i = 1:nsess
      sess = []; % Clear previous values
      sess = cell2mat(beta1(i,subjix)); % Push current subject, current session betas
      spa_sess = mean(sess,1); % Spatially aggregated values
      tempa_sess = mean(sess,2); % Temporally aggregated values  
      
      figure; 
      hold on;
      hist(sess(:),100); % Plot a histogram using hundred bins
      ax = axis; % Get the current axis bounds
    
      % Plot lines showing mean, median and +/- 1 std dev
    
      h1 = plot([mean_subj_sess(subjix,i) mean_subj_sess(subjix,i)], ax(3:4),'--r');
      h2 = plot([mean_subj_sess(subjix,i)-std_subj_sess(subjix,i) mean_subj_sess(subjix,i)-std_subj_sess(subjix,i)],ax(3:4),'--g');
      h3 = plot([mean_subj_sess(subjix,i)+std_subj_sess(subjix,i) mean_subj_sess(subjix,i)+std_subj_sess(subjix,i)],ax(3:4),'--g');
      h4 = plot([med_subj_sess(subjix,i) med_subj_sess(subjix,i)],ax(3:4),'--y');
      hold off
    
      xlabel('Percentage Signal Values');
      ylabel('Frequency');
      xlim([-150,150]);
      ylim([0 6000000]);
      legend([h1 h2 h3 h4],{'Mean', 'Mean - Std','Mean + Std','Median'});
      str2 = sprintf('Data Subject %02d, Session %02d  with mean,median and +/- 1 std dev',subjix,i);
      title(str2);
      str1 = sprintf('/Sessionwise_%02d/Total_Data_%02d/Subject_%02d_%02d/Data_Subject_%02d,_Session_%02d_%02d.png',betatype,betatype,subjix,betatype,subjix,i,betatype);
      print('-dpng',[pwd str1]); % Save figure

      % Plot Spatially aggregated figures 
      figure; 
      hold on;
      hist(spa_sess(:),100); % Plot a histogram using hundred bins
      ax = axis; % Get the current axis bounds
    
      % Plot lines showing mean, median and +/- 1 std dev
    
      h1 = plot([mean_subj_sess_spa(subjix,i) mean_subj_sess_spa(subjix,i)], ax(3:4),'--r');
      h2 = plot([mean_subj_sess_spa(subjix,i)-std_subj_sess_spa(subjix,i) mean_subj_sess_spa(subjix,i)-std_subj_sess_spa(subjix,i)],ax(3:4),'--g');
      h3 = plot([mean_subj_sess_spa(subjix,i)+std_subj_sess_spa(subjix,i) mean_subj_sess_spa(subjix,i)+std_subj_sess_spa(subjix,i)],ax(3:4),'--g');
      h4 = plot([med_subj_sess_spa(subjix,i) med_subj_sess_spa(subjix,i)],ax(3:4),'--y');
      hold off
    
      xlabel('Super Voxel Percentage Signal Values');
      ylabel('Frequency');
      xlim([-10,15]);
      ylim([0 45]);
      legend([h1 h2 h3 h4],{'Mean', 'Mean - Std','Mean + Std','Median'});
      str3 = sprintf('Spatially Aggregated Data Subject %02d, Session %02d  with mean,median and +/- 1 std dev',subjix,i);
      title(str3);
      str4 = sprintf('/Sessionwise_%02d/Spatially_Aggregated_Data_%02d/Subject_%02d_%02d/Spatially_Aggregated_Data_Subject_%02d,_Session_%02d_%02d.png',betatype,betatype,subjix,betatype,subjix,i,betatype);
      print('-dpng',[pwd str4]); % Save figure

      % Plot temporally aggregated figures

      figure; 
      hold on;
      hist(tempa_sess(:),100); % Plot a histogram using hundred bins
      ax = axis; % Get the current axis bounds
    
      % Plot lines showing mean, median and +/- 1 std dev
    
      h1 = plot([mean_subj_sess_tempa(subjix,i) mean_subj_sess_tempa(subjix,i)], ax(3:4),'--r');
      h2 = plot([mean_subj_sess_tempa(subjix,i)-std_subj_sess_tempa(subjix,i) mean_subj_sess_tempa(subjix,i)-std_subj_sess_tempa(subjix,i)],ax(3:4),'--g');
      h3 = plot([mean_subj_sess_tempa(subjix,i)+std_subj_sess_tempa(subjix,i) mean_subj_sess_tempa(subjix,i)+std_subj_sess_tempa(subjix,i)],ax(3:4),'--g');
      h4 = plot([med_subj_sess_tempa(subjix,i) med_subj_sess_tempa(subjix,i)],ax(3:4),'--y');
      hold off
    
      xlabel('Percentage Signal Values for super trial');
      ylabel('Frequency');
      xlim([-100,100]);
      ylim([0 8000]);
      legend([h1 h2 h3 h4],{'Mean', 'Mean - Std','Mean + Std','Median'});
      str2 = sprintf('Temporally Aggregated Data Subject %02d, Session %02d  with mean,median and +/- 1 std dev',subjix,i);
      title(str2);
      str1 = sprintf('/Sessionwise_%02d/Temporally_Aggregated_Data_%02d/Subject_%02d_%02d/Data_Subject_%02d,_Session_%02d_%02d.png',betatype,betatype,subjix,betatype,subjix,i,betatype);
      print('-dpng',[pwd str1]); % Save figure
    end


  subjix

  end
  % Plot means of all subjects
  figure
  hold on
  cmap0 = jet(8);
  for p = 1:size(mean_subj_sess,1)
    t = plot(mean_subj_sess(p,:),'-','Color',cmap0(p,:),'LineWidth',3);
    ylim([0 10]);
    t2(p) = {sprintf('Subject %02d',p)};
  end
  legend(t2(:),'Location','Best');

  hold off
  xlabel('Sessions');
  ylabel('Percentage Signal Values');
  title('Mean of all subjects across all sessions');
  str = sprintf('All_mean_%02d',betatype); % Beta preparation type is suffixed for clarity
  print(str,'-dpng'); % Save figure


  % All medians are plotted
  figure
  hold on
  cmap0 = jet(8);
  for p = 1:size(med_subj_sess,1)
    t = plot(med_subj_sess(p,:),'-','Color',cmap0(p,:),'LineWidth',3);
    ylim([0 10]);
    t2(p) = {sprintf('Subject %02d',p)};
  end
  legend(t2(:),'Location','Best');
  hold off
  xlabel('Sessions');
  ylabel('Percentage Signal Values');
  title('Median of all subjects across all sessions');
  str = sprintf('All_median_%02d',betatype); % Beta preparation type is suffixed for clarity
  print(str,'-dpng'); % Save figure

  close all
  disp('Function executed')

end