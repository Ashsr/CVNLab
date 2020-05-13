%% Noise ceiling calculations - NSD General ROI 
% 
% Aim:
% This code focuses on loading, finding NC values and projecting it on the flatmaps of the subjects' brains
% 
% Logic: 
% Load the voxel betas for the number of sessions specified, zscore them sessionwise. 
% Find voxelwise standard deviation for two and three repeats 
% Find their average - v metric
% Statistically simulate the experiment and vary the standard deviation of the noise and find the corresponding "v metric" .
% Use the experimentally determined "v metric value" to map it to the simulation to extrapolate and find the Noise Ceiling value of the voxels
% Find Noise ceiling values for single trial estimates, 2 trial averaged and 3 trial averaged.
% Plot histograms, find average plots for subjects, project it to flatmaps (all 3 layers) save as nifti volumes and .mat files.
% 
% Inputs: 
% betatype - integer - to choose which beta preparation to be used for analyses
% nsess - integer - number of sessions to be considered for analyses
% 
% Variables used:
% nsubj - integer - number of subjects
% ntps - integer - number of trials
% filename,fnam - string - filename to store the results
% nsddatadir - string - directory to access the data
% a1 - struct - mask
% a3 - matlab i/o file - Has the sessionwise beta values for the subject 
% subjix,sess,j,t,i,p,rep,st,en - integer - counter 
% beta1 - cell - store sessionwise subject beta values - size nsess x nsubj and each cell contains nvox x ntps
% d1,d2,d3 - vector - dimensions of the cuboid required to be loaded to extract the required voxels
% ix - vector - indices of the required voxels
% ii - vector - indices of the required voxels in the cuboid given by d1,d2,d3
% ixval - cell - store the indices of the voxels selected using mask, size 1 x nsubj where each cell has nvox x 1
% nvox - array - stores the number of voxels selected using the mask for each subject - size 8x1
% vol - 3D array - binary volume mask similar to NSDGeneral ROI
% volsize - cell - stores the volume size for reconstruction - size 1 x nsubj where each cell has size of the volume of the subject
% temp - array - single - used to temporarily hold the nvox's beta values for ntps trials - size nvox x ntps
% zsc - array - temporarily holds the sessionwise zscored voxel beta values - size nvox x ntps
% zscbeta - cell - stores the sessionwise zscored voxel beta values - size nsess x nsubj and each cell contains nvox x ntps
% val - array - to store the repeated trial voxel values temporarily to find their standard deviation - size 2/3 x nvox
% q - integer - to find the session in which the trial lies
% tval - integer - repeated trial value
% x - integer - the session number in which the repeated trial lies
% y - integer - the trial number within ntps (750) in the selected session (for the repeated trial)
% stadev2,stadev3 - cell - to store the standard deviation of the voxels for the repeated trials, size 1 x nsubj where each cell is number of repeats x nvox
% mstadev2,mstadev3 - cell - average standard deviation value for each voxel for all such repetations, size 1 x nsubj where each cell is 1 x nvox
% mstadev - array - final average of standard deviation value for each voxel for mstadev2,mstadev3, size 1 x all voxels in all subjects
% s - integer - signal standard deviation
% noiselevels - vector - noise standard deviations
% signal - array - simulated ground truth - size 1 x 10,000
% noise - array - simulated noise - size 3 x 10,000
% data - array - simulated experimental data, 3 x 10,000
% vmetric - array - standard deviation of simulated data - size no. of noise levels x rep (to generate more data points)
% xx - array - standard deviation averaged over the additional datapoints - size no. of noise levels x 1
% SNR1,SNR_2trial, SNR_3trial - vector - SNR value (defined as the ratio of signal standard deviation by standard deviation of noise) defined for single trial estimates, two and three trial averaged values - size no. of noise levels x 1
% yy,aa,zz - vectors - Noise ceiling values (in %) for single trial, two trial averaged and three trial averaged repeats - 1 x size no. of noise levels  
% nclevels1,nclevels2,nclevels3 - vectors - Extrapolated noise ceiling values of voxels as mapped to simulation using the v metric - size 1 x all voxels in all subjects
% nclevelst1,nclevelst2,nclevelst3 - cells - Noise ceiling values divided as cells for nsubj - size 1 x nsubj where each cell is 1 x nvox
% nam,nam2,nam3,nam4 - string - path to save the figures 
% vals1,vals2,vals3 - vector - to store the nc values - size 1 x nvox
% vol1,vol2,vol3 - 3D array - to store the NC values for the corresponding voxel
% data1,data2 - vectors - volumes mapped to inflated surfaces left and right hemispheres
%
% Outputs:
% Betas stored separately
% Noise ceiling values stored separately
% Histograms for 3 trial averaged per subject
% Average per subject noise ceiling values (all 3)
% NIFTI volumes
% Inflated surface maps (all 3 depths)

