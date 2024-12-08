function bode_plots(dados1,dados2, fig_flag, file_name)
%% recebe como argumento uma estrutura do tipo:
%
% dados.file_name=[];
% dados.freqs=[];
% dados.mag_dB=[];
% dados.fase_deg=[];
% 
% e produce o grafico de Boede de todos os dados.

if fig_flag == 1
	fig1 = figure('visible','off');
	subplot(2,1,1);
	for i=1:length(dados1)
    		semilogx(dados1(i).freqs, dados1(i).mag_dB,'.');
    		hold on;
	end
	for i=1:length(dados2)
		semilogx(dados2(i).freqs, dados2(i).mag_dB,'o','MarkerSize', 10, 'color', 'red');
	end
	xlim([1e-3,1.0]);
	grid;
	subplot(2,1,2);
	for i=1:length(dados1)
    		semilogx(dados1(i).freqs, dados1(i).fase_deg,'.');
    	hold on;
	end
	for i=1:length(dados2)
		semilogx(dados2(i).freqs, dados2(i).fase_deg,'o','MarkerSize', 12, 'color', 'red');
	end
	xlim([1e-3,1.0]);
	ylim([-270,90]);
	grid;
	xlabel('Freq (Hz)');
	saveas(fig1,file_name);
end

end
