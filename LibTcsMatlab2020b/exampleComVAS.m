%VAS example:

%clean up workspace ...
clear all

%open com, parameter is com number
vas = VasOpenCom( 3 );

%configure VAS led display
VasSetLedDisplayMode( vas, 'bargraph'); %default led display mode
%VasSetledDisplayMode( vas, 'single');

%configure buttons, default state:
% all buttons are enabled and 'white'

%disables left button, and lights up the button in red
VasDisableButton( vas, 'left' );
VasSetButtonColor( vas, 'left', 'red' );

%enable center button , and lights up the button in green
VasEnableButton( vas, 'center' );
VasSetButtonColor( vas, 'center', 'green' );

%disables right button, and lights up the button in red
VasDisableButton( vas, 'right' );
VasSetButtonColor( vas, 'right', 'red' );

%prepare new measure
VasPrepareMeasure( vas, true ); %true = reset scale

% measures at 10Hz until an active button is pressed
cpt = 0;
recTime=[];
recPos=[];
buttonPressed = 'none';
tstart = tic;
while strcmp( buttonPressed, 'none')
    
    %get last position and button
    [pos, button, touched] = VasGetLastPositionAndButton( vas );
    buttonPressed = button;
    
    % record position and time in arrays
    if touched
        cpt = cpt + 1;
        recPos( cpt ) = pos; %record pos
        recTime( cpt ) = toc(tstart); %record time
        disp( pos );%display position
    end
    
    %10Hz
    while toc < 0.1
    end
    tic
 end    
    
%display position vs time
plot( recTime, recPos, '-*' );
grid on; zoom on;

%close com
VasCloseCom( vas );
