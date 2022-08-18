% // calculate the proportions of targets and foils
function out = calculateImproperties(stimtime,isi,delayBetTargets,numberimages) 
 
    % stimtime in ms, presentation duration 
    % isi in ms, interstimulus interval
    % delayBetTargets in second, Minimum delay between target repeats
    % images.length = number of total available images,
%     numberimages = 100;
    % delayBetVigilance. The number of trials per image block for vigilance test,
    delayBetVigilance=5;
   
	trialtime = stimtime + isi;
    
	trialsBetTargets = floor(delayBetTargets*1000 / trialtime); % number of gap trial before repeat
    
    B = trialsBetTargets;
	S = delayBetVigilance;
	C =  numberimages %images.length; 
	
	numfoils = ((S-1 + (S-2)*(C+(B/S)-1)-(B/S))/(S-1)); % // derived formula for how many foils you can have that satisfy your constraints
	
% 	/* Derivation comes from this:
% 	variables:
% 	C = # images, T = # targets, F = # foils, S = number of trials per block, B = minimum # of trials between targets
% 	abbreviations:
% 	t = target, f = foil, v = vigilance repeat, r = target repeat
% 	
% 	F = (first block is 1 t, the rest f) + (blocks before r starts is 1 t, 1 v, the rest f) + (remaining blocks are 1 t, 1 v, 1 r, the rest f) + (except for blocks when you're not showing any new t, put back a f to fill that space)
% 	F = (S-1) + (S-2)(B/S - 1) + (S-3)(T) + (T - B/S)		C = T + F
% 	F = (S-1) + (S-2)(B/S - 1) + (S-3)(C-F) + (C-F - B/S)
% 	...
% 	F = (S-1 + (S-2)(C + B/S - 1) - B/S)/(S-1)
% 	
% 	*/
	numtargets = C - numfoils;
	
	out.numfoils = floor(numfoils);
	out.numtargets = ceil(numtargets);
	out.numberimages=numberimages;
% 	// calculate how many subjects will be needed total
% 	out.proptargets = C / numtargets * subsperim;
% 	
% 	// calculate how many trials before a break
% 	trialsBetweenBreaks = Math.ceil(timeBetweenBreaks*1000/trialtime);
% 	
% 	console.log("Calculated the proportions of images.");

    end