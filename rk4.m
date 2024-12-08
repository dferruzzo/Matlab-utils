% @date: 24/11/2021
% @author: Diego Ferruzzo
function [x tempo] = rk4(rhs,ti,tf,dt,x0)
% ----------------------------------------------------------------------------
% Implementação de Runge-Kutta de ordem 4 de passo fixo.
% ----------------------------------------------------------------------------
%
%                       [dx tempo] = rk4(rhs,ti,tf,dt,x0)
%
% rhs(t,x), lado direito da equação diferencial, 
% ti, tempo inicial,
% tf, tempo final, tf > ti,
% dt, passo de integração,
% x0, condição inicial.
% ----------------------------------------------------------------------------

% Verificação de erros nos parâmetros
if length(x0(1,:))>1 % se numero de colunas > 1
    error('init:cond','Condição inicial não é um vetor');
end
%
%if ((tf<=ti)||(tf<0)||(ti<0)||(tf<ti+dt))
if (abs(tf-ti)<=abs(dt))
    error('time:time','Erro no tempo de simulação');
end
%-----------------------------------------------------------------------------
% vetor de tempo,
tempo = NaN*(ones(floor(abs((tf-ti)/dt)),1));
% vetor de saída,
x = NaN*ones(length(x0(:,1)),length(tempo));
% Computo do Runge-Kutta
x(:,1) = x0;
t = ti;
i = 1;
%f = waitbar(0,'RK-4 em progresso: 0%%','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
%setappdata(f,'canceling',0);
%while (t <= tf)
for i = 1:length(tempo)
%   if getappdata(f,'canceling')
 %       break
 %   end
    k1 = rhs( t      , x(:,i) );
    k2 = rhs( t+dt/2 , x(:,i)+dt*k1/2 );
    k3 = rhs( t+dt/2 , x(:,i)+dt*k2/2 );
    k4 = rhs( t+dt   , x(:,i)+dt*k3   );
    x(:,i+1) = x(:,i) + (dt/6)*(k1+2*k2+2*k3+k4);
    tempo(i) = t;
  %  waitbar(t/(tf-dt),f,sprintf('RK-4 em progresso: %.2f%%',t*100/(tf-dt)));
    t = t + dt;    
    %i = i + 1;
end
%delete(f);
x=x(:,1:length(tempo));

