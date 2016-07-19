%%  Indoor Geomagnetic Model
% @file "GeomagneticModel.m"
% @authors Keung Charteris & T.s.road CZQ
% @version 1.0 ($Revision$)
% @date 16/5/2016 $LastChangedDate$
% @addr. GUET, Gui Lin, 540001,  P.R.China
% @contact : cztsiang@gmail.com &  t.s.road@bk.ru
% @date Copyright(c)  2016-2020,  All rights reserved.
% This is an open access code distributed under the Creative Commons Attribution License, which permits 
% unrestricted use, distribution, and reproduction in any medium, provided the original work is properly cited. 


function [coefficient,z15]=BuildMagneticModel(GridLength,GridWidth,MeasureData)
%   BUILDMAGNETICMODEL Build Geomagnetic Model.
%   BuildMagneticModel(GridLength,GridWidth,ModelFull) reads data from
%   GridLength---------------------------------Map field length
%   GridWidth----------------------------------Map field width
%   MeasureData-------------------------------Magnetic Data(x,y,magnetic)
%   Optionally, returns a whole magnetic model.

%%  Multivariate polynomial regression
x=MeasureData(:,1);
y=MeasureData(:,2);

X=[ones(size(MeasureData))  x  y  x.^2  x.*y  y.^2 ...
       x.^3   x.^2.*y  x.*y.^2   y.^3  x.^4  x.^3.*y  x.^2.*y.^2   x.*y.^3  y.^4 ];

[coefficient,bint] = regress(MeasureData(:,3),X);


xa = 0:0.1:GridLength;
ya = 0:0.1:GridWidth;
[x,y] = meshgrid(xa,ya);

% Magnetic Map
z15=coefficient(1)+coefficient(2)*x+coefficient(3)*y+coefficient(4)*x.^2+coefficient(5)*x.*y+coefficient(6)*y.^2+...
      coefficient(7)*x.^3 +coefficient(8)*x.^2.*y +coefficient(9)*x.*y.^2 +coefficient(10)*y.^3+coefficient(11)*x.^4+...
      coefficient(12)*x.^3.*y+coefficient(13) *x.^2.*y.^2 +coefficient(14)*x.*y.^3+coefficient(15)*y.^4 ;  

%% Plot
figure
title('Map--(15参)');
xlabel('横向网格');ylabel('纵向网格');zlabel('磁场强度/uT');
contourf(x,y,z15);
% shading interp;
colorbar;

figure
surf(x,y,z15);
shading interp;
xlabel('横向网格');ylabel('纵向网格');zlabel('磁场强度/uT');
grid on;
hold on;

