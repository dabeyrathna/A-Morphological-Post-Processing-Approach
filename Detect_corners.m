function [x1,y1] = Detect_corners(mask,x1,y1,n)
    corners = detectHarrisFeatures(mask);
    s4c = corners.selectStrongest(n);

    for l = 1:length(s4c)
        if(s4c.Metric(l) > 0.1) % Strength of a corner
            x1 = [x1,s4c.Location(l,1)];
            y1 = [y1,s4c.Location(l,2)];
        end
    end
%     nm = cat(3,masked,masked,masked);
%     nm = double(nm);
%     figure, imshow(nm);
%     hold on
%     plot(x1,y1,'ro');
end