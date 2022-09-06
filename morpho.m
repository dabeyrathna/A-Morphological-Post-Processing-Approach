function [new_connObj, branchObj, sarr, fskel] = morpho(connObj)
    I = connObj;
    [rows, columns, numberOfColorChannels] = size(I);
    if numberOfColorChannels > 1
	    I = rgb2gray(I);
    end
    BW = double(I);
    w = imbinarize(BW);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Skeletonization + proning
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold off
    B1 = bwskel(w); 
    B = bwskel(w,'MinBranchLength',6); 
    branchimage = bwmorph(B, 'branchpoints'); % branch points
    [c,v] = find(branchimage);
    for k = 1:length(c)  % to merge close brach points
        B = insertShape(double(B),'FilledCircle',[v(k) c(k) 10],'Color','white','Opacity',1);
    end
    B = bwskel(im2bw(B),'MinBranchLength',10); 
    branchimage = bwmorph(B, 'branchpoints'); % branch points
    endimage = bwmorph(B, 'endpoints'); %end points
    otherimage = B - branchimage - endimage;
    ss = imdilate(branchimage, strel('disk',3,0));
    fskel = B - ss - endimage;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Corner point generation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [y,x] = find(branchimage);
    r = 25;
    r1 = r-10;
    count = 1;
    branchObj = [];
    sarr = [];
    cp = {'blue','red','green','yellow'};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Corner point generation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    b_inf = Branch_info(fskel, BW, branchimage, endimage);
    
    for k = 1:length(x)
        x1 = [];
        y1 = [];  
        x2 = [];
        y2 = [];
        c = drawcircle('Center',[x(k),y(k)],'Radius',r);
        m = createMask(c,BW);
        masked = w & m;
    
        c1 = drawcircle('Center',[x(k),y(k)],'Radius',r1);
        m1 = createMask(c1,BW);
        masked1 = w & (m-m1);
    
        [x1,y1] = Detect_corners(masked, x1, y1, 4);
        [x2,y2] = Detect_corners_1(masked, x1, y1);
        mask1 = fskel & m; 
        It = bwmorph(mask1,'thin','inf');
        B =  bwmorph(It,'branchpoints');
        It1 = It & (m-m1);
        s = regionprops(It1,'centroid','PixelList','PixelIdxList');
        centroids = cat(1,s.Centroid);
        [a,b] = find(B); 
        
        flag = 0;    
        for nn = 1:length(branchObj)
            if any(branchObj(nn).a == round(mean(a))) && any(branchObj(nn).b == round(mean(b)))
                flag = 1;
            end
        end
        if flag == 0
            branchObj(count).name = count;
            branchObj(count).a = round(mean(a));
            branchObj(count).b = round(mean(b));
            branchObj(count).cx1 = x1;
            branchObj(count).cy1 = y1;
            branchObj(count).cx2 = x2;
            branchObj(count).cy2 = y2;
            branchObj(count).lines = centroids;
            branchObj(count).pixid = s;
            branchObj(count).as = b_inf(k);
            count = count+1;
        end
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Single cells
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [sarr] = Single_cell(fskel, branchimage, endimage, sarr);

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Display branching objects
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Display_branching_info(branchObj, fskel, branchimage, sarr, BW);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initial Color Assignements
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    newf = double(im2bw(fskel));
    newf1 = double(im2bw(fskel));
    for k = 1:length(branchObj) 
        [newf1, branchObj] = Random_Color(branchObj,k,newf,newf1, cp);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Local Agreement
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    newf = fskel;
    newf1 = fskel;
    for k = 1:length(branchObj) 
        [newf1, branchObj] = Local_Agreement(branchObj,k,newf,newf1, cp);
    end
    new_connObj = newf1;
end
