%% Clear Workspace

clear; clc; close all;

%% Clean All Data

% Collecting all data files
datafolder = [pwd, '/data'];
datapattern = fullfile(datafolder, '*');
datafiles = dir(datapattern);
datafiles = datafiles(~ismember({datafiles.name},{'.','..'}));
cleandata = struct();

% Iterate through all tables
for i = 1:length(datafiles)
    % Read and clean data
    T = readmatrix([datafiles(i).folder '/' datafiles(i).name], "FileType", "text", 'Delimiter', '\t');
    rmmissing(T);

    % Name file
    name = datafiles(i).name;

    % Add table to data struct
    cleandata.(name) = T;
end

% Clean all other data
clear datafolder datapattern datafiles i name T ans;

% Save as MATLAB workspace
save('cleandata.mat');