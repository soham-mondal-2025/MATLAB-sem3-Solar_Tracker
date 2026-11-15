
clc;
clear;
close all;

% Experiment parameters
fixed_angle = 30;
peak_DNI = 800;
cloud_cover = 0;
panel_area = 1;
panel_efficiency = 20;

% Run mathematical model
R = solar_tracker_model( ...
    fixed_angle,peak_DNI,cloud_cover, ...
    panel_area,panel_efficiency);

time = R.time;

% Sun elevation
figure('Name','Sun Elevation','Color','w');

plot(time,R.sunElevation,'b','LineWidth',2);

title('Sun Elevation Throughout the Day');
xlabel('Time (hours)');
ylabel('Sun Elevation (degrees)');

xlim([6 18]);
ylim([0 70]);
xticks(6:2:18);
grid on;

% Power comparison
figure('Name','Solar Power Comparison','Color','w');

plot(time,R.fixedPowerDensity,'r','LineWidth',2);
hold on;

plot(time,R.trackingPowerDensity,'g','LineWidth',2);

title('Fixed vs Tracking Panel Power');
xlabel('Time (hours)');
ylabel('Power Density (W/m^2)');

legend('Fixed Panel','Tracking Panel','Location','northwest');

xlim([6 18]);
grid on;

% Daily energy comparison
figure('Name','Daily Energy Comparison','Color','w');

bar([R.fixedEnergyPerArea R.trackingEnergyPerArea]);

set(gca,'XTickLabel',{'Fixed Panel','Tracking Panel'});

title('Daily Energy Generation');
ylabel('Energy (Wh/m^2)');
grid on;

% Electrical energy comparison
figure('Name','Electrical Energy','Color','w');

bar([R.fixedElectricalEnergy R.trackingElectricalEnergy]);

set(gca,'XTickLabel',{'Fixed Panel','Tracking Panel'});

title('Estimated Electrical Energy');
ylabel('Electrical Energy (Wh)');
grid on;

% Tilt angle experiment
angles = [0 15 30 45 60];

fixedEnergy = zeros(size(angles));
trackingEnergy = zeros(size(angles));
improvement = zeros(size(angles));

for i = 1:length(angles)

    E = solar_tracker_model( ...
        angles(i),peak_DNI,cloud_cover, ...
        panel_area,panel_efficiency);

    fixedEnergy(i) = E.fixedEnergyPerArea;
    trackingEnergy(i) = E.trackingEnergyPerArea;
    improvement(i) = E.improvement;

end

ExperimentResults = table( ...
    angles',fixedEnergy',trackingEnergy',improvement', ...
    'VariableNames', ...
    {'FixedTilt','FixedEnergy','TrackingEnergy','ImprovementPercent'});

disp('========== TILT ANGLE EXPERIMENT ==========');
disp(ExperimentResults);

% Final results
fprintf('\n========== SOLAR TRACKER RESULTS ==========\n');

fprintf('Fixed tilt angle: %.1f degrees\n',R.fixedTilt);
fprintf('Peak DNI: %.2f W/m^2\n',R.peakDNI);
fprintf('Cloud cover: %.1f%%\n',R.cloudCover);
fprintf('Panel area: %.2f m^2\n',R.panelArea);
fprintf('Panel efficiency: %.1f%%\n',R.panelEfficiency);

fprintf('\n----- ENERGY PER UNIT AREA -----\n');

fprintf('Fixed panel: %.2f Wh/m^2\n',R.fixedEnergyPerArea);
fprintf('Tracking panel: %.2f Wh/m^2\n',R.trackingEnergyPerArea);

fprintf('\n----- ELECTRICAL ENERGY -----\n');

fprintf('Fixed panel: %.2f Wh\n',R.fixedElectricalEnergy);
fprintf('Tracking panel: %.2f Wh\n',R.trackingElectricalEnergy);

fprintf('\n----- IMPROVEMENT -----\n');

fprintf('Tracking improvement: %.2f%%\n',R.improvement);

fprintf('\n===========================================\n');
