%% This is a script to create image collages (10 x 10) of the shared 1000 images annotated by Rater 1, 2 and the automated algorithm (ver1) for both words and faces

% Get shared image data

clear all

tot_shared_img = 1000;

load nsd_expdesign.mat
%load im.mat %in main script remove
% 
 for i = 1:tot_shared_img
  im(:,:,:,i) = permute(h5read('nsd_stimuli.hdf5','/imgBrick',[1 1 1 sharedix(i)],[3 425 425 1]),[3 2 1 4]); % insert the directory if nsd_stimuli.hdf5 is not in the same folder.
 end

randno = randperm(tot_shared_img,100); % get the random indices

val = {'Faces','Words'};

for l = 1:2
% Get the 3 bounding box inputs
rater_1 = load(sprintf('./Metric_Outputs/Rater1/%s/Outputmat_mode2v5.mat',val{l}) ); % put the directory accordingly

rater_2 = load(sprintf('./Metric_Outputs/Rater2/%s/Outputmat_mode2v5.mat',val{l}));

auto = load(sprintf('./%s/binaryimage_mode2.mat',val{l}));

% Rater 1
temp = [];
temp = rater_1.outputmat2(:,:,randno); % get the bounding box position 
temp = repmat(temp,[1,1,1,3]); 
tempimr1 = permute(im(:,:,:,randno),[1 2 4 3]); % get the image value
tempimr1(temp == 0) = 255; % Outside bounding box is white
tempimr1 = permute(tempimr1, [1 2 4 3]); % Inside bounding box image data

% Rater 2
temp = [];
temp = rater_2.outputmat2(:,:,randno);
temp = repmat(temp,[1,1,1,3]);
tempimr2 = permute(im(:,:,:,randno),[1 2 4 3]);
tempimr2(temp == 0) = 255;
tempimr2 = permute(tempimr2, [1 2 4 3]);

% Automated Algorithm
temp = [];
temp = auto.binaryimagemat(:,:,sharedix(randno));
temp = repmat(temp,[1,1,1,3]);
tempimam = permute(im(:,:,:,randno),[1 2 4 3]);
tempimam(temp == 0) = 255;
tempimam = permute(tempimam, [1 2 4 3]);

%% Make the Image collage

f1 = figure
 firstpos = 0.9:-.1:0;
 for i = 1:100
     subplot(10,10,i)
     imagesc(tempimr1(:,:,:,i))
     set(gca,'xtick',[],'ytick',[]) % remove axes
 end
ha=get(gcf,'children');

for i = 1:100

    pos = mod(i,10);
     pos2 = 10 - fix(i/10);
     if pos ==0
         pos = 10;
         pos2 = 10 - fix((i-1)/10);
     end
     set(ha(i),'position',[firstpos(pos) firstpos(pos2)  .1 .1]); % Fix their position

end

saveas(f1,sprintf('Rater1_collage_%s',val{l}),'png');


%%
f2 = figure
 firstpos = 0.9:-.1:0;
 for i = 1:100
     

     subplot(10,10,i)
     
     imagesc(tempimr2(:,:,:,i))
     set(gca,'xtick',[],'ytick',[])
     %set(gcf,'position',[firstpos(pos) firstpos(pos2)  .05 .05]);
 end
ha=get(gcf,'children');

for i = 1:100

    pos = mod(i,10);
     pos2 = 10 - fix(i/10);
     if pos ==0
         pos = 10;
         pos2 = 10 - fix((i-1)/10);
     end
     set(ha(i),'position',[firstpos(pos) firstpos(pos2)  .1 .1]);

end

saveas(f2,sprintf('Rater2_collage_%s',val{l}),'png');

%%
f3 = figure
 firstpos = 0.9:-.1:0;
 for i = 1:100
     

     subplot(10,10,i)
     
     imagesc(tempimam(:,:,:,i))
     set(gca,'xtick',[],'ytick',[])
     %set(gcf,'position',[firstpos(pos) firstpos(pos2)  .05 .05]);
 end
ha=get(gcf,'children');

for i = 1:100

    pos = mod(i,10);
     pos2 = 10 - fix(i/10);
     if pos ==0
         pos = 10;
         pos2 = 10 - fix((i-1)/10);
     end
     set(ha(i),'position',[firstpos(pos) firstpos(pos2)  .1 .1]);

end

saveas(f3,sprintf('Automated_collage_%s',val{l}),'png');
end
