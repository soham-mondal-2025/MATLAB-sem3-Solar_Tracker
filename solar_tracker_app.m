
function solar_tracker_app
% ==========================================
% SOLAR TRACKER SIMULATION APPLICATION
% ==========================================
% Run: solar_tracker_app
%
% Requires:
% solar_tracker_model.m
%
% Features:
% Dashboard
% Animated solar simulation
% Environmental parameters
% Performance analytics
% CSV and TXT report export
% Settings and model information

clc;

% ==========================================
% INITIAL PARAMETERS
% ==========================================

currentResults = solar_tracker_model(30,800,0,1,20);

% ==========================================
% MAIN WINDOW
% ==========================================

fig = uifigure( ...
    'Name','Solar Tracker Simulation System', ...
    'Position',[60 40 1300 850], ...
    'Color',[0.95 0.97 0.99]);

tabs = uitabgroup(fig, ...
    'Position',[10 10 1280 830]);

dashboardTab = uitab(tabs,'Title','Dashboard');

simulationTab = uitab(tabs,'Title','Simulation');

environmentTab = uitab(tabs,'Title','Environment');

analyticsTab = uitab(tabs,'Title','Analytics');

reportsTab = uitab(tabs,'Title','Reports');

settingsTab = uitab(tabs,'Title','Settings');


% ==========================================
% DASHBOARD - SCROLLABLE LAYOUT
% ==========================================

dg = uigridlayout(dashboardTab,[3 2]);

dg.RowHeight = {60,400,400};
dg.ColumnWidth = {'1x','1x'};
dg.Padding = [15 15 15 15];
dg.RowSpacing = 15;
dg.ColumnSpacing = 15;
dg.Scrollable = 'on';

titleLabel = uilabel(dg, ...
    'Text','SOLAR TRACKER DASHBOARD', ...
    'FontSize',23, ...
    'FontWeight','bold', ...
    'FontColor',[0.08 0.20 0.36], ...
    'HorizontalAlignment','center');

titleLabel.Layout.Row = 1;
titleLabel.Layout.Column = [1 2];

% Performance panel
summaryPanel = uipanel(dg,'Title','SYSTEM PERFORMANCE');
summaryPanel.Layout.Row = 2;
summaryPanel.Layout.Column = 1;

sg = uigridlayout(summaryPanel,[6 1]);
sg.RowHeight = {40,40,40,40,40,'1x'};
sg.Padding = [15 15 15 15];

fixedSummary = uilabel(sg,'Text','Fixed Energy: -- Wh/m^2','FontSize',13);
trackingSummary = uilabel(sg,'Text','Tracking Energy: -- Wh/m^2','FontSize',13);
gainSummary = uilabel(sg,'Text','Tracking Improvement: -- %', ...
    'FontSize',13,'FontWeight','bold');
powerSummary = uilabel(sg,'Text','Peak DNI: -- W/m^2','FontSize',13);
electricalSummary = uilabel(sg,'Text','Electrical Energy: -- Wh','FontSize',13);
dashboardStatus = uilabel(sg,'Text','System Status: Ready', ...
    'FontSize',12,'FontWeight','bold');

% Power chart panel
dashPowerPanel = uipanel(dg,'Title','POWER COMPARISON');
dashPowerPanel.Layout.Row = 2;
dashPowerPanel.Layout.Column = 2;

dpg = uigridlayout(dashPowerPanel,[1 1]);
dpg.Padding = [5 5 5 5];

axDashPower = uiaxes(dpg);
hold(axDashPower,'on');

dashFixedLine = plot(axDashPower,currentResults.time, ...
    currentResults.fixedPowerDensity,'r','LineWidth',2);

dashTrackingLine = plot(axDashPower,currentResults.time, ...
    currentResults.trackingPowerDensity,'g','LineWidth',2);
dashFixedMarker = plot(axDashPower,currentResults.time(1),0,'ro', ...
    'MarkerFaceColor','r','HandleVisibility','off');
dashTrackingMarker = plot(axDashPower,currentResults.time(1),0,'go', ...
    'MarkerFaceColor','g','HandleVisibility','off');

title(axDashPower,'Power Comparison');
xlabel(axDashPower,'Time (hours)');
ylabel(axDashPower,'Power Density (W/m^2)');
legend(axDashPower,{'Fixed','Tracking'},'Location','northwest');
grid(axDashPower,'on');

