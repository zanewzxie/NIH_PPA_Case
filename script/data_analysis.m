% data processing script 

clear all
% get path
projectpath='/Users/xiew5/OneDrive - National Institutes of Health/TempFiles/Manuscripts/7_PPA_lesioncase/experiments/Forgetting/';
addpath(genpath(fullfile(projectpath,'data')));
addpath(genpath(fullfile(projectpath,'script')));


SubjResults = extract_load_datastruct(projectpath);


%% Ok now analyze the data

for isub=2 %length(SubjResults)
    
    currstruct=SubjResults(isub).Datastruct_all;
    
    
    TimeStamps=[currstruct.StimuluseOnsetUnixTime];
    Corr=[currstruct.Corr];
    IsRepeated=[currstruct.IsRepeated];
    Resp={currstruct.Resp};
    Task = [currstruct.Task];
    CurrentImageID = [currstruct.CurrentImageID];
    Session = [currstruct.Session];
   
    correcthit=[];correctfalse=[];meantimelag=[];bincount=[];
    for itask=1
    taskmask= Task==itask;
    
    % 1. find the lags
    RepeatedID= unique(CurrentImageID(taskmask & IsRepeated==1));
    imgpairs=[];imgpairs_corr=[];imgpairs_IsRepeated=[];clear imgpairs_respons;imgpairs_sessions=[];
    for irep=1:length(RepeatedID)
       indx = find(taskmask & ismember(CurrentImageID,RepeatedID(irep))); %here the indx is overall inx
       imgpairs(irep,:) = TimeStamps(indx);
       imgpairs_corr(irep,:) = Corr(indx);
       imgpairs_IsRepeated(irep,:) = IsRepeated(indx);
       imgpairs_respons(irep,:) = Resp(indx);
       imgpairs_sessions(irep,:) = Session(indx);
    end
    
    % false alarm rate at each session for each task
    for iss=1:3
        sessionmask= Session==iss & taskmask & IsRepeated==0 ;
        FAssession(itask,iss) = sum(sessionmask & contains(Resp,'R'))/sum(sessionmask);
    end
    
    timedelay= diff(imgpairs')'/1000/60; %in min
%     timedelaycond=[];
%     %binning the timedelay
%     timedelaycond(timedelay<1)=1; %1min
%     timedelaycond(timedelay>=1 & timedelay<20)=2; % 1-20 min
%     timedelaycond(timedelay>=20 )=3;
%     
%     meandelaytime= [mean(timedelay(timedelay<1)) mean(timedelay(timedelay>=1 & timedelay<20)) mean(timedelay(timedelay>=20)) ];
% 
%     for i=1:3
%          hit=mean(imgpairs_corr(timedelaycond==i,:)); 
%          
%          correcthit(itask,i)= hit(2);
%          correctfalse(itask,i)= 1-hit(1);
%     end
    
    % moving average over time
    timebind = prctile(timedelay,[0:50:100]);
%     a = histogram(timedelay);
    for    ibin=1:length(timebind)-1
        for iss=1:3
        mask=timedelay>=timebind(ibin) & timedelay<timebind(ibin+1) & imgpairs_sessions(:,2)==iss;

        if sum(mask)~=0
            meantimelag(iss,itask,ibin)=median(timedelay(mask));
            bincount(iss,itask,ibin)=sum((mask));
            hit=mean(imgpairs_corr(mask,:)); 
            correcthit(iss,itask,ibin)= hit(2) - FAssession(itask,iss);
        else
            bincount(iss,itask,ibin)=nan;
            meantimelag(iss,itask,ibin)=nan;
            correcthit(iss,itask,ibin)= nan;
            correctfalse(iss,itask,ibin)= nan;              
        end
    end
    end
    
    end
end


%% Session by session data combine

adjusthit=[];timenbin=[];trialbin=[];
for itask=1
     temp=[];temptime=[];tempcount=[];
     for    ibin=1:length(timebind)-1
           temp=[temp;(correcthit(:,itask,ibin))];%-(correctfalse(:,itask,ibin))];
           temptime= [temptime;meantimelag(:,itask,ibin)];
           tempcount=[tempcount;bincount(:,itask,ibin)];
     end
     adjusthit(:,itask)=temp;
     timenbin(:,itask)=temptime;
     trialbin(:,itask)=tempcount;
end

figure;
subplot(2,2,1);hold on;
x=timenbin(:,1);y=adjusthit(:,1);
plot(x,y,'.')
[X,Y,coefficients,yFitted,SMOOTHX,yFittedSmooth] = fitExponential(x, y);
plot(SMOOTHX, yFittedSmooth,'-');
axis([-5 60 -0.1 1])
ylabel('Adjusted hit rate (Hit - FA)')
xlabel('mean delay (min)')
title('Scene')
axis square;

subplot(2,2,2);hold on;
x=timenbin(:,2);y=adjusthit(:,2);
plot(x,y,'.')
[X,Y,coefficients,yFitted,SMOOTHX,yFittedSmooth] = fitExponential(x, y);
plot(SMOOTHX, yFittedSmooth,'-');
axis([-5 60 -0.1 1])
ylabel('Adjusted hit rate (Hit - FA)')
xlabel('mean delay (min)')
title('Face')
axis square;

subplot(2,2,3);hold on;
x=timenbin(:,1);y=trialbin(:,1);
plot(x,y,'.')
axis([-5 60 0 40])
ylabel('trial count')
xlabel('mean delay (min)')
axis square;

subplot(2,2,4);hold on;
x=timenbin(:,2);y=trialbin(:,2);
plot(x,y,'.')
axis([-5 60 0 40])
ylabel('trial count')
xlabel('mean delay (min)')
axis square;



print(gcf,['Pilotdata_103_decay_' date '.pdf'],'-dpdf','-bestfit');

%%


figure;
subplot(231)
plot(mean(meantimelag),correcthit,'.-');
axis([-2 35 0 1]);
axis square;
xlabel('mean delay (min)')
ylabel('hit')
title('Hit')

subplot(232)
plot(mean(meantimelag),correctfalse,'.-');
axis([-2 35 0 1]);
axis square;
xlabel('mean delay (min)')
ylabel('false alarm')
title('FA')

subplot(233)
plot(mean(meantimelag),correcthit'-correctfalse','.-');
axis([-2 35 -0.2 0.8]);
axis square;
xlabel('mean delay (min)')
ylabel('Corrected (Hit-FA)')
title('Corrected (Hit-FA)')
legend('sence','face')

subplot(234)
plot(mean(meantimelag),bincount','.-');
axis([-2 35 10 40]);
axis square;
xlabel('mean delay (min)')
ylabel('trail count')
title('trail count')


print(gcf,['Pilotdata_102_' date '.pdf'],'-dpdf','-bestfit');





