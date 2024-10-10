

Train_Feat=0;
for a1=1 : 58
    
I = imread([pwd,'\test\',num2str(a1),'.jpg']);
I = imresize(I,[256,256]);
a1
cform = makecform('srgb2lab');

lab_he = applycform(I,cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);

segmented_images = cell(1,3);

rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end

figure(1);
imshow(segmented_images{1});title(' Cluster 1 ');
figure(2);
imshow(segmented_images{2});title(' Cluster 2 ');
figure(3);
imshow(segmented_images{3});title(' Cluster 3 ');


% Feature Extraction
pause(5)
% x = inputdlg('Enter the cluster no. containing the ROI only:');
i = 3;
% Extract the features from the segmented image
seg_img =segmented_images{i};

% Convert to grayscale if image is RGB
if ndims(seg_img) == 3
   img = rgb2gray(seg_img);
end
%figure, imshow(img); title('Gray Scale Image');

% Evaluate the disease affected area
black = im2bw(seg_img,graythresh(seg_img));
%figure, imshow(black);title('Black & White Image');
m = size(seg_img,1);
n = size(seg_img,2);

zero_image = zeros(m,n); 
%G = imoverlay(zero_image,seg_img,[1 0 0]);

cc = bwconncomp(seg_img,6);
diseasedata = regionprops(cc,'basic');
A1 = diseasedata.Area;
sprintf('Area of the disease affected region is : %g%',A1);

I_black = im2bw(I,graythresh(I));
kk = bwconncomp(I,6);
leafdata = regionprops(kk,'basic');
A2 = leafdata.Area;
sprintf(' Total leaf area is : %g%',A2);

%Affected_Area = 1-(A1/A2);
Affected_Area = (A1/A2);
if Affected_Area < 0.1
    Affected_Area = Affected_Area+0.15;
end
sprintf('Affected Area is: %g%%',(Affected_Area*100))
Affect = Affected_Area*100;
% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img);

% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(seg_img);
Standard_Deviation = std2(seg_img);
Entropy = entropy(seg_img);
RMS = mean2(rms(seg_img));
%Skewness = skewness(img)
Variance = mean2(var(double(seg_img)));
a = sum(double(seg_img(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(seg_img(:)));
Skewness = skewness(double(seg_img(:)));
% Inverse Difference Movement
m = size(seg_img,1);
n = size(seg_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];

%feat_disease(1,2)
for b1=1:13
Train_Feat(a1,b1) = feat_disease(1,b1);
end
end
 uisave('Train_Feat ', 'dataset1');
 
 
 
Train_Label = 0;
for i=1 : 58
    
    if(i >=1 & i <= 11)
    Train_Label(1,i) = 0;
    elseif(i >=12 & i <= 17)
       Train_Label(1,i) = 1;  
     elseif(i >=18 & i <= 28)
       Train_Label(1,i) = 2;  
      elseif(i >=29 & i <= 39)
       Train_Label(1,i) = 3;  
        elseif(i >=40 & i <= 45)
       Train_Label(1,i) = 4;  
         elseif(i >=46 & i <= 58)
       Train_Label(1,i) = 5; 
    end
    
end

 uisave('Train_Label ', 'dataset2');
