function [x1,y1] = Detect_corners_1(I,x1,y1)
    [rows, columns, numberOfColorChannels] = size(I);
    if numberOfColorChannels > 1
	    I = rgb2gray(I);
    end
    
    BW = double(I);
    w = imbinarize(BW);
    e = edge(w);
    [y,x] = find(e);
    r = 10;
    count = 1;
    mask = zeros(rows, columns,1,'uint8');

    val = 1:length(x);

    for k = 1:length(x)
        c = drawcircle('Center',[x(k),y(k)],'Radius',r);
        m = createMask(c,mask);
        masked = w & m;        
        val(k) = length(find(masked))/(pi*r*r);
        if val(k) > 0.6 | val(k) < 0.4 
            x1(count) = x(k);
            y1(count) = y(k);
            count = count + 1;
        end
    end
    %imshow(I);
    % hold on
    % plot(x1,y1, 'rx');
    % hold off
    % plot(val, '-o');
end