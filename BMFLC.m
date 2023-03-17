%% BMFLC Filter
%Reference https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3231462/

clear all;

%% Parameters

N = 35;    % # of dominant frequency components (a big number)
F0 = 1;   % starting frequency
dF = 1;   % frequency step
MU = 0.01; % adaptive gain parameter

tmax = 120; % simulation time (s)
dt = 0.001; % time step(s)
t = 0:dt:tmax-dt; % time axis
L = length(t); % #samples

%% Input Signal

Mpv = sin(t) + 2*sin(2*t) + 3*sin(3*t) + cos(t) + 2*cos(2*t) + 3*cos(3*t); % Clean signal
Mpi = 0.1*sin(30*t) + 0.1*sin(35*t) + 0.1*cos(30*t) + 0.1*cos(35*t); % Noise

MP = Mpv + Mpi; % Reference signal

%% Additional Parameters

v = zeros(1,N); % array of angular frequencies
x = zeros(2,N); % reference input vector (2xN matrix) - 1st row for sin, 2nd row for cos
w = zeros(2,N); % weight vector(2xN matrix) -  1st row for sin, 2nd row for cos

for i = 1:N
    v(i) = (F0+dF*(i-1)); %assign a band of frequencies, multiply by 2pi if signal is not in rad/s.
    w(1,i) = 0; 
    w(2,i) = 0; %init weights

end

%% Initialize with zeros

y = zeros(1,L);
y_reconstruct = zeros(1,L); 
yc = zeros(1,L);

%% BMFLC Implementation

for k = N+1:L
    % find reference input vector
    for i = 1:N
        x(1,i) = sin(v(i)*t(k));
        x(2,i) = cos(v(i)*t(k));
    end
    
    %Find estimated signal, y
    for i = 1:N
        y(k) = y(k) + w(1,i)*x(1,i) + w(2,i)*x(2,i);
    end
    
    %Adapt weights
    for i = 1:N
        err = MP(k) - y(k);
        w(1,i) = w(1,i) + 2*MU*x(1,i)*err;
        w(2,i) = w(2,i) + 2*MU*x(2,i)*err;
    end
    
    %Extract signal from estimate, y_reconstruct
    N2=3; %We know our frequencies are of 3 components, thus we extract the first three.
    for i=1:N2
        y_reconstruct(k) = y_reconstruct(k) + w(1,i)*x(1,i) + w(2,i)*x(2,i);
    end
end

%% Plotting

figure(1);
subplot(2,1,1);
plot(t,y_reconstruct,'-b', t,Mpv,'-r')
legend('Estimate','Clean Signal')
title('BMFLC Estimate vs Clean Signal');
grid("on");
xlim([50 60]);

subplot(2,1,2);
plot(t,y_reconstruct,'-b',t,MP,'magenta');
legend('Estimate','Noisy Signal');
title('BMFLC Estimate vs Noise Signal');
grid("on");
xlim([50 60]);

figure(2);
subplot(2,1,1);
plot(t,y_reconstruct,'-b', t,Mpv,'-r')
legend('Extracted Signal','Clean Signal')
title('BMFLC Estimate vs Clean Signal');
grid("on");

subplot(2,1,2);
plot(t,y_reconstruct,'-b',t,MP,'magenta');
legend('Extracted Signal','Noisy Signal');
title('BMFLC Estimate vs Noise Signal');
grid("on");