function fase = desfasagem(tempo, sinal1, sinal2)
%% Devolve a desfasagem em graus do sinal2 em relacao ao sinal 1. 
% O vetor tempo tem que estar igualmente espacado.
% assume-se que os sinais oscilam aoredor do zero 
%fprintf('freq. signal1 = %f (Hz)\n',freq(tempo, sinal1));
%fprintf('freq. signal1 = %f (rad/s)\n',freq(tempo, sinal1)*2*pi);
%
%fprintf('freq. signal2 = %f (Hz)\n',freq(tempo, sinal2));
%fprintf('freq. signal2 = %f (rad/s)\n',freq(tempo, sinal2)*2*pi);

%
% freq dos sinais
freq_sinais = mean([freq(tempo, sinal1),freq(tempo, sinal2)]); 
T_sinais = 1/freq_sinais;
% tempo de amostragem
%dt = tempo(2)-tempo(1); 
% cruzamentos em zero dos sinais
[zc1,dir1] = zero_cross(sinal1);
[zc2,dir2] = zero_cross(sinal2);
% apenas cruzamentos positivos, de menos a mais.
zc1p = zc1(dir1>0);
zc2p = zc2(dir2>0);
%
fase = [];
for i=1:length(zc1p)
    if tempo(zc2p(i))-tempo(zc2p(i))<T_sinais
        % o sinal1 aparece primeiro que o sinal2
        fase = [fase, 2*pi*freq_sinais*(tempo(zc1p(1))-tempo(zc2p(1)))];
    end
end
%fprintf('\nFase = %f (rad)\n', mean(fase));
%fprintf('Fase = %f (deg)\n', mean(fase)*180/pi);
%fprintf('Desvio padrao da fase = %f\n',std(fase));
fase = mean(fase)*180/pi;
