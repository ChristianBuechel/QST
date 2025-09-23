% open serial com with TCS
% if found TCS then returns matlab serial port object
% else returns empty
function TCS = TcsOpenCom( noCom )

%close TCS com if allready opened !
seriallist = instrfind( 'Type', 'serial' );
for i = 1:length( seriallist )
   if strcmp( get( seriallist(i), 'UserData' ), 'TCS' ) then
        fclose( seriallist(i) );
   end
end

%try to open com
disp('Initializing TCS device');
TCS = serialport( [ 'COM', int2str(noCom) ], 115200, 'Timeout', 1 );
TCS.UserData = 'TCS';
