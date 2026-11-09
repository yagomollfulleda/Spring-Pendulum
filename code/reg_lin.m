%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Ajusta una recta y = a x + b als vectors x, y.
%
%  Torna el coeficient de regressió r, el pendent a i
%  l''ordenada a l''origen b.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [r,a,b]=reg_lin(x,y)

if iscolumn(x)
 x=x';
end

if iscolumn(y)
 y=y';
end

if size(x,2) ~= size(y,2)
 fprintf('La mida dels dos vectors no es la mateixa al cridar a reg_lin. \n')
 return
end

n=size(x,2);

ax=sum(x)/n; ay=sum(y)/n; 

ax2=sum(x.^2)/n; ay2=sum(y.^2)/n; axy=sum(x.*y)/n;

a=(axy-ax*ay)/(ax2-ax^2);
c=(axy-ax*ay)/(ay2-ay^2);
r=sqrt(a*c);
b=ay-a*ax;
d=ax-c*ay;

%n,r,a,b,ax,ay,ax2,ay2,axy;

end
