%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       Bayesian Data Analysis
%                       and Signal Processing
%
%                    A PHY 451/551 and I CSI 451/551
%                             FALL 2011
%
%                     Instructor: Kevin H. Knuth
%
%
% Introduction to Global Warming Data
%
%
% We will perform some *crude* analyses of atmospheric CO2 data.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% These data are provided courtesy of:
% Historical carbon dioxide record from the Vostok ice core
% J.-M. Barnola, D. Raynaud, C. Lorius
% Laboratoire de Glaciologie et de Géophysique de l'Environnement, CNRS,
% BP96, 38402 Saint Martin d'Heres Cedex, France 
% and
% N.I. Barkov
% Arctic and Antarctic Research Institute, Beringa Street 38, 199397, St.
% Petersburg, Russia

present = 2003;
vostokicecoreco002 = importdata('HW3-DATA/vostok/vostok-icecore-co2.txt', '\t', 21);

vco2 = flip(vostokicecoreco002.data(:,4));      %reorient co2 data early-->late
temp00 = flip(vostokicecoreco002.data(:,3));    %reorient years early-->late
vyear = present - temp00;                       %convert year data to to years before JC
V = numel(vco2);                                %count measurements


%save restructured vostok data to .mat file
header = {'mean age of the air (negative numbers represent years BC)','CO2 concentration (PPMV)'};
temp0 = horzcat(vyear,vco2);
vostokRework = [header; num2cell(temp0)];
save('HW3Vdata.mat','vostokRework', 'V');


% Plot the CO2 levels over time
figure(1);
subplot(2,2,[1,2]);
plot(vyear, vco2,'.','color','black');
title ('C02 levels over time (Vostok ice-core data)');
xlabel('years (negative numbers denote years BC');
ylabel('co2 concenttration (ppm)');


% What is the range of variability of the CO2 levels?
minco2 = min(vco2);
maxco2 = max(vco2);
fprintf("\nVOSTOK ICE CORE DATA \n");
fprintf("Range of co2 levels:                   %d to %d\n", minco2, maxco2);

% Compute the mean and standard deviation of the CO2 levels?
fprintf("Mean of co2 levels:                    %d\n", mean(vco2));
fprintf("Standard deviation of co2 levels:      %d\n\n", std(vco2));

fprintf("2 standard deviations from mean:       %d\n\n", mean(vco2)+4*(std(vco2)));

% Plot a histogram of the CO2 levels?
subplot(2,2,[3,4]);
histogram(vco2,50);
title('distribution of CO2 levels');
xlabel('co2 concenttration (ppm)');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Download (or unzip) the Mauna Loa Atmopheric Sample Data Set
% Import them into Matlab using the Import Data function in the File Menu
% Restructure the data and save them in these arrays:
% myear  <1x557>   - year  
% mmonth <1x557>   - month
% mtime  <1x557>   - time in years
% mco2   <1x557>   - co2 concentration in ppm
% M                - number of measurements
% save the results in a mat-file
% WARNING: THERE ARE MISSING DATA VALUES THAT YOU MUST DEAL WITH.
% Dont interpolate them, just omit them from the data array.
%
% These data are provided courtesy of:
% Atmospheric carbon dioxide record from Mauna Loa
% C.D. Keeling and T.P. Whorf
% Carbon Dioxide Research Group, Scripps Institution of Oceanography,
% University of California, La Jolla, California 92093-0444, U.S.A.


maunaloa = importdata('HW3-DATA/mauna loa/maunaloa_co2.txt', ' ', 16);
mdata = maunaloa.data;
startYear = 1958; monthCount = 0.5; monthsInYear = 12; 
myear = zeros(557,1); mmonth = zeros(557,1); mtime = zeros(557,1); mco2 = zeros(557,1);
M = 0; % number of measurements/index count for all arrays

%iterate over co2 data collecting corresponding cronological info
for row = 1:47
    month = 1;                      %reset to january at the start of each year
    for col = 2:13
        if mdata(row,col) > 0       %record only if co2 data is non-null
            M = M + 1;
            myear(M) = mdata(row,1);
            mmonth(M) = month;
            mtime(M) = (monthCount/monthsInYear)+startYear;
            mco2(M) = mdata(row,col);
        end
        monthCount = monthCount + 1; %incriment time in months
        month = month + 1;           %incriment month
    end
end


% -Plot the CO2 levels over modern times
figure(2);
plot(mtime, mco2,'color','black');
title ('C02 levels over time (Mauna Loa data)');
xlabel('years (negative numbers denote years BC)');
ylabel('co2 concentration (ppm)');

%save restructured mauna loa data to .mat file
header = {'year','month','years since 1958','CO2 concentration (PPMV)'};
temp0 = horzcat(myear,mmonth,mtime,mco2);
maunaLoaRework = [header; num2cell(temp0)];
save('hW3Mdata.mat','maunaLoaRework', 'M');

% -Can you determine (roughly) the period of the oscillations?
% they apper to be yearly 
% -What could cause this?
% CO2 levels fluctuate on an annual basis because the majority of the 
% earth's land mass, where plants are present to absorb C02 during 
% photosynthesis, is in the northern hemisphere.
% http://science.answers.com/Q/Why_is_there_an_annual_fluctuation_in_the_level_of_carbon_dioxide_in_the_atmosphere

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the two data sets by concatenating the arrays
% time  <1x920>   - time in years
% co2   <1x920>   - co2 concentration in ppm
% S = V + M       - number of measurements
% Remember that the Vostok data is in years before present, while the Mauna
% Loa data are real dates.


% concatenate co2 and time arrays
co2 = [vco2;mco2];
time = [vyear;mtime];
S = V + M;

% Plot the CO2 levels over time
% 'YOUR CODE GOES HERE'
figure(3);
plot(time, co2,'.','color','black');

title ('C02 levels over time (Combine data sets--Vostok, Mauna Loa)');
xlabel('years (negative numbers denote years BC)');
ylabel('co2 concenttration (ppm)');


