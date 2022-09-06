function Display_branching_info(branchObj, fskel, branchimage, sarr, BW)
    [yb,xb] = find(branchimage);
    figure,imshow(BW);
    hold on
    
    for k = 1:length(branchObj)
        plot(branchObj(k).cx1,branchObj(k).cy1, 'rx','MarkerSize',6, 'LineWidth', 3);
        plot(branchObj(k).b,branchObj(k).a,'go', 'MarkerSize',3); 
        for o2 = 1:length(branchObj(k).as.e)
            plot(branchObj(k).as.e(o2).cen.x,branchObj(k).as.e(o2).cen.y,'go');   
            plot(branchObj(k).as.e(o2).connected.x,branchObj(k).as.e(o2).connected.y,'yx','MarkerSize',2);
            plot([branchObj(k).as.e(o2).branchpt.x branchObj(k).as.e(o2).cen.x],[branchObj(k).as.e(o2).branchpt.y branchObj(k).as.e(o2).cen.y],"Color",'b','LineWidth',1);
        end
    end 
    for n=1:length(sarr)
        plot(sarr(n).y,sarr(n).x, 'r.');
    end
end