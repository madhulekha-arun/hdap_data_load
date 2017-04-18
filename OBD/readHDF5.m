function [ E4out ] = readHDF5( filename )
%Reads HDF5 file and outputs data in structure as E4out
% Inputs:
%   filename -- name of HDF5 file
if nargin < 1
   [fn, pn] = uigetfile('*.h5','Select HDF5 File');
   filename = [pn,fn];
end

fields = {'/ACC','/BVP','/EDA','/HR','/IBI','/TEMP'};
info = h5info(filename);
E4out.UID = info.Attributes(2).Value;

for i = 1:6
    curField = fields{i};
    data = h5read(filename,curField);
    ts = datetime(h5readatt(filename,curField,'ts'),'ConvertFrom','datenum');
    
    eval(['E4out.', curField(2:end),'.data = data;']);
    eval(['E4out.', curField(2:end),'.ts = ts;']);
    
    if ~strcmp(curField(2:end),'IBI');
        fs = h5readatt(filename,curField,'fs');
        eval(['E4out.', curField(2:end),'.fs = fs;']);
    end
end

end

