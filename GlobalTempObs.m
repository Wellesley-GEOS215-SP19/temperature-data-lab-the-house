%% Author: NBB

%Instructions :Now you will use the same approach you have used in analyzing 
%the data from your individual station to analyze the global mean temperature data set.
%Create a new script titled “GlobalTempObs.m” and follow the same analysis procedure you applied
%on your individual station data, but this time, read in the file “global_temp.xls.”
%(Though you might be able to do this by copying the exact lines of code you wrote for 
%your station data, I encourage you do this without any copying and pasting, focusing on 
%thinking through and making sure you understand each step of the code you are writing.)
%How do your results from the individual station compare with the global mean temperature
%results?

%% Read in the file for your station as a data table
filename = 'global_temp.xls'; %change this to select a different station
globalData = readtable(filename);

%% Calculate the annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array
tempGlobal = table2array(globalData(:,2:end))
years = table2array(globalData(:,1))

%Calculate the mean, standard deviation, minimum, and maximum temperature
%for every month. This will be similar to what you did above for a single
%month, but now applied over all months simultaneously.
meanMonthlyTemp = nanmean(tempGlobal)
stdMonthlyTemp = nanstd(tempGlobal)
minMonthlyTemp = min(tempGlobal)
maxMonthlytemp = max(tempGlobal)

meanYearlyTemp = nanmean(tempGlobal')
stdYearlyTemp = nanstd(tempGlobal')
minYearlyTemp = min(tempGlobal')
maxYearlytemp = max(tempGlobal') 

tempGlobalMod = tempGlobal

for i = 1:12
    %use the find and isnan functions to find the index location in the
    %array of data points with NaN values
    indnan = find(isnan(tempGlobal(:,i)) == 1); 
    %fill the corresponding values with the climatological mean
    tempGlobalMod(indnan,i) = meanMonthlyTemp(i)
end
meanYearlyTempMod = nanmean(tempGlobalMod')
stdYearlyTempMod = nanstd(tempGlobalMod')
minYearlyTempMod = min(tempGlobalMod')
maxYearlytempMod = max(tempGlobalMod')

%% holds the indexes of where the desired years are 
baselinePeriod = find(years >= 1981 & years <=2000) 
baselineMean = mean(tempGlobalMod(baselinePeriod)) %baseline mean for a year

anomaly = meanYearlyTempMod - baselineMean
%%
figure(1); clf
plot(years,meanYearlyTemp)
%errorbar(meanYearlyTemp, stdYearlyTemp) would be nice to show as a shade
title('Annual Mean Global Temperature 1880-2006')
xlabel('Year')
ylabel('Temp (C)')

%%
figure(2); clf
hold on %so that multiple lines can go on one figure
plot(years,anomaly, '.')
title('Global Annual Temperature Anomaly Relative to 1981-2000')
xlabel('Year')
ylabel('Temperature (C) Different from baseline')
fiveMean = movmean(anomaly,5)
plot(years,fiveMean)

transposedYears = years'
pTotal = polyfit(transposedYears,anomaly,1)
p1960 = polyfit(transposedYears(81:end),anomaly(81:end),1)
p1980 = polyfit(transposedYears(101:end),anomaly(101:end),1)
p2000 = polyfit(transposedYears(121:end),anomaly(121:end),1)

plot(transposedYears,pTotal(1)*transposedYears+pTotal(2))
plot(transposedYears(81:end),p1960(1)*transposedYears(81:end)+p1960(2))
plot(transposedYears(101:end),p1980(1)*transposedYears(101:end)+p1980(2))
%plot(transposedYears(121:end),p2000(1)*transposedYears(121:end)+p2000(2))

legend('Annual Average °C', ...
'5 year moving mean', ... 
'Global Trend 1883-Present Average', .... 
'Global Trend 1960-Present Average', ...
'Global Trend 1980-Present Average')
hold off
