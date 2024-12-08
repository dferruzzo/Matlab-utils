function dados_bode = get_data_sin(file_name, fig_flag)
%% Recebe cvcomo argumento o arquivo 'AnsXXRadSin.mat'
%
% Ans0.5RadSin.mat
% Ans1RadSin.mat
% Ans3RadSin.mat
%
% Obtem:
%   - a frequencia da oscilacao,
%   - a amplitude do sinal do sinal de entrada,
%   - a amplitude do sinal de saida,
%   - o moludo em ganho e em dB,
%   - a desfasagem entre os sinais,
%   - gera os gráficos dos sinais.
dados = load(file_name);
%
tempo = dados.ans(1,:);
%ref = dados.ans(2,:);
psi = dados.ans(3,:);
tau = dados.ans(6,:);
%
% Passo 1: Definir os parâmetros do sinal
dt = tempo(2)-tempo(1);

if fig_flag==1
    fig1 = figure('visible','off');
    plot(tempo,tau,tempo,psi);
    grid
    legend('tau','psi');
    saveas(fig1, strcat(file_name,'tau_psi.png'));
end
% TODO:
% - [X] Recortar o primeiro 1/4 do sinal.
% - [X] Filtrar os sinais
% - [X] Remover a media dos sinais.
% - [X] Recortar para comenc,ar na primeira subida do sinal de entrada.
% - [X] Calcular os as amplitudes dos sinais.
% - [X] Calcular o ganho e o ganho em dB
% - [X] Calcular a desfasagem dos sinais.
% - [ ] Gerar o vetor de saída.
%
% Recortar o primeiro 1/4 do sinal
t_clip = 0.25*tempo(end);
t_clip_idx = find(tempo<=t_clip);
tempo_clipped = tempo(t_clip_idx(end):end);
tau_clipped = tau(t_clip_idx(end):end);
psi_clipped = psi(t_clip_idx(end):end);
%
if fig_flag==1
    fig2 = figure('visible','off');
    plot(tempo_clipped, tau_clipped, tempo_clipped, psi_clipped);
    grid;
    legend('tau_clipped','psi_clipped');
    saveas(fig2, strcat(file_name,'tau_psi_clipped.png'));
end
% ---------------------------------------------------------------------------------------------------------
%% filtrar os sinais
% Parâmetros do sinal
fs = 1/dt; % Frequência de amostragem (Hz)
% Configuração do filtro Butterworth
fc = 1; % Frequência de corte (Hz)
order = 5; % Ordem do filtro
% Projeto do filtro (passe-baixa)
[b, a] = butter(order, fc/(fs/2), 'low');
%
% Aplicação do filtro ao sinal
tau_clip_fil = filtfilt(b, a, tau_clipped);
psi_clip_fil = filtfilt(b, a, psi_clipped);

if fig_flag==1
    % Plotagem dos resultados
    fig3 = figure('visible','off');
    plot(tempo_clipped, tau_clipped, tempo_clipped, psi_clipped);
    hold on;
    plot(tempo_clipped, tau_clip_fil, tempo_clipped, psi_clip_fil,'linewidth',2);
    grid on;
    legend('tau clipped','tau clipped filtered', 'psi clipped', 'psi clip filt');
    saveas(fig3, strcat(file_name,'sinais_filtradas.png'));
end
% ---------
% Tirar a tendencia e a média dos sinais
p1_tau = polyfit(tempo_clipped, tau_clip_fil, 1);
tau_lin =  p1_tau(1)*tempo_clipped + p1_tau(2);
%tau_clip_fitt = tau_clip_fil - tau_lin;
tau_clip_fitt = tau_clip_fil - mean(tau_clip_fil);
if fig_flag==1
    fig4 = figure('visible','off');
    plot(tempo_clipped, tau_clipped, tempo_clipped, tau_clip_fitt,'linewidth',2);
    hold on;
    %plot(tempo_clipped, tau_clipped - tau_lin, 'o');
    %plot(tempo_clipped, tau_clipped - tau_lin - mean(tau_clipped - tau_lin));
    grid on;
    legend('tau clipped', 'tau clip fitt');
    saveas(fig4,strcat(file_name, 'tau_fitted.png'));
end
% ----------
% obter a frequencia dos sinals
freq_hz = freq(tempo_clipped, tau_clip_fitt); 
% Obter o ganho
[amp_tau, amp_tau_std] = amp_detector(tau_clip_fitt);
[amp_psi, amp_psi_std] = amp_detector(psi_clip_fil);
ganho = abs(amp_psi)/abs(amp_tau);
ganho_dB = 20*log10(ganho);
% obter a desfasagem
fase = desfasagem(tempo_clipped, tau_clip_fitt, psi_clip_fil);
% prints
fprintf('\n------------------------');
fprintf('\nData file: %s', file_name)
fprintf('\nFrequência = %.2f (Hz)', freq_hz);
fprintf('\nFrequência = %.2f (rad/s)', freq_hz*2*pi);
fprintf('\nGanho = %.2f ', ganho);
fprintf('\nGanho = %.2f (dB) ', ganho_dB);
fprintf('\nFase = %.2f (graus)\n', fase);

dados_bode = [freq_hz; ganho_dB; fase];
end
