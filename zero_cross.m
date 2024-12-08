function [zc, dir] = zero_cross(signal)
%% Recebe como argumento um vetor de um sinal escalar
% devolve:
%   - zc: os indices onde o `signal' passa por zero.
%   - dir: a direcao do cruzamento:
%           +1 de menos para mais.
%           -1 de mais para menos.
%
zc = find(diff(sign(signal)));
dsignal = diff(signal);
dir = sign(dsignal(zc));
%
end