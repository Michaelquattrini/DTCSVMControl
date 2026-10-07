% FILE MOTORE BRUSHLESS M.Quattrini
% SIMULAZIONE DEL MOTORE BRUSHLESS A FEM SINUSOIDALE

% Matrice Inversa D per passare da alfabeta->ab(c)
D = [1 0; 1/sqrt(3) 2/sqrt(3)];
invD = D^(-1);

%% PARAMETRI RELATIVI AL MOTORE BRUSHLESS A FEM SINUSOIDALE

% Induttanza sincrona(H)
Lmin = 9.93;                % [mH]
Lmax = 15.44;               % [mH]
Lmedio = (Lmin + Lmax) / 2; % [mH]
Ls = (Lmedio*1e-3)/2;       % [H]

% Resistenza di fase (Ohm) alla temperatura di regime
Rs = (0.628/2)*(1+(135-25)*3.9e-3); % [Ohm]

% Momento d'inerzia (kg m2)
Jm = 0.00670;   

% Flusso di eccitazione (Wb)
Fe = 0.1367; 

% Valore di picco della corrente massima d'indotto (A)
Imax = 20*sqrt(2);

% Coppie di poli
p = 3;

% Velocità meccanica nominale in rpm e in rad/s
Nn = 1200;
Wn = Nn*2*pi/60;

% Coppia nominale (Nm)
Pn = 2137;   
Cn = Pn / Wn;

% Valore di picco della corrente nominale (A)
In = 7.4 * sqrt(2);     
%% PARAMETRI RELATIVI ALL'INVERTER

% Tensione del bus DC (V)
Edc = 380;

% Periodo di commutazione del chopper (s)
Tc = 50e-6;

%% PARAMETRI RELATIVI AL CARICO

% Momento d'inerzia del carico (kg m2)
Jc = 3 * Jm; % Supponiamo che l'inerzia del carico sia il triplo del motore.

% Coefficiente di attrito (Nm s/rad)
b = 1e-3;

% Coefficiente proporzionale di
Kc = Cn/Wn-b;

% Grafico di coppia resistente preso da datasheet  
Torque = [0, 0.01, 0.9, 4, 7.3, 6.4, 4.5, 2.5, 0];
Torque = (Torque * 10) / max(Torque);
theta_deg = [0, 60, 120, 180, 210, 240, 270, 300, 360];
theta_rad = deg2rad(theta_deg);

%% STUDIO DEL CONTROLLO
J=Jc+Jm;            % Inerzia totale;

s=tf('s');
tau_m=J/b;            % Costante meccanica
tau_e=Ls/Rs;          % Costante elettrica

% Parametri Controllo di velocità
Ki_s = 1;
Kp_s = Ki_s*tau_m;

% Parametri Controllo di coppia
Ki_t = 10000;
Kp_t = Ki_t*tau_e;

% Parametri Controllo di flusso
Ki_f = 5000;
Kp_f = Ki_f*tau_e;
