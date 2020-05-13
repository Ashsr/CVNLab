%% Helper Function Word labels

% Input section

disp('This is a helper function which takes in the annotation file, labels and mode and outputs the computes metric.');
fname = input('Please enter the file name/path','s'); % gets the input file

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
         word_val = str2num(test3(k).region_attributes.Word); % gets the value for word
         if word_val ~= 0 % if a word is present
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


flag = 1; % flag to continue/stop program

% Calculate the values and store and output according to user input
while flag == 1
 p = 1; % initialise a counter variable   
 labels = input('Please enter the list of labels \n a - Clear words \n b - Occluded \n c - Blurry \n d - Alphanumeric \n e - Numbers or Special Characters \n f - Different orientation \n ','s');% get the set of labels from user
 mode_val = input('Please enter the mode you''d like to use \n Mode 1 : Returns the counts of each label category in the 1000 images \n Mode 2 : Returns sum of binary masks for the labels in the 1000 images \n Mode 3 : Returns a cell with each element is a vector of the x coordinate of the bounding box center, its y cordinate, angle subtended by the box with respect to the center of the image and it''s eccentricity. \n'); % get the type of mode from the user.
 for q = 1:size(labels,2) % Loop over the number of labels
     % Map labels to corresponding numeric value
     switch labels(q) 
         case 'a'
          label_vals(p) = 1;
          p = p + 1; % increment counter
        
         case 'b'
          label_vals(p) = 2;
          p = p + 1;
          
         
         case 'c'
          label_vals(p) = 3;
          p = p + 1;
         
         
         case 'd'
          label_vals(p) = 4;
          p = p + 1;
          
         
         case 'e'
          label_vals(p) = 5;
          p = p + 1;
          
         
         case 'f'
          label_vals(p) = 6;
          p = p + 1;
              
     end
 end
 ver = input('Please enter in which version do you want the outputs to be saved in. \n a.version 5.0 \n b.version 7.3','s');
 switch mode_val
     case 1
          outputmat = sum(wordcountmat(:,[label_vals]),2); % mode 1 sum the count matrix according to the input label
          switch ver
              case 'a'
               save('Outputmat_mode1v5.mat','outputmat'); % Save output vector
               save('Outputbigmat_mode1v5.mat','wordcountmat');
              case 'b'
                  save('Outputmat_mode1v7.mat','outputmat','-v7.3');
                  save('Outputbigmat_mode1v7.mat','wordcountmat','-v7.3');
          end
     case 2
          outputmat2 = sum(binaryimagemat(:,:,:,[label_vals]),4); % mode 2 sum the binary image mat according to the labels 
          outputmat2 = uint8(outputmat2);
          out2 = uint8(binaryimagemat);
          switch ver
              case 'a'
               save('Outputmat_mode2v5.mat','outputmat2'); % Save output matrix
               save('Outputbigmat_mode2v5.mat','out2');
              case 'b'
                  save('Outputmat_mode2v7.mat','outputmat2','-v7.3');
                  save('Outputbigmat_mode2v7.mat','out2','-v7.3');
          end
                  
     case 3
          outcell = cell(totimg,size(label_vals,2),4); % initialise the cells 1000xlabelsx4(features)
          label_vals = sort(label_vals); % sort the label numeric values
          
          for l = 1 : totimg % loop over all images
              
              num = size(test2.(tempo(l,:)).regions); % get the number of regions
              if num(1) ~= 0 % if regions exist
               test3 = test2.(tempo(l,:)).regions;
               
               for k = 1:num(1) % Loop over number of regions
                  word_val = str2num(test3(k).region_attributes.Word); % get their corresponding word value
                  [log_val,loc_val] = ismember(word_val,label_vals); % find if the word category is in the required label category
                   if log_val == 1 % if yes
                       x11 = test3(k).shape_attributes.x; % get x coordinate
                       y11 = test3(k).shape_attributes.y; % get y coordinate
                       width1 = test3(k).shape_attributes.width; % get width
                       height1 = test3(k).shape_attributes.height; % get height
                       if x11 + width1 > 425
                           cen_x = x11 + (425 - x11)./2;
                       else
                       
                             cen_x = x11 + (width1./2); % Find bounding box center x
                             
                       end
                       if y11 + height1 > 425
                             cen_y = y11 + ((425 - y11)./2);
                           else
                             cen_y = y11 + (height1./2);
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
          switch ver
              case 'a'
               save('Outputcell_mode3v5.mat','outcell'); % save the output cell
              case 'b'
                  save('Outputcell_mode3v7.mat','outcell','-v7.3');
          end              
         otherwise
             disp('Invalid entry, please try again');
          end
          

 
 flag = input('Please enter 0 to stop and 1 to continue'); % Ask user if they want to continue
 
end