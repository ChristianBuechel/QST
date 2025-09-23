% function [pos, button, release] = VasGetLastPositionAndButton( ser )
%   switch on a led (only works in custom mode) 
% parameters:
%   ser: VAS serial handle
% outputs: 
%   pos: slider last touched position = 0 to 100, -1 if not yet touched
%   button: last button pressed = 'left','center','right','none' if not yet pressed
%   touched: boolean, indicates whether the finger is touching the slider

function [pos, button, touched] = VasGetLastPositionAndButton( ser )
    % Variables globales
    global vasLastPosition vasLastButton vasTouched;

    % Initialiser les variables de sortie
    pos = 0;
    button = 'none';
    
    % Vérifier si le descripteur de fichier est valide
    if ser < 1
        return;
    end

    % Lecture du premier caractère du buffer série
    caractere = '';
    posStr = '';
    
    % Lire des caractères du buffer série jusqu'à ce qu'il soit vide
    while ser.NumBytesAvailable > 0
        % Lire un caractère
        caractere = read( ser, 1, 'char' );

        % Nouvelle ligne ?
        if strcmp( caractere, newline )
            posStr = '';
        end
        
        % Bouton ?
        if caractere == 'L'
            vasLastButton = 'left';
        elseif caractere == 'C'
            vasLastButton = 'center';
        elseif caractere == 'R'
            vasLastButton = 'right';
        end
        
        % Digit ?
        if caractere >= '0' && caractere <= '9'
            posStr = [posStr, caractere];
            
            % Mise à jour "release" ou "derniere position"
            if length(posStr) == 3
                posOuRelache = str2double(posStr);
                
                if posOuRelache == 999
                    vasTouched = false;
                elseif posOuRelache <= 100 && posOuRelache >= 0
                    vasLastPosition = posOuRelache;
                    vasTouched = true;
                end
            end
        end
    end

    % Récupérer la dernière position/bouton
    pos = vasLastPosition;
    button = vasLastButton;
    touched = vasTouched;

end


