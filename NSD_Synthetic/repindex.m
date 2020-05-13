load /home/surly-raid4/kendrick-data/nsd/nsddata/experiments/nsdsynthetic/nsdsynthetic_expdesign.mat
maxreps = 5;
totimgs = 284;
noruns = 8;
notrials = 107;
stim = 93;
d = diff(masterordering); % vector of 1x743
onebackbeta_trials = find(d==0) + 1; %each beta and its +1 for one back task

output_fix = cell(totimgs,maxreps);
output_mem = cell(totimgs,maxreps);
for i = 1:noruns, i
    count2 = 0;
    for j = 1:notrials, j 
        if stimpattern(1,i,j) == 1
         count2 = count2 + 1;   
         count = (i-1)*stim + count2; count
         sta = 1;
         temp = masterordering(count); temp
         if (( i == 1) || (i == 3) || (i== 5) || (i == 7))
          Lia = ismember(count,onebackbeta_trials);
          if(~Lia)  
          while(isempty(cell2mat(output_fix(temp,sta))) == 0)
            sta = sta + 1;
          end
          sta
          temp2 = count;
          output_fix(temp,sta) = {temp2}; 
          end
         else
             Lia = ismember(count,onebackbeta_trials);
             if(~Lia)
               while(isempty(cell2mat(output_mem(temp,sta))) == 0)
                sta = sta + 1;
               end
               sta
               temp2 = count;
               output_mem(temp,sta) = {temp2};
             end
         end
          
        end
    end
end
            

save('repindexoutput.mat','output_fix','output_mem');