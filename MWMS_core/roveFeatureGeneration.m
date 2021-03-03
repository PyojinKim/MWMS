%--------------------------------------------------------------------------
% Real-time Camera Orientation and Vanishing Point Estimation (ROVE)
%     Copyright (C) 2015 Jeong-Kyun Lee and Kuk-Jin Yoon
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
% If you use this code, please cite:
%   Jeong-Kyun Lee and Kuk-Jin Yoon, 'Real-Time Joint Estimation of Camera
%   Orientation and Vanishing Points', The IEEE Conference on Computer
%   Vision and Pattern Recognition (CVPR), Boston, June, 2015.
%--------------------------------------------------------------------------
function [linedata, centerpt, len, grad, linenormal, circlenormal, desc] = roveFeatureGeneration(dimg, line, Kinv, typeDescriptor)

% pre-processing of image
[height, width] = size(dimg);


% line feature with LBD descriptor
if (strcmp(typeDescriptor,'lbd'))
    
    % grid mask
    gxmask = [-1 0 1;-2 0 2;-1 0 1];
    gymask = [1 2 1;0 0 0;-1 -2 -1];
    
    % line information
    linedata = line(1:4);
    centerpt = (line(1:2) + line(3:4))/2;
    len = sqrt((line(1)-line(3))^2+(line(2)-line(4))^2);
    pt = round(centerpt);
    
    % out of image size
    if ((pt(1)-1 <= 0) || (pt(1)+1 > width) || (pt(2)-1 <= 0) || (pt(2)+1 > height))
        linedata = [];
        centerpt = [];
        len = [];
        grad = [];
        linenormal = [];
        circlenormal = [];
        desc= [];
        return;
    end
    
    % gradient at the center point
    grad = [sum(sum(dimg((pt(2)-1):(pt(2)+1),(pt(1)-1):(pt(1)+1)).*gxmask)), sum(sum(dimg((pt(2)-1):(pt(2)+1),(pt(1)-1):(pt(1)+1)).*gymask))];
    linenormal = [line(4) - line(2), line(1) - line(3)];
    if (grad * linenormal' < 0)
        linenormal = -linenormal;
    end
    
    % normal of great circle (line)
    if (nargout > 5)
        linedata = line(1:4);
        p1_ = Kinv * [linedata(1:2) 1]';
        p2_ = Kinv * [linedata(3:4) 1]';
        A = [ 0 0 0 1 ; p1_' 1 ; p2_' 1 ];
        [eigv, ~] = eig(A'*A);
        normal = [ eigv(1,1) eigv(2,1) eigv(3,1) eigv(4,1) ];
        circlenormal = normal(1:3) / norm(normal(1:3));
    end
    
    % LBD descriptor
    if (nargout > 6)
        normalnorm = norm(linenormal);
        sintht = linenormal(2)/normalnorm;
        costht = linenormal(1)/normalnorm;
        dg = [costht,sintht];
        dl = [sintht,-costht];
        
        m = 5; h = 7;
        mc = (m+1)/2; hc = (h+1)/2;
        sigg = 0.5*(m*h-1);
        fg = 1/(sqrt(2*pi)*sigg) * exp(-((1:m*h)-0.5*(m*h+1)).^2/(2*sigg^2));
        fl = 1/(sqrt(2*pi)*h) * exp(-((1:3*h)-(hc+h)).^2/(2*h^2));
        
        w = floor(len/3);
        if mod(w,2) == 0
            w = w+1;
        end
        wc = (w+1)/2;
        M1 = zeros(m*3,4); %
        wss = len/w;
        
        for mi = 1:m
            for hi = 2:2:6
                for wi = 1:w
                    cp = round(centerpt + wss*(wi-wc)*dl + (h*mi+hi-mc*h-hc)*dg);
                    
                    ge =  [ sum(sum(dimg((cp(2)-1):(cp(2)+1),(cp(1)-1):(cp(1)+1)).*gxmask)) sum(sum(dimg((cp(2)-1):(cp(2)+1),(cp(1)-1):(cp(1)+1)).*gymask)) ];
                    gdg = dg*ge'; gdl = dl*ge';
                    if gdg > 0
                        M1((mi-1)*3+hi/2,1) = M1((mi-1)*3+hi/2,1) + gdg;
                    else
                        M1((mi-1)*3+hi/2,2) = M1((mi-1)*3+hi/2,2) - gdg;
                    end
                    if gdl > 0
                        M1((mi-1)*3+hi/2,3) = M1((mi-1)*3+hi/2,3) + gdl;
                    else
                        M1((mi-1)*3+hi/2,4) = M1((mi-1)*3+hi/2,4) - gdl;
                    end
                end
            end
        end
        
        desc = zeros(1,8*m);
        for mi = 1:m
            Mt = [];
            if mi == 1
                kk = [2 4 6 9 11 13];
                for k = 1:6
                    Mt = [Mt;fg(kk(k))*fl(h+kk(k))*M1(k,:)];
                end
            elseif mi == m
                kk = [2 4 6 9 11 13];
                for k = 1:6
                    Mt = [Mt;fg(kk(k))*fl(h+kk(k))*M1(m*3-k+1,:)];
                end
            else
                c = (mi-2)*h;
                kk = [2 4 6 9 11 13 16 18 20];
                for k = 1:9
                    Mt = [Mt;fg(c+kk(k))*fl(kk(k))*M1((mi-2)*3+k,:)];
                end
            end
            
            desc((mi-1)*4+(1:4)) = mean(Mt);
            desc((m+mi-1)*4+(1:4)) = std(Mt);
        end
        
        % LBD descriptor
        desc(1:4*m) = desc(1:4*m)/norm(desc(1:4*m));
        desc(4*m+1:8*m) = desc(4*m+1:8*m)/norm(desc(4*m+1:8*m));
        desc(desc > 0.4) = 0.4;
        desc = desc/norm(desc);
    end
    
else
    
    % grid mask
    gxmask = [-1 -4 -5 0 5 4 1;
        -4 -16 -20 0 20 16 4;
        -6 -24 -30 0 30 24 6;
        -4 -16 -20 0 20 16 4;
        -1 -4 -5 0 5 4 1]/512;
    gymask = [-1 -4 -6 -4 -1;
        -4 -16 -24 -16 -4;
        -5 -20 -30 -20 -5;
        0 0 0 0 0;
        5 20 30 20 5;
        4 16 24 16 4;
        1 4 6 4 1]/512;
    
    % line information
    linedata = line(1:4);
    centerpt = (line(1:2) + line(3:4))/2;
    len = sqrt((line(1)-line(3))^2+(line(2)-line(4))^2);
    pt = round(centerpt);
    
    % out of image size
    if ((pt(1)-1 <= 0) || (pt(1)+1 > width) || (pt(2)-1 <= 0) || (pt(2)+1 > height))
        linedata = [];
        centerpt = [];
        len = [];
        grad = [];
        linenormal = [];
        circlenormal = [];
        desc= [];
        return;
    end
    
    % gradient at the center point
    grad = [sum(sum(dimg(pt(2)-2:pt(2)+2,pt(1)-3:pt(1)+3).*gxmask)), sum(sum(dimg(pt(2)-3:pt(2)+3,pt(1)-2:pt(1)+2).*gymask))];
    linenormal = [line(4) - line(2), line(1) - line(3)];
    if (grad * linenormal' < 0)
        linenormal = -linenormal;
    end
    
    % normal of great circle (line)
    if (nargout > 5)
        linedata = line(1:4);
        p1_ = Kinv * [linedata(1:2) 1]';
        p2_ = Kinv * [linedata(3:4) 1]';
        A = [ 0 0 0 1 ; p1_' 1 ; p2_' 1 ];
        [eigv, ~] = eig(A'*A);
        normal = [ eigv(1,1) eigv(2,1) eigv(3,1) eigv(4,1) ];
        circlenormal = normal(1:3) / norm(normal(1:3));
    end
    
    % no descriptor
    if (nargout > 6)
        desc = [];
    end
end


end