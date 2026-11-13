
clc;
clear;
close all;

% SOLAR TRACKER SIMULATION

% Time from 6 AM to 6 PM
time = 6:0.1:18;

% Sun elevation angle
sun_angle = 60 * sind((time - 6) * 15);

% Fixed panel tilt
fixed_angle = 30;

% Maximum solar irradiance (W/m^2)
intensity = 800;

% Available solar irradiance
irradiance = intensity .* sind(sun_angle);

% Fixed panel power
fixed_power = irradiance .* max(0, ...
    cosd(90 - (fixed_angle + sun_angle)));

% Tracking panel power
tracking_power = irradiance;

% Calculate daily energy (Wh/m^2)
fixed_energy = trapz(time, fixed_power);
tracking_energy = trapz(time, tracking_power);

% Calculate improvement
improvement = ((tracking_energy - fixed_energy) ...
    / fixed_energy) * 100;

% FIGURE 1: Sun Elevation
figure;

subplot(2,1,1);

plot(time, sun_angle, 'b', 'LineWidth', 2);

title('Sun Elevation Throughout the Day');
xlabel('Time (Hours)');
ylabel('Sun Elevation (Degrees)');

xlim([6 18]);
ylim([0 70]);

grid on;

% FIGURE 2: Power Comparison
subplot(2,1,2);

plot(time, fixed_power, 'r', 'LineWidth', 2);
hold on;

plot(time, tracking_power, 'g', 'LineWidth', 2);

title('Solar Panel Power Comparison');
xlabel('Time (Hours)');
ylabel('Power per Unit Area (W/m^2)');

legend('Fixed Panel', 'Tracking Panel');

xlim([6 18]);
ylim([0 850]);

grid on;

% FIGURE 3: Energy Comparison
figure;

bar([fixed_energy tracking_energy]);

set(gca, 'XTickLabel', ...
    {'Fixed Panel', 'Tracking Panel'});

title('Daily Energy Generation Comparison');
ylabel('Energy (Wh/m^2)');

grid on;

% DISPLAY RESULTS
fprintf('\n----- SOLAR TRACKER RESULTS -----\n');

fprintf('Fixed Panel Energy: %.2f Wh/m^2\n', ...
    fixed_energy);

fprintf('Tracking Panel Energy: %.2f Wh/m^2\n', ...
    tracking_energy);

fprintf('Energy Improvement: %.2f%%\n', ...
    improvement);
