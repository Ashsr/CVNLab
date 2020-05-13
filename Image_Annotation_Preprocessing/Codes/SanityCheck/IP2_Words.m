% Image Annoatation Sanity Checks 
% Image pyramid

test1 = fileread('via_export_json_outputs_r2.json');
load im.mat

% Calculate the count matrix for mode 1
totimg = 1000; % total number of images
test2 = jsondecode(test1);
yy = fieldnames(test2);
tempo = cat(1,yy{:}); % fieldnames
prevout = 0;
% video = VideoWriter('Faces_pyramid_1k_r2_f8.avi'); %create the video object
% video.FrameRate = 10
% open(video);
%fig = figure('position',[100 100 5350 500]);
% One for loop for 1000 images
for i = 1:totimg 
 num = size(test2.(tempo(i,:)).regions); % gets the number of regions
 if num(1) ~= 0 % Checks if a region is present
     test3 = test2.(tempo(i,:)).regions;  
  for k = 1:num(1) % Loops over number of available regions 
         word_val = str2num(test3(k).region_attributes.Word); % gets the value for face
         if word_val == 6 % if a face is present
             imgup = 0;
             x1 = test3(k).shape_attributes.x; % get its x coordinate
             y1 = test3(k).shape_attributes.y; % get its y coordinate
             width = test3(k).shape_attributes.width; % get its width
             height = test3(k).shape_attributes.height; % get its height 
             t = 0;
            
             if i>=256 && i<512
                
                t = 1;
             else if i>=512 && i< 768
                     
                     t = 2;
                 else if i>=768
                    
                     t = 3;
                     end
                 end
             end
             imgbrick = [];
             ht = y1+height;
             wt = x1+width;
             if ht > 425 
                 ht = 425;
             else
                 if wt > 425
                     wt = 425;
                 end
             end
             imgbrick = im(ht-height+1:ht,wt-width+1:wt,:,i);
             imgbrick(1,1,:)= [0,t,i-t*255];
             if prevout == 0
              output = imgbrick;
              lastsize = width*height;
              width_list = width; 
              height_list = height;
              size_list = lastsize;
              prevout = 1;
              imgup = 1;
             else
                 if height<=height_list(end)
                     sz = size(output);
                     
                     temp = NaN(max(sz(1),height),sz(2)+width,sz(3));
                     
                     temp(1:sz(1),1:sz(2),:) = output;
                     
                     temp(1:height,sz(2)+1:end,:) = imgbrick;
                     lastsize = width*height;
                     width_list = [width_list,width]; 
                     size_list = [size_list,lastsize];
                     height_list = [height_list,height];
                     output = temp;
                     imgup = 1;
                 else
                     siz = size(height_list,2);
                     while(siz>0)
                      if height_list(siz) >= height
                         ind = sum(width_list(1:siz));
                         sz = size(output);
                         
                         outputlast = output(:,ind+1:end,:);
                         
                         temp = NaN(max(height,sz(1)),sz(2)+width,3);
                         temp(1:sz(1),1:ind,:) = output(1:sz(1),1:ind,:);
                         temp(1:height,ind+1:ind+width,:) = imgbrick;
                         temp(1:sz(1),ind+1+width:end,:) = outputlast;
                         output = temp;
                         lastsize = width_list(end)*height_list(end);
                         width_list = [width_list(1:siz),width,width_list(1+siz:end)] ; 
                         size_list = [size_list(1:siz),width*height,size_list(siz+1:end)];
                         height_list = [height_list(1:siz),height,height_list(siz+1:end)];
                         imgup = 1;
                         siz = 0;
                      else
                         siz = siz-1;
                      end
                     end 
                 end
                    if imgup==0
                         sz2 = size(output);
                         temp = NaN(max(height,sz2(1)),sz2(2)+width,3);
                         temp(1:height,1:width,:) = imgbrick;
                         temp(1:sz2(1),width+1:width+sz2(2),:) = output;
                         lastsize = width_list(end)*height_list(end);
                         width_list = [width,width_list]; 
                         size_list = [width*height,size_list];
                         height_list = [height,height_list];
                         output = temp;
                    end
                    
%                     out = NaN(120,500,3);
%                     sz1 = size(output);
%                     out(1:sz1(1),1:sz1(2),:) = output;
%                     out(isnan(out)) = 255;
%                     out = uint8(out);
%                     imagesc(out)
%                     frame = getframe(gcf);
%      writeVideo(video,frame);
  end
 end
end
 end
end
%close(video);
output(isnan(output))= 255;
imwrite(uint8(output),'Words_pyramid_1k_r2_w6.png');