function hor_AF = computeHorizontalDDfromTheta(params, thetas)

% % A * cos + B * sin + C  
% %  blue_after    red_after                               
% %   A1 B1 C1     A4 B4 C4     
% %  [A2 B2 C2],  [A5 B5 C5]
% %   A3 B3 C3     A6 B6 C6
% 
% 
A1=params(1);B1=params(2);A2=params(3);B2=params(4);A3=params(5);B3=params(6); 

hor_AF = [];
    % R w.r.t. one paramter
    for i = 1:size(thetas,2)
        col_x = A1*cos(thetas(i))+B1*sin(thetas(i)); % third col -- d1 unit vector
        col_y = A2*cos(thetas(i))+B2*sin(thetas(i)); 
        col_z = A3*cos(thetas(i))+B3*sin(thetas(i));

        hor_AF = [hor_AF,[col_x; col_y; col_z]];
    end
    
end