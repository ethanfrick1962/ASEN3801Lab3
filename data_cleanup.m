%% Clear Workspace

clear; clc; close all;

%% Clean All Data

% Collecting all data files
datafolder = [pwd, 'Data'];
datapattern = fullfile(datafolder, '*');
datafiles = dir(datapattern);