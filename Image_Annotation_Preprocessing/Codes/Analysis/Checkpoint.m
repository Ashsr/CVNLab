test = fileread('Allfandw_via_export_json_1.json');
totimg = 1000;
count = 0;
test2 = jsondecode(test);
yy = fieldnames(test2);
tempo = cat(1,yy{:});
% One for loop for 1000 images
for i = 1:totimg
 num = size(test2.(tempo(i,:)).regions);
% One for loop for number of regions
 if num(1) ~= 0
     test3 = test2.(tempo(i,:)).regions;
  for k = 1:num(1)
     f1 = isfield(test3(k).region_attributes,'Face');
     w1 = isfield(test3(k).region_attributes,'Word');
     if f1 && w1 ~= 0
      face_val = str2num(test3(k).region_attributes.Face);
      word_val = str2num(test3(k).region_attributes.Word);
      if (face_val == word_val) || (face_val > 0 && word_val > 0)
         count = count + 1;
         mismatch(count).imgno = (tempo(i,:));
         mismatch(count).regno = k;
      end
     else
         count = count + 1;
         mismatch(count).imgno = (tempo(i,:));
         mismatch(count).regno = k;
     end
     width = test3(k).shape_attributes.width; % get its width
     height = test3(k).shape_attributes.height;    
     if width == 0 || height == 0 
         count = count + 1;
         mismatch(count).imgno = (tempo(i,:));
         mismatch(count).regno = k;
     end
% check points - Face=Words and Face>0 and Words>0
%  mismatch(count).imgname = (tempo(i,:));
%  mismatch(count).regno = k;
  end
 end
 end
 if count == 0
     disp('There are no mismatches')
 else
     disp('There are mismatches, please check the mismatch struct');
end