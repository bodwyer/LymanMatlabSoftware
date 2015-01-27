function [saveStr] = GenerateSaveFolders(dataDirectory, measureType)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Set up directory and filenames for saving all data.
% If folder exists with same name, create new folder with num + 1
% at the end
timeVec = clock;
year = num2str(timeVec(1));
month = num2str(timeVec(2));
day = num2str(timeVec(3));
hour = num2str(timeVec(4));
minute = num2str(timeVec(5));

dateStr = [year, '_', month, '_', day];

fileBase = [dateStr, '_', measureType];
dateDirectory = [dataDirectory, dateStr, '\'];

listDir = dir(dateDirectory);
isub = [listDir(:).isdir]; % logical vector
nameFolds = {listDir(isub).name};

matches = regexp(nameFolds, [measureType, '_run_', '[0-9]+'], 'match');
matchesTrue = ~cellfun(@isempty, matches);
numMatches = sum(matchesTrue);
% indMatch = find(matchesTrue, 1, 'last');
if ~exist(dateDirectory, 'dir')
    mkdir(dataDirectory, dateStr)
end
maxNum = numMatches + 1;

folder = [measureType, '_run_', num2str(maxNum)];
mkdir(dateDirectory, folder)
saveStr = [dateDirectory, folder, '\', fileBase];



end

