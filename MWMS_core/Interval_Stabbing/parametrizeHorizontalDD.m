function params = parametrizeHorizontalDD(cscs)


% beta = asin(dd_vert(3));
% alpha = asin(dd_vert(2)/cos(beta));
%
% cos_a = cos(alpha);
% sin_a = sin(alpha);
% cos_b = cos(beta);
% sin_b = sin(beta);
cos_a = cscs(1);
sin_a = cscs(2);
cos_b = cscs(3);
sin_b = cscs(4);

params = compute_basisCoeff_specific(cos_a, sin_a, cos_b, sin_b);

end


function params = compute_basisCoeff_specific(cos_a, sin_a, cos_b, sin_b)

A1 = -(abs(cos_a)*sin_a)/cos_a;
B1 = -abs(cos_a)*sin_b;

A2 = abs(cos_a);
B2 = -(abs(cos_a)*sin_a*sin_b)/cos_a;

A3 = 0;
B3 = (abs(cos_a)*cos_b)/cos_a;

params = [A1, B1, A2, B2, A3, B3]';

end


function dd_hor_der()

syms b1_x b1_y b1_z ...
    b2_x b2_y b2_z ...
    lam real

b1 = [b1_x; b1_y; b1_z];
b2 = [b2_x; b2_y; b2_z];

dd_hor = b1*cos(lam)+b2*sin(lam);

% dd_hor =
%  b1_x*cos(lam) + b2_x*sin(lam)
%  b1_y*cos(lam) + b2_y*sin(lam)
%  b1_z*cos(lam) + b2_z*sin(lam)

A4 = b1_x;
B4 = b2_x;
A5 = b1_y;
B5 = b2_y;
A6 = b1_z;
B6 = b2_z;

end


function [A4,B4,A5,B5,A6,B6] = dd_hor_cal(b1, b2)

b1_x = b1(1);
b1_y = b1(2);
b1_z = b1(3);

b2_x = b2(1);
b2_y = b2(2);
b2_z = b2(3);

A4 = b1_x;
B4 = b2_x;
A5 = b1_y;
B5 = b2_y;
A6 = b1_z;
B6 = b2_z;

end