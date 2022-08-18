%// create the memorability-based image sequence
function  T = generateseq(numberimages,numtargets,numfoils,trialsBetTargets,delayBetVigilance)

% 
% 	/* NOTE: This code assumes you want to get the memorability scores of all of your images. If you instead have images you already know will be sorted as target vs. filler, you can edit that here. To do that:
% 		1. Input images as targets followed by fillers (in the textbox list of images in the other frame, or at the top with var images = ...
% 		2. Set numtargets to your number of targets
% 		3. Remove allImArray = Shuffle(allImArray).
% 	The reason I haven't implemented this is because this depends on you choosing a good number of targets and fillers (rather than me calculating it for you here) and so it takes some thought
% 	*/

	allImArray = 1:numberimages;
% 	allImArray = Shuffle(allImArray); % // Comment this if you want to manually determine the targets and fillers
    targetIms = 1:numtargets;
	fillerIms = 200+(1:numfoils);

	targetIms = Shuffle(targetIms);
	repeatIms = Shuffle(targetIms);
	fillerIms = Shuffle(fillerIms);

	tc = 1; %// target counter
	fc = 1; %// filler counter
	ofbc = 1;% // old filler block counter
	rc = 1; %// repeat counter
	allc = 1;% // overall sequence counter

% 	// now make pseudorandomized image blocks of 4 trials each
  	oldfillblock = [];
    
    allimgseq=[];
    imtypeseq=[];
    performanceseq=[];
    
	while rc <= numtargets && fc  <= numfoils
        
		 c = 1; %// mini-block counter

		if tc <= numtargets %  / TRIAL 1: a new targets (if there are still new ones to add)
			imblock(c) = targetIms(tc);
			typeblock(c) = "TARGET";
			perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
			tc=tc+1; c=c+1; allc=allc+1;
        else % ( // if we're out of new targets, put in a regular filler
			imblock(c) = fillerIms(fc);
			typeblock(c) = "FILLER";
			perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
			oldfillblock(ofbc) = fillerIms(fc);
			c=c+1; allc=allc+1; ofbc=ofbc+1; fc=fc+1;
        end

		if length(oldfillblock)>0 % (oldfillblock.length > 0) % ( // TRIAL 2: vigilance repeat from the last block
			oldfillblock = Shuffle(oldfillblock);
			imblock(c) = oldfillblock(1);
			typeblock(c) = "VIGILANCE";
			perfblock(c) = "MISS";  %// default: no response means they missed it
			c=c+1; allc=allc+1;
			oldfillblock = []; ofbc = 1;
         else  %( // if there was no last block, put in a regular filler
            imblock(c) = fillerIms(fc);
			typeblock(c) = "FILLER";
			perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
			oldfillblock(ofbc) = fillerIms(fc);
			c=c+1; allc=allc+1; ofbc=ofbc+1; fc=fc+1;            
        end

		if (allc > trialsBetTargets) %( // TRIAL 3: if enough delay has passed, can do target repeats
			imblock(c) = repeatIms(rc);
			typeblock(c) = "REPEAT";
			perfblock(c) = "MISS";
			rc=rc+1; c=c+1; allc=allc+1;
        else %( // if it's not time for the target repeats yet, put in a regular filler
            imblock(c) = fillerIms(fc);
			typeblock(c) = "FILLER";
			perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
			oldfillblock(ofbc) = fillerIms(fc);
			c=c+1; allc=allc+1; ofbc=ofbc+1; fc=fc+1;         
        end

		for i = 1:delayBetVigilance-3 % // remaining trials: filler
			if fc <= length(fillerIms) %( // only if there are fillers left to fill
                imblock(c) = fillerIms(fc);
                typeblock(c) = "FILLER";
                perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
                oldfillblock(ofbc) = fillerIms(fc);
                c=c+1; allc=allc+1; ofbc=ofbc+1; fc=fc+1;  
            end
        end
        

%  	(imblock, typeblock, perfblock) = Shuffles((imblock, typeblock, perfblock));
    
		allimgseq =[allimgseq imblock];
		imtypeseq = [imtypeseq typeblock];
		performanceseq = [performanceseq perfblock];


% 	console.log("Done making the image sequence!");
    end
%     
%     T.allimgseq=allimgseq;
%     T.imtypeseq=imtypeseq;
%     T.performanceseq=performanceseq;
    varNames={'allimgseq','imtypeseq','performanceseq'};
    T = table(allimgseq',imtypeseq',performanceseq','VariableNames',varNames);
  
end