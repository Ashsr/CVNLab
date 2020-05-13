%% Helper Function Word labels
function output = wordhelper(fname,label_vals,mode_val)

test1 = fileread(fname);

% Calculate the count matrix for mode 1
totimg = 1000; % total number of images

test2 = jsondecode(test1);
yy = fieldnames(test2);
tempo = cat(1,yy{:}); % fieldnames
wordcountmat = zeros(totimg,6); % initialise count matrix
binaryimagemat = zeros(425,425,totimg,6); % initialise binary image matrix
% One for loop for 1000 images
for i = 1:totimg 
 num = size(test2.(tempo(i,:)).regions); % gets the number of regions
 if num(1) ~= 0 % Checks if a region is present
     test3 = test2.(tempo(i,:)).regions;  
  for k = 1:num(1) % Loops over number of available regions 
         word_val = str2num(test3(k).region_attributes.Word); % gets the value for face
         if word_val ~= 0 % if a face is present
             wordcountmat(i,word_val) = wordcountmat(i,word_val) + 1; % increment count
             x1 = test3(k).shape_attributes.x; % get its x coordinate
             y1 = test3(k).shape_attributes.y; % get its y coordinate
             width = test3(k).shape_attributes.width; % get its width
             height = test3(k).shape_attributes.height; % get its height 
             ht = y1+height;
             wt = x1+width;
             if ht > 425 
                 ht = 425;
             else
                 if wt > 425
                     wt = 425;
                 end
             end
             binaryimagemat(y1+1:ht,x1+1:wt,i,word_val) = binaryimagemat(y1+1:ht,x1+1:wt,i,word_val) + 1; % Increment the values in the position, also x1,y1 starts from 0 hence +1. From the tool output its seen that x corresponds to columns of the matrix and y corresponds to rows of the matrix.
             
         end
  end
 end
end
wordcountmat(i+1,:) = sum(wordcountmat,1); % Total sum in each label category

 
 switch mode_val
     case 1
          output = sum(wordcountmat(:,[label_vals]),2); % mode 1 sum the count matrix according to the input label
          save('Outputbigmat_mode1v5.mat','wordcountmat');
          save('Outputbigmat_mode1v7.mat','wordcountmat','-v7.3');
          
     case 2
          output = sum(binaryimagemat(:,:,:,[label_vals]),4); % mode 2 sum the binary image mat according to the labels 
          
          out2 = uint8(binaryimagemat);
          save('Outputbigmat_mode2v5.mat','out2');
          save('Outputbigmat_mode2v7.mat','out2','-v7.3');
          
     case 3
          outcell = cell(totimg,size(label_vals,2),4); % initialise the cells 1000xlabelsx4(features)
          label_vals = sort(label_vals); % sort the label numeric values
          
          for l = 1 : totimg % loop over all images
              
              num = size(test2.(tempo(l,:)).regions); % get the number of regions
              if num(1) ~= 0 % if regions exist
               test3 = test2.(tempo(l,:)).regions;
               
               for k = 1:num(1) % Loop over number of regions
                  word_val = str2num(test3(k).region_attributes.Word); % get their corresponding face value
                  [log_val,loc_val] = ismember(word_val,label_vals); % find if the face category is in the required label category
                   if log_val == 1 % if yes
                       x11 = test3(k).shape_attributes.x; % get x coordinate
                       y11 = test3(k).shape_attributes.y; % get y coordinate
                       width1 = test3(k).shape_attributes.width; % get width
                       height1 = test3(k).shape_attributes.height; % get height
                       if x11 + width1 > 425
                           cen_x = x11 + (425 - x11)./2;
                           if y11 + height1 > 425
                             cen_y = y11 + ((425 - y11)./2);
                           else
                             cen_y = y11 + (height1./2);
                           end
                       else
                           if y11 + height1 > 425
                             if x11 + width1 > 425
                                 cen_x = x11 + (425 - x11)./2;
                             else
                              cen_x = x11 + ((width1./2));
                             end
                             cen_y = y11 + ((425 - y11)./2);
                           else
                             cen_x = x11 + (width1./2); % Find bounding box center x
                             cen_y = y11 + (height1./2); % center y
                           end
                       end
                       ang = atan2(212.5-cen_y,cen_x-212.5)*180./pi; % Find the angle subtended at the center
                       ecc = sqrt((212.5-cen_y).^2 + (212.5-cen_x).^2); % Find the eccentricity
                       for m = 1:4 % loop over the features
                        temp = cell2mat(outcell(l,loc_val,m)); % store the cell contents in a temporary variable
                        % concatenate the value to the variable according
                        % to the corresponding metric/feature type
                        switch m
                            case 1
                             temp = [temp,cen_x]; 
                            case 2
                                temp = [temp,cen_y];
                            case 3
                                temp = [temp,ang];
                            case 4
                                temp = [temp,ecc];
                        end
                        outcell(l,loc_val,m) = {temp}; % store the values in the cell
                       end     
                       end
                       
                   end
               end
          end
              output = outcell; % save the output cell
       
 end
end
          

