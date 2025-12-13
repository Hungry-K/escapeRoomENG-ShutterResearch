function [] = SilemsRoom(arduino_initilization)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
Joystick_arduino= arduino_initilization;%initialize arduino

xPin= 'A0'; %pin for joystick
yPin= 'A1'; %pin for joystick
swPin= 'A2'; %pin for joystick
lbnt= 'A3'; %pin for left button
rbtn= 'A4'; %pin for right button
pinR = 'D6'; %pin for RGB
pinG = 'D5'; %pin for RGB
pinB = 'D3'; %pin for RGB

% Optional: configure pins for PWM (clarifies intent)
configurePin(Joystick_arduino, pinR, 'PWM');
configurePin(Joystick_arduino, pinG, 'PWM');
configurePin(Joystick_arduino, pinB, 'PWM');


background = [2 2 2 7 2 2 10
    44, 45, 2, 8, 44, 45 18
    52, 53, 2 2 52 53 2]

guyground = [1 1 1 1 1 1 1
    1 1 1 1 1 1 1
    1 1 1 1 1 1 1]

portground = [1 1 1 1 1 1 1
    1 1 1 1 1 1 1
    1 1 1 1 1 1 1]


% - - - - - - - - - - -





room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,8 ,[255,255,255]);
%room size
%innitial x/y positions
port_x =1;%portal curser
port_y =1;
orgP_x =2;%orange portal
orgP_y =1;
bluP_x =3;%blue portal
bluP_y =1;
exitx =12;%level
exity =10;
guy_y=3;%charicter
guy_x=1;
%sprite locations

eveD=31;
eveL=21;
eveR=20;
orgP_pos = 26;
bluP_pos = 25;
port_pos = 34;
tileplace=29;
tilena=2;
tileext=[32, 40,46,54];
walls =[4,11,12,41,52];%wall sprits
door=0;
%background innitialization

guyground(3,1)=eveR; %put eve on starting quardinate
%portground innitializtion
max_ydim = 3;
max_xdim = 7;




%initialize scene
drawScene(room, background, portground,guyground)

level=1;%level is false
mode = 1; %1==walk,0==portal
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
%will continuously run until person walks through level
while(level==1)

    if readDigitalPin(Joystick_arduino, "D10") == 1
       disp ('too high ')
       setColor(Joystick_arduino, pinR, pinG, pinB, 200, 0, 0);%red light

       % Matrix below changes room to open (door open)
        background = [2 2 2 7 2 2 10
    44, 45, 2, 8, 44, 45 18
    52, 53, 2 2 52 53 2];
        
    else
        disp ('worked')

        % Matrix below returns the room to it's orignal look (door closed)

       setColor(Joystick_arduino, pinR, pinG, pinB, 0, 0, 0);%turns off red light
       background = [2 2 2 7 2 2 48
    44, 45, 2, 8, 46, 45 56
    52, 53, 2 2 54 53 2];

    if(ismember(background(guy_y,guy_x), tileext))
        level = 2; 
        disp('next room'); 
    end

    end
    
   xvalue= readVoltage(Joystick_arduino,xPin);%read the values of the voltage for joystick
   yvalue= readVoltage(Joystick_arduino,yPin);
   Btnvalue= readVoltage(Joystick_arduino,swPin);
   lvolt = readVoltage(Joystick_arduino, lbnt);% read values of the voltage for the buttons
   rvolt = readVoltage(Joystick_arduino, rbtn);
   % make it to where eve falls when not on a solid surface


   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(xvalue>3 && guy_x<max_xdim && ~(ismember(background(guy_y,guy_x+1), walls)) && background(guy_y,guy_x+1)~=42 && background(guy_y,guy_x+1)~=43 && background(guy_y,guy_x+1)~=52)
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x+1; %move eve
        guyground(guy_y,guy_x)=eveR; 
    elseif(xvalue<2 && guy_x>1 && ~(ismember(background(guy_y,guy_x-1), walls)) && background(guy_y,guy_x-1)~=42 && background(guy_y,guy_x-1)~=43)
        guyground(guy_y,guy_x)=1;
        guy_x=guy_x-1;
        guyground(guy_y,guy_x)=eveL;
    elseif(Btnvalue==0 && eveL==23)
        mode = 0;
        portground(port_y,port_x)=1;
        port_x = guy_x;
        port_y = guy_y;
        portground(port_y,port_x)=port_pos;
    end

      case(0)%portal mode
    if(xvalue>3 && port_x<max_xdim && ~(ismember(background(port_y, port_x+1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x+1;
        portground(port_y,port_x)=port_pos;
    elseif(xvalue<2 && port_x>1 && ~(ismember(background(port_y, port_x-1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x-1;
        portground(port_y,port_x)=port_pos;
    elseif(yvalue<2 && port_y>1 && ~(ismember(background(port_y-1, port_x), walls))  && port_x==guy_x)
        portground(port_y,port_x)=1;
        port_y = port_y-1;
      portground(port_y,port_x)=port_pos;
    elseif(yvalue>3 && port_y<max_ydim && ~(ismember(background(port_y+1, port_x), walls))  && port_x==guy_x)
         portground(port_y,port_x)=1;
        port_y = port_y+1;
       portground(port_y,port_x)=port_pos;
    elseif(lvolt==5 && background(port_y,port_x)==tileplace)
       portground(orgP_y,orgP_x)=1;
        orgP_x=port_x;  
        orgP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(orgP_y,orgP_x)=orgP_pos;
        portground(port_y,port_x)=port_pos;
        setColor(Joystick_arduino, pinR, pinG, pinB, 200, 20, 0);    % orange light

    elseif(rvolt==5 && background(port_y,port_x)==tileplace)
       portground(bluP_y,bluP_x)=1;
        bluP_x=port_x;
        bluP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(bluP_y,bluP_x)=bluP_pos;
        portground(port_y,port_x)=port_pos;
        setColor(Joystick_arduino, pinR, pinG, pinB, 0, 0, 200);    % Blue light
     elseif(Btnvalue==0)
       mode = 1;   
       portground(port_y,port_x)=1;
       port_x = 1;
       port_y = 1;
    end
  end

   
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end


end