% Sun elevation panel
elevationPanel = uipanel(dg,'Title','SUN ELEVATION');
elevationPanel.Layout.Row = 3;
elevationPanel.Layout.Column = 1;

epg = uigridlayout(elevationPanel,[1 1]);
epg.Padding = [5 5 5 5];

axElevation = uiaxes(epg);

plot(axElevation,currentResults.time, ...
    currentResults.sunElevation,'b','LineWidth',2);
dashSunMarker = plot(axElevation,currentResults.time(1), ...
    currentResults.sunElevation(1),'ro','MarkerFaceColor','r', ...
    'HandleVisibility','off');

title(axElevation,'Sun Elevation');
xlabel(axElevation,'Time (hours)');
ylabel(axElevation,'Elevation (degrees)');
xlim(axElevation,[6 18]);
ylim(axElevation,[0 70]);
grid(axElevation,'on');

% Energy comparison panel
energyPanel = uipanel(dg,'Title','DAILY ENERGY');
energyPanel.Layout.Row = 3;
energyPanel.Layout.Column = 2;

eng = uigridlayout(energyPanel,[1 1]);
eng.Padding = [5 5 5 5];

axEnergy = uiaxes(eng);

bar(axEnergy,[currentResults.fixedEnergyPerArea ...
    currentResults.trackingEnergyPerArea]);

axEnergy.XTick = [1 2];
axEnergy.XTickLabel = {'Fixed','Tracking'};

title(axEnergy,'Daily Energy Comparison');
ylabel(axEnergy,'Energy (Wh/m^2)');
grid(axEnergy,'on');



% ==========================================
% SIMULATION TAB - SCROLLABLE
% ==========================================

simGrid = uigridlayout(simulationTab,[1 2]);

simGrid.RowHeight = {720};
simGrid.ColumnWidth = {290,'1x'};
simGrid.Padding = [12 12 12 12];
simGrid.ColumnSpacing = 15;
simGrid.Scrollable = 'on';

controlPanel = uipanel(simGrid,'Title','Simulation Controls');
controlPanel.Layout.Row = 1;
controlPanel.Layout.Column = 1;

cg = uigridlayout(controlPanel,[15 1]);

cg.RowHeight = {28,28,50,42,42,28,28,28,28,28,28,28,28,28,'1x'};
cg.Padding = [12 10 12 10];
cg.RowSpacing = 8;

uilabel(cg,'Text','Fixed Panel Tilt Angle','FontWeight','bold');

angleLabel = uilabel(cg,'Text','30 degrees', ...
    'FontSize',16,'FontColor',[0.1 0.4 0.8]);

angleSlider = uislider(cg,'Limits',[0 60],'Value',30, ...
    'MajorTicks',0:15:60);

angleSlider.ValueChangingFcn = @changeAngle;
angleSlider.ValueChangedFcn = @updateAll;

startButton = uibutton(cg,'push', ...
    'Text','START SIMULATION', ...
    'FontWeight','bold', ...
    'BackgroundColor',[0.1 0.55 0.3], ...
    'FontColor',[1 1 1], ...
    'ButtonPushedFcn',@startSimulation);

resetButton = uibutton(cg,'push', ...
    'Text','RESET SIMULATION', ...
    'BackgroundColor',[0.2 0.4 0.7], ...
    'FontColor',[1 1 1], ...
    'ButtonPushedFcn',@resetSimulation);

uilabel(cg,'Text','SIMULATION INFORMATION','FontWeight','bold');

simEnergyLabel = uilabel(cg,'Text','Tracking Energy: -- Wh/m^2');
simGainLabel = uilabel(cg,'Text','Improvement: -- %');
currentTimeLabel = uilabel(cg,'Text','Time: --');
currentSunLabel = uilabel(cg,'Text','Sun elevation: -- deg');
fixedPowerLabel = uilabel(cg,'Text','Fixed power: -- W/m^2');
trackingPowerLabel = uilabel(cg,'Text','Tracking power: -- W/m^2');
fixedAccumLabel = uilabel(cg,'Text','Fixed accumulated: -- Wh/m^2');
trackingAccumLabel = uilabel(cg,'Text','Tracking accumulated: -- Wh/m^2');

statusLabel = uilabel(cg,'Text','Status: Ready', ...
    'FontWeight','bold','WordWrap','on');

