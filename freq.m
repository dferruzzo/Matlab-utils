function freq_hz = freq(tempo, sinal)
%% Calcula a frequencia de um sinal em Hertz para um sinal que
% oscila ao redor do zero.
% Recebe um vetor de tempo e um sinal oscilat'orio, que tem cruzamentos por
% zero.
% Assume-se que o o passo de tempo 'e constante.
% Calcula a media das frequencias obtidas.
[zc,dir] = zero_cross(sinal); % detecta os cruzamentos por zero
dt = tempo(2)-tempo(1); % calcula o passo do tempo
zcp=zc(dir>0); % pega apenas os cruzamentos positivos (de menos para mais)
%
freq_hz = zeros(1,length(zcp)-1);
for i=1:length(freq_hz)
    freq_hz(i)=1/((zcp(i+1)-zcp(i))*dt);
end
freq_hz = mean(freq_hz);
end
