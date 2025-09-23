% function VasSetLedIntensity( ser, intens )
%   set led intebsity 
% parameters:
%   ser: VAS serial handle
%   intens: intensity = 0 to 100

function VasSetLedIntensity( ser, intens )
%input parameter thresholding
if intens > 100
    intens = 100;
endif
if intens < 0
    intens = 0;
endif
%build command
command = [ 'I', sprintf( '-%03d', intens ) ];
%send command
disp ( command );
write( ser, command, 'char' ); 
flush( ser, 'output' ); %flush output characters