% Animation panel
animationPanel = uipanel(simGrid,'Title','SOLAR TRACKING ANIMATION');
animationPanel.Layout.Row = 1;
animationPanel.Layout.Column = 2;

animGrid = uigridlayout(animationPanel,[1 1]);
animGrid.Padding = [5 5 5 5];

axAnimation = uiaxes(animGrid);

title(axAnimation,'Solar Tracking Animation');
xlabel(axAnimation,'Horizontal Position');
ylabel(axAnimation,'Height');

xlim(axAnimation,[-4.8 4.8]);
ylim(axAnimation,[0 5]);

axAnimation.XTick = [];
axAnimation.YTick = [];

grid(axAnimation,'on');
hold(axAnimation,'on');

plot(axAnimation,[-4.8 4.8],[0.35 0.35], ...
    'k','LineWidth',3);

sx = linspace(-4,4,150);
sy = 3 + 1.5 .* sqrt(max(0,1-(sx./4).^2));

plot(axAnimation,sx,sy,'--', ...
    'Color',[0.7 0.73 0.76]);

sunDot = plot(axAnimation,-4,3,'o', ...
    'MarkerSize',18, ...
    'MarkerFaceColor',[1 0.75 0.1], ...
    'MarkerEdgeColor',[1 0.48 0]);

panelLine = plot(axAnimation,[-0.8 0.8],[0.7 0.7], ...
    'Color',[0.1 0.35 0.8],'LineWidth',8);

rayLine = plot(axAnimation,[-4 0],[3 0.7],'--', ...
    'Color',[1 0.65 0],'LineWidth',1.5);

fixedPanelLine = plot(axAnimation,[-0.8 0.8], ...
    [0.7-0.8*sind(30),0.7+0.8*sind(30)], ...
    'Color',[0.85 0.2 0.2],'LineWidth',7);


% ==========================================
% ENVIRONMENT TAB
% ==========================================

eg = uigridlayout(environmentTab,[5 2]);

eg.RowHeight = {55,55,55,55,60};
eg.ColumnWidth = {'1x','1x'};

eg.Padding = [30 25 30 25];
eg.RowSpacing = 15;
eg.ColumnSpacing = 20;

uilabel(eg,'Text','Peak DNI (W/m^2)', ...
    'FontWeight','bold');

peakField = uieditfield(eg,'numeric', ...
    'Limits',[100 1200], ...
    'Value',800);

uilabel(eg,'Text','Cloud Cover (%)', ...
    'FontWeight','bold');

cloudField = uieditfield(eg,'numeric', ...
    'Limits',[0 100], ...
    'Value',0);

uilabel(eg,'Text','Panel Area (m^2)', ...
    'FontWeight','bold');

areaField = uieditfield(eg,'numeric', ...
    'Limits',[0.1 1000], ...
    'Value',1);

uilabel(eg,'Text','Panel Efficiency (%)', ...
    'FontWeight','bold');

efficiencyField = uieditfield(eg,'numeric', ...
    'Limits',[0 100], ...
    'Value',20);

applyButton = uibutton(eg,'push', ...
    'Text','APPLY ENVIRONMENT SETTINGS', ...
    'FontWeight','bold', ...
    'BackgroundColor',[0.1 0.45 0.75], ...
    'FontColor',[1 1 1], ...
    'ButtonPushedFcn',@updateAll);

applyButton.Layout.Row = 5;
applyButton.Layout.Column = [1 2];


% ==========================================
% ANALYTICS TAB - SCROLLABLE
% ==========================================

ag = uigridlayout(analyticsTab,[2 2]);

ag.RowHeight = {400,400};
ag.ColumnWidth = {'1x','1x'};
ag.Padding = [12 12 12 12];
ag.RowSpacing = 12;
ag.ColumnSpacing = 12;
ag.Scrollable = 'on';

% Power graph panel
analyticsPowerPanel = uipanel(ag,'Title','POWER ANALYSIS');
analyticsPowerPanel.Layout.Row = 1;
analyticsPowerPanel.Layout.Column = [1 2];

apg = uigridlayout(analyticsPowerPanel,[1 1]);
apg.Padding = [5 5 5 5];

axAnalyticsPower = uiaxes(apg);

% Tilt graph panel
tiltPanel = uipanel(ag,'Title','TILT COMPARISON');
tiltPanel.Layout.Row = 2;
tiltPanel.Layout.Column = 1;

