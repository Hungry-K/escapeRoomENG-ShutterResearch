%This demo shows how to layer sprites on top of each other and use a
%keyboard to control character movement. 
%In this simple demo a wizard sprite is put on top of a grass backround and
%is able to walk around the image using the arrow keys until reaching the 
% door at which point you "win"

close all

%Initialize sprites 
room = escapeRoomEngine('test.png',10,10,0,0,8,[255,255,255]);

%Sets the size of the room
%Read the variable name, you can understand what it is ^^
maxDimensionVertical = 5; maxDimensionHorizontal = 5; 

%Sets background of room
%The 'scallar' number correlates to the # on sprite sheet
background=ones(maxDimensionVertical,maxDimensionHorizontal)*6; 



%fill the foreground matrix with blank cells except 1 which is the wizard
foreground = ones(maxDimensionVertical,maxDimensionHorizontal)*1; %the 1st cell is a blank cell
playerSpriteValue = 5; % the # correlates to sprite sheet -> should be the player sprite

%Player starting sprite (AKA -> spawn :O)
%Read the variable name, you can understand what it is ._.
player_xPosition = 1; player_yPosition = 1;

%Places player at that position
foreground(player_yPosition,player_xPosition)= playerSpriteValue;  



% just the sprite for the exit
% location yCoord then xCoord and equal to the # on sprite sheet
background(end, end) = 7;



%Draw the room
drawScene(room, background, foreground)

framerate = 10; % frames per second
in_door=0;
selectedMode = 1

%will continuously run until person walks through door
while(in_door==0)


    while selectedMode == 1
           
           pressedKey = getKeyboardInput(room)

           switch pressedKey

               case 'rightarrow'
                   if player_xPosition < maxDimensionHorizontal
                    disp ('In right move')
                       
                    foreground (player_yPosition, player_xPosition) = 1;% replaces current player position with transparent sprite
                    player_yPosition = player_yPosition + 1; 
                    foreground(player_yPosition, player_xPosition);
                    
                   end

               case 'leftarrow'
                   if player_xPosition > 1
                    disp ('In left move')
                    foreground(wizard_r,wizard_c)=1;
                    wizard_c=wizard_c-1;
                    foreground(wizard_r,wizard_c)=blue_guy_pos;
                   end

               case 'uparrow'
                   if player_yPosition > 1
                    disp ('in up move')
                    foreground(wizard_r,wizard_c)=1;
                    wizard_r=wizard_r-1;
                    foreground(wizard_r,wizard_c)=blue_guy_pos;
                   end

               case 'downarrow'
                   if player_yPosition < maxDimensionVertical
                    disp ('in down move')
                    foreground(wizard_r,wizard_c)=1;
                    wizard_r=wizard_r+1;
                    foreground(wizard_r,wizard_c)=blue_guy_pos;
                   end 

               case r
                   selectedMode = 0;
              
           end % ends switch 
    end % ends loop


    
end
