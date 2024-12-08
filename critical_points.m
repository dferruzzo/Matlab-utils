function [pc, minmax] = critical_points(signal)
% Recebe um sinal e devolve os indices dos pontos criticos dx/dt=0 e 
% o sinal da segunda derivada nesses indices.
%   (-) se eh maximo.
%   (+) se eh minimo.
pc = find(diff(sign(diff(signal)))); % indice aos pontos criticos
ddtau=sign(diff(diff(signal))); % sinal da segunda derivada
minmax = ddtau(pc); % sinal da segunda derivada nos pontos criticos
end