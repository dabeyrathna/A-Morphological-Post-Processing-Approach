function [sarr] = Single_cell(fskel, branchimage, endimage, sarr)
    [ye,xe] = find(endimage);
    fskel = fskel + endimage;
    fskel = double(im2bw(fskel));
    cc1 = bwconncomp(fskel);
    L1 = labelmatrix(cc1);
    A = fskel;
    c = 1;
    for o1 = 1:cc1.NumObjects
        msk1 = A .* (L1 == o1);  
        count =0;       
        for jj = 1:length(xe)    
            if msk1(ye(jj),xe(jj)) > 0
                count = count+1;
            end
        end      
        if count > 1
            [xi, yi] = find(msk1);
            sarr(c).x = xi;
            sarr(c).y = yi;
        end
    end
end