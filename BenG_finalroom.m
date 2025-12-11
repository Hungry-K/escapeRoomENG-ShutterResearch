close all
clear all
clc
Joystick_arduino= arduino("/dev/cu.usbmodem144301","Uno");%initialize arduino

%set values for pins
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

room = escapeRoomEngine('PortalSprites-265x265(8).png',32,32,1,1,8 ,[255,255,255]);
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
guy_y=11;%charicter
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
if door==0
bcgmx=[ 57, 2, 2, 2, 2, 2, 41, 2, 44, 45, 2, 2;
        2, 2, 2, 2, 2, 2, 41, 2, 52, 53, 2, 2;
        2, 2, 2, 59, 2, 2, 41, 41, 41, 41, 41, 41;
        2, 2, 2, 2, 2, 2, 49, 49, 49, 49, 46, 47;
        29, 29, 2, 2, 2, 2, 2, 2, 2, 2, 54, 55;
        42, 43, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41;
        50, 51, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49;
        2, 2, 29, 2, 2, 61, 2, 2, 2, 29, 29, 2;
        41, 41, 41, 42, 2, 2, 43, 41, 41, 42, 43, 41;
        49, 49, 49, 50, 2, 2, 51, 49, 49, 50, 51, 49;
        29, 2, 60, 2, 2, 2, 2, 2, 2, 2, 2, 58;
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4;];
else
end
max_dim=12;%dimmention of room
background=bcgmx;%set backround as matrix
%guyground innitializtion
guyground=[1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,33;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;
           1,1,1,1,1,1,35,1,1,1,1,1;
           1,1,1,1,1,1,1,1,1,1,1,1;]; %make guyground clear
guyground(guy_y,guy_x)=eveR; %put eve on starting quardinate
%portground innitializtion
portground =ones(max_dim,max_dim);%make portground clear




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
   xvalue= readVoltage(Joystick_arduino,xPin);%read the values of the voltage for joystick
   yvalue= readVoltage(Joystick_arduino,yPin);
   Btnvalue= readVoltage(Joystick_arduino,swPin);
   lvolt = readVoltage(Joystick_arduino, lbnt);% read values of the voltage for the buttons
   rvolt = readVoltage(Joystick_arduino, rbtn);
   % make it to where eve falls when not on a solid surface
 if (background(guy_y+1,guy_x)~=42)
     if (background(guy_y+1,guy_x)~=walls)
         if (background(guy_y+1,guy_x)~=43) 
        guyground(guy_y,guy_x)=1;
        guy_y=guy_y+1;
       guyground(guy_y,guy_x)=eveD;
         end
     end
 end

% change eve sprite when she picks up gun
 if guy_x==7
     eveL=23;
     eveR=22;
 end
   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(xvalue>3 && guy_x<max_dim && ~(ismember(bcgmx(guy_y,guy_x+1), walls)) && background(guy_y,guy_x+1)~=42 && background(guy_y,guy_x+1)~=43 && background(guy_y,guy_x+1)~=52)
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x+1; %move eve
        guyground(guy_y,guy_x)=eveR; 
    elseif(xvalue<2 && guy_x>1 && ~(ismember(bcgmx(guy_y,guy_x-1), walls)) && background(guy_y,guy_x-1)~=42 && background(guy_y,guy_x-1)~=43)
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
    if(xvalue>3 && port_x<max_dim && ~(ismember(bcgmx(port_y, port_x+1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x+1;
        portground(port_y,port_x)=port_pos;
    elseif(xvalue<2 && port_x>1 && ~(ismember(bcgmx(port_y, port_x-1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x-1;
        portground(port_y,port_x)=port_pos;
    elseif(yvalue<2 && port_y>1 && ~(ismember(bcgmx(port_y-1, port_x), walls))  && port_x==guy_x)
        portground(port_y,port_x)=1;
        port_y = port_y-1;
      portground(port_y,port_x)=port_pos;
    elseif(yvalue>3 && port_y<max_dim && ~(ismember(bcgmx(port_y+1, port_x), walls))  && port_x==guy_x)
         portground(port_y,port_x)=1;
        port_y = port_y+1;
       portground(port_y,port_x)=port_pos;
    elseif(lvolt==5 && bcgmx(port_y,port_x)==tileplace)
       portground(orgP_y,orgP_x)=1;
        orgP_x=port_x;  
        orgP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(orgP_y,orgP_x)=orgP_pos;
        portground(port_y,port_x)=port_pos;
        setColor(Joystick_arduino, pinR, pinG, pinB, 200, 20, 0);    % orange light
       

    elseif(rvolt==5 && bcgmx(port_y,port_x)==tileplace)
       portground(bluP_y,bluP_x)=1;
        bluP_x=port_x;
        bluP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(bluP_y,bluP_x)=bluP_pos;
        portground(port_y,port_x)=port_pos;
        setColor(Joystick_arduino, pinR, pinG, pinB, 0, 0, 200);
       
     elseif(Btnvalue==0)
       mode = 1;   
       portground(port_y,port_x)=1;
       port_x = 1;
       port_y = 1;
    end
  end
   %teleport
    if(guy_y==bluP_y && guy_x==bluP_x)% blu -> org
         guyground(guy_y,guy_x)=1;
        guy_y = orgP_y;
       guy_x = orgP_x;
       guyground(guy_y,guy_x)=eveR;
       pause(0.5)
    elseif(guy_y==orgP_y && guy_x==orgP_x)%org -> blu
         guyground(guy_y,guy_x)=1;
        guy_y = bluP_y;
       guy_x = bluP_x;
       guyground(guy_y,guy_x)=eveL;
       pause(0.5)
    end
    
%level room
    if(ismember(bcgmx(guy_y,guy_x), tileext))
        level = 2; 
        disp('next room'); 
    end
   
   
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
 % flash lights green    
