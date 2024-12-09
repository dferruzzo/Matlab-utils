function sinal_filtrado = filtro(sinal, fs, fc, n)
	% Parâmetros do filtro
	%fs = 100; % Frequência de amostragem em Hz
	%fc = 10;  % Frequência de corte em Hz
	%n = 5;    % Ordem do filtro

	% Normalizar a frequência de corte
	Wn = fc / (fs / 2);

	% Projetar o filtro Butterworth
	[b, a] = butter(n, Wn);

	% filtrar o sinal
	sinal_filtrado = filtfilt(b, a, sinal);
end

