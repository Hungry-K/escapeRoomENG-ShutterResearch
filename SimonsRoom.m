function [] = SimonsRoom(arduino_initilization)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Joystick_arduino= arduino_initilization;
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
room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,8 ,[255,255,255]);
%room size
%innitial x/y positions
port_x =1;%portal curser x pos
port_y =1;%portal curser y pos
orgP_x =2;%orange portal x pos
orgP_y =1;%orange portal y pos
bluP_x =3;%blue portal x pos
bluP_y =1;%blue portal y pos
exitx =10;%level exit x pos
exity =1;%level exit y pos
guy_y=6;%charicter y
guy_x=8;%charicter x
ly=1;
lx=1;   
%sprite locations
eveU=30; %eve up
eveD=31; %eve down
eveL=39;%eve left
eveR=38;%eve right
orgP_pos = 26;%orange portal
bluP_pos = 25;%blue portal
port_pos = 34;%curser portal
tileplace=29;%placable tile
tilena=2;% no place tile
tileext=[32, 40];%exit tile
walls =[4,11,12,41,24];%wall sprits
lazers =[13,14,15,16,24,28,36];%lazer sprits
nalazr=[4,25,26,28,36];
%background innitialization
bcgmx=[ 3, 3, 3, 3, 3, 3, 3, 4, 4, 4;
        63,62,62,62,62,64, 3, 3, 3, 3;
        7, 2, 2,29,29, 3, 3, 3, 3, 3;
        4, 2, 2, 2, 2, 4, 2,29,29,29;
        4, 2, 2, 2, 2, 4, 2, 2, 2, 2;
        4, 2, 2, 2, 2, 4, 2, 2, 2, 2;
        2, 2, 2,29,29, 4, 4, 4, 4, 4;
       63,62,62,62,62,62,62,62,62,64;
        4, 9, 3, 3, 3, 3, 3, 3, 3, 7;
        4,17, 3, 3, 3, 2,29,29, 2, 2;];
max_dim=10;%dimmention of room
background=bcgmx;%set backround as matrix

guymx=[1,1,1,1,1,1,1,1,1,1%guyground innitializtion
    1,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,24,1,1,1,1;
    1,14,1,1,1,1,14,1,1,1;
    1,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,1;
    14,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,24;];

guyground=guymx;
guyground(guy_y,guy_x)=eveR;%put eve on starting quardinate
%portground innitializtion
portground =ones(max_dim,max_dim);%make portground clear

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

%initialize scene
drawScene(room, background, portground,guyground)

level=1;%level is false
mode = 1; %1==walk,0==portal

%will continuously run until person walks through level
while(level==1)
  % key_down = getKeyboardInput(room);
    xvalue= readVoltage(Joystick_arduino,xPin);%read the values of the voltage
   yvalue= readVoltage(Joystick_arduino,yPin);
   Btnvalue= readVoltage(Joystick_arduino,swPin);
   lvolt = readVoltage(Joystick_arduino, lbnt);
   rvolt = readVoltage(Joystick_arduino, rbtn);% get keybord imput and set value
  


   % if (guymx(3,5)==15||guymx(3,5)==28)
   %     guyground(3,6)=16;
   %     guyground(4,2)=13;
   %     guymx(4,2)=13;
   % end
   % if(guymx(10,9)==15)
   %     guyground(10,10)=16;
   %     background(9,2)=32;
   %     background(10,2)=40;
   % end

