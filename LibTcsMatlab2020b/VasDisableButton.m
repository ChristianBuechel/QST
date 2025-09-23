% function VasDisableButton( ser, pos )
%   disable response button 
% parameters:
%   ser: VAS serial handle
%   pos: button position = 'left','center','right'

function VasDisableButton( ser, pos )
%build command
%get button position
if strcmp( pos, 'left')
    command = 'L';
elseif strcmp( pos, 'center')
    command = 'C';
elseif strcmp( pos, 'right')
    command = 'R';
else
    command = 'X';
end
command = [command,'d'];
%send command
%disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
