function [ status ] = createHDF5( E4, UID )
%Creates HDF5 file for input E4 data
% Inputs:
%   E4 -- E4 data
%   UID -- User Id of E4 data

filename = [UID,'_',datestr(E4.ACC.ts,'yyyymmdd_HHMM'),'.h5'];

flds = fieldnames(E4);

if ~(exist(filename, 'file') == 2)
    fid = H5F.create(filename);
    H5F.close(fid);
end

fileattrib(filename,'+w');
h5writeatt(filename,'/','creation_date',datenum(now));
h5writeatt(filename,'/','UID', UID);

for i = 1:length(flds);

    curFld = flds{i};
    dataStruc = E4.(curFld);
    
    if strcmp(curFld,'IBI')
        loc = ['/',curFld];
        [m, n] = size(dataStruc.data);
        h5create(filename, loc, [m,n]);
        h5write(filename, loc, dataStruc.data);
        h5writeatt(filename,loc,'ts',datenum(dataStruc.ts));
    else
        loc = ['/',curFld];
        [m, n] = size(dataStruc.data);
        h5create(filename, loc, [m,n]);
        h5write(filename, loc, dataStruc.data);
        h5writeatt(filename,loc,'fs',dataStruc.fs);
        h5writeatt(filename,loc,'ts',datenum(dataStruc.ts));
    end
end


end