tpg = uigridlayout(tiltPanel,[1 1]);
tpg.Padding = [5 5 5 5];

axTilt = uiaxes(tpg);

% Experiment table panel
tablePanel = uipanel(ag,'Title','EXPERIMENT DATA');
tablePanel.Layout.Row = 2;
tablePanel.Layout.Column = 2;

tbg = uigridlayout(tablePanel,[1 1]);
tbg.Padding = [5 5 5 5];

experimentTable = uitable(tbg);

experimentTable.ColumnName = { ...
    'Tilt (deg)', ...
    'Fixed Energy', ...
    'Tracking Energy', ...
    'Gain (%)'};

experimentTable.ColumnWidth = {75,100,110,85};


% ==========================================
% REPORTS TAB
% ==========================================

rg = uigridlayout(reportsTab,[4 1]);

rg.RowHeight = {70,65,65,'1x'};

rg.Padding = [35 30 35 30];

rg.RowSpacing = 15;

uilabel(rg, ...
    'Text','EXPERIMENT REPORT GENERATION', ...
    'FontSize',21, ...
    'FontWeight','bold');

csvButton = uibutton(rg,'push', ...
    'Text','EXPORT SIMULATION DATA (CSV)', ...
    'FontWeight','bold', ...
    'ButtonPushedFcn',@exportCSV);

txtButton = uibutton(rg,'push', ...
    'Text','GENERATE EXPERIMENT REPORT (TXT)', ...
    'FontWeight','bold', ...
    'ButtonPushedFcn',@saveReport);

reportStatus = uilabel(rg, ...
    'Text','Reports will be saved to your selected location.', ...
    'WordWrap','on');

% ==========================================
% SETTINGS TAB
% ==========================================

stg = uigridlayout(settingsTab,[6 1]);

stg.RowHeight = {55,45,45,65,65,'1x'};

stg.Padding = [25 25 25 25];

uilabel(stg, ...
    'Text','PROJECT INFORMATION', ...
    'FontSize',21, ...
    'FontWeight','bold');

uilabel(stg, ...
    'Text','Project: Solar Tracker Simulation System');

uilabel(stg, ...
    'Text','Platform: MATLAB Desktop Application');

uilabel(stg, ...
    'Text','Model: Simplified solar elevation and direct irradiance model', ...
    'WordWrap','on');

uilabel(stg, ...
    'Text','Tracker: Ideal sun-facing panel with perfect alignment', ...
    'WordWrap','on');

uilabel(stg, ...
    'Text',['Note: This is an educational simulation. Real-world ' ...
    'performance also depends on location, date, solar azimuth, ' ...
    'atmospheric conditions, diffuse radiation, shading and ' ...
    'hardware losses.'], ...
    'WordWrap','on');

% ==========================================
% CONNECT ENVIRONMENT INPUTS
% ==========================================

peakField.ValueChangedFcn = @updateAll;

cloudField.ValueChangedFcn = @updateAll;

areaField.ValueChangedFcn = @updateAll;

efficiencyField.ValueChangedFcn = @updateAll;

% ==========================================
% INITIAL UPDATE
% ==========================================

updateAll([],[]);

