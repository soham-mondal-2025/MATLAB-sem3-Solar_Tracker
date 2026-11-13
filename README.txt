%% README of Solar Tracker
SOLAR TRACKER SIMULATION USING MATLAB

1. PROJECT OVERVIEW

This project is a MATLAB-based simulation that compares the estimated
power and energy produced by two solar-panel arrangements during an
idealized day:

-   Fixed solar panel: remains at a constant tilt angle.
-   Sun-tracking solar panel: continuously adjusts its orientation to
    face the Sun.

The purpose is to demonstrate how panel orientation affects the amount
of solar energy collected. The project is software-only and requires no
physical solar panel, Arduino, sensors, or other hardware.

2. PROJECT OBJECTIVES

1.  Simulate the Sunâ€™s elevation between 6:00 AM and 6:00 PM.

2.  Estimate the solar irradiance available during the day.

3.  Calculate the power received by a fixed-tilt panel.

4.  Calculate the power received by an ideally tracking panel.

5.  Compare both systems using graphs and daily energy calculations.

6.  SOFTWARE REQUIREMENTS

-   MATLAB or MATLAB Online.
-   No additional toolbox is required.
-   Save the MATLAB script as: solar_tracker.m

The project uses standard MATLAB functions, including sind, cosd, max,
trapz, plot, subplot, and bar.

4. HOW THE SIMULATION WORKS

A. SUN ELEVATION The Sunâ€™s elevation is represented using a simplified
sinusoidal model:

    sun_angle = 60 * sind((time - 6) * 15)

The Sun is at 0 degrees at 6:00 AM and 6:00 PM, and reaches a maximum
elevation of 60 degrees at noon.

B. AVAILABLE SOLAR IRRADIANCE The simplified irradiance model is:

    irradiance = 800 * sind(sun_angle)

The available irradiance is zero at sunrise and sunset and reaches 800
W/m^2 at noon. This is an idealized model, not measured weather data.

C. FIXED-PANEL POWER The fixed panel is assumed to have a constant tilt
angle of 30 degrees. Its estimated power per square metre is calculated
as:

    fixed_power = irradiance .* max(0, ...
        cosd(90 - (fixed_angle + sun_angle)))

The max(0, â€¦) term prevents negative power when sunlight is behind the
panel.

D. TRACKING-PANEL POWER The tracking panel is assumed to face the Sun
perfectly:

    tracking_power = irradiance

This is an ideal tracking assumption. Real systems experience
mechanical, electrical, weather, and conversion losses.

E. DAILY ENERGY The power curves are integrated over time using MATLABâ€™s
trapz function:

    fixed_energy = trapz(time, fixed_power)
    tracking_energy = trapz(time, tracking_power)

Since time is measured in hours and power is expressed in W/m^2, the
result is Wh/m^2.

F. PERCENTAGE IMPROVEMENT The percentage improvement is calculated as:

    improvement = ((tracking_energy - fixed_energy) ...
        / fixed_energy) * 100

This indicates the increase in estimated daily energy from tracking
compared with the fixed panel under the assumptions of this model.

5. GRAPHS AND OUTPUT

FIGURE 1: SUN ELEVATION THROUGHOUT THE DAY Displays the simulated Sun
elevation from 6:00 AM to 6:00 PM. The curve rises to 60 degrees at noon
and then falls.

FIGURE 2: SOLAR PANEL POWER COMPARISON Compares the estimated power per
square metre from the fixed panel and the tracking panel. Both curves
start and finish at zero. The tracking panel receives more power during
much of the day in this model.

FIGURE 3: DAILY ENERGY COMPARISON A bar chart compares the total
estimated daily energy collected by the fixed and tracking panels.

COMMAND WINDOW Displays: - Fixed-panel daily energy in Wh/m^2. -
Tracking-panel daily energy in Wh/m^2. - Percentage energy improvement.

The exact values are calculated by MATLAB when the script runs.

6. HOW TO RUN THE PROJECT

1.  Open MATLAB or MATLAB Online.

2.  Create a new script.

3.  Paste the MATLAB code into the editor.

4.  Save the script as solar_tracker.m.

5.  Click Run.

6.  View the graphs in the Figure windows.

7.  Check the energy results in the Command Window.

8.  MODEL ASSUMPTIONS AND LIMITATIONS

    This is an educational, simplified simulation, not a detailed
    solar-engineering design.

-   The Sunâ€™s path is represented by a simple sinusoidal curve.
-   The maximum Sun elevation is fixed at 60 degrees.
-   The irradiance profile is idealized and does not use live weather or
    location data.
-   The tracking panel is assumed to align perfectly with the Sun.
-   Clouds, shading, panel temperature, dust, inverter efficiency, motor
    energy, and mechanical limitations are not modelled.
-   Results are normalized per square metre. Actual panel output depends
    on panel area and efficiency.

Therefore, the results should be interpreted as a comparison under the
stated assumptions, not as a prediction for a real solar installation.

8. CONCLUSION

The simulation demonstrates how changing a solar panelâ€™s orientation can
affect the solar energy it receives. By comparing a fixed panel with an
ideal sun-tracking panel, MATLAB visualizes the difference in power
throughout the day and estimates the total energy collected by each
arrangement.

The project can be extended in the future by adding location-based solar
geometry, real weather data, panel efficiency, tracking losses, and a
graphical user interface.
