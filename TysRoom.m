function [] = TysRoom(arduino_initilization)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Joystick_arduino = arduino_initilization;
%set values for pins
xPin= 'A0';
yPin= 'A1';
swPin= 'A2';
lbnt= 'A3';
rbtn= 'A4';
pinR = 'D6'; %pin for RGB
pinG = 'D5'; %pin for RGB
pinB = 'D3'; %pin for RGB

% Optional: configure pins for PWM (clarifies intent)
configurePin(Joystick_arduino, pinR, 'PWM');
configurePin(Joystick_arduino, pinG, 'PWM');
configurePin(Joystick_arduino, pinB, 'PWM');

%initialize sprites
room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,3,[255,255,255]);
%background
max_dim=10;
background=ones(max_dim,max_dim)*2;
%fun details
background(9,2)=60;%desk
background(2,9)=61;%poster
background(6,3)=58;%fan
background(1,4)=57;%vent
background(1,5)=59;%window
background(1,6)=59;
background(1,7)=57;%vent
%floor
background(10,1)=4;
background(10,2)=4;
background(10,3)=4;
background(10,4)=4;
background(10,5)=4;
background(10,6)=6;
background(10,7)=6;
background(10,8)=6;
background(10,9)=4;
background(10,10)=4;
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
background(5, 9)=8*6+1;
background(5, 10)=8*6+1;
%door
background(2, 1)=8*5+4;
background(3, 1)=8*6+4;
background(2, 2)=8*5+5;
background(3, 2)=8*6+5;
%control panel
background(9,10)=5;
%cables
background(8,10)=7;
background(7,10)=8;
background(6,10)=7;
background(5,10)=7;
%piston cables
background(9,6)=63;
background(9,7)=62;
background(9,8)=64;
%midground
%portals
portorange_x=1;
portorange_y=9;
portblue_x=1;
portblue_y=8;
midground=ones(max_dim,max_dim)*1;%fill the midground matrix with blank cells
midground(portblue_y, portblue_x)=25; %blue portal
midground(portorange_y, portorange_x)=26; %orange portal
%laser
midground(4, 5)=14;
midground(4, 6)=15;
midground(4, 7)=15;
midground(4, 8)=15;
midground(4, 9)=16;
%foreground
foreground=ones(max_dim,max_dim)*1;%fill the foreground matrix with blank cells
%EVE
wizard_r=9;
wizard_c=3;
EVEright=22;
EVEleft=23;
foreground(wizard_r,wizard_c)=EVEright;
%crosshair
crosshair_x=1;
crosshair_y=7;
foreground(crosshair_y,crosshair_x)=34;
%piston
direction = 1;
piston_r = 8;
%pistons
foreground(9,6)=8*2+3;
foreground(9,7)=8*2+3;
foreground(9,8)=8*2+3;
%piston top
foreground(piston_r,7)=8+3;
foreground(piston_r,6)=8+3;
foreground(piston_r,8)=8+3;
%floor-like values
floor = [4,11,12,13,14,16,24,41];
%initialize scene
drawScene(room, background, midground, foreground)
%set up a few variables
in_door=0;
mode = 1;
tpcheck = 1;
%will continuously run until person walks through door
function setColor(a, pinR, pinG, pinB, r, g, b, commonAnode)
    if nargin < 8
        commonAnode = false;
    end
    rgb = double([r g b]);
    rgb = max(min(rgb,255),0);    % clamp
    duty = rgb / 255;             % scale to 0..1
    if commonAnode
        duty = 1 - duty;
    end
    writePWMDutyCycle(a, pinR, duty(1));
    writePWMDutyCycle(a, pinG, duty(2));
    writePWMDutyCycle(a, pinB, duty(3));
