% function VasSetledDisplayMode( ser, mode )
%   set led display mode 
% parameters:
%   ser: VAS serial handle
%   mode: 'bargraph','single','custom'
% ( in custom mode use functions VasSwitchOnLed and VasSwitchOffLed )

function VasSetledDisplayMode( ser, mode )
%build command
%get button position
if strcmp( mode, 'bargraph')
    command = 'b';
elseif strcmp( mode, 'single')
    command = 's';
elseif strcmp( mode, 'custom')
    command = 'c';
else
    command = 'x';
end
command = ['M',command];
%send command
%disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
