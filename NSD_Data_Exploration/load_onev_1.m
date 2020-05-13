onevoxdir='/home/surly-raid4/kendrick-data/nsd/nsddata_betas/ppdata/subj';
nsess=7;
beta1={};
sub=8;
for j=1:sub
for i=1:nsess
    a3=matfile([onevoxdir sprintf('%02d',j) '/func1pt8mm/betas_fithrf/betas_session' sprintf('%02d',i) '.mat']);
    beta1{i,j}=double(squeeze(a3.betas(41,6,42,:)))./300;
end
end
data=cell2mat(beta1);
figure
plot(data);
figure
hold on
for j=1:sub
    x=(j-1)*5250:1:j*5250 -1;
    scatter(x,data(:,j),[],rand(1,3));
    mean_data(j)=mean(data(:,j));
    
    plot(x,mean_data(j));
end
hold off
% figure 
% hold on
% for j=1:sub
% x1=0:1:5249;
% scatter(x1,data(:,j));
% end
% hold off