% ==========================================
% CALLBACK FUNCTIONS
% ==========================================

    function updateAll(~,~)

        if ~isvalid(fig)
            return;
        end

        % Get latest simulation parameters

        try

            currentResults = solar_tracker_model( ...
                angleSlider.Value, ...
                peakField.Value, ...
                cloudField.Value, ...
                areaField.Value, ...
                efficiencyField.Value);

        catch ME

            uialert(fig,ME.message,'Invalid Parameters');

            return;

        end

        R = currentResults;

        % Dashboard information

        fixedSummary.Text = sprintf( ...
            'Fixed Energy: %.2f Wh/m^2', ...
            R.fixedEnergyPerArea);

        trackingSummary.Text = sprintf( ...
            'Tracking Energy: %.2f Wh/m^2', ...
            R.trackingEnergyPerArea);

        if isnan(R.improvement)

            gainSummary.Text = 'Tracking Improvement: N/A';

        else

            gainSummary.Text = sprintf( ...
                'Tracking Improvement: %.2f%%',R.improvement);

        end

        powerSummary.Text = sprintf( ...
            'Peak DNI: %.2f W/m^2',max(R.DNI));

        electricalSummary.Text = sprintf( ...
            'Tracking Electrical Energy: %.2f Wh', ...
            R.trackingElectricalEnergy);

        dashboardStatus.Text = 'System Status: Model Updated';

        % Simulation labels

        angleLabel.Text = sprintf( ...
            '%.1f degrees',R.fixedTilt);

        simEnergyLabel.Text = sprintf( ...
            'Tracking Energy: %.2f Wh/m^2', ...
            R.trackingEnergyPerArea);

        if isnan(R.improvement)
            simGainLabel.Text = 'Improvement: N/A';
        else
            simGainLabel.Text = sprintf('Improvement: %.2f%%',R.improvement);
        end

        currentTimeLabel.Text = 'Time: 6:00 AM';
        currentSunLabel.Text = sprintf('Sun elevation: %.2f deg',R.sunElevation(1));
        fixedPowerLabel.Text = sprintf('Fixed power: %.2f W/m^2',R.fixedPowerDensity(1));
        trackingPowerLabel.Text = sprintf('Tracking power: %.2f W/m^2',R.trackingPowerDensity(1));
        fixedAccumLabel.Text = 'Fixed accumulated: 0.00 Wh/m^2';
        trackingAccumLabel.Text = 'Tracking accumulated: 0.00 Wh/m^2';

        % Dashboard power graph

        dashFixedLine.YData = R.fixedPowerDensity;

        dashTrackingLine.YData = R.trackingPowerDensity;
        dashFixedMarker.XData = R.time(1);
        dashFixedMarker.YData = R.fixedPowerDensity(1);
        dashTrackingMarker.XData = R.time(1);
        dashTrackingMarker.YData = R.trackingPowerDensity(1);
        dashSunMarker.XData = R.time(1);
        dashSunMarker.YData = R.sunElevation(1);

        % Dashboard energy graph

        cla(axEnergy);

        bar(axEnergy,[R.fixedEnergyPerArea ...
            R.trackingEnergyPerArea]);

        axEnergy.XTick = [1 2];

        axEnergy.XTickLabel = {'Fixed','Tracking'};

        title(axEnergy,'Daily Energy Comparison');

        ylabel(axEnergy,'Energy (Wh/m^2)');

        grid(axEnergy,'on');

        % Analytics power graph

        cla(axAnalyticsPower);

        hold(axAnalyticsPower,'on');

        plot(axAnalyticsPower,R.time, ...
            R.fixedPowerDensity,'r','LineWidth',2);

        plot(axAnalyticsPower,R.time, ...
            R.trackingPowerDensity,'g','LineWidth',2);

        title(axAnalyticsPower,'Detailed Power Comparison');

        xlabel(axAnalyticsPower,'Time (hours)');

        ylabel(axAnalyticsPower,'Power Density (W/m^2)');

        legend(axAnalyticsPower, ...
            {'Fixed Panel','Tracking Panel'}, ...
            'Location','northwest');

        grid(axAnalyticsPower,'on');

        % Tilt angle experiments

        angles = [0 15 30 45 60];

        fixedEnergy = zeros(size(angles));

        trackingEnergy = zeros(size(angles));

        gain = zeros(size(angles));

        for j = 1:length(angles)

            E = solar_tracker_model( ...
                angles(j), ...
                peakField.Value, ...
                cloudField.Value, ...
                areaField.Value, ...
                efficiencyField.Value);

            fixedEnergy(j) = E.fixedEnergyPerArea;

            trackingEnergy(j) = E.trackingEnergyPerArea;

            gain(j) = E.improvement;

        end

        % Tilt comparison graph

        cla(axTilt);

        plot(axTilt,angles,fixedEnergy, ...
            '-ro','LineWidth',2,'MarkerFaceColor','r');

        hold(axTilt,'on');

        plot(axTilt,angles,trackingEnergy, ...
            '--go','LineWidth',2,'MarkerFaceColor','g');

        title(axTilt,'Energy vs Fixed Panel Tilt');

        xlabel(axTilt,'Fixed Tilt (degrees)');

        ylabel(axTilt,'Energy (Wh/m^2)');

        legend(axTilt,{'Fixed','Tracking'}, ...
            'Location','best');

        xticks(axTilt,angles);

        grid(axTilt,'on');

        % Experiment table

        experimentTable.Data = [ ...
            num2cell(angles(:)), ...
            num2cell(fixedEnergy(:)), ...
            num2cell(trackingEnergy(:)), ...
            num2cell(gain(:))];

        drawnow limitrate;

    end

