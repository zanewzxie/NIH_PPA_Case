% circular sampling of the decay time.


% for
% 
%     simulatedData.errors = SampleFromModel(StandardMixtureModel, [0.6 3], [1 1])
% 
% 
% end

% uniform delay time

TestID=1:400;
FillerID=2001:3000;

ImageSeq=zeros(1200,1);

ImageSeqID1 = randsample(1:1200,400);
for i=1:400
    ImageSeq(ImageSeqID1(i))=TestID(i);
end



% A= [5 20 50 110 230];
% alllage=repmat(A,100,1);
% Alldelay=Shuffle(reshape(alllage,500,1));
% allimagseq=[];
% rc=1;
% fc=1;
% numtargets=length(TestID);
% numfoils=length(FillerID);
% ImageSeq=Shuffle([TestID FillerID TestID]);
% lag=[];
% 
% for ip=1:length(TestID)
%    lag(ip)= diff(find(ismember(ImageSeq,TestID(ip))));
% end
% 
% repeat=[];
% for ip=1:length(TestID)
%    indx= (find(ismember(ImageSeq,TestID(ip))));
%    repeat(ip)= indx(2);
% end
% 
% allrepeat=zeros(length(ImageSeq),1);
% allrepeat(repeat)=1;






c=1;

tc=1;
fc=1;
numtargets=240;
numfoils=480;
allc=1;
c=1;

while rc <= numtargets && fc  <= numfoils
    
%     allimagseq(c)= TestID(c);
%     allimagseq(c+Alldelay(c))= TestID(c);
%     
%     c=c+1;rc=rc+1;
    
    if tc <= numtargets %  / TRIAL 1: a new targets (if there are still new ones to add)
        imblock(c) = TestID(tc);
        typeblock(c) = "TARGET";
        perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
        tc=tc+1;  allc=allc+1;
    else % ( // if we're out of new targets, put in a regular filler
        imblock(c) = FillerID(fc);
        typeblock(c) = "FILLER";
        perfblock(c) = "CORRECTREJECTION"; %// default: no response means CR
        fc=fc+1;
    end    
    
    c=c+1;
    
end

% delaytime=randsample(A,500,'true');





