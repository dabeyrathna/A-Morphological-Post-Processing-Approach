function [final_BW, cell_area, cell_area1] = Instance_segments(component_images,I,final_BW,cc1,e)
    [rows, columns, ~] = size(I);
    img = zeros(rows, columns,3);
    cell_area = zeros(rows, columns);
    cell_area1 = zeros(rows, columns);
    cp = {[1,0,1],[0,1,0],[1,1,0],[1,0,0],[0,0,1]};
    for o1 = 1:cc1.NumObjects
        c = mod(o1,3)+1;
        img = img + component_images(o1).image;      
        for k = 1:length(component_images(o1).branchObj)
            for n = 1:length(component_images(o1).branchObj(k).as.e)                 
                if component_images(o1).branchObj(k).as.e(n).color == 1
                    [mask_strel] = Segment_radius(e, component_images(o1).branchObj(k).as.e(n).x, component_images(o1).branchObj(k).as.e(n).y);              
                    for nn = 1:length(component_images(o1).branchObj(k).as.e(n).x)  
                        final_BW(component_images(o1).branchObj(k).as.e(n).y(nn), component_images(o1).branchObj(k).as.e(n).x(nn), :) = [0, 0, 1];
                        cell_area = insertShape(double(cell_area),'FilledCircle',[component_images(o1).branchObj(k).as.e(n).x(nn) component_images(o1).branchObj(k).as.e(n).y(nn) mask_strel(nn).r],'LineWidth',1,'Color',[0, 0, 1]);
                        cell_area1 = insertShape(double(cell_area1),'FilledCircle',[component_images(o1).branchObj(k).as.e(n).x(nn) component_images(o1).branchObj(k).as.e(n).y(nn) mask_strel(nn).r],'LineWidth',1,'Color',[1, 1, 1]);
                    end
                end
                if component_images(o1).branchObj(k).as.e(n).color == 2
                    [mask_strel] = Segment_radius(e, component_images(o1).branchObj(k).as.e(n).x, component_images(o1).branchObj(k).as.e(n).y); 
                    for nn = 1:length(component_images(o1).branchObj(k).as.e(n).x)                 
                        final_BW(component_images(o1).branchObj(k).as.e(n).y(nn), component_images(o1).branchObj(k).as.e(n).x(nn), :) = [1, 0, 0];
                        cell_area = insertShape(double(cell_area),'FilledCircle',[component_images(o1).branchObj(k).as.e(n).x(nn) component_images(o1).branchObj(k).as.e(n).y(nn) mask_strel(nn).r],'LineWidth',1,'Color',[1, 0, 0]);
                        cell_area1 = insertShape(double(cell_area1),'FilledCircle',[component_images(o1).branchObj(k).as.e(n).x(nn) component_images(o1).branchObj(k).as.e(n).y(nn) mask_strel(nn).r],'LineWidth',1,'Color',[1, 1, 1]);
                    end
                end
            end
        end
        for k = 1:length(component_images(o1).sarr)
            [mask_strel] = Segment_radius(e, component_images(o1).sarr.y, component_images(o1).sarr.x);
            for nn = 1:length(component_images(o1).sarr.x)   
                final_BW(component_images(o1).sarr.x(nn), component_images(o1).sarr.y(nn), :) = cell2mat(cp(c));
                cell_area = insertShape(double(cell_area),'FilledCircle',[component_images(o1).sarr.y(nn) component_images(o1).sarr.x(nn) mask_strel(nn).r],'LineWidth',1,'Color',cell2mat(cp(c)));
                cell_area1 = insertShape(double(cell_area1),'FilledCircle',[component_images(o1).sarr.y(nn) component_images(o1).sarr.x(nn) mask_strel(nn).r],'LineWidth',1,'Color','white');
            end
        end
    end
end