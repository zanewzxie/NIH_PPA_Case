% circular approach in choosing images

addpath(genpath('/Users/xiew5/OneDrive - National Institutes of Health/Zane_Toolbox_V1/MemoryModel/MemToolbox/'));

% Simulate data
simulatedData.errors = SampleFromModel(StandardMixtureModel, [0.80 10], [1 500]);
