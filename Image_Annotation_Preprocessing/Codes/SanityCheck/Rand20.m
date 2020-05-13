randno = randperm(1000,20);
test1 = fileread('Rater1_Version2_via_export_json.json');
load im.mat
imgbrick = NaN(425,425,3,20);
% Calculate the count matrix for mode 1
totimg = 1000; % total number of images
test2 = jsondecode(test1);
yy = fieldnames(test2);
tempo = cat(1,yy{:}); % fieldnames
% prevout = 0;
% video = VideoWriter('Faces_pyramid_1k_r1_f1.avi'); %create the video object
% video.FrameRate = 30;
% open(video);
% One for loop for 1000 images
for i = 1:20 
 count = 1;
 num = size(test2.(tempo(randno(i),:)).regions); % gets the number of regions
 if num(1) ~= 0 % Checks if a region is present
     test3 = test2.(tempo(randno(i),:)).regions;  
  for k = 1:num(1) % Loops over number of available regions 
         face_val = str2num(test3(k).region_attributes.Face); % gets the value for face
         if face_val ~= 0 % if a face is present
             
             x1 = test3(k).shape_attributes.x; % get its x coordinate
             y1 = test3(k).shape_attributes.y; % get its y coordinate
             x1 = max(x1,1);
             y1 = max(y1,1);
             width = test3(k).shape_attributes.width; % get its width
             height = test3(k).shape_attributes.height; % get its height 
             imgbrick(y1+1:y1+height,x1+1:x1+width,:,i) = im(y1+1:y1+height,x1+1:x1+width,:,randno(i));
             colormat1 = zeros(height+2,2,3);
             colormat2 = zeros(2,width+2,3);
             switch face_val
                 case 1
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = 1.*ones([height+2,2,3]);
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = 1.*ones([height+2,2,3]);
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = 1.*ones([2,width+2,3]);
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = 1.*ones([2,width+2,3]);
                 case 2
                     
                     colormat1(:,:,2) = 100;
                     colormat2(:,:,2) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 3
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,3) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 4
                     colormat1(:,:,1) = 100;
                     colormat2(:,:,1) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 5
                    colormat1(:,:,2) = 100;
                    colormat1(:,:,1) = 100;
                     colormat2(:,:,2) = 100;
                     colormat2(:,:,1) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 6
                     colormat1(:,:,2) = 100;
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,2) = 100;
                     colormat2(:,:,3) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 7
                     colormat1(:,:,1) = 100;
                     colormat2(:,:,1) = 100;
                     colormat1(:,:,2) = 100;
                     colormat2(:,:,2) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 8
                     colormat1(:,:,2) = 100;
                     colormat2(:,:,2) = 100;
                     colormat1(:,:,1) = 50;
                     colormat1(:,:,3) = 150;
                     colormat2(:,:,1) = 50;
                     colormat2(:,:,3) = 150;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 9
                     colormat1(:,:,2) = 10;
                     colormat2(:,:,2) = 10;
                     colormat1(:,:,1) = 50;
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,1) = 50;
                     colormat2(:,:,3) = 100;
                     imgbrick(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
             end
         end
  end
 end
end



test1 = fileread('Rater2_Version2_via_export_json.json');

imgbrick2 = NaN(425,425,3,20);
% Calculate the count matrix for mode 1
totimg = 1000; % total number of images
test2 = jsondecode(test1);
yy = fieldnames(test2);
tempo = cat(1,yy{:}); % fieldnames
% prevout = 0;

% One for loop for 1000 images
for i = 1:20 
 count = 1;
 num = size(test2.(tempo(randno(i),:)).regions); % gets the number of regions
 if num(1) ~= 0 % Checks if a region is present
     test3 = test2.(tempo(randno(i),:)).regions;  
  for k = 1:num(1) % Loops over number of available regions 
         face_val = str2num(test3(k).region_attributes.Face); % gets the value for face
         if face_val ~= 0 % if a face is present
             
             x1 = test3(k).shape_attributes.x; % get its x coordinate
             y1 = test3(k).shape_attributes.y; % get its y coordinate
             width = test3(k).shape_attributes.width; % get its width
             height = test3(k).shape_attributes.height; % get its height 
             imgbrick2(y1+1:y1+height,x1+1:x1+width,:,i) = im(y1+1:y1+height,x1+1:x1+width,:,randno(i));
             y1 = max(y1,1);
             x1 = max(x1,1);
             colormat1 = zeros(height+2,2,3);
             colormat2 = zeros(2,width+2,3);
             switch face_val
                 case 1
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = 1.*ones([height+2,2,3]);
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = 1.*ones([height+2,2,3]);
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = 1.*ones([2,width+2,3]);
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = 1.*ones([2,width+2,3]);
                 case 2
                     
                     colormat1(:,:,2) = 100;
                     colormat2(:,:,2) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 3
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,3) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 4
                     colormat1(:,:,1) = 100;
                     colormat2(:,:,1) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 5
                    colormat1(:,:,2) = 100;
                    colormat1(:,:,1) = 100;
                     colormat2(:,:,2) = 100;
                     colormat2(:,:,1) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 6
                     colormat1(:,:,2) = 100;
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,2) = 100;
                     colormat2(:,:,3) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 7
                     colormat1(:,:,1) = 100;
                     colormat2(:,:,1) = 100;
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,3) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 8
                     colormat1(:,:,2) = 100;
                     colormat2(:,:,2) = 100;
                     colormat1(:,:,1) = 50;
                     colormat1(:,:,3) = 150;
                     colormat2(:,:,1) = 50;
                     colormat2(:,:,3) = 150;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
                 case 9
                     colormat1(:,:,2) = 10;
                     colormat2(:,:,2) = 10;
                     colormat1(:,:,1) = 50;
                     colormat1(:,:,3) = 100;
                     colormat2(:,:,1) = 50;
                     colormat2(:,:,3) = 100;
                     imgbrick2(y1:y1+height+1,max(x1-1,1):max(x1,2),:,i) = colormat1;
                     imgbrick2(y1:y1+height+1,x1+width:x1+width+1,:,i) = colormat1;
                     imgbrick2(max(y1-1,1):max(y1,2),x1:x1+width+1,:,i) = colormat2;
                     imgbrick2(y1+height:y1+height+1,x1:x1+width+1,:,i) = colormat2;
             end
         end
  end
 end
end
imgbrick(isnan(imgbrick)) = 255;
imgbrick2(isnan(imgbrick2)) = 255;
cmap = [0,0,0
    0,0.4,0
    0,0,0.4
    0.4,0,0
    0.4,0.4,0
    0,0.4,0.4
    0.4,0,0.4
    0.2,0.4,0.6
    0.2,0.04,0.4];
lbl = {'Full Human Face','Most Human Face','Background Human Face','Implied Human Face','Full Animal Face','Most Animal Face','Background Animal Face','Implied Animal Face','Paredoilic Face'};
video = VideoWriter('Rand20_faces.avi'); %create the video object
video.FrameRate = 1;
open(video);
fig = figure('position',[100 100 1350 500]);
for i = 1:20
    
   
    subplot(1,3,1)
    imagesc(uint8(imgbrick(:,:,:,i)))
    subplot(1,3,2)
    imagesc(uint8(imgbrick2(:,:,:,i)))
    subplot(1,3,3)
    for ii = 1:size(cmap,1)
    p(ii) = patch(NaN, NaN, cmap(ii,:));
    end
    legend(p, lbl);
    set(gca,'visible','off');
    set(gca,'xtick',[]);
    frame = getframe(fig);
    writeVideo(video,frame);
end
close(video)


