close all;
clear;

Joystick_arduino = arduino('COM7','Uno');

%set values for pins
xPin= 'A0';
yPin= 'A1';
swPin= 'A2';
lbnt= 'A3';
rbtn= 'A4';

%initialize sprites
room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,1,[255,255,255]);
%background
max_dim=10;
background=ones(max_dim,max_dim)*2;
%floor
background(10,1)=41
background(10,2)=41
background(10,3)=41
background(10,4)=41
background(10,5)=41
background(10,6)=41
background(10,7)=41
background(10,8)=41
background(10,9)=41
background(10,10)=41
%platforms
background(4, 1)=8*5+1;
background(4, 2)=8*5+1;
background(4, 3)=8*5+1;
background(4, 4)=8*5+1;
background(4, 10)=8*5+1;
%platform shadow
background(5, 1)=8*6+1;
background(5, 2)=8*6+1;
background(5, 3)=8*6+1;
background(5, 4)=8*6+1;
background(5, 10)=8*6+1;
%door
background(2, 1)=8*5+4;
background(3, 1)=8*6+4;
background(2, 2)=8*5+5;
background(3, 2)=8*6+5;
%control panel
background(9,max_dim)=5
%cables
background(8,10)=7
background(7,10)=8
background(6,10)=7
background(5,10)=63

%midground(portals)
portorange_x=1;
portorange_y=5;
portblue_x=2
portblue_y=5
midground=ones(max_dim,max_dim)*1;%fill the midground matrix with blank cells
midground(portblue_y, portblue_x)=25; %initialize bottom corner to an orange portal
midground(portorange_y, portorange_x)=26; %initialize top corner to a blue portal


%foreground
foreground=ones(max_dim,max_dim)*1;%fill the foreground matrix with blank cells
%EVE
wizard_r=9;
wizard_c=1;
EVEright=22;
EVEleft=23;
foreground(wizard_r,wizard_c)=EVEright; %initialize the first cell to the little wizard.
%piston
direction = 1;
piston_r = 7;
foreground(9,6)=8*3+3;%base
foreground(9,7)=8*3+3;
foreground(9,8)=8*3+3;
foreground(8,6)=8*2+3;%piston
foreground(8,7)=8*2+3;
foreground(8,8)=8*2+3;
foreground(piston_r,7)=8+3;
foreground(piston_r,6)=8+4;
foreground(piston_r,8)=8+4;
%lasers
foreground(4, 5)=14;
foreground(4, 6)=15;
foreground(4, 7)=15;
foreground(4, 8)=15;
foreground(4, 9)=16;
%crosshair
crosshair_x=3
crosshair_y=5
foreground(crosshair_y,crosshair_x)=34;

%initialize scene
drawScene(room, background, midground, foreground)

in_door=0;
mode = 1;
%will continuously run until person walks through door

