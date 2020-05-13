%% This is the main script which calls the other functions to analyse the session betas of subjects. 
% It runs till the user terminates it by pressing a '0'.
% There are three preparations of betas available. 1 corresponds to
% betas_assumehrf, 2 corresponds to betas_fithrf and 3 to
% betas_fithrf_GLMdenoise_RR.
% And there are 4 unique functions that can be called. 
% 1 -> Just the basic Data Metrics preparations (calculation of mean,std,etc sessionwise across
% subjects). 
% 2 -> Plotting or visualising the values obtained from the DM
% function (before one).
% 3 -> Plot the correlation plots amongst sessions for each subject
% 4 -> Keep track of indexing and find the repeated trials. Find their SNR
% value and compare to a simulation
% 5 -> Do all the 4 functions


ept = 1; % Counter for end condition
prompt5 = 'Please enter the number of sessions you want to analyse \n';
nsess = input(prompt5); % Number of sessions
nsubj = 8; % Number of subjects
ntps = 750; % Number of trials in one session



while (ept ~= 0)
  disp('Hi! This script can be used for Data Exploration of the preprocessed betas of the NSD experiment. Please choose the data preparation you wish to analyse.');
  prompt1 = '1 - betas_assumehrf, 2 - betas_fithrf, 3 - betas_fithrf_GLMDenoise_RR \n';
  betatype = input(prompt1); % Choose which beta prep
  disp('Please select which type of analysis to proceed with');
  prompt2 = '1 - General Data Metrics and trend analysis, 2 - General Data Metrics analysis with plots, 3 - General Data Metrics with correlation plots, 4 - Noise metric estimation using Statistical simulations, 5 - All of the above \n';
  choice2 = input(prompt2); % Choose which type of analysis
  
  % Correpondingly call the required functions
  if(betatype~=0) 
    if choice2 == 1
      DMallvox(betatype,nsess,ntps,nsubj);
    else
      if choice2 == 2
        DMallvoxPlots(betatype,nsess,ntps,nsubj);
      else 
        if choice2 == 3
          DMallvoxCorr(betatype,nsess,ntps,nsubj);
        else
          if choice2 == 4
            Noisemetallvox(betatype,nsess,ntps,nsubj);
          else
            if choice2 == 5
              DMallvoxPlots(betatype,nsess,ntps,nsubj);
              DMallvoxCorr(betatype,nsess,ntps,nsubj);
              Noisemetallvox(betatype,nsess,ntps,nsubj);
            else
              disp('Invalid choice. Please try again.');
            end
          end
        end
      end
    end
  else    
    disp('Invalid option, try again');
  end
  % Check condition for termination
  disp('Do you wish to continue?');
  prompt3 = '1 - To continue, 0 - To end \n';
  ept = input(prompt3);
end

