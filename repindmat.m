% Aim: 
% This function aims at finding the repeated trials (both twice and thrice)  
% 
% Logic: 
% There are stored in a 3D matrix called rept
% First dimension is for different subjects, lets consider just for one subject.
% The other two dimensions are
% 
%      d2          d5
%      c2      c4  c5
%  b1  b2  b3  b4  b5  b6  b7
%  a1  a2  a3  a4  a5  a6  a7
% 
% Here a1,a2,a3... are unique image IDs for the subject shown at trials b1,b2,b3,...
% When an image ID is shown more than once, the corresponding second trial numbers are c2,c4,c5,...
% When an image is shown more than twice, the corresponding third trial numbers are stored as d2,d5,...
% 
% Inputs: 
% nsubj - integer - number of subjects - 8
% nsess - integer - number of sessions
% ntps - integer - number of trials in a session - 750
% 
% Variables used: 
% i,j,count - integer - counter
% tot - array - image number (from 73k) ordering for the 30k trials for the 8 subjs, size 8x30,000
% req - array - subset of tot only for the required number of trials (nsess*ntps), size 8x(nsess*ntps)
% t1 - integer - number of unique trials in the subset of required trials 
% rept - array - the 3D matrix with all the information regarding the repeats as explained in the logic section, size nsubjx4xt1 
% t - logical - to check if the image already exists in the matrix
% tloc - integer - to find the first location of the repeated image
% k23 - integer - total number of trials repeated twice or thrice
% a - array - contains all the trial orders repeated twice or thrice, size k23x3
% k2 - integer - total number of trials repeated twice
% a_two - array - contains all the trial orders repeated twice, size k2x2
% k3 - integer - total number of trials repeated thrice
% a_three - array - contains all the trials repeated thrice 
% 
% Outputs: 
% The workspace with all the variables are saved as repmat.mat
function repindmat(nsubj,nsess,ntps)
  
  load /home/surly-raid4/kendrick-data/nsd/nsddata/experiments/nsd/nsd_expdesign.mat % Load the workspace with experimetn design information

  i = 1; % As we are concerned about the ordering here, which is same for all subjects, hence it suffices to find just for one subject
  tot = subjectim(:,masterordering); % Gets the ordering of the trials required for analysis
  req = tot(:,1:(ntps*nsess)); % Lets consider the subset of the total we require 
  t1 = max(size(unique(req(i,:)))); % Find the size of unique trials - cwteg - wf
  rept = zeros(nsubj,4,t1); % Create a matrix rept which is 3D, first dimension is the number of subjects, second consists of 4 numbers and third the number of unique trials.

  
  for i = 1:nsubj % Looping over Subjects
    for j = 1:ntps*nsess % Looping over the total trials under consideration
      if j == 1    % First iteration
        rept(i,1,j) = req(i,j); % Stores image ID
        rept(i,2,j) = j; % Stores it's trial number
        count = 2;
      end
      if j ~= 1
        [t tloc] = ismember(req(i,j),rept(i,1,:));
        if t == 0 % If new value
          rept(i,1,count) = req(i,j); % Store the image ID
          rept(i,2,count) = j; % Stores trial number
          count = count+1; % Counter for unique trials
        end
        if t == 1 % Means it exists in our required matrix already.
          if(rept(i,3,tloc) == 0) % check if this is second repeat
            rept(i,3,tloc) = j; % Stores trial number
          else
              rept(i,4,tloc) = j; % Else assumed it repeats the third time and its trial number is stored in the second dimension fourth position
          end
        end
      end
    end
  end

  k23 = 0;
   % Getting trial numbers for two,three repeats
  for j = 1:t1
    if rept(1,3,j) ~= 0 
      k23 = k23 + 1;
      a(k23,1) = rept(1,2,j); % Considering just for subject 01 as the ordering is similar for all subjects
      a(k23,2) = rept(1,3,j);
      a(k23,3) = rept(1,4,j);
    end
  end
  % Getting trial numbers only for two repeats
  k2 = 0;
  for j = 1:t1
    if rept(1,3,j) ~= 0 && rept(1,4,j) == 0
      k2 = k2 + 1;
      a_two(k2,1) = rept(1,2,j); % Considering just for subject 01 as the ordering is similar for all subjects
      a_two(k2,2) = rept(1,3,j);
    end
  end
   % Getting trial numbers only for three repeats
  k3 = 0;
  for j = 1:t1
    if rept(1,3,j) ~= 0 && rept(1,4,j) ~= 0
      k3 = k3 + 1;
      a_three(k3,1) = rept(1,2,j); % Considering just for subject 01 as the ordering is similar for all subjects
      a_three(k3,2) = rept(1,3,j);
      a_three(k3,3) = rept(1,4,j);
    end
  end

%% Save Workspace
  save('repmat.mat')

end