% ==========================================
% SLIDER CALLBACK
% ==========================================

    function changeAngle(~,event)

        angleLabel.Text = sprintf( ...
            '%.1f degrees',event.Value);

    end

% ==========================================
% START SIMULATION
% ==========================================

    function startSimulation(~,~)

        if ~isvalid(fig)
            return;
        end

        updateAll([],[]);

        startButton.Enable = 'off';
        resetButton.Enable = 'off';
        angleSlider.Enable = 'off';
        peakField.Enable = 'off';
        cloudField.Enable = 'off';
        areaField.Enable = 'off';
        efficiencyField.Enable = 'off';

        R = currentResults;
        statusLabel.Text = 'Status: Simulation Running...';

        for k = 1:2:length(R.time)

            if ~isvalid(fig)
                return;
            end

            sunX = (R.time(k)-12)*(4/6);
            sunY = 3 + 1.5*sqrt(max(0,1-((R.time(k)-12)/6)^2));

            sunDot.XData = sunX;
            sunDot.YData = sunY;

            % Ideal tracking panel follows the Sun.
            trackAngle = 90-R.sunElevation(k);
            hx = 0.8*cosd(trackAngle);
            hy = 0.8*sind(trackAngle);
            panelLine.XData = [-hx hx];
            panelLine.YData = [0.7-hy 0.7+hy];

            % Fixed panel remains at the selected tilt.
            fixedAngle = R.fixedTilt;
            fhx = 0.8*cosd(fixedAngle);
            fhy = 0.8*sind(fixedAngle);
            fixedPanelLine.XData = [-fhx fhx];
            fixedPanelLine.YData = [0.7-fhy 0.7+fhy];

            rayLine.XData = [sunX 0];
            rayLine.YData = [sunY 0.7];

            % Update live chart markers.
            dashFixedMarker.XData = R.time(k);
            dashFixedMarker.YData = R.fixedPowerDensity(k);
            dashTrackingMarker.XData = R.time(k);
            dashTrackingMarker.YData = R.trackingPowerDensity(k);
            dashSunMarker.XData = R.time(k);
            dashSunMarker.YData = R.sunElevation(k);

            % Accumulated energy up to the current simulation time.
            if k > 1
                fixedAccum = trapz(R.time(1:k),R.fixedPowerDensity(1:k));
                trackingAccum = trapz(R.time(1:k),R.trackingPowerDensity(1:k));
            else
                fixedAccum = 0;
                trackingAccum = 0;
            end

            clockHour = floor(R.time(k));
            clockMinute = round((R.time(k)-clockHour)*60);
            if clockMinute == 60
                clockHour = clockHour + 1;
                clockMinute = 0;
            end
            currentTimeLabel.Text = sprintf('Time: %02d:%02d',clockHour,clockMinute);
            currentSunLabel.Text = sprintf('Sun elevation: %.2f deg',R.sunElevation(k));
            fixedPowerLabel.Text = sprintf('Fixed power: %.2f W/m^2',R.fixedPowerDensity(k));
            trackingPowerLabel.Text = sprintf('Tracking power: %.2f W/m^2',R.trackingPowerDensity(k));
            fixedAccumLabel.Text = sprintf('Fixed accumulated: %.2f Wh/m^2',fixedAccum);
            trackingAccumLabel.Text = sprintf('Tracking accumulated: %.2f Wh/m^2',trackingAccum);

            statusLabel.Text = sprintf('Status: Running at %.1f hours',R.time(k));

            drawnow;
            pause(0.035);

        end

        if isvalid(fig)
            currentTimeLabel.Text = 'Time: 18:00';
            fixedAccumLabel.Text = sprintf('Fixed accumulated: %.2f Wh/m^2',R.fixedEnergyPerArea);
            trackingAccumLabel.Text = sprintf('Tracking accumulated: %.2f Wh/m^2',R.trackingEnergyPerArea);
            statusLabel.Text = 'Status: Simulation Completed';

            startButton.Enable = 'on';
            resetButton.Enable = 'on';
            angleSlider.Enable = 'on';
            peakField.Enable = 'on';
            cloudField.Enable = 'on';
            areaField.Enable = 'on';
            efficiencyField.Enable = 'on';
        end

    end

    function resetSimulation(~,~)

        if ~isvalid(fig)
            return;
        end

        angleSlider.Value = 30;

        peakField.Value = 800;
        cloudField.Value = 0;
        areaField.Value = 1;
        efficiencyField.Value = 20;

        updateAll([],[]);

        % Reset animation

        sunDot.XData = -4;

        sunDot.YData = 3;

        panelLine.XData = [-0.8 0.8];

        panelLine.YData = [0.7 0.7];

        rayLine.XData = [-4 0];

        rayLine.YData = [3 0.7];
        fixedPanelLine.XData = [-0.8 0.8];
        fixedPanelLine.YData = [0.7-0.8*sind(30),0.7+0.8*sind(30)];

        statusLabel.Text = 'Status: Reset - Ready';

    end

