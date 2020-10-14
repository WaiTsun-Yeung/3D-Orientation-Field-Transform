function [x,y,z] = intline3(x1,x2,y1,y2,z1,z2)
%INTLINE3 3D Integer-coordinate line drawing algorithm.
%   [X, Y, Z] = INTLINE3(X1, X2, Y1, Y2, Z1, Z2) computes an
%   approximation to the line segment joining (X1, Y1, Z1) and
%   (X2, Y2, Z2) with integer coordinates.  X1, X2, Y1, Y2, Z1 and Z2
%   should be integers.  INTLINE is reversible; that is,
%   INTLINE(X1, X2, Y1, Y2, Z1, Z2) produces the same results as
%   FLIPUD(INTLINE(X2, X1, Y2, Y1, Z1, Z2)).

%   Copyright 1993-2008 The MathWorks, Inc.  

dx = abs(x2 - x1);
dy = abs(y2 - y1);
dz = abs(z2 - z1);

% Check for degenerate case.
if ((dx == 0) && (dy == 0) && (dz == 0))
    x = x1;
    y = y1;
    z = z1;
    return;
end

flip = 0;
dzmax = false;

if (dx >= dy)
    if (dx >= dz)
        if (x1 > x2)
            % Always "draw" from left to right.
            t = x1; x1 = x2; x2 = t;
            t = y1; y1 = y2; y2 = t;
            t = z1; z1 = z2; z2 = t;
            flip = 1;
        end
        m = (y2 - y1)/(x2 - x1);
        x = (x1:x2).';
        y = round(y1 + m*(x - x1));
        m = (z2 - z1)/(x2 - x1);
        z = round(z1 + m*(x - x1));
    else
        dzmax = true;
    end
else  
    if (dy >= dz)
        if (y1 > y2)
            % Always "draw" from bottom to top.
            t = x1; x1 = x2; x2 = t;
            t = y1; y1 = y2; y2 = t;
            t = z1; z1 = z2; z2 = t;
            flip = 1;
        end
        m = (x2 - x1)/(y2 - y1);
        y = (y1:y2).';
        x = round(x1 + m*(y - y1));
        m = (z2 - z1)/(y2 - y1);
        z = round(z1 + m*(y - y1));
    else
        dzmax = true;
    end
  
end

if dzmax
    if (z1 > z2)
        t = x1; x1 = x2; x2 = t;
        t = y1; y1 = y2; y2 = t;
        t = z1; z1 = z2; z2 = t;
        flip = 1;
    end
    m = (x2 - x1)/(z2 - z1);
    z = (z1:z2).';
    x = round(x1 + m*(z - z1));
    m = (y2 - y1)/(z2 - z1);
    y = round(y1 + m*(z - z1));
end
  
if (flip)
  x = flipud(x);
  y = flipud(y);
  z = flipud(z);
end
