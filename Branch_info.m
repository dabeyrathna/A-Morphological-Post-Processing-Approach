function [as] = Branch_info(fskel, BW, branchimage, endimage)
    [yb,xb] = find(branchimage);
    [ye,xe] = find(endimage);
    
    fskel = fskel + endimage;
    fskel = double(im2bw(fskel));

    cc1 = bwconncomp(fskel);
    L1 = labelmatrix(cc1);
    A = fskel;
    r = 25;
    r1 = r-10;
    count = 1;
    as = {};

    for k = 1:length(xb)
        c = drawcircle('Center',[xb(k),yb(k)],'Radius',r);
        m = createMask(c,BW);
        mask1 = fskel & m; 
        c1 = drawcircle('Center',[xb(k),yb(k)],'Radius',r1);
        m1 = createMask(c1,BW);
        It = bwmorph(mask1,'thin','inf');
        B1 =  bwmorph(It,'branchpoints');
        It1 = It & (m-m1);    
        [a,b] = find(B1);
        fkel_new = fskel - imdilate(B1, strel('disk',3,0));
        cc1 = bwconncomp(fkel_new,8);
        L1 = labelmatrix(cc1);
        A = fskel;
        for o1 = 1:cc1.NumObjects
            msk1 = A .* (L1 == o1);

            figure, imshow(msk1);
            cc2 = bwconncomp(It1);
            L2 = labelmatrix(cc2);
            for o2 = 1:cc2.NumObjects
                msk2 = A .* (L2 == o2);
                newmsk = msk1 & msk2;
                if length(find(newmsk)) > 3
                    [y1i, x1i] = find(msk1);
                    [y2i, x2i] = find(msk2);                    
                    as(k).e(o2).name = k;
                    as(k).e(o2).branchpt.x = xb(k);
                    as(k).e(o2).branchpt.y = yb(k);
                    as(k).e(o2).x = x1i;
                    as(k).e(o2).y = y1i;
                    as(k).e(o2).cen.x = x2i(1);
                    as(k).e(o2).cen.y = y2i(1);
                    
                    % branching point to end point links
                    for jj = 1:length(xe)                          
                        if msk1(ye(jj),xe(jj)) > 0
                            as(k).e(o2).connected.name = jj;
                            as(k).e(o2).connected.type = 'e';
                            as(k).e(o2).connected.x = xe(jj);
                            as(k).e(o2).connected.y = ye(jj);
                        end
                    end      
                    % branching point to branching point links
                    for jj = 1:length(xb)                          
                        if msk1(yb(jj),xb(jj)) > 0
                            as(k).e(o2).connected.name = jj;
                            as(k).e(o2).connected.type = 'b';
                            as(k).e(o2).connected.x = xb(jj);
                            as(k).e(o2).connected.y = yb(jj);
                        end
                    end   
                 end
            end
        end
    end
end



