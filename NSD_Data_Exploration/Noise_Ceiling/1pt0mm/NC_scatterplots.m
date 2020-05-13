% Scatter Plots of NC values
load('NCvals_B03.mat')
ncb3t1 = nclevelst1;
ncb3t3 = nclevelst3;
load('NCvals_B02.mat')
ncb2t1 = nclevelst1;
ncb2t3 = nclevelst3;
load('NCvals_B01.mat')
ncb1t1 = nclevelst1;
ncb1t3 = nclevelst3;

% Plot scatter plots for various betas

% Single Trials

% Beta1 vs Beta2
nsubj = 8;
cmap0 = jet(8);
f1 = figure
b1 = 0;
b2 = 0;
for subjix = 1:nsubj
   
    x1 = cell2mat(ncb1t1(subjix));
    y1 = cell2mat(ncb2t1(subjix));
    for i =1:size(cell2mat(ncb1t1(subjix)),2)
        if x1(i)<y1(i)
            b2 = b2 + 1 ;
        else
            if x1(i)>y1(i)
                b1 = b1 + 1 ;
            end        
        end
    end
    
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
   
    hold on
    
end
if b2>b1
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end
hold off

xlabel('Noiseceiling values of Beta1')
ylabel('Noiseceiling values of Beta2')
title('NC Singletrial Beta1vsBeta2')
print(f1,'-dpng','NC_Singletrial_b12_1pt8.png')
print(f1,'-depsc2','NC_Singletrial_b12_1pt8.eps')


% Beta1 vs Beta3

f2 = figure
b1 = 0;
b3 = 0;
for subjix = 1:nsubj
    x1 = cell2mat(ncb1t1(subjix));
    y1 = cell2mat(ncb3t1(subjix));
    for i =1:size(cell2mat(ncb1t1(subjix)),2)
        if x1(i)<y1(i)
            b3 = b3 + 1 ;
        else
            if x1(i)>y1(i)
                b1 = b1 + 1 ;
            end        
        end
    end
    
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
    hold on
end
if b3>b1
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end
hold off
hold off

xlabel('Noiseceiling values of Beta1')
ylabel('Noiseceiling values of Beta3')
title('NC Singletrial Beta1vsBeta3')
print(f2,'-dpng','NC_Singletrial_b13_1pt8.png')
print(f2,'-depsc','NC_Singletrial_b13_1pt8.eps')

% Beta2 vs Beta3

f3 = figure
b2 = 0;
b3 = 0;
for subjix = 1:nsubj
    x1 = cell2mat(ncb2t1(subjix));
    y1 = cell2mat(ncb3t1(subjix));
    for i =1:size(cell2mat(ncb1t1(subjix)),2)
        if x1(i)<y1(i)
            b3 = b3 + 1 ;
        else
            if x1(i)>y1(i)
                b2 = b2 + 1 ;
            end        
        end
    end 
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
   
    hold on
    
end
if b3>b2
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end
hold off

xlabel('Noiseceiling values of Beta2')
ylabel('Noiseceiling values of Beta3')
title('NC Singletrial Beta2vsBeta3')
print(f3,'-dpng','NC_Singletrial_b23_1pt8.png')
print(f3,'-depsc','NC_Singletrial_b23_1pt8.eps')


% Three trials

% Beta1 vs Beta2
b1 = 0;
b2 = 0;
f4 = figure
for subjix = 1:nsubj
    x1 = cell2mat(ncb1t3(subjix));
    y1 = cell2mat(ncb2t3(subjix));
    for i =1:size(cell2mat(ncb1t3(subjix)),2)
        if x1(i)<y1(i)
            b2 = b2 + 1 ;
        else
            if x1(i)>y1(i)
                b1 = b1 + 1 ;
            end        
        end
    end 
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
   
    hold on
    
end
if b2 > b1
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end
hold off

xlabel('Noiseceiling values of Beta1')
ylabel('Noiseceiling values of Beta2')
title('NC Threetrial Beta1vsBeta2')
print(f4,'-dpng','NC_Threetrial_b12_1pt8.png')
print(f4,'-depsc','NC_Threetrial_b12_1pt8.eps')


% Beta1 vs Beta3

f5 = figure
b1 = 0;
b3 = 0;
for subjix = 1:nsubj
    x1 = cell2mat(ncb1t3(subjix));
    y1 = cell2mat(ncb3t3(subjix));
    for i =1:size(cell2mat(ncb1t3(subjix)),2)
        if x1(i)<y1(i)
            b3 = b3 + 1 ;
        else
            if x1(i)>y1(i)
                b1 = b1 + 1 ;
            end        
        end
    end 
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
   
    hold on
    
end
if b3>b1
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end
hold off

xlabel('Noiseceiling values of Beta1')
ylabel('Noiseceiling values of Beta3')
title('NC Threetrial Beta1vsBeta3')
print(f5,'-dpng','NC_Threetrial_b13_1pt8.png')
print(f5,'-depsc','NC_Threetrial_b13_1pt8.eps')


% Beta2 vs Beta3
f6 = figure
b2 = 0;
b3 = 0;
for subjix = 1:nsubj
    x1 = cell2mat(ncb2t3(subjix));
    y1 = cell2mat(ncb3t3(subjix));
    for i =1:size(cell2mat(ncb1t3(subjix)),2)
        if x1(i)<y1(i)
            b3 = b3 + 1 ;
        else
            if x1(i)>y1(i)
                b2 = b2 + 1 ;
            end        
        end
    end 
    [n,x,y] = hist2d(x1,y1,0:0.5:100);
    imagesc(x(1,:),y(:,1),n);
    colormap(hot)
    set(gca,'YDir','normal')
   
    hold on
    
end
if b3>b2
 plot(x(1,:),y(:,1),'w')
else
    plot(x(1,:),y(:,1),'y')
end

hold off

xlabel('Noiseceiling values of Beta2')
ylabel('Noiseceiling values of Beta3')
title('NC Threetrial Beta2vsBeta3')
print(f6,'-dpng','NC_Threetrial_b23_1pt8.png')
print(f6,'-depsc','NC_Threetrial_b23_1pt8.eps')
close all