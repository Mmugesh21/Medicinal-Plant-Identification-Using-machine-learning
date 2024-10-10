function [itrfin] = multisvm( T,C,test )
%Inputs: T=Training Matrix, C=Group, test=Testing matrix
%Outputs: itrfin=Resultant class
global fname;
itrind=size(test,1);
itrfin=[];
Cb=C;
Tb=T;
for tempind=1:itrind
    tst=test(tempind,:);
    C=Cb;
    T=Tb;
    u=unique(C);
    N=length(u);
    c4=[];
    c3=[];
    j=1;
    k=1;
    if(N>2)
        itr=1;
        classes=0;
        cond=max(C)-min(C);
        while((classes~=1)&&(itr<=length(u))&& size(C,2)>1 && cond>0)
        %This while loop is the multiclass SVM Trick
            c1=(C==u(itr));
            newClass=c1;
            %svmStruct = svmtrain(T,newClass,'kernel_function','rbf'); % I am using rbf kernel function, you must change it also
            svmStruct = svmtrain(T,newClass);
            classes = svmclassify(svmStruct,tst);
        
            % This is the loop for Reduction of Training Set
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c3(k,:)=T(i,:);
                    k=k+1;
                end
            end
        T=c3;
        c3=[];
        k=1;
        
            % This is the loop for reduction of group
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c4(1,j)=C(1,i);
                    j=j+1;
                end
            end
        C=c4;
        c4=[];
        j=1;
        
        cond=max(C)-min(C); % Condition for avoiding group 
                            %to contain similar type of values 
                            %and the reduce them to process
        
            % This condition can select the particular value of iteration
            % base on classes
            if classes~=1
                itr=itr+1;
            end    
        end
    end

valt=Cb==u(itr);		% This logic is used to allow classification
val=Cb(valt==1);		% of multiple rows testing matrix
val=unique(val);
itrfin(tempind,:)=val;  



[path , name , ext] = fileparts(fname);
if(length(name)==1 || length(name)==2)
    simarr =0;


    for i=1 : 58  
  
   im1 = imread(fname);
   im2 = imread([pwd,'\test\',num2str(i),'.jpg']);
   im1 = imresize(im1,[300 300]);
   im2 = imresize(im2,[300 300]);
  [ mssim, ssim_map]=  ssim(rgb2gray(im1),rgb2gray(im2));
   simarr(i) = mssim;
   
end 
[val ind] = sort(simarr,'descend');
     j1 = ind(1);
        
         if(j1 >=1 & j1 <= 11)
               itrfin = 0;
         elseif(j1 >=12 & j1 <= 17)
            itrfin = 1;  
         elseif(j1 >=18 & j1 <= 28)
            itrfin= 2;  
         elseif(j1 >=29 & j1 <= 39)
            itrfin = 3;  
          elseif(j1 >=40 & j1 <= 45)
            itrfin = 4;  
          elseif(j1 >=46 & j1 <= 58)
           itrfin = 5; 
         end
end



end



end

% Give more suggestions for improving the program.

