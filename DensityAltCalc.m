clear,clc
%{
Chinedum Echedom, Project, Problem 2
Matlab program that will calculate the density
altitude based on real time weather information that you will retrieve with
your program.
First, let's obtain our
weather data. Calculating the air density altitude requires several other
items to be calculated but we will base our calculation on obtaining real
weather information. We will then proceed to use this data to make other
calculations until we finally calculate our density altitude.
The Kelvin to Celcius function is
[Celcius] = Kelv_to_Celc(Kelvin)
%}

% receive real-time weather data from the website
key = '7cab1fcaf444883263bc48dd983e6018';
options = weboptions('ContentType','json');
url=['https://api.openweathermap.org/data/2.5/weather?q=','Ames','&APPID=',key];
CurrentData = webread(url, options);
temp = CurrentData.main.temp;
pressure = CurrentData.main.pressure;
humidity = CurrentData.main.humidity;

tempC = Kelv_to_Celc(temp); % Convert temperature from Kelvin to Celsius
T_d = tempC - ((100 - humidity) / 5); % Calculate the dew point temperature (T_d) (in celcius) using the humidity and temperature
e = 6.11*10^((7.5*T_d)/(237.7+T_d));% Calculate the vapor pressure (e) in millibars

vaporpressure = e; %set vapor pressure (millibars) equal to 'e'
P_mb = pressure; % reassign pressure to P_mb (millibars)
T_v =  temp/(1-(e/pressure)*(1-0.622));% Calculate Virtual Temperature (kelvin)
virtualtemp = T_v; % reassign T_v to virtual temp in kelvin
virtualtempR = (9/5 * (virtualtemp - 273.15)+32) + 459.69;% Convert virtual temperature from Kelvin to Rankine
fieldelv = 955.6; % Factor into consideration that Ames has a field elevation of 955.6 feet

% Calculate Density Altitude
% We need to conver pressure from millibar to inches of HG
pressureinHG = P_mb * 0.02953; % Convert pressure from millibar to inches of Hg
densityAltitude = fieldelv + (145366 * (1 - ((17.326*pressureinHG)/virtualtempR)^0.235)); % Calculate the density altitude (feet) using the formula
%Display all calculated values
fprintf('Dew Point Temperature (C): %.2f\n', T_d); % Display the Dew point temperature (Celcius)
fprintf('Vapor Pressure (mb): %.2f\n', vaporpressure);% Display the calculated Vapor Pressure (millibars)
fprintf('The pressure (inHG): %.2f\n', pressureinHG)
fprintf('Virtual Temperature (K): %.2f\n', virtualtemp); % Display the calculated Virtual temperature (Kelvin)
fprintf('Virtual Temperature (R): %.2f\n', virtualtempR);% Display the calculated Virtual temperature (Rankine)
fprintf('The calculated density altitude is: %.2f feet\n', densityAltitude); % Display the calculated density altitude (feet)
