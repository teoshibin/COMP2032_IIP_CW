function T = pieceWiseLinear(c1, c2)
%Calculate transformation lookup table using piecewise linear method
%   T is the transformation table use it by doing g = T(f + 1)
%   c1, c2 are two of the coordinates that stretches the transformation
%   line

    x1 = c1(1);
    y1 = c1(2);
    x2 = c2(1);
    y2 = c2(2);
    t1 = getY(0:x1, 0, 0, x1, y1);
    t2 = getY((x1+1):x2, x1, y1, x2, y2);
    t3 = getY((x2+1):255, x2, y2, 255, 255);
    T = uint8(floor([t1 t2 t3]));
    % simple high school math
    function a = getY(x, x1,y1,x2,y2)
        a = ((x - x1)/(x2-x1))*(y2-y1) + y1;
    end
end

