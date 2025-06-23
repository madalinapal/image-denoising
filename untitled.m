s = tf('s');
% H = (-2*s+1)/(2*s+1);
% %nyquist(H)
% H2 = 10/(s*(1+s)*(1+10*s));
% %bode(H2)
% norm(H2, inf);
% K = 10*s/(s+10)
% %bode(K);
% T = 21/(0.2*s+1)^4
% bode(T)
nyquist(T)

G = 1/(s+0.01)^2
%bode(G)
norm(G,2)
norm(G, inf)