% Loading and zscoring 

  betatype = input('Please enter which betatype you would want to analyse: 1 - betas_assumehrf, 2 - betas_fithrf, 3 - betas_fithrf_GLMDenoise_RR \n'); % Taking in which betatype to be analysed
  nsess = input('Enter the number of sessions you want to analyse \n'); % Getting the number of sessions to be analysed
  nsubj = 8; % Total number of subjects
  ntps = 750; % Total number of trials in a session
  
  filename = sprintf('beta_allvox_NSDGen_NC_%02d.mat',betatype); % Filename to store the results
  
  nsddatadir = '/home/surly-raid4/kendrick-data/nsd/nsddata'; % Directory to access data
  beta1 = {}; % Initialise empty cell to store betas
    
  tic 
  for subjix = 1:nsubj



      a1 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1mm/roi/nsdgeneral.nii.gz',nsddatadir,subjix))); % Load mask

      ix=find(a1.img>0); % Find required voxels by limiting the threshold
      % Create a binary mask with the voxels we want set to 1
      vol = zeros(size(a1.img));
      volsize{subjix} = size(a1.img); % Save volume size
      vol(ix) = 1;
      nvox(subjix) = size(ix,1); % Save number of voxels  
      ixval{subjix} = ix; % Save voxel indices

      [d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii

      for sess = 1:nsess % Loop over sessions

      % Depending on the beta preparation chosen the corresponding file is accessed to get the betas 
        if betatype == 1
          a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_assumehrf/betas_session' sprintf('%02d',sess) '.mat']); % Get betas from the selected voxels from each session
        else
          if betatype == 2 
            a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf/betas_session' sprintf('%02d',sess) '.mat']); % Get betas from the selected voxels from each session
          else 
            if betatype == 3
              a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf_GLMdenoise_RR/betas_session' sprintf('%02d',sess) '.mat']); % Get betas from the selected voxels from each session
            else
              disp('Invalid choice, please try again');
                
              return
            end
          end
        end
 

        temp = single(squish(a3.betas(d1,d2,d3,:),3))./300; % Cast into double and divide by 300 to get original values
        temp = temp(ii,:); 
        beta1{sess,subjix} = temp; % Store the values in the cell (No. of voxels x no. of trials)
        zsc = (temp - repmat(mean(temp,2),[1 ntps]))./repmat(std(temp,0,2),[1 ntps]); % zscore it - checked with simple example - works as desired
        %zsc(isnan(zsc)) = 0; % Eliminate NANs
        zscbeta{sess,subjix} = zsc;
        assert(isequal(size(zsc),size(temp))) % Another check for zsc dimensions
        sess  
      end
      subjix
    end 
 
    repindmat(nsubj,nsess,ntps); % Calls the function which figures out the number of reps
    load repmat.mat
    
    %% Calculating the Standard Deviation of the repeats

  for subjix = 1:nsubj % Loops over subjects
    val = zeros(2,nvox(subjix)); % Initialising to zeros 

  % Two trial repeats
    for j = 1:k2
      for t = 1:2
        tval = a_two(j,t); % Find trial number
        q = fix(tval./ntps); % Check in which session it falls
        if q*ntps ~= tval % Checking for end trial condition
          x = q+1;
          y = tval-q*ntps;
        else % End trial value
          x = q;
          y = ntps;
        end
        val(t,:) = zscbeta{x,subjix}(:,y); % Extract trials of interest
      end
     
      stadev2{subjix}(j,1:nvox(subjix)) = std(val); % Find their std 
    end 
    mstadev2{subjix}(1:nvox(subjix)) = nanmean(cell2mat(stadev2(subjix))); % Average them 
    

  % Three trial repeats
    val = zeros(3,nvox(subjix)); % Initialise values to zeros
    for j = 1:k3
      for t = 1:3 % For three repeats
        tval = a_three(j,t); % Get the trial number
        q = fix(tval./ntps); % Find in which session it falls
        if q*ntps ~= tval % Checking for last trial condition 
          x = q+1;
          y = tval-q*ntps;
        else
          x = q; % Last trial
          y = ntps;
        end
        val(t,:) = zscbeta{x,subjix}(:,y); % Extracts particular trial of interest 
      end
      stadev3{subjix}(j,1:nvox(subjix)) = std(val); % Find standard deviation amidst the 3 repeats
    end
    mstadev3{subjix}(1:nvox(subjix)) = nanmean(cell2mat(stadev3(subjix))); % Find its average
   
  end
  mstadev = (cell2mat(mstadev2)+cell2mat(mstadev3))./2; % Average metric value of each subject for trials with repeats 2 and 3
 
    
    
     %% Noise Metric Simulation and Finding SNR Value


  s = 100;  % signal standard deviation
  noiselevels = 2.^([0:.2:10 10:2:20]);  % different levels for the noise standard deviation

  vmetric = [];
  for p=1:length(noiselevels)
    for rep=1:50 % To make the simulation more smoother 
      signal = 0 + s*randn(1,10000);  % for 10,000 images, the true mean
      noise = noiselevels(p) * randn(3,10000);  % the noise to add to each of 3 trials for each distinct image
      data = repmat(signal,[3 1]) + noise ;  % add the noise to the signal
  
      % now analyze the data as if it were NSD data
      mn = mean(data(:)); 
      sd = std(data(:));
  
      % z-score all the data points
      data = (data-mn) ./ sd;
  
      % calculate the average variability across triplets [having already z-scored]
      vmetric(p,rep) = mean(std(data,[],1));
    end

  end

  xx = mean(vmetric,2);        % funny vmetric
  SNR1 = s./noiselevels;  % SNR - single trial
  SNR_2trial = (s.*sqrt(2))./noiselevels; % SNR - average of two trials
  SNR_3trial = (s.*sqrt(3))./noiselevels; % SNR - average of three trials
  yy = 100*(1-((noiselevels.^2)./(s.^2+noiselevels.^2)));  % NC single trial
  aa = 100*(1-(1./((SNR_2trial.^2)+1))); % NC - average of 2 trials
  zz = 100*(1-(1./((SNR_3trial.^2)+1))); % NC - average of 3 trials
  
  nclevels1 = interp1(xx,yy,mstadev,'linear','extrap');
  nclevels2 = interp1(xx,aa,mstadev,'linear','extrap');
  nclevels3 = interp1(xx,zz,mstadev,'linear','extrap');
  
  st=1;
  for subjix=1:nsubj
    subjix
    st  
    en = st+nvox(subjix)-1 
    
    nclevelst1{subjix}(1:nvox(subjix)) = nclevels1(st:en);
    nclevelst2{subjix}(1:nvox(subjix)) = nclevels2(st:en);
    nclevelst3{subjix}(1:nvox(subjix)) = nclevels3(st:en);
    
    st = en+1;
  end


  % Plot Values

 
  mkdir (sprintf('Noise_metric_plots/NC_Values/beta_version_%02d/flatmaps',betatype)) 
  for subjix = 1:nsubj
    
    f5 = figure;
    
    hist(cell2mat(nclevelst3(subjix)));
    xlabel('NC values in %');
    ylabel('Frequency');
    xlim([0 100]);
    ylim([0 50000]);
    
    nam = sprintf('/Noise_metric_plots/NC_Values/beta_version_%02d/NC_Value_frequency_Subject%02d_B%02d.png',betatype,subjix,betatype);
    print(f5,'-dpng',[pwd nam]);
    
  end

  
    % Plotting average NC plot
    
    f7 = figure;
    bar(cellfun(@mean,nclevelst3))
    hold on 
    bar(cellfun(@mean,nclevelst2),'r')
    bar(cellfun(@mean,nclevelst1),'g')
    hold off
    xlabel('Subjects')
    ylabel('Average NC value')
    legend('NC - 3 trials averaged','NC - 2 trials averaged','NC - single trial estimates')
    ylim([0 100]);
    nam2 = sprintf('/Noise_metric_plots/NC_Values/beta_version_%02d/Average_NC_%02d.png',betatype,betatype);
    print(f7,'-dpng',[pwd nam2]) % Save it

  close all
  toc
  
  %% Save Workspace
  tic
  save(filename, 'beta1','-v7.3');
  fnam = sprintf('NCvals_B%02d',betatype);
  save(fnam,'nclevelst1','nclevelst2','nclevelst3');
  fnam1 = sprintf('Metricvals_B%02d',betatype);
  save(fnam1,'mstadev');
  toc
  
   %% Visualising the noise ceiling values in the surface space
  mkdir(sprintf('NC_volumes/betatype_%02d/NC_Single_trial',betatype))
  mkdir(sprintf('NC_volumes/betatype_%02d/NC_Two_trial',betatype))
  mkdir(sprintf('NC_volumes/betatype_%02d/NC_Three_trial',betatype))
   
  for subjix=1:nsubj
       % define the data we want to visualize
    vals1 = nclevelst1{subjix};
    vals2 = nclevelst2{subjix};
    vals3 = nclevelst3{subjix};
    
      % reconstitute a 3D volume
    vol1 = -1*ones(volsize{subjix});
    vol2 = -1*ones(volsize{subjix});
    vol3 = -1*ones(volsize{subjix});
    
    vol1(ixval{subjix}) = vals1;
    vol2(ixval{subjix}) = vals2;
    vol3(ixval{subjix}) = vals3;
    
    %nam3 = [pwd sprintf('/NC_volumes/betatype_%02d/NC_Single_trial/NC_Trial1_Subj_%02d_B%02d_1pt8.nii.gz',betatype,subjix,betatype)];
    %nam4 = [pwd sprintf('/NC_volumes/betatype_%02d/NC_Two_trial/NC_Trial2_Subj_%02d_B%02d_1pt8.nii.gz',betatype,subjix,betatype)];
    %nam5 = [pwd sprintf('/NC_volumes/betatype_%02d/NC_Three_trial/NC_Trial3_Subj_%02d_B%02d_1pt8.nii.gz',betatype,subjix,betatype)];
    
    if betatype == 1
     nam3 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_assumehrf/noiseceiling_1trial.nii.gz'];
     nam4 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_assumehrf/noiseceiling_2trial.nii.gz'];
     nam5 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_assumehrf/noiseceiling_3trial.nii.gz'];
    else
        if betatype == 2
            nam3 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf/noiseceiling_1trial.nii.gz'];
            nam4 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf/noiseceiling_2trial.nii.gz'];
            nam5 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf/noiseceiling_3trial.nii.gz'];
        else
            nam3 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf_GLMdenoise_RR/noiseceiling_1trial.nii.gz'];
            nam4 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf_GLMdenoise_RR/noiseceiling_2trial.nii.gz'];
            nam5 = [nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1mm/betas_fithrf_GLMdenoise_RR/noiseceiling_3trial.nii.gz'];
        end
    end
            
     
    nsd_savenifti(vol1,[1.0 1.0 1.0],nam3,1);
    nsd_savenifti(vol2,[1.0 1.0 1.0],nam4,1);
    nsd_savenifti(vol3,[1.0 1.0 1.0],nam5,1);
    
    for level = 1:3
     

      % map from volume to surface and visualize the results on fsaverage
      % flatmaps
      data1 =  nsd_mapdata(subjix,'func1pt0',sprintf('lh.layerB%01d',level),vol3,'nearest');
      data2 = nsd_mapdata(subjix,'func1pt0',sprintf('rh.layerB%01d',level),vol3,'nearest');
    
      [rawimg,Lookup,rgbimg,himg] = cvnlookup(sprintf('subj%02d',subjix),10,[data1; data2],[0 100],hot,-.9);
    
      nam = sprintf('/Noise_metric_plots/NC_Values/beta_version_%02d/flatmaps',betatype);
      imwrite(rgbimg,sprintf('%s/subj%02d_NC_1pt8_L%01d_B%02d.png',[pwd nam],subjix,level,betatype));

    end

 end
 close all % Close all open figures
 disp('All NC values are computed and stored.'); 
 % Script ends