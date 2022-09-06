function [r] =  Segment_radius(edge_Im, X, Y)
    [edgey, edgex] = find(edge_Im);
    r = [];
    for k = 1:numel(X)
        %shortest distance from skeliton pixels to the edge pixels
        D = sqrt( (X(k)-edgex).^2 + (Y(k)-edgey).^2 );
        r(k).r = min(D);
    end
end
