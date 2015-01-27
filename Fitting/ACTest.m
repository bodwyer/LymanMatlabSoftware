mu_b = 9.27401e-21; % Bohr maneton, CGS. Erg/Gauss
g = 2.002319; % Electron g factor
hbar = 1.054572e-27; % Planks constant, erg*second
preFactor = mu_b*g/hbar;
freq = 300e3; % 5.05 MHz
BVec = linspace(.0001, .01, 5);

tauVec = linspace(0, 200, 1000)*1e-9;

hVec = hsv(length(BVec));

figure
xlabel('\tau');
ylabel('P(\tau)');
hold on

bStr = {};

for i = 1:length(BVec)
    B = BVec(i);
    color = hVec(i, :);
    phi = prefactor^2*4*B^2/(freq^2)*sin(2*pi*freq*tauVec./4).^4;
    P = (1 + exp(-phi))./2;
    size(P)
    size(color)
    plot(tauVec, P, 'color',color);
    bStr{i} = ['B = ', num2str(B)];
end

legend(bStr)