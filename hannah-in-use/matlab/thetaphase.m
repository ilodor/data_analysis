function f = thetaphase(lfp, tme, above);

%input raw unfiltered LFP. filters in theta band returns times of peaks in theta
% input for above is how many st devs above mean you want peak to be to be counted

lfp = thetafilt(lfp);

st = mean(lfp)+(above*std(lfp));


start = tme(1);


[pks,locs] = findpeaks(thetafilt(lfp), 2000, 'MinPeakDistance', .08, 'MinPeakHeight', st , 'WidthReference', 'halfprom');

f = locs+start;



