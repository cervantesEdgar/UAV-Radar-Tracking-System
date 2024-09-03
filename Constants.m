classdef Constants
    properties (Constant)
        c = 3e8; % Speed of light in m/s
        k = 1.38e-23; % Boltzmann's constant in J/K
        h = 6.626e-34; % Planck's constant in J*s
        epsilon0 = 8.854e-12; % Permittivity of free space in F/m
        mu0 = 4*pi*1e-7; % Permeability of free space in H/m
        NF = 3; % Noise figure in dB
        L = 2; % System loss factor (linear)
    end
end
