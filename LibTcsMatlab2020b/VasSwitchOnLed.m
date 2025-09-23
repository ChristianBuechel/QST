% function VasSwitchOnLed( ser, num )
%   switch on a led (only works in custom mode) 
% parameters:
%   ser: VAS serial handle
%   num: led number = 1 to 60

function VasSwitchOnLed( ser, num )
%input parameter thresholding
if num > 60
    num = 60;
endif
if num < 1
    num = 1;
endif
%build command
command = [ 'O', sprintf( '%02d', num ) ];
%send command
%disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
