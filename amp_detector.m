function [amp, amp_std] = amp_detector(signal)
	% Calcula a amplitude de um sinal senoidal.
	[pc, minmax] = critical_points(signal); % pontos criticos e se min ou max 
	pc_min = pc(minmax==1);
	pc_max = pc(minmax==-1);
	amp = zeros(1,min(length(pc_min),length(pc_max)));
	for i=1:length(amp)
		amp(i)=(signal(pc_max(i))-signal(pc_min(i)))/2;
	end
	amp_std = std(amp);
	amp = mean(amp);
end

