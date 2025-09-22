function [varargout] = UseQSTPTB(action,varargin)
% Interface script for QST thermodes, for use with PTB (Matlab or Octave).
% [varargout] = UseQSTPTB(action,varargin)

global qst; % make sure this is accessible everywhere

switch lower(action)
    
    %-----------------------------------------------------------
    case 'init' % UseQSTPTB('init',ComPort, BaselineTemp)
        % creates a global struct array qst
        % all functions that use UseQST should declare this
        % as global (global qst;)
        %-----------------------------------------------------------
        oldverbosity = IOPort('Verbosity', 0);
        [h, errmsg] = IOPort('OpenSerialPort', varargin{1},'BaudRate=115200,DTR=1,RTS=1');
        if h >= 0
            IOPort('Close', h); %OK Port exists and can be opened
        elseif isempty(strfind(errmsg, 'ENOENT'))
            error([varargin{1} ' is already open']);
        else
            error([varargin{1} ' does not exist']);
        end
        IOPort('Verbosity', oldverbosity);
        
        s  = IOPort('OpenSerialPort', char(varargin{1}),'BaudRate=115200,DTR=1,RTS=1');
        WaitSecs(1);
        IOPort('Purge',s);
        ver = mywriteread(s,"B",14); %Battery command
        switch char(ver(9))
            case  'v' % is the v (voltage) in the string
                ind = numel(qst)+1;
                qst(ind).port   = varargin{1};
                qst(ind).id     = []; %see whether we can store the ProbeID
                qst(ind).handle = s;
                qst(ind).t      = [];
                qst(ind).t_init = repmat(varargin{2},1,5);
                qst(ind).up     = [];
                qst(ind).down   = [];
                qst(ind).period = [];
                qst(ind).total  = [];
                mywrite(s,"F"); % Quiet mode
                mywrite(s,sprintf('N%03d', varargin{2}*10)); % Set baseline temp
                clear s;
            otherwise
                IOPort('Close',s);
                error(['Version not supported']);
        end
        %-----------------------------------------------------------
    case 'gettemp'  % UseQSTPTB('gettemp',Index) --> returns the temps of QST Index
        % UseQSTPTB('gettemp') --> returns the temps of 1st QST
        % temps in °C [ambient T1 T2 T3 T4 T5]
        % outpout [when, temps]
        %-----------------------------------------------------------
        if numel(varargin) == 1
            ind = varargin{1};
        else
            ind = 1;
        end
        if ind <= numel(qst)
            IOPort('Purge',qst(ind).handle);
            [resp, when] = mywriteread(qst(ind).handle,"E",24);
            varargout{1} = when;
            varargout{2} = sscanf(char(resp),'%3d %4d %4d %4d %4d %4d')'./10;
        else
            error(['QST ' num2str(ind) ' does not exist'])
        end
        %-----------------------------------------------------------
    case 'getbattery'  % UseQSTPTB('getbattery',Index) --> returns the battery status of QST Index
        % UseQSTPTB('gettemp') --> returns the the battery status of 1st QST
        % output [voltage(V) status(%)]
        %-----------------------------------------------------------
        if numel(varargin) == 1
            ind = varargin{1};
        else
            ind = 1;
        end
        if ind <= numel(qst)
            IOPort('Purge',qst(ind).handle);
            [resp, when] = mywriteread(qst(ind).handle,"B",14);
            battery      = sscanf(char(resp),'%f%*c%d%%')';
            varargout{1} = battery(1);
            varargout{2} = battery(2);
        else
            error(['QST ' num2str(ind) ' does not exist'])
        end
        %-----------------------------------------------------------
    case 'prepareramp'  % UseQSTPTB('prepareramp',params, Index) --> prepare ramps for QST Index
        % UseQSTPTB('prepareramp',params) --> prepare ramps for 1st QST
        % params = [1/5 x 4 matrix with 5 zones x [duration(s) rampspeed(°/s) returnspeed(°/s) temperature(°C)]
        % if size(params,1) == 1 we apply these to all zones
        %-----------------------------------------------------------
        params = varargin{1};
        if numel(varargin) == 2
            ind = varargin{2};
        else
            ind = 1;
        end
        if ind <= numel(qst)
            IOPort('Purge',qst(ind).handle);
            if size(params,1) == 1
                mywrite(qst(ind).handle,sprintf('D0%05d', round(params(1,1)*1000))); % set duration
                mywrite(qst(ind).handle,sprintf('V0%04d', round(params(1,2)*10)));   % set rampspeed
                mywrite(qst(ind).handle,sprintf('R0%04d', round(params(1,3)*10)));   % set returnspeed
                mywrite(qst(ind).handle,sprintf('C0%03d', round(params(1,4)*10)));   % set temperature
                qst(ind).up     = repmat(params(1,2),1,5);
                qst(ind).down   = repmat(params(1,3),1,5);
                qst(ind).period = repmat(params(1,1),1,5);
                qst(ind).t      = repmat(params(1,4),1,5);
                qst(ind).total  = params(1,1)+abs(params(1,4)-qst(ind).t_init)./params(1,3);
            else
                for z=1:5
                    mywrite(qst(ind).handle,sprintf('D%d%05d',z, round(params(z,1)*1000))); % set duration
                    qst(ind).period(1,z) = params(z,1);
                    mywrite(qst(ind).handle,sprintf('V%d%04d',z, round(params(z,2)*10)));   % set rampspeed
                    qst(ind).up(1,z) = params(z,2);
                    mywrite(qst(ind).handle,sprintf('R%d%04d',z, round(params(z,3)*10)));   % set returnspeed
                    qst(ind).down(1,z) = params(z,3); 
                    mywrite(qst(ind).handle,sprintf('C%d%03d',z, round(params(z,4)*10)));   % set temperature
                    qst(ind).t(1,z) = params(z,4);
                    qst(ind).total(1,z)  = params(z,1)+abs(params(z,4)-qst(ind).t_init)./params(z,3);
                end
            end
        else
            error(['QST ' num2str(ind) ' does not exist'])
        end
        %-----------------------------------------------------------
    case 'startramp'  % UseQSTPTB('startramp',record,Index) --> start ramps for QST Index
        % UseQSTPTB('startramp',record) --> start ramps for 1st QST
        % returns when the stimlation started varargout {1}
        % if record == 1 we record temperatures for the longest stimulus of the 5
        % zones and return this matrix as varargout{2}
        % we get a matrix t x 6 of temperatures and times [time ambient T T1 T2 T3 T4 T5] per timepoint
        %-----------------------------------------------------------
        record = varargin{1};
        if numel(varargin) == 2
            ind = varargin{2};
        else
            ind = 1;
        end
        if ind <= numel(qst)
            IOPort('Purge',qst(ind).handle);
            when = mywrite(qst(ind).handle,'L'); % fire
            varargout{1} = when;
            if ~isempty(record) && record == 1
                temps = zeros(1,7);
                start = GetSecs;
                ii = 1;
                while (GetSecs-start) < (max(qst(ind).total) + 1) % record 1s more
                    [resp,t] = mywriteread(qst(ind).handle,"E",24);
                    temps(ii,:) = [t sscanf(char(resp),'%3d %4d %4d %4d %4d %4d')'./10];
                    ii = ii + 1;
                end
                varargout{2} = temps;
            end
        else
            error(['QST ' num2str(ind) ' does not exist'])
        end
        
        %-----------------------------------------------------------
    case 'kill' % closes all qst instances
        % UseQSTPTB('kill') --> reset all QSTs, clear the global var and
        % close all serial ports
        %-----------------------------------------------------------
        
        IOPort('CloseAll');
        clear global qst
    otherwise
        varargout{1} = 'command not implemented';
end
end

%-----------------------------------------------------
function [resp, when] = mywriteread(s,str,n)
% wait for n bytes
t_out = 1; %timeout 1s
resp  = [];
[~, when, ~, ~, ~, ~] = IOPort('Write', s, char(str));
elapsed = 0;
while (IOPort('BytesAvailable',s) < n) && (elapsed < t_out) %get busy until we have enough data or time_out
    elapsed = GetSecs-when;
end
resp = IOPort('Read', s);
end

%-----------------------------------------------------
function [when] = mywrite(s,str)
[~, when, ~, ~, ~, ~] = IOPort('Write', s, char(str));
end

