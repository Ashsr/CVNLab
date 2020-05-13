%% Data Visualisation and Exploration

% To compute mean, median and standard deviations for various sessions of
% different subjects. 


function DMallvox(betatype,nsess,ntps,nsubj)

  %Checks if this function is already called 
  filename = sprintf('beta_allvox_%02d.mat',betatype);
  if exist(filename,'file') == 2 
    disp('File exists');
  else
    nsddatadir = '/home/surly-raid4/kendrick-data/nsd/nsddata'; % Directory to access data
    beta1 = {}; % Initialise empty cell to store betas
    

    for subjix = 1:nsubj



      a1 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1pt8mm/TESTBACKBRAIN.nii.gz',nsddatadir,subjix)));% Load mask
      a2 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1pt8mm/R2.nii.gz',nsddatadir,subjix)));% Load variance explained averaged over all sessions

      a1 = double(a1.img); % Casting to double from int16
      a2 = double(a2.img);

      ix=find(a1>0 & a2>5); % Find required voxels by limiting the threshold
      % Create a binary mask with the voxels we want set to 1
      vol = zeros(size(a1));
      vol(ix) = 1;
      nvox(subjix) = size(ix,1);
      ixval{subjix,:} = ix;

      [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii

      for i = 1:nsess % Loop over sessions

      % Depending on the beta preparation chosen the corresponding file is accessed to get the betas 
        if betatype == 1
          a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1pt8mm/betas_assumehrf/betas_session' sprintf('%02d',i) '.mat']); % Get betas from the selected voxels from each session
        else
          if betatype == 2 
            a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1pt8mm/betas_fithrf/betas_session' sprintf('%02d',i) '.mat']); % Get betas from the selected voxels from each session
          else 
            if betatype == 3
              a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1pt8mm/betas_fithrf_GLMdenoise_RR/betas_session' sprintf('%02d',i) '.mat']); % Get betas from the selected voxels from each session
            else
              disp('Invalid choice, please try again');
                
              return
            end
          end
        end
 

        temp = double(squish(a3.betas(d1,d2,d3,:),3))./300; % Cast into double and divide by 300 to get original values
        temp = temp(ii,:); 
        beta1{i,subjix} = temp; % Store the values in the cell

      end

      %data = cell2mat(beta1(:,subjix)); % Push all sessions subject betas to matrix



      %% Compute Mean, Standard deviation, median and plot them 

      % Session wise - whole data

      for i = 1:nsess
        sessval = []; % Clear previous values
        sessval = cell2mat(beta1(i,subjix)); % Push current subject, current session betas
        spa_sessval = mean(sessval,1); % Spatial aggregated values, i.e., a super voxel with 750 trial values
        tempa_sessval = mean(sessval,2); % Temporal aggregated values, i.e., a super trial values for 1000 voxels 
        mean_subj_sess(subjix,i) = mean(sessval(:)); % Compute mean, same for the temporally aggregated and spatially aggregated values
        med_subj_sess(subjix,i) = median(sessval(:)); % Compute median
        std_subj_sess(subjix,i) = std(sessval(:)); % Compute Standard deviation
        mean_subj_sess_each_vox{subjix,i,:} = mean(sessval'); % Compute mean of individual voxels for the 750 trials
        med_subj_sess_each_vox{subjix,i,:} = median(sessval'); % Compute median of individual voxels for the 750 trials 
        std_subj_sess_each_vox{subjix,i,:} = std(sessval'); % Compute standard deviation of individual voxels for 750 trials 
        mean_subj_sess_spa(subjix,i) = mean(spa_sessval); % Compute the mean of Spatially aggregated aka super voxel
        med_subj_sess_spa(subjix,i) = median(spa_sessval); % Compute the median of Spatially aggregated aka super voxel
        std_subj_sess_spa(subjix,i) = std(spa_sessval); % Compute the standard deviation of Spatially aggregated aka super voxel
        mean_subj_sess_tempa(subjix,i) = mean(tempa_sessval); % Compute the mean of temporally aggregated aka super trial
        med_subj_sess_tempa(subjix,i) = median(tempa_sessval); % Compute the median of temporally aggregated aka super trial
        std_subj_sess_tempa(subjix,i) = std(tempa_sessval); % Compute the standard deviation of temporally aggregated aka super trial
        
        
      end

      subjix

    end


  %% Save workspace

  save(filename,'beta1','mean_subj_sess','std_subj_sess','med_subj_sess','nvox','ixval','mean_subj_sess_each_vox','med_subj_sess_each_vox','std_subj_sess_each_vox','mean_subj_sess_spa','med_subj_sess_spa','std_subj_sess_spa','mean_subj_sess_tempa','med_subj_sess_tempa','std_subj_sess_tempa','-v7.3');
  end
  
  disp('Function DM executed');
end


  
  
