

% This function aims to calculate the SNR value of the beta preparation of the repeated trials using a statistical simulation assuming an additive gaussian noise is addded to the signal


function Noisemetallvox(betatype,nsess,ntps,nsubj)

%% Metric calculation for the data

  repindmat(nsubj,nsess,ntps); % Calls the function which figures out the number of reps
  load repmat.mat

  % To check if DM Function has been run previously

  filename = sprintf('beta_allvox_%02d.mat',betatype);
  if exist(filename,'file') == 2
    disp('File exists');
  else
    DMallvox(betatype,nsess,ntps,nsubj); 
  end


  load (filename)
  totmat={};
  % Preprocess data - zscoring it
  for i = 1:nsubj
    for j = 1:nsess
      data1 = cell2mat(beta1(j,i)); % Take sessionwise betas
      mean_tempa = mean(data1,2);
      std_tempa = std(data1,0,2);
      data2 = (data1-repmat(mean_tempa,[1 ntps]))./repmat(std_tempa,[1 ntps]); % Subtract their sessionwise mean and divide by their sessionwise std  
      data2(isnan(data2)) = 0;
      totmat(i,(j-1)*nvox(i)+1:j*nvox(i),1:ntps) = num2cell(data2); % Storing it in a matrix
    end
  end

  %% Calculating the Standard Deviation of the repeats

  for i = 1:nsubj % Loops over subjects
    val = zeros(2,nvox(i)); % Initialising to zeros 

  % Two trial repeats
    for j = 1:k2-1
      for t = 1:2
        tval = a_two(j,t); % Find trial number
        q = fix(tval./ntps); % Check in which session it falls
        if q*ntps ~= tval % Checking for nnd trial condition
          x = (q*nvox(i))+1:(q+1)*nvox(i);
          y = tval-q*ntps;
        else % End trial value
          x = (q-1)*nvox(i)+1:q*nvox(i);
          y = ntps;
        end
        val(t,:) = cell2mat(totmat(i,x,y)); % Extract trials of interest
      end
      
      stadev2{i}(j,1:nvox(i)) = std(val,1); % Find their std 
    end 
    mstadev2{i}(1:nvox(i)) = mean(cell2mat(stadev2(i))); % Average them 
    m2stadev2(i) = mean(cell2mat(mstadev2(i)));% Final metric for each subject

  %Three trial repeats
    val = zeros(3,nvox(i)); % Initialise values to zeros
    for j = 1:k3-1
      for t = 1:3 % For three repeats
        tval = a_three(j,t); % Get the trial number
        q = fix(tval./ntps); % Find in which session it falls
        if q*ntps ~= tval % Checking for last trial condition 
          x = (q*nvox(i))+1:(q+1)*nvox(i);
          y = tval-q*ntps;
        else
          x = (q-1)*nvox(i)+1:q*nvox(i); % Last trial
          y = ntps;
        end
        val(t,:) = cell2mat(totmat(i,x,y)); % Extracts particular trial of interest 
      end
      stadev3{i}(j,1:nvox(i)) = std(val,1); % Find standard deviation amidst the 3 repeats
    end
    mstadev3{i}(1:nvox(i)) = mean(cell2mat(stadev3(i))); % Find its average
    m2stadev3(i) = mean(cell2mat(mstadev3(i)));
  end
  mstadev = (cell2mat(mstadev2)+cell2mat(mstadev3))./2; % Average metric value of each subject for trials with repeats 2 and 3
 


  %% Noise Metric Simulation and Finding SNR Value


  s = 100;  % signal standard deviation
  noiselevels = 2.^(0:.2:25);  % different levels for the noise standard deviation

  vmetric = [];
  for p=1:length(noiselevels)
    for rep=1:5 % To make the simulation more smoother 
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
  yy = s./noiselevels;  % SNR
  figure; hold on;
  plot(xx,yy,'ro-');
  xlabel('funny vmetric');
  ylabel('signal std / noise std');

  snrlevels1 = interp1(xx,yy,mstadev,'linear','extrap');
  st=1;
  for subjix=1:nsubj
    subjix
    st  
    en = st+nvox(subjix)-1 
    snrlevels{subjix}(1:nvox(subjix)) = snrlevels1(st:en);
    mstd{subjix}(1:nvox(subjix)) = mstadev(st:en);
    st = nvox(subjix)+1;
  end


  %% Plot Values

  mkdir (sprintf('Noise_metric_plots/Metric/beta_version_%02d',betatype)) % Make directory
  mkdir (sprintf('Noise_metric_plots/SNR_Values/beta_version_%02d',betatype)) 
  for subjix = 1:nsubj
    
    % Metric values  
 
    f1 = figure;
    
    % Plotting metric histogram
    
    hist(cell2mat(mstd(subjix)),100); % Plot the histogram
    xlabel('Vmetric values');
    ylabel('Frequency');
    xlim([0 1]);
    ylim([0 1000]);
    
    nam=sprintf('/Noise_metric_plots/Metric/beta_version_%02d/Metric_frequency_Subject%02d_%02d.png',betatype,subjix,betatype);
    print(f1,'-dpng',[pwd nam]); % Save it

    % SNR Values
    
    f3 = figure;
    
    hist(cell2mat(snrlevels(subjix)),100);
    xlabel('SNR values');
    ylabel('Frequency');
    xlim([0 2]);
    ylim([0 1000]);
    
    nam = sprintf('/Noise_metric_plots/SNR_Values/beta_version_%02d/SNR_Value_frequency_Subject%02d_%02d.png',betatype,subjix,betatype);
    print(f3,'-dpng',[pwd nam]);
  end
    % Plotting average metric plot
    
    f4 = figure;
    bar(cellfun(@mean,snrlevels))
    xlabel('Subjects')
    ylabel('Average SNR value')
    %ylim([0 1]);
    nam2 = sprintf('/Noise_metric_plots/SNR_Values/beta_version_%02d/Average_SNR_%02d.png',betatype,betatype);
    print(f4,'-dpng',[pwd nam2]) % Save it
    
    % Plotting average metric plot
    f2 = figure;
    bar(cellfun(@mean,mstd))
    xlabel('Subjects')
    ylabel('Average metric value')
    %ylim([0 1]);
    nam2=sprintf('/Noise_metric_plots/Metric/beta_version_%02d/Average_Metric_%02d.png',betatype,betatype);
    print(f2,'-dpng',[pwd nam2]) % Save it

  close all

  %% Save Workspace

  filename_nm = sprintf('noisemet_data_allvox_%02d.mat',betatype);
  save(filename_nm,'mstd','snrlevels');


  disp('Noise Metric Function End')
end               
            