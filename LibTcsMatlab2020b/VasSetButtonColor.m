% function VasSetButtonColor( ser, pos, color )
%   set button color 
% parameters:
%   ser: VAS serial handle
%   pos: button position = 'left','center','right'
%   color: button color = 'red','green','white'

function VasSetButtonColor( ser, pos, color )
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
%get color
if strcmp( color, 'red')
    command = [command,'r'];
elseif strcmp( color, 'green')
    command = [command,'g'];
elseif strcmp( color, 'white')
    command = [command,'o'];
else
    command = [command,'x'];
end
%send command
%disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
