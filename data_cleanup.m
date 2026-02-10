%% Clear Workspace

clear; clc; close all;

%% Clean All Data

% Collecting all data files
datafolder = [pwd, '/data'];
datapattern = fullfile(datafolder, '*');
datafiles = dir(datapattern);

for i = 1:length(datafiles)

    T = readtable("data", "FileType", "text", 'Delimiter', '\t');

end