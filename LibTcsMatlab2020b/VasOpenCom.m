% open serial com with VAS
% if found VAS then returns matlab serial port object
% else returns empty
function VAS = VasOpenCom( noCom )

%close VAS com if allready opened !
seriallist = instrfind( 'Type', 'serial' );
for i = 1:length( seriallist )
   if strcmp( get( seriallist(i), 'UserData' ), 'VAS' ) then
        fclose( seriallist(i) );
   end
end

%try to open com
disp('Initializing VAS device');
VAS = serialport( [ 'COM', int2str(noCom) ], 115200, 'Timeout', 1 );
VAS.UserData = 'VAS';
