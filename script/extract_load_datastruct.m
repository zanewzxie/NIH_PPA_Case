

function SubjResults = extract_load_datastruct(projectpath)

% get subject
% Input is the project path
datapath = fullfile(projectpath,'data');
Subjfiles=dir([datapath '/*NIH*']);

for isub=1:length(Subjfiles)
   isub
   sessionfiles= dir(fullfile(Subjfiles(isub).folder,[Subjfiles(isub).name '/session_*']));
   Datastruct_all=[];
   for iss=1:length(sessionfiles)
       iss
      datafiles= dir(fullfile(sessionfiles(iss).folder,[sessionfiles(iss).name '/Record_*']));
      for idata=1:length(datafiles)
          clear Datastruct
          load(fullfile(datafiles(idata).folder,datafiles(idata).name))
          Datastruct_all=[Datastruct_all Datastruct];
      end
   end
   
   SubjResults(isub).Datastruct_all=Datastruct_all;
   SubjResults(isub).ID=Subjfiles(isub).name ;
   SubjResults(isub).path=fullfile(Subjfiles(isub).folder,Subjfiles(isub).name);
   
end