% if(guymx(1,1)==14)
%     if(portground(1,4)==bluP_pos||portground(1,4)==36)
%         guyground(1, 2:7) = 1;%clear line
%          guyground(1, 2:3) = 15;%crate lazer
%          portground(1, 4) = 36;%creale lazerportal
%          bluP_x =3;%blue portal x pos
%         bluP_y =1;%blue portal y pos
%     elseif(portground(1,5)==bluP_pos||portground(1,5)==36)  
%        guyground(1, 2:7) = 1;%clear line
%         guyground(1, 2:4) = 15;%crate lazer
%        portground(1, 5) = 36;%creale lazerportal
%        bluP_x =3;%blue portal x pos
%         bluP_y =1;%blue portal y pos
%     elseif(portground(1,6)==bluP_pos||portground(1,6)==36)
%         guyground(1, 2:7) = 1;%clear line
%         guyground(1, 2:5) = 15;%crate lazer
%         portground(1, 6) = 36;%creale lazerportal
%         bluP_x =3;%blue portal x pos
%         bluP_y =1;%blue portal y pos
%     else
%        guyground(1, 2:7) = 1;%clear line
%         guyground(1, 2:6) = 15;%creat lazer
%     end   c
% else
%     guyground(1, 2:7) = 1;
% end


    if(portground(4,8)==bluP_pos||portground(4,8)==36||portground(4,8)==orgP_pos)
        guyground(4, 8:10) = 1;%clear line
         portground(4, 8) = 36;%creale lazerportal
         bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
    elseif(portground(4,9)==bluP_pos||portground(4,9)==36||portground(4,9)==orgP_pos)  
       guyground(4, 8:10) = 1;%clear line
        guyground(4, 8) = 15;%crate lazer
       portground(4, 9) = 36;%creale lazerportal
       bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
    elseif(portground(4,10)==bluP_pos||portground(4,10)==36||portground(4,10)==orgP_pos)
        guyground(4, 8:10) = 1;%clear line
        guyground(4, 8:9) = 15;%crate lazer
        portground(4, 10) = 36;%creale lazerportal
        bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
    else
       guyground(4, 8:10) = 1;%clear line
        guyground(4, 8:10) = 15;%creat lazer
    end

    if(guymx(4,2)==14)
         guyground(4, 3:5) = 15;
    else
    guyground(4, 3:5) = 1;
    end

     
    if(portground(7,4)==bluP_pos||portground(7,4)==36||portground(7,4)==orgP_pos)  
       guyground(7, 2:5) = 1;%clear line
        guyground(7, 2:3) = 15;%crate lazer
       portground(7, 4) = 36;%creale lazerportal
       bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
        portground(4, 8:10) = 1;
    elseif(portground(7,5)==bluP_pos||portground(7,5)==36||portground(7,5)==orgP_pos)
        guyground(7, 2:5) = 1;%clear line
        guyground(7, 2:4) = 15;%crate lazer
        portground(7, 5) = 36;%creale lazerportal
        bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
        portground(4, 8:10) = 1;
    else
       guyground(7, 2:5) = 1;%clear line
        guyground(7, 2:5) = 15;%creat lazer
    end
 
    if(portground(3,4)==orgP_pos||portground(3,4)==28||portground(3,4)==bluP_pos)  
       guyground(3, 2:5) = 1;%clear line
        guyground(3, 5) = 15;%crate lazer
       portground(3, 4) = 28;%creale lazerportal
       bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
         guyground(3,6)=16;
       guyground(4,2)=13;
       guymx(4,2)=13;
    elseif(portground(3,5)==bluP_pos||portground(3,5)==28|| portground(3,5)==orgP_pos)
        guyground(3, 2:5) = 1;%clear line
        portground(3, 5) = 28;%creale lazerportal
        bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
        guyground(3,6)=16;
       guyground(4,2)=13;
       guymx(4,2)=13;
    else
       guyground(3, 4:5) = 1;%clear line
        guyground(3,6)=24;
       guyground(4,2)=14;
       guymx(4,2)=14;
       
    end
    if(portground(10,7)==orgP_pos||portground(10,7)==28||portground(10,7)==bluP_pos)  
       guyground(10, 9) = 1;%clear line
        guyground(10, 8:9) = 15;%crate lazer
       portground(10, 7) = 28;%creale lazerportal
       bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
         guyground(10,10)=16;
          background(9,2)=32;
       background(10,2)=40;
       portground(3, 2:5) = 1;%clear line
    elseif(portground(10,8)==bluP_pos||portground(10,8)==28|| portground(10,8)==orgP_pos)
        guyground(10, 9) = 1;%clear line
        guyground(10, 9) = 15;%crate lazer
        portground(10, 8) = 28;%creale lazerportal
        bluP_x =3;%blue portal x pos
        bluP_y =1;%blue portal y pos
        guyground(10,10)=16;
         background(9,2)=32;
       background(10,2)=40;
       portground(3, 2:5) = 1;%clear line
    else
       guyground(10, 6:9) = 1;%clear line
        guyground(10,10)=24;
      
       
    end


   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(xvalue>3 && guy_x<max_dim && ~(ismember(bcgmx(guy_y,guy_x+1), walls))&& ~(ismember(guyground(guy_y,guy_x+1), lazers)))%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x+1; %move eve
        guyground(guy_y,guy_x)=eveR; %uptate eve
    elseif(xvalue<2==1 && guy_x>1 && ~(ismember(bcgmx(guy_y,guy_x-1), walls)) && ~(ismember(guyground(guy_y,guy_x-1), lazers)))%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x-1;%move eve
        guyground(guy_y,guy_x)=eveL;%uptate eve
    elseif(yvalue<2 && guy_y>1 && ~(ismember(bcgmx(guy_y-1,guy_x), walls)) && ~(ismember(guyground(guy_y-1,guy_x), lazers)))%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_y=guy_y-1;%move eve
        guyground(guy_y,guy_x)=eveU;%uptate eve
    elseif(yvalue>3&& guy_y<max_dim && ~(ismember(bcgmx(guy_y+1,guy_x),walls)) && ~(ismember(guyground(guy_y+1,guy_x), lazers)))%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_y=guy_y+1;%move eve
       guyground(guy_y,guy_x)=eveD;%uptate eve
    elseif(Btnvalue==0)%swich mode conditionals
        mode = 0;%swich mode
        portground(port_y,port_x)=1;%swich 
        port_x = guy_x;%open curser at eve position
        port_y = guy_y;%open curser at eve position
        portground(port_y,port_x)=port_pos;%update portal
    end

      case(0)%portal mode
    if(xvalue>3 && port_x<max_dim && ~(ismember(bcgmx(port_y, port_x+1), walls)) && port_y==guy_y)%portal conditionals
       portground(port_y,port_x)=1;%set past clear
        port_x=port_x+1;%move portal
        portground(port_y,port_x)=port_pos;%updtae portal
    elseif(xvalue<2==1 && port_x>1 && ~(ismember(bcgmx(port_y, port_x-1), walls)) && port_y==guy_y)%portal conditionals
       portground(port_y,port_x)=1;%set past clear
        port_x=port_x-1;%move portal
        portground(port_y,port_x)=port_pos;%updtae portal
    elseif(yvalue<2 && port_y>1 && ~(ismember(bcgmx(port_y-1, port_x), walls))  && port_x==guy_x)%portal conditionals
        portground(port_y,port_x)=1;%set past clear
        port_y = port_y-1;%move portal
      portground(port_y,port_x)=port_pos;%updtae portal
    elseif(yvalue>3 && port_y<max_dim && ~(ismember(bcgmx(port_y+1, port_x), walls))  && port_x==guy_x)%portal conditionals
         portground(port_y,port_x)=1;%set past clear
        port_y = port_y+1;%move portal
       portground(port_y,port_x)=port_pos;%updtae portal
    elseif(lvolt==5 && bcgmx(port_y,port_x)==tileplace)%orange portal conditionals
       portground(orgP_y,orgP_x)=1;%clear portal curser
        orgP_x=port_x;  %set org port pos
        orgP_y=port_y; %set org port pos
        port_x = guy_x;%set port curs to guy
        port_y = guy_y;%set port curs to guy
        portground(orgP_y,orgP_x)=orgP_pos;%update org port
        portground(port_y,port_x)=port_pos;%update portcurser
        setColor(Joystick_arduino, pinR, pinG, pinB, 200, 20, 0);    % orange light
    elseif(lvolt==5 || rvolt==5 && bcgmx(port_y,port_x)==tileplace)%blue portal conditionals
       portground(bluP_y,bluP_x)=1;%clear portal curser
        bluP_x=port_x; %set blue port pos
        bluP_y=port_y;%set blue port pos
        port_x = guy_x;%set port curs to guy
        port_y = guy_y;%set port curs to guy
        portground(bluP_y,bluP_x)=bluP_pos;%update blu port
        portground(port_y,port_x)=port_pos;%update portcurser
        setColor(Joystick_arduino, pinR, pinG, pinB, 0, 0, 200); %blue light
     elseif(Btnvalue==0)%swich mode conditionals
       mode = 1;   %swich mode
       portground(port_y,port_x)=1;%hide portal curser
       port_x = 1;%move portal curser
       port_y = 1;%move portal curser
    end
  end
   %teleport
    % if(guy_y==bluP_y && guy_x==bluP_x)% blu -> org
    %      guyground(guy_y,guy_x)=1;%set past clear
    %     guy_y = orgP_y;%move eve
    %    guy_x = orgP_x;%move eve
    %    guyground(guy_y,guy_x)=eveR;%update eve  
    % elseif(guy_y==orgP_y && guy_x==orgP_x)%org -> blu
    %      guyground(guy_y,guy_x)=1;%set past clear
    %     guy_y = bluP_y;%move eve
    %    guy_x = bluP_x;%move eve
    %    guyground(guy_y,guy_x)=eveL;%update eve
    % end
    %lazers

%level room
    if(guy_x==2&&guyground(10,10)==16)%next room condirional
        level = 2; %set level value
        disp('next room'); %display next room
    end
   
    
    
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
end