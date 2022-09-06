function [newf1,branchObj] =  Local_Agreement(branchObj,k, newf, newf1, cp, adjust, edge_col)
    [rows, columns, numberOfColorChannels] = size(newf);
    if numberOfColorChannels > 1
	    newf = rgb2gray(newf);
    end
    L = bwlabel(newf, 8);
    BW2 = bwselect(L,branchObj(k).b,branchObj(k).a,8);

    if branchObj(k).type == 1
        x2 = branchObj(k).b;
        y2 = branchObj(k).a;
        for n = 2:length(branchObj(k).lines)
            [,V1] = branchObj(k).lines(n,:);
            branchObj(k).lines(n,4) = mod(atan2d(V1(1)*y2-V1(2)*x2,V1(1)*x2+V1(2)*y2)+360,360);
        end        
        branchObj(k).lines = sortrows(branchObj(k).lines,4);
        for n = 1:length(branchObj(k).lines)  
%             newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
%                 'LineWidth',2,'Color',cp{mod(n,2)+1});
            branchObj(k).lines(n,3) = mod(n,2)+1;  
            
            nnn = 1;
            min_dist = branchObj(k).as.e(nnn);
            
            for nn = 1:length(branchObj(k).as.e)
                d_min = norm([min_dist.cen.x min_dist.cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                d = norm([branchObj(k).as.e(nn).cen.x branchObj(k).as.e(nn).cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                if d_min > d
                    min_dist = branchObj(k).as.e(nn);
                    nnn = nn;
                end
            end
            newf = insertShape(double(newf),'Line',[branchObj(k).as.e(nnn).cen.x branchObj(k).as.e(nnn).cen.y branchObj(k).b branchObj(k).a], ...
                    'LineWidth',2,'Color',cp{mod(n,2)+1});
            branchObj(k).as.e(nnn).color = mod(n,2)+1;
        end


    elseif branchObj(k).type == 2
        x1 = branchObj(k).cx1(1,1);
        y1 = branchObj(k).cy1(1,1);
    
        x2 = branchObj(k).cx1(1,2);
        y2 = branchObj(k).cy1(1,2);

        plot(branchObj(k).cx1,branchObj(k).cy1, 'rx');

        for n=1:length(branchObj(k).lines)
            b1 = zeros(rows, columns,1);
            b2 = zeros(rows, columns,1);

            b1 = insertShape(double(b1),'Line',[[x1 y1],[x2 y2]], ...
            'LineWidth',1,'Color','white');
            b2 = insertShape(double(b2),'Line',[[branchObj(k).lines(n,1) branchObj(k).lines(n, 2)], [branchObj(k).b branchObj(k).a]], ...
            'LineWidth',1,'Color','white');

            if find(b1&b2) > 1 
                newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
                'LineWidth',2,'Color',cp{1});
                branchObj(k).lines(n,3) = 1; 

                nnn = 1;
                min_dist = branchObj(k).as.e(nnn);

                for nn = 1:length(branchObj(k).as.e)
                    d_min = norm([min_dist.cen.x min_dist.cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                    d = norm([branchObj(k).as.e(nn).cen.x branchObj(k).as.e(nn).cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                    if d_min > d
                        min_dist = branchObj(k).as.e(nn);
                        nnn = nn;
                    end
                end

                newf = insertShape(double(newf),'Line',[branchObj(k).as.e(nnn).cen.x branchObj(k).as.e(nnn).cen.y branchObj(k).b branchObj(k).a], ...
                        'LineWidth',2,'Color',cp{mod(n,2)+1});
                branchObj(k).as.e(nnn).color = 1;
            
            else
                newf = insertShape(double(newf),'Line',[branchObj(k).lines(n,1) branchObj(k).lines(n, 2) branchObj(k).b branchObj(k).a], ...
                'LineWidth',2,'Color',cp{2});
                branchObj(k).lines(n,3) = 2;
                nnn = 1;
                min_dist = branchObj(k).as.e(nnn);
                
                for nn = 1:length(branchObj(k).as.e)
                    d_min = norm([min_dist.cen.x min_dist.cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                    d = norm([branchObj(k).as.e(nn).cen.x branchObj(k).as.e(nn).cen.y] - [branchObj(k).lines(n,1) branchObj(k).lines(n, 2)]);
                    if d_min > d
                        min_dist = branchObj(k).as.e(nn);
                        nnn = nn;
                    end
                end

                newf = insertShape(double(newf),'Line',[branchObj(k).as.e(nnn).cen.x branchObj(k).as.e(nnn).cen.y branchObj(k).b branchObj(k).a], ...
                        'LineWidth',2,'Color',cp{nnn});
                branchObj(k).as.e(nnn).color = 2;
            end
        end
    else
       newf = insertShape(double(newf),'Line',[branchObj(k).lines(1,1) branchObj(k).lines(1, 2) branchObj(k).b branchObj(k).a], ...
        'LineWidth',2,'Color',cp{1});
        branchObj(k).lines(1,3) = 1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Global Backpropagation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for nn = 1:length(branchObj(k).as.e)
        if branchObj(k).as.e(nn).connected.type == 'b'
            [newf2, branchObj] = Local_Agreement(branchObj,k,newf,newf1, cp, 1, branchObj(k).as.e(nn).color);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    newf1 = newf1 + newf;
%     figure, imshow(newf1);
%     imwrite(newf,strcat(string(k),"_.png"));
end