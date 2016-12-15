function f = STA(eventtimes, lfp, time, binsize) 

% finds spike triggered average
% bin size in seconds
% f = STA(eventtimes, lfp, time, binsize) 

figure;
hold on;
if size(eventtimes, 2) > size(eventtimes, 1)
	eventtimes = eventtimes';
end

%trims eventtimes to eliminate times that fall in first bin
starttime = eventtimes(1)+binsize;
A = find(eventtimes > starttime);
trimmedevents = [];
trimmedevents = eventtimes(A);

i = 1;
bintimes = [];
binnedLFP = zeros(binsize*2000,1);
q=1;
currentLFP = zeros(binsize*2000,1);


while i <= size(trimmedevents,1)
	% get index for binning in time
	% time of event
	q = trimmedevents(i);
	%find index for start of event
	
	timeendevent = find(abs(time-q)<.0001);
	
	timestartevent = timeendevent-(binsize*2000);
	% add LFP data to a row of binned LFP, each row is for a different spikee

	n=(timestartevent);
	timeendevent;
	
	z = 1;

	size(binnedLFP);
	size(lfp);
	while z<= binsize*2000
		binnedLFP(z);
		lfp((n-1+z));
		binnedLFP(z) = binnedLFP(z) + lfp(n-1+z);
		currentLFP(z) = lfp((n-1+z));
		z = z+1;
	end

	size(currentLFP);
	size(binnedLFP);

	plot(((-size(binnedLFP,1))/binsize+1:0), currentLFP', 'Color', 	[0.5 0.5 0.5]);
	currentLFP = [];

i = i+1;
end

%finds average

binnedLFPaverage = (binnedLFP./size(trimmedevents,1));
f= binnedLFPaverage;

(-size(binnedLFPaverage));

hold on
plot(((-size(binnedLFPaverage))+1/binsize:0), binnedLFPaverage', 'k');




