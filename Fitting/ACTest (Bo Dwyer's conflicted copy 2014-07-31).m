mu_b = 9.27401e-21; % Bohr maneton, CGS. Erg/Gauss
g = 2.002319; % Electron g factor
hbar = 1.054572e-27; % Planks constant, erg*second
preFactor = mu_b*g/hbar;
freq = 5e6; % 5.05 MHz
BVec = linspace(.0001, 1, 10);

tauVec = linspace(0, 1e3, 10000)*1e-9;

hVec = hsv(length(BVec));

figure
xlabel('\tau');
ylabel('P(\tau)');
hold on

bStr = {};

for i = 1:length(BVec)
    B = BVec(i);
    color = hVec(i, :);
    P = (1 + exp(-(preFactor^2*B^2/(2*pi*freq)^2*4*sin(2*pi*freq/4*tauVec).^4)))/2;
    plot(tauVec, P, 'color',color);
    bStr{i} = ['B = ', num2str(B)];
end

legend(bStr)