% ==========================================
% EXPORT CSV
% ==========================================

    function exportCSV(~,~)

        R = currentResults;

        [file,path] = uiputfile( ...
            'solar_tracker_results.csv', ...
            'Save Simulation Data');

        if isequal(file,0)
            return;
        end

        T = table( ...
            R.time(:), ...
            R.sunElevation(:), ...
            R.DNI(:), ...
            R.horizontalIrradiance(:), ...
            R.fixedPowerDensity(:), ...
            R.trackingPowerDensity(:), ...
            R.fixedElectricalPower(:), ...
            R.trackingElectricalPower(:), ...
            'VariableNames',{ ...
            'Time', ...
            'SunElevation', ...
            'DNI', ...
            'HorizontalIrradiance', ...
            'FixedPower', ...
            'TrackingPower', ...
            'FixedElectricalPower', ...
            'TrackingElectricalPower'});

        writetable(T,fullfile(path,file));

        reportStatus.Text = sprintf( ...
            'CSV successfully exported: %s',file);

    end

% ==========================================
% GENERATE TEXT REPORT
% ==========================================

    function saveReport(~,~)

        R = currentResults;

        [file,path] = uiputfile( ...
            'solar_tracker_report.txt', ...
            'Save Experiment Report');

        if isequal(file,0)
            return;
        end

        filename = fullfile(path,file);

        fid = fopen(filename,'w');

        if fid == -1

            uialert(fig,'Could not create the report file.', ...
                'Export Error');

            return;

        end

        fprintf(fid,'SOLAR TRACKER EXPERIMENT REPORT\n');

        fprintf(fid,'====================================\n\n');

        reportDate = char(datetime("now",'Format','dd-MMM-yyyy HH:mm:ss'));
        fprintf(fid,'Date: %s\n\n',reportDate);

        fprintf(fid,'SIMULATION PARAMETERS\n');

        fprintf(fid,'Fixed Tilt: %.2f degrees\n',R.fixedTilt);

        fprintf(fid,'Peak DNI: %.2f W/m^2\n',R.peakDNI);

        fprintf(fid,'Cloud Cover: %.2f%%\n',R.cloudCover);

        fprintf(fid,'Panel Area: %.2f m^2\n',R.panelArea);

        fprintf(fid,'Panel Efficiency: %.2f%%\n\n', ...
            R.panelEfficiency);

        fprintf(fid,'ENERGY RESULTS\n');

        fprintf(fid,'Fixed Energy: %.2f Wh/m^2\n', ...
            R.fixedEnergyPerArea);

        fprintf(fid,'Tracking Energy: %.2f Wh/m^2\n', ...
            R.trackingEnergyPerArea);

        fprintf(fid,'Fixed Electrical Energy: %.2f Wh\n', ...
            R.fixedElectricalEnergy);

        fprintf(fid,'Tracking Electrical Energy: %.2f Wh\n', ...
            R.trackingElectricalEnergy);

        fprintf(fid,'Tracking Improvement: %.2f%%\n\n', ...
            R.improvement);

        fprintf(fid,'MODEL ASSUMPTIONS\n');

        fprintf(fid,['Simplified solar elevation and approximate ' ...
            'direct irradiance profile.\n']);

        fprintf(fid,['Ideal sun-facing tracking panel with ' ...
            'perfect alignment.\n']);

        fprintf(fid,['Cloud cover represented by a uniform ' ...
            'irradiance reduction.\n']);

        fprintf(fid,['Real-world shading, azimuth errors, ' ...
            'diffuse radiation and hardware losses are excluded.\n']);

        fclose(fid);

        reportStatus.Text = sprintf( ...
            'Report successfully saved: %s',file);

    end

end
