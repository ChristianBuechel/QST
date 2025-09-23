% function VasSetSliderPosition( ser, pos )
%   set slider position 
% parameters:
%   ser: VAS serial handle
%   pos: position = 0 to 100

function VasSetSliderPosition( ser, pos )
%input parameter thresholding
if pos > 100
    pos = 100;
end
if pos < 0
    pos = 0;
end
%build command
command = [ 'P', sprintf( '%03d', pos ) ];
%send command
%disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
