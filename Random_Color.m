function [newf1,branchObj] =  Random_Color(branchObj,k, newf, newf1, cp)
    [rows, columns, numberOfColorChannels] = size(newf);
    if numberOfColorChannels > 1
	    newf = rgb2gray(newf);
    end
    L = bwlabel(newf, 8);
    BW2 = bwselect(L,branchObj(k).b,branchObj(k).a,8);

    if length(branchObj(k).cx1) > 2
        text(branchObj(k).b+25,branchObj(k).a+5,'X type','color','g');
        branchObj(k).type = 1;
        c = 1;
        for n = 1:length(branchObj(k).lines)  
            newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
                'LineWidth',2,'Color',cp{c});
            branchObj(k).lines(n,3) = c;    
            c=c+1;
        end
    elseif length(branchObj(k).cx1) > 1
        text(branchObj(k).b+25,branchObj(k).a-10,'Y type','color','g');
        branchObj(k).type = 2;
        c = 1;
        for n = 1:length(branchObj(k).lines)  
            newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
                'LineWidth',2,'Color',cp{c});
            branchObj(k).lines(n,3) = c;  
            c=c+1;
        end
    else
        text(branchObj(k).b+20,branchObj(k).a,'I type','color','g');
        branchObj(k).type = 3;
        c = 1;
        for n = 1:length(branchObj(k).lines)  
            newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
                'LineWidth',2,'Color',cp{c});
            branchObj(k).lines(n,3) = c;  
            c=c+1;
        end
    end
    newf1 = newf;
end