function r = isiShuffle(vel,units,time,criteria)
%vels = velocity(pos);
%vel = vels;    
%units = mazet21c1*7.75e-2;
%lfp = lfpmaze19.data;
%time = lfpmaze19.timestamp*7.75e-2;
%criteria = 5000;

notMovingIndicies = vel(1,:) < criteria;
notMovingTimes = vel(2,notMovingIndicies);
l_nmt = length(notMovingTimes);
notMovingBands = zeros([l_nmt,2]);
notMovingBands(1,1) = notMovingTimes(1);
notMovingBands(1,2) = notMovingTimes(1);
for x = 2:l_nmt 
    distance = notMovingTimes(x) - notMovingTimes(x-1);
    if distance < 3*0.035 %three camera samples (too sensitive to noise?)
        notMovingBands(x,1) = -1;
        notMovingBands(x,2) = notMovingTimes(x);
    else
        notMovingBands(x,1) = notMovingTimes(x);
        notMovingBands(x,2) = notMovingTimes(x);    
    end
end
units = movementunits(vel, units);
adjUnits = units;
%adjLFP = lfp;
%adjTime = time';
s = size(notMovingBands);
last = -1;
for x = 1:s(1)
    if notMovingBands(x,1) == -1 && (x == s(1) || notMovingBands(x+1,1) ~= -1)
        l_b = notMovingBands(x,2) - last;
        i = find(units > notMovingBands(x,2));
        adjUnits(i) = adjUnits(i) - l_b;
        %t = find(adjTime > notMovingBands(x,2) | adjTime < last);
        %adjLFP = adjLFP(t);
        %adjTime = adjTime(t);
    elseif notMovingBands(x,1) == notMovingBands(x,2)
        last = notMovingBands(x,1);
    end
end

isiTimes = zeros(length(adjUnits)-1,1);
for x = 1:length(adjUnits)-1
    isiTimes(x) = adjUnits(x+1)-adjUnits(x);
end
    
isiTimes = isiTimes(randperm(length(isiTimes)));
shuffledUnits = zeros(length(adjUnits),1);
shuffledUnits(1) = adjUnits(1);

for x = 2:length(adjUnits)
    shuffledUnits(x) = shuffledUnits(x-1) + isiTimes(x-1);
end

for x = 1:s(1) %re-insert not moving times
    if notMovingBands(x,1) == -1 && (x == s(1) || notMovingBands(x+1,1) ~= -1)
        l_b = notMovingBands(x,2) - last;
        i = find(shuffledUnits > notMovingBands(x,2));
        shuffledUnits(i) = shuffledUnits(i) + l_b;
    elseif notMovingBands(x,1) == notMovingBands(x,2)
        last = notMovingBands(x,1);
    end
end

for x = 1:length(shuffledUnits) %align shuffled times to lfp sample times
    val = shuffledUnits(x);
    tmp = abs(time-val);
    [c, idx] = min(tmp);
    shuffledUnits(x) = time(idx);
end
r = shuffledUnits;