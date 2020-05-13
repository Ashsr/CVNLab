disp('This functions helps you to get metric values after combining the outputs from the raters');
flag = 1;
while flag ~= 0
 typ = input('Which type of annotations do you want to analyze? \n 1. Faces \n 2. Words');
 switch typ
     case 1
        labels = input('Please enter the list of labels \n a - Full Human \n b - Most Human \n c - Background Human \n d - Implied Human \n e - Full Animal \n f - Most Animal \n g - Background Animal \n h - Implied Animal \n i - Pareidolic Images \n','s');% get the set of labels from user
     case 2
        labels = input('Please enter the list of labels \n a - Clear words \n b - Occluded \n c - Blurry \n d - Alphanumeric \n e - Numbers or Special Characters \n f - Different orientation \n ','s');% get the set of labels from user
 end
 totimg = 1000;
 p = 1;
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
          
         
         case 'g'
             label_vals(p) = 7;
             p = p + 1;
             
         
         case 'h'
             label_vals(p) = 8;
             p = p + 1;
            
             
         case 'i'
             label_vals(p) = 9;
             p = p + 1;
             
         
     end
  end
 
  switch typ
    case 1
        
        output1 = facehelper('Rater1_Version2_via_export_json.json',label_vals,mode_val);
        output2 = facehelper('Rater2_Version2_via_export_json.json',label_vals,mode_val);
        
        
    case 2
        output1 = wordhelper('Rater1_Version2_via_export_json.json',label_vals,mode_val);
        output2 = wordhelper('Rater2_Version2_via_export_json.json',label_vals,mode_val);
        
    otherwise
                disp('Invalid entry, please try again');
  end        
  ver = input('Please enter which version you want the output to be saved in. \n a. version 5.0 \n b. version 7.3','s');
  
  
                switch mode_val
                    case 1
                      outputmat = (output1 + output2)./2;  
                      switch ver
                          case 'a'
                           save('Outputmat_mode1v5.mat','outputmat');
                          case 'b'
                           save('Outputmat_mode1v7.mat','outputmat','-v7.3');
                      end
                    case 2
                        outputbmat = (output1 + output2)./2;
                        outputbmat = uint8(10*outputbmat);
                        switch ver
                            case 'a'
                              save('Outputmat_mode2v5.mat','outputbmat');
                            case 'b'
                              save('Outputmat_mode2v7.mat','outputbmat','-v7.3');
                        end
                                
                    case 3
                        outcell = cell(totimg,size(label_vals,2),4);
                        for i = 1:totimg
                            for j = 1:size(label_vals,2)
                                for k = 1:4
                                    temp1 = cell2mat(output1(i,j,k));
                                    temp2 = cell2mat(output2(i,j,k));
                                    temp = [temp1,temp2];
                                    outcell(i,j,k) = {temp};
                                end
                            end
                        end
                        switch ver
                            case 'a'
                             save('Outputcell_mode3v5.mat','outcell');
                            case 'b'
                             save('Outputcell_mode3v7.mat','outcell','-v7.3');
                        end
                
  end
flag = input('Please enter 0 to quit and 1 to continue');  
end
