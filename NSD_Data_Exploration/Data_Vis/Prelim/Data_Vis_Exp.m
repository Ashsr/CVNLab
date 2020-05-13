%% Data Visualisation and Exploration

% To compute mean, median and standard deviations for various sessions of
% different subjects. 
% And also to visualise them.


nsddatadir='/home/surly-raid4/kendrick-data/nsd/nsddata'; % Directory to access data

nsess=7; % Total number of sessions
nvox=1000; % Total number of voxels considered
beta1 = {}; % Initialise empty cell to store betas
nsubj=8; % Total number of subjects

for subjix=1:nsubj

data=[]; % Clear out previous iteration data

a1 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1pt8mm/TESTBACKBRAIN.nii.gz',nsddatadir,subjix)));% Load mask
a2 = load_untouch_nii(gunziptemp(sprintf('%s/ppdata/subj%02d/func1pt8mm/R2.nii.gz',nsddatadir,subjix)));% Load variance explained averaged over all sessions

a1 = double(a1.img); % Casting to double from int16
a2 = double(a2.img);

ix=find(a1>0 & a2>5); % Find required voxels by limiting the threshold

%%% At this point, ix is a vector of indices.  The indices are already in sorted order.

% These are the R2 values for the voxels you have selected
r2vals = a2(ix);


% Sort the R2 values and get the indices for that sorted order
[~,ii] = sort(r2vals,'descend');



% Get the first 1000 "best R2" indices and index into ix
% in order to obtain the final set of indices.
ix = ix(ii(1:nvox));


% Create a binary mask with the voxels we want set to 1
vol = zeros(size(a1));
vol(ix) = 1;


[d1,d2,d3,ii] = computebrickandindices(vol); % Find the required voxels as described by di,d2,d3 and ii


for i=1:nsess % Loop over sessions

a3 = matfile([nsddatadir '_betas/ppdata/subj' sprintf('%02d',subjix) '/func1pt8mm/betas_fithrf/betas_session' sprintf('%02d',i) '.mat']); % Get betas from the selected voxels from each session
temp=double(squish(a3.betas(d1,d2,d3,:),3))./300; % Cast into double and divide by 300 to get original values
temp = temp(ii,:); 
beta1{i,subjix} = temp; % Store the values in the cell

end

data=cell2mat(beta1(:,subjix)); % Push all sessions subject betas to matrix



%% Compute Mean, Standard deviation, median and plot them 

% Total data for one subject

figure;
imagesc(makeimagestack(data')); % Visualise it

mn = mean(data(:)); % Compute mean
sd = std(data(:)); % Compute standard deviation
med=median(data(:)); % Compute median % make a figure

figure;

hold on;
hist(data(:),100); % Plot a histogram using hundred bins
ax = axis; % Get the current axis bounds
 
% Plot lines showing mean, median and +/- 1 std dev

h1 = plot([mn mn], ax(3:4),'--r');
h2 = plot([mn-sd mn-sd],ax(3:4),'--g');
h3 = plot([mn+sd mn+sd],ax(3:4),'--g');
h4 = plot([med med],ax(3:4),'--y');
hold off

xlabel('Percentage Signal Values');
ylabel('Frequency');
xlim([-120,120]);
%ylim([0 1400000]);
legend([h1 h2 h3 h4],{'Mean', 'Mean - Std','Mean + Std','Median'});
str=sprintf('Total Data for Subject %02d with mean,median and +/- 1 std dev',subjix);
title(str);
str=sprintf('Total_Data_Subject%02d',subjix);
print( str, '-dpng'); % Save figure

% Session wise

for i=1:nsess
    e=[]; % Clear previous values
    e=cell2mat(beta1(i,subjix)); % Push current subject, current session betas
    mean_sess(i)=mean(e(:)); % Compute mean
    med_sess(i)=median(e(:)); % Compute median
    std_sess(i)=std(e(:)); % Compute Standard deviation

    figure; 
    hold on;
    hist(e(:),100); % Plot a histogram using hundred bins
    ax = axis; % Get the current axis bounds
    
    % Plot lines showing mean, median and +/- 1 std dev
    
    h1 = plot([mean_sess(i) mean_sess(i)], ax(3:4),'--r');
    h2 = plot([mean_sess(i)-std_sess(i) mean_sess(i)-std_sess(i)],ax(3:4),'--g');
    h3 = plot([mean_sess(i)+std_sess(i) mean_sess(i)+std_sess(i)],ax(3:4),'--g');
    h4 = plot([med_sess(i) med_sess(i)],ax(3:4),'--y');
    hold off
    
    xlabel('Percentage Signal Values');
    ylabel('Frequency');
    xlim([-120,120]);
    %ylim([0 200000]);
    legend([h1 h2 h3 h4],{'Mean', 'Mean - Std','Mean + Std','Median'});
    str=sprintf('Data Subject %02d, Session %02d  with mean,median and +/- 1 std dev',subjix,i);
    title(str);
    str=sprintf('Data_Subject_%02d,_Session_%02d',subjix,i);
    print(str, '-dpng'); % Save figure
    
 end

mean_subj_sess(subjix,1:nsess)=reshape(mean_sess,7,1); % Save mean across sessions for subjects
med_subj_sess(subjix,1:nsess)=med_sess; % Save median across sessions for subjects
std_subj_sess(subjix,1:nsess)=std_sess; % Save std across sessions for subjects
subjix

end

figure
hold on
cmap0 = jet(8);
for p=1:size(mean_subj_sess,1)
  t=plot(mean_subj_sess(p,:),'-','Color',cmap0(p,:));
  ylim([0 10]);
  t2(p)={sprintf('Subject %02d',p)};
end
legend(t2(:),'Location','Best');

hold off
xlabel('Sessions');
ylabel('Percentage Signal Values');
title('Mean of all subjects across all sessions');
str='All_mean';
print(str,'-dpng'); % Save figure


figure
hold on
cmap0 = jet(8);
for p=1:size(med_subj_sess,1)
  t=plot(med_subj_sess(p,:),'-','Color',cmap0(p,:));
  ylim([0 14]);
  t2(p)={sprintf('Subject %02d',p)};
end
legend(t2(:),'Location','Best');
hold off
xlabel('Sessions');
ylabel('Percentage Signal Values');
title('Median of all subjects across all sessions');
str='All_median';
print(str,'-dpng'); % Save figure

%% Save workspace

save('beta','beta1','mean_subj_sess','std_subj_sess');


