% function VasPrepareMeasure( ser, resetScale )
%   prepares a new measure 
% parameters:
%   ser: VAS serial handle
%   resetScale: boolean, reset slider or keep current slider position

function VasPrepareMeasure( ser, resetScale )
global vasLastPosition vasLastButton vasTouched;
vasTouched = false;
vasLastButton = 'none';
if resetScale
    vasLastPosition = -1; %reset position
    VasSetSliderPosition( ser, 0); %reset slider leds
end

