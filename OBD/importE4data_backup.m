function varargout = importE4data_b(pn)

if nargin<1
    pn = uigetdir;
end

dirlist = dir(pn);
dirlist = dirlist(3:end);

E4data = [];
for k = 1:length(dirlist)
    fname = dirlist(k).name;
    [~,name,ext] = fileparts(fname);
    
    if strcmp(ext,'.csv') && ~strcmp(name,'tags') && (sum(regexp(name,'automatic')) == 0)
        
        try
            data = xlsread([pn '\' dirlist(k).name]);
            timestamp = datetime(datenum([1970 1 1 0 0 data(1,1)]),'ConvertFrom','datenum');
            timestamp = timestamp - hours(4);
            
            if strcmp(name,'IBI')
                data(1,:) = [];
                E4data.(name).ts = timestamp;
                E4data.(name).data = data;
            else
                fs = data(2,1);
                data(1:2,:) = [];
                
                
                E4data.(name).ts = timestamp;
                E4data.(name).fs = fs;
                E4data.(name).data = data;
            end
        catch ME
            disp(ME.identifier)
%             error('Unexpected Error')
        end
    end
end

% Check if Temp has outliers
ndx = find(E4data.TEMP.data>100);
E4data.TEMP.data(ndx) = [];

if nargout < 1
    
    % Heart Rate
    time = E4data.HR.ts + seconds((0:length(E4data.HR.data)-1)./E4data.HR.fs)';
    figure
    plot(time,E4data.HR.data); grid
    xlabel('time'); ylabel('bpm')
    
    % Raw PPG
    time = E4data.BVP.ts + seconds((0:length(E4data.BVP.data)-1)./E4data.BVP.fs)';
    figure
    plot(time,E4data.BVP.data); grid
    xlabel('time'); ylabel('PPG Amplitude')
    
    % Acceleration
    time = E4data.ACC.ts + seconds((0:length(E4data.ACC.data)-1)./E4data.ACC.fs)';
    figure
    plot(time,E4data.ACC.data); grid
    xlabel('time'); ylabel('g')
    
    % Electrodermal Activity
    time = E4data.EDA.ts + seconds((0:length(E4data.EDA.data)-1)./E4data.EDA.fs)';
    figure
    plot(time,E4data.EDA.data); grid
    xlabel('time'); ylabel('?S')
    
    % HRV
    figure
    plot(E4data.IBI.data(:,1),E4data.IBI.data(:,2)); grid
    xlabel('time respect to initial time (sec)'); ylabel('duration (sec)')
    
    % Skin Temp
    time = E4data.TEMP.ts + seconds((0:length(E4data.TEMP.data)-1)./E4data.TEMP.fs)';
    figure
    plot(time,E4data.TEMP.data); grid
    xlabel('time'); ylabel('°C')
    
else
    varargout{1} = E4data;
end









