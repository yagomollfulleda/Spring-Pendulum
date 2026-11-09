function solc=sistema_nl(t, x)
r=x(1);
rho=x(2);
theta=x(3);
omega=x(4);
m=x(5); k=x(6); l0=x(7);
g=10;

solc=ones(4,1);
solc(1) = rho; % Velocidad radial
solc(2) = r*omega^2-(k/m)*(r-l0)+g*cos(theta); % Aceleración radial
solc(3) = omega; % Velocidad angular
solc(4) = (-g*sin(theta)-2*rho*omega)/r; % Aceleracion angular
solc(5)=0; solc(6)=0; solc(7)=0;
end