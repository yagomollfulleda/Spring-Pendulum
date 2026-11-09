format long g
close all
clear all

intervalo=[0 10];

m=1; k=10; l_0=1;
%% VISUALIZACIÓN DE LAS ENERGÍAS DEL MUELLE Y PENDULAR

x0=[11 0 pi/2 0 m k l_0]; %(r rho theta omega m k lo)

opts = odeset('RelTol',1e-12,'AbsTol',1e-12);
[t,solcs]=ode45(@sistema_nl, intervalo,x0, opts);
pot_muelle=0.5.*k.*(solcs(:, 1)-l_0).^2;
cin_muelle=0.5.*m.*(solcs(:,2).^2);


pot_grav=10.*m.*(l_0-cos(solcs(:,3)).*solcs(:,1));
cin_grav=0.5.*m.*((solcs(:,1).^2).*(solcs(:,4).^2));

e_rad=pot_muelle+cin_muelle;
e_ang=pot_grav+cin_grav;

e_mec=e_rad+e_ang;

e_cin=cin_grav+cin_muelle;
e_pot=pot_grav+pot_muelle;


figure(1)
title('Visualización de las energías radial y angular')
plot(t,e_rad); hold on; grid on
plot(t,e_ang);
plot(t,e_mec)
xlabel('Tiempo (s)');
ylabel('Energía (J)');
legend('Energía del muelle', 'Energía del péndulo','Energía mecánica');


figure(2)
title('Visualización de las energías cinética y potencial')
plot(t,e_cin); hold on; grid on
plot(t,e_pot);
plot(t,e_mec)
xlabel('Tiempo (s)');
ylabel('Energía (J)');
legend('Energía cinética', 'Energía potencial','Energía mecánica');

%% RETRATOS DE FASE

figure(3)
title('Retrato de fases radial')
plot(solcs(:,1),solcs(:,2)); hold on; grid on

xlabel('Radio (m)');
ylabel('Velocidad radial (m/s)');

figure(4)
title('Retrato de fases angular')
plot(solcs(:,3),solcs(:,4)); hold on; grid on

xlabel('Ángulo (rad)');
ylabel('Velocidad angular (rad/s)');


%% ANÁLISIS DEL EQUILIBRIO INFERIOR. Periodos

%Gráficas con theta_0=10^-7. Caso particular
x0=[2 0 1e-7 0 m k l_0];


tj=[0 3];

opts = odeset('RelTol',1e-12,'AbsTol',1e-14);
[t,solcs]=ode45(@sistema_nl, tj,x0, opts);
theta=solcs(:,3);
omega=solcs(:,4);



figure(5)
title('Retrato de fases angular para pequeñas oscilaciones')
plot(theta,omega); hold on; grid on
xlabel('Componente angular (rad)')
ylabel('Derivada de la componente angular (rad/s)')


figure(6)
title('Gráfica de la velocidad angular')
plot(t,omega); hold on; grid on

xlabel('Tiempo (s)');
ylabel('Velocidad angular (rad/s)');

figure(7)
title('Gráfica de la componente angular')
plot(t, theta); hold on; grid on

xlabel('Tiempo (s)');
ylabel('Ángulo (rad)');

% CÓDIGO PARA LA OBTENCIÓN DE EL PERIODO

malla_angulos_iniciales=logspace(-9,-1,300);
t_final=[];
for ii=1:length(malla_angulos_iniciales)
    x0=[2 0 malla_angulos_iniciales(ii) 0 m k l_0];
    tj=[0 3];
    opts = odeset('RelTol',1e-12,'AbsTol',1e-14);
    [t,solcs]=ode45(@sistema_nl, tj,x0, opts);
    theta=solcs(:,3);
    omega=solcs(:,4);
    T=cambio_signo(t, omega);
    while abs(t(T(1))-t(T(2)))>1e-10
        x0=solcs(T(1), :);
        intervalo=[t(T(1)) t(T(2))];
        opts = odeset('RelTol',1e-12,'AbsTol',1e-14);
        [t,solcs]=ode45(@sistema_nl, intervalo,x0, opts);
        omega=solcs(:,4);
        T=cambio_signo(t, omega);
    end
    t_final=[t_final (t(T(1))+t(T(2)))/2];
end

T_teor=2*pi*sqrt((m*10+k*l_0)/(k*10));


error_T=abs(T_teor-t_final);

figure(8)
title('Error del periodo teórico contra el numérico')
loglog(malla_angulos_iniciales,error_T)
xlabel('Ángulo inicial en escala logarítmica');
ylabel('Error numérico-teórico en escala logarítmica');


[r,a,b]=reg_lin(log(malla_angulos_iniciales(180:300)),log(error_T(180:300)))




function T=cambio_signo(t, theta)
T=[];
for ii=2:length(theta) 
    if theta(ii-1)*theta(ii)<0 & t(ii)>2
        T=[T ii-1 ii];
    end
end
end