while(in_door==0)
    xvalue= readVoltage(Joystick_arduino,xPin); %read the values of the voltage
    yvalue= readVoltage(Joystick_arduino,yPin);
    Btnvalue= readVoltage(Joystick_arduino,swPin);
    lvolt = readVoltage(Joystick_arduino, lbnt);
    rvolt = readVoltage(Joystick_arduino, rbtn);   
  
    switch mode
    case(1)
        %Moving Character
        if(xvalue>3 && wizard_c<max_dim && foreground(wizard_r,wizard_c+1) ~= 27)%Right
            foreground(wizard_r,wizard_c)=1;
            wizard_c=wizard_c+1;
            foreground(wizard_r,wizard_c)=EVEright;
            
        elseif(xvalue<2 && wizard_c>1 && foreground(wizard_r,wizard_c-1) ~= 27)%Left
            foreground(wizard_r,wizard_c)=1;
            wizard_c=wizard_c-1;
            foreground(wizard_r,wizard_c)=EVEleft;
            
        elseif(yvalue<2 && (wizard_r ==3 || wizard_r==9))%Up
            foreground(wizard_r,wizard_c)=1;
            wizard_r=wizard_r-1;
            foreground(wizard_r,wizard_c)=EVEright;
            drawScene(room, background, midground, foreground);
            pause(0.1);
            
            foreground(wizard_r,wizard_c)=1;
            wizard_r=wizard_r-1;
            foreground(wizard_r,wizard_c)=EVEright;
            drawScene(room, background, midground, foreground);
            pause(0.2);
            
        elseif(yvalue<2 && wizard_r==2 && wizard_c>2)%Up on platform
            foreground(wizard_r,wizard_c)=1;
            wizard_r=wizard_r-1;
            foreground(wizard_r,wizard_c)=EVEright;
            drawScene(room, background, midground, foreground);
            pause(0.1);
            
        %elseif(yvalue>3 && wizard_r<max_dim)%Down
        %    foreground(wizard_r,wizard_c)=1;
        %    wizard_r=5;
        %    foreground(wizard_r,wizard_c)=blue_guy_pos;
            
        elseif(Btnvalue==0) %change mode to portal gun
            mode = 0;
    
        end

    case(0)
    
    %hi ben
        %Moving Portals
        if(xvalue>3 && crosshair_x<max_dim && (foreground(crosshair_y,crosshair_x+1)~=11) && (foreground(crosshair_y,crosshair_x+1)~=19) && (foreground(crosshair_y,crosshair_x+1)~=27))%Portal Right
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_x=crosshair_x+1;
            foreground(crosshair_y,crosshair_x)=34;
            
        elseif(xvalue<2 && crosshair_x>1 && (foreground(crosshair_y,crosshair_x-1)~=11) && (foreground(crosshair_y,crosshair_x-1)~=19) && (foreground(crosshair_y,crosshair_x-1)~=27))%Portal Left
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_x=crosshair_x-1;
            foreground(crosshair_y,crosshair_x)=34;
            
        elseif(yvalue<2 && crosshair_y>1 && crosshair_y>5)%Portal Up
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_y = crosshair_y-1;
            foreground(crosshair_y,crosshair_x)=34;
            
        elseif(yvalue>3 && crosshair_y<max_dim && crosshair_y<9)%Portal Down
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_y = crosshair_y+1;
            foreground(crosshair_y,crosshair_x)=34;

        elseif(lvolt==5)%place blue portal
            midground(portblue_y,portblue_x)=1;
            portblue_y=crosshair_y;
            portblue_x=crosshair_x;
            midground(portblue_y,portblue_x)=25;

        elseif(rvolt==5)%place orange portal
            midground(portorange_y,portorange_x)=1;
            portorange_y=crosshair_y;
            portorange_x=crosshair_x;
            midground(portorange_y,portorange_x)=26;

        elseif(Btnvalue==0)%Change mode to character
            mode = 1;
    
        end
    end
    
    %teleport
    if(wizard_r==portblue_y && wizard_c==portblue_x)
        foreground(wizard_r,wizard_c)=1;
        wizard_r = portorange_y;
        wizard_c = portorange_x;
        foreground(wizard_r,wizard_c)=EVEright;
    end
    
    %test if EVE has reached door
    if(wizard_r==3 && wizard_c==1) 
        in_door = 1; % Set in_door to 1 to indicate the wizard has reached the door
        disp('next room'); % Display a winning message
    end
    
    %Gravity(platform, piston edge, piston center, laser
    if(background(wizard_r+1,wizard_c) ~= 41)
        if(foreground(wizard_r+1,wizard_c) ~= 11)
            if(foreground(wizard_r+1,wizard_c) ~= 12)
                if(foreground(wizard_r+1,wizard_c) ~= 14)
                    if(in_door==0)
                        foreground(wizard_r,wizard_c)=1;
                         wizard_r=wizard_r+1;
                         foreground(wizard_r,wizard_c)=EVEright;
                    end
                end
            end
        end
    end
    
    %piston pushing EVE up
    if((wizard_r+1) == piston_r)
        foreground(wizard_r,wizard_c)=1
        wizard_r=wizard_r-1
        foreground(wizard_r,wizard_c)=EVEright;
    end
    %piston moving
    %1=up
    %2=down
    
    if(piston_r == 8)
        direction=1;
    elseif(piston_r == 5)
        direction = 2;
    end

    if(direction == 1)%up
    foreground(piston_r, 6)=8*2+3;
    foreground(piston_r, 7)=8*2+3;
    foreground(piston_r, 8)=8*2+3;
    piston_r = piston_r-1;
    foreground(piston_r,7)=8+3;
    foreground(piston_r,6)=8+3;
    foreground(piston_r,8)=8+3;

    elseif(direction == 2)%down
    foreground(piston_r, 6)=1;
    foreground(piston_r, 7)=1;
    foreground(piston_r, 8)=1;
    piston_r = piston_r+1;
    foreground(piston_r,7)=8+3;
    foreground(piston_r,6)=8+3;
    foreground(piston_r,8)=8+3;
    end
    %Update the matrix image to the screen. 
    drawScene(room, background, midground, foreground)
    
end