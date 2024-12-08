function dados_bode = get_data(file_name, fig_flag)
%% Funcao que recebe o nome do arquivo 'AnsXXRadSqr.mat' 
% e obtem os dados de resposta em frequencia, epecificamente do diagrama de
% Bode: o vetor das frequencias, o modulo em dB e a fase em graus.
dados = load(file_name);
fprintf('Data file: %s\n', file_name)
%
tempo = dados.ans(1,:);
ref = dados.ans(2,:);
psi = dados.ans(3,:);
tau = dados.ans(6,:);
%
% FFT
% Passo 1: Definir os parâmetros do sinal
dt = tempo(2)-tempo(1);
Fs = 1/dt;          % Frequência de amostragem (Hz)
t = 0:1/Fs:1-1/Fs;  % Vetor de tempo de 1 segundo

% Passo 2: Calcular a frequência correspondente
n_tau = length(tau);            % Número de pontos
f_tau = (0:n_tau-1)*(Fs/n_tau); % Eixo de frequência
n_psi = length(psi);
f_psi = (0:n_psi-1)*(Fs/n_psi);     % Eixo de frequência

% Passo 3: Calcular a FFT
S_psi = fft(psi);
S_tau = fft(tau);

% Passo 4: Calcular amplitude e fase
ampl_S_tau = abs(S_tau/n_tau);      % Magnitude da FFT
fase_S_tau = unwrap(angle(S_tau));  % Fase da FFT

ampl_S_psi = abs(S_psi/n_psi);      % Magnitude da FFT
fase_S_psi = unwrap(angle(S_psi));  % Fase da FFT

% diagramas de Bode
mag = zeros(1,floor(n_tau/2));
fase = zeros(1,floor(n_tau/2));
freq = zeros(1,floor(n_tau/2));

% começa em 2 para evitar a frequência zero no plot semi-logx
for i=1:n_tau/2
    mag(i) = 20*log10(ampl_S_psi(i)/ampl_S_tau(i));
    fase(i) = (fase_S_psi(i)-fase_S_tau(i))*180/pi;
    freq(i) = f_psi(i);
end

dados_bode = [freq; mag; fase];

% figuras
if fig_flag==true
    figure(1);
    plot(tempo,ref,'k','LineWidth',1.5);
    hold on;
    plot(tempo,psi,'b','LineWidth',1.5);
    plot(tempo,tau,'g','LineWidth',1.5);
    legend('Ref.','Psi',' Tau');
    grid on;
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    title('Simulacao do Modelo');

    % Passo 5: Plotar o espectro
    figure(2);
    subplot(2, 1, 1);
    % Dividir a figura em 2 linhas, 1 coluna, e ativar a primeira
    plot(f_tau(1:floor(n_tau/2)), ampl_S_tau(1:floor(n_tau/2)),'color','blue');
    % Apenas a metade positiva do espectro
    hold on;
    plot(f_psi(1:floor(n_psi/2)), ampl_S_psi(1:floor(n_psi/2)),'color','red');
    % Apenas a metade positiva do espectro
    title('Magnitude da FFT');
    legend('fft tau','fft psi')
    xlabel('Frequência (Hz)');
    ylabel('Magnitude');
    grid on;

    subplot(2, 1, 2); % Ativar a segunda parte da figura
    % Apenas a metade positiva do espectro
    plot(f_tau(1:floor(n_tau/2)), fase_S_tau(1:floor(n_tau/2)),'color','blue');
    hold on;
    % Apenas a metade positiva do espectro
    plot(f_psi(1:floor(n_psi/2)), fase_S_psi(1:floor(n_psi/2)),'color','red');
    legend('fft tau','fft psi');
    title('Fase da FFT');
    xlabel('Frequência (Hz)');
    ylabel('Fase (radianos)');
    grid on

    figure(3);
    subplot(2,1,1);
    semilogx(freq, mag,'.b');
    grid on;
    subplot(2,1,2);
    semilogx(freq, fase,'.b');
    grid on;
end

end