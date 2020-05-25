%% In this script, make 5 x 5 collage of the shared 1000 images with yellow bounding box at the location annotated by rater 1,2 or the automated algorithm, after resized the images to half its size.

clear all

tot_shared_img = 1000;

load nsd_expdesign.mat
%load im.mat %in main script remove

for i = 1:tot_shared_img
 im(:,:,:,i) = permute(h5read('nsd_stimuli.hdf5','/imgBrick',[1 1 1 sharedix(i)],[3 425 425 1]),[3 2 1 4]); % if the hdf5 file is not in the same directory, insert dir accordingly
end

val ={'Faces','Words'};

for l = 1:2
% Get the 3 bounding box inputs
rater_1 = load(sprintf('./Metric_Outputs/Rater1/%s/Outputmat_mode2v5.mat',val{l}));
rater_2 = load(sprintf('./Metric_Outputs/Rater2/%s/Outputmat_mode2v5.mat',val{l}));
auto = load(sprintf('./%s/binaryimage_mode2.mat',val{l})); % Enter the directories accordingly


for k = 1:40 % 1000 = 40 x 25
for i = 1:5
    for j = 1:5
        ind = (((i-1)*5) +j) + (k-1)*25 ; % index with regard to 1000
        indystr = (j-1)*213 + 2; % starting y index - 213 as the images will be resized to half from 425 
        indyend = j*213 +1; % Ending y index
        indxstr = (i-1)*213 + 2; % Starting x index
        indxend = i*213 +1; % Ending x index
        temp1(indystr:indyend,indxstr:indxend,1:3) = reshape(imresize(im(:,:,:,ind),0.5),[213,213,3]); % Get the image values
        temp2(indystr:indyend,indxstr:indxend) = imresize(rater_1.outputmat2(:,:,ind),0.5); % Get the bounding box location
        temp1(j*213 + 2,i*213 + 2,1:3) = 127*ones(1,1,3); % one pixel wide boundary
        temp2(j*213 + 2,i*213 + 2) = [0.5];
    end
end

    tt = edge(temp2,'canny'); % find the bounding box edges 
    ff=bsxfun(@times,tt,reshape([255 255 0],1,1,3)); % Color it yellow
    ff= uint8(ff); % convert to the proper data class
    gg= temp1 .* uint8(all(ff==0,3))   +   ff .* uint8((1-all(ff==0,3))); % In regions of the bounding box make it yellow and in the rest of the place put the original image
    mkdir('Rater1_word_chunks') % Make new dir 
    imwrite(gg,sprintf('./Rater1_word_chunks/chunk%03d_rater1_word.png',k)); % Save it to new dir
end
 % Can modify the code accordingly for other types just be cautious of the
 % indexing as for the automated case its 73k indices not 1k hence use
 % sharedix(randno)