end
while(in_door==0)
    xvalue= readVoltage(Joystick_arduino,xPin); %read the values of the voltage
    yvalue= readVoltage(Joystick_arduino,yPin);
    Btnvalue= readVoltage(Joystick_arduino,swPin);
    lvolt = readVoltage(Joystick_arduino, lbnt);
    rvolt = readVoltage(Joystick_arduino, rbtn);   
    %Moving Character
    switch mode
    case(1)
        %Right
        if(xvalue>3 && wizard_c<max_dim && foreground(wizard_r,wizard_c+1) ~= 19 && foreground(wizard_r,wizard_c+1) ~= 20)
            if(wizard_r~=7 || wizard_c~=6)
            foreground(wizard_r,wizard_c)=1;
            wizard_c=wizard_c+1;
            foreground(wizard_r,wizard_c)=EVEright;
            end
        %Left
        elseif(xvalue<2 && wizard_c>1 && foreground(wizard_r,wizard_c-1) ~= 19  && foreground(wizard_r,wizard_c-1) ~= 20)
            if(wizard_r~=7 || wizard_c~=8)
            foreground(wizard_r,wizard_c)=1;
            wizard_c=wizard_c-1;
            foreground(wizard_r,wizard_c)=EVEleft;
            end
        %Up
        elseif(yvalue<2 && (background(wizard_r+1,wizard_c)==4 || background(wizard_r+1,wizard_c)==41))
            foreground(wizard_r,wizard_c)=1;
            wizard_r=wizard_r-1;
            foreground(wizard_r,wizard_c)=EVEright;
            drawScene(room, background, midground, foreground);
            pause(0.1);
            %up 2nd row
            foreground(wizard_r,wizard_c)=1;
            wizard_r=wizard_r-1;
            foreground(wizard_r,wizard_c)=EVEright;
            drawScene(room, background, midground, foreground);
            pause(0.2);
        %turning off lasers
        elseif(yvalue>3 && wizard_r==9 && wizard_c==max_dim)
            midground(4,5)=13;
            midground(4,6)=1;
            midground(4,7)=1;
            midground(4,8)=1;
            midground(4,9)=24;
        %change mode to portal gun
        elseif(Btnvalue==0)
            mode = 0;
        end
    case(0)
        %hi ben
        %Moving Crosshair
        %Crosshair Right
        if(xvalue>3 && crosshair_x<max_dim && (foreground(crosshair_y,crosshair_x+1)~=11) && (foreground(crosshair_y,crosshair_x+1)~=19))
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_x=crosshair_x+1;
            foreground(crosshair_y,crosshair_x)=34;
        %Crosshair Left
        elseif(xvalue<2 && crosshair_x>1 && (foreground(crosshair_y,crosshair_x-1)~=11) && (foreground(crosshair_y,crosshair_x-1)~=19))
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_x=crosshair_x-1;
            foreground(crosshair_y,crosshair_x)=34;
        %Crosshair Up
        elseif(yvalue<2 && crosshair_y>1 && crosshair_y>5)
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_y = crosshair_y-1;
            foreground(crosshair_y,crosshair_x)=34;
        %Crosshair Down
        elseif(yvalue>3 && crosshair_y<max_dim && crosshair_y<9)
            foreground(crosshair_y,crosshair_x)=1;
            crosshair_y = crosshair_y+1;
            foreground(crosshair_y,crosshair_x)=34;
        %place blue portal
        elseif(lvolt==5)
            midground(portblue_y,portblue_x)=1;
            portblue_y=crosshair_y;
            portblue_x=crosshair_x;
            midground(portblue_y,portblue_x)=25;
             setColor(Joystick_arduino, pinR, pinG, pinB, 0, 0, 200);%blue light
        %place orange portal
        elseif(rvolt==5)
            midground(portorange_y,portorange_x)=1;
            portorange_y=crosshair_y;
            portorange_x=crosshair_x;
            midground(portorange_y,portorange_x)=26;
            setColor(Joystick_arduino, pinR, pinG, pinB, 200, 20, 0);    % orange light
        %Change mode to character
        elseif(Btnvalue==0)
            mode = 1;
        end
    end
    %teleport EVE from orange to blue
    if(wizard_r==portorange_y && wizard_c==portorange_x && tpcheck==1)
        if(foreground(portblue_y,portblue_x)~=19)%no if portal is behind piston
            if(foreground(portblue_y,portblue_x)~=11)
                foreground(wizard_r,wizard_c)=1;
                wizard_r = portblue_y;
                wizard_c = portblue_x;
                foreground(wizard_r,wizard_c)=EVEright;
                tpcheck=0;
            end
        end
    end
    %teleport EVE from blue to orange
    if(wizard_r==portblue_y && wizard_c==portblue_x && tpcheck==1)
        if(foreground(portorange_y,portorange_x)~=19)%no if portal is behind piston
            if(foreground(portorange_y,portorange_x)~=11)
                foreground(wizard_r,wizard_c)=1;
                wizard_r = portorange_y;
                wizard_c = portorange_x;
                foreground(wizard_r,wizard_c)=EVEright;
                tpcheck=0;
            end
        end
    end
    %test if EVE has reached door
    if((wizard_r==3 || wizard_r==2) && (wizard_c==1 || wizard_c==2)) 
        in_door = 1; % Set in_door to 1 to indicate the wizard has reached the door
        disp('next room'); % Display a winning message
    end
    %Gravity
    if(wizard_r+1 ~= 10)%floor
        if(foreground(wizard_r+1,wizard_c) ~= 11)%piston
            if(midground(wizard_r+1,wizard_c) ~= 13)%laser off
                if(midground(wizard_r+1,wizard_c) ~= 14)%laser on
                    if(midground(wizard_r+1,wizard_c) ~= 16)%detector
                        if(midground(wizard_r+1,wizard_c) ~= 24)%detector off
                            if(background(wizard_r+1,wizard_c) ~= 41)%platform
                                if(in_door==0)
                                    foreground(wizard_r,wizard_c)=1;
                                    wizard_r=wizard_r+1;
                                    foreground(wizard_r,wizard_c)=EVEright;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    %piston pushes crosshair out of the way
    if(crosshair_y>piston_r && (crosshair_x==6 || crosshair_x==7 || crosshair_x==8))
        foreground(crosshair_y,crosshair_x)=1;
        crosshair_x=5;
        foreground(crosshair_y,crosshair_x)=34;
    end
    %piston pushes EVE up
    if((wizard_r+1==piston_r || wizard_r==piston_r) && (wizard_c==6 || wizard_c==7 || wizard_c==8))
        foreground(wizard_r,wizard_c)=1;
        wizard_r=piston_r-2;
        foreground(wizard_r,wizard_c)=EVEright;
    end
    %piston moving
    %1=up
    %2=down
    if(piston_r == 9)
        direction=1;
    elseif(piston_r == 4)
        direction = 2;
    end
    %up
    if(direction == 1)
    foreground(piston_r, 6)=8*2+3;
    foreground(piston_r, 7)=8*2+3;
    foreground(piston_r, 8)=8*2+3;
    piston_r = piston_r-1;
    foreground(piston_r,7)=8+3;
    foreground(piston_r,6)=8+3;
    foreground(piston_r,8)=8+3;
    %down
    elseif(direction == 2)
    foreground(piston_r, 6)=1;
    foreground(piston_r, 7)=1;
    foreground(piston_r, 8)=1;
    piston_r = piston_r+1;
    foreground(piston_r,7)=8+3;
    foreground(piston_r,6)=8+3;
    foreground(piston_r,8)=8+3;
    end
    %laser gently undoing EVE
    if(midground(wizard_r,wizard_c)==15)
        background(3,7)=29;
        background(4,6)=29;
        background(4,7)=29;
        background(4,8)=29;
        background(5,7)=29;
        drawScene(room, background, midground, foreground)
        pause(0.4)
        foreground(wizard_r,wizard_c)=1;
        background(3,7)=2;
        background(4,6)=2;
        background(4,7)=2;
        background(4,8)=2;
        background(5,7)=2;
        wizard_c = 3;
        wizard_r = 9;
        foreground(wizard_r,wizard_c)=EVEright;
    end
    %tpcheck
    if(midground(wizard_r,wizard_c)~=25 && midground(wizard_r,wizard_c)~=26)
        tpcheck = 1;
    end
    %Update the matrix image to the screen. 
    drawScene(room, background, midground, foreground)
end
end