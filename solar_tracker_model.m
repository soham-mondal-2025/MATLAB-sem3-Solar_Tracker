
function results = solar_tracker_model(fixedTilt, peakDNI, cloudCover, panelArea, panelEfficiency)

    if nargin < 1, fixedTilt = 30; end
    if nargin < 2, peakDNI = 800; end
    if nargin < 3, cloudCover = 0; end
    if nargin < 4, panelArea = 1; end
    if nargin < 5, panelEfficiency = 20; end

    validateattributes(fixedTilt,{'numeric'}, ...
        {'scalar','real','finite','>=',0,'<=',90});

    validateattributes(peakDNI,{'numeric'}, ...
        {'scalar','real','finite','nonnegative'});

    validateattributes(cloudCover,{'numeric'}, ...
        {'scalar','real','finite','>=',0,'<=',100});

    validateattributes(panelArea,{'numeric'}, ...
        {'scalar','real','finite','positive'});

    validateattributes(panelEfficiency,{'numeric'}, ...
        {'scalar','real','finite','>=',0,'<=',100});

    % Time
    time = 6:0.1:18;

    % Simplified solar trajectory
    solarHourAngle = (time - 12) .* 15;

    sunElevation = 60 .* sind((time - 6) .* 15);
    sunElevation = max(0,sunElevation);

    % Simplified clear-sky DNI profile
    sunShape = max(0,sind(sunElevation)).^0.25;

    if max(sunShape) > 0
        sunShape = sunShape ./ max(sunShape);
    end

    cloudFactor = 1 - cloudCover/100;

    DNI = peakDNI .* sunShape .* cloudFactor;

    % Horizontal irradiance
    horizontalIrradiance = DNI .* sind(sunElevation);

    % Fixed south-facing panel incidence angle
    incidenceFactor = ...
        sind(sunElevation).*cosd(fixedTilt) + ...
        cosd(sunElevation).*cosd(solarHourAngle).*sind(fixedTilt);

    incidenceFactor = max(0,incidenceFactor);

    fixedPowerDensity = DNI .* incidenceFactor;

    % Ideal tracking panel
    trackingPowerDensity = DNI;

    % Energy per unit area
    fixedEnergyPerArea = trapz(time,fixedPowerDensity);
    trackingEnergyPerArea = trapz(time,trackingPowerDensity);

    % Electrical power
    efficiencyFactor = panelEfficiency/100;

    fixedElectricalPower = ...
        fixedPowerDensity .* panelArea .* efficiencyFactor;

    trackingElectricalPower = ...
        trackingPowerDensity .* panelArea .* efficiencyFactor;

    % Electrical energy
    fixedElectricalEnergy = trapz(time,fixedElectricalPower);
    trackingElectricalEnergy = trapz(time,trackingElectricalPower);

    % Tracking improvement
    if fixedEnergyPerArea > 0
        improvement = ...
            (trackingEnergyPerArea-fixedEnergyPerArea) ...
            / fixedEnergyPerArea * 100;
    else
        improvement = NaN;
    end

    % Results
    results.time = time;
    results.solarHourAngle = solarHourAngle;
    results.sunElevation = sunElevation;
    results.DNI = DNI;
    results.horizontalIrradiance = horizontalIrradiance;
    results.incidenceFactor = incidenceFactor;

    results.fixedPowerDensity = fixedPowerDensity;
    results.trackingPowerDensity = trackingPowerDensity;

    results.fixedEnergyPerArea = fixedEnergyPerArea;
    results.trackingEnergyPerArea = trackingEnergyPerArea;

    results.fixedElectricalPower = fixedElectricalPower;
    results.trackingElectricalPower = trackingElectricalPower;

    results.fixedElectricalEnergy = fixedElectricalEnergy;
    results.trackingElectricalEnergy = trackingElectricalEnergy;

    results.improvement = improvement;

    results.fixedTilt = fixedTilt;
    results.peakDNI = peakDNI;
    results.cloudCover = cloudCover;
    results.panelArea = panelArea;
    results.panelEfficiency = panelEfficiency;

end
