close all
clear all
clc
Joystick_arduino= arduino("/dev/cu.usbmodem142301","Uno");

%set values for pins
xPin= 'A0';
yPin= 'A1';
swPin= 'A2';


room = escapeRoomEngine('test.png',10,10,0,0,8,[255,255,255]);
%room size
max_dim=10;
%innitial x/y positions
port_x =1;
port_y =1;
orgP_x =2;
orgP_y =1;
bluP_x =3;
bluP_y =1;
exitx =5;
exity =1;
guy_x=1;
guy_y=1;
%sprite locations
blue_guy_pos=5; 
orgP_pos = 4;
bluP_pos = 3;
port_pos = 2;
%background innitialization
background=ones(max_dim,max_dim)*6;
background(exity, exitx)=7;
%guyground innitializtion
guyground=ones(max_dim,max_dim)*1; 
guyground(guy_x,guy_y)=blue_guy_pos; 
%portground innitializtion
portground =ones(max_dim,max_dim)*1;
portground(port_y, port_x)= 2;
portground(orgP_y,orgP_x)=4;
portground(bluP_y,bluP_x)=3;



%initialize scene
drawScene(room, background, portground,guyground)
%%framerate = 30;
exit=0;
mode = 1; %1==walk,2==portal

disp('game')
%will continuously run until person walks through exit
while(exit==0)
   %key_down = getKeyboardInput(room);  
   xvalue= readVoltage(Joystick_arduino,xPin);%read the values of the voltage
   yvalue= readVoltage(Joystick_arduino,yPin);
   Btnvalue= readVoltage(Joystick_arduino,swPin);
   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(xvalue>3 && guy_y<max_dim)
        guyground(guy_x,guy_y)=1;
        guy_y=guy_y+1;
        guyground(guy_x,guy_y)=blue_guy_pos;
    elseif(xvalue<2 && guy_y>1)
        guyground(guy_x,guy_y)=1;
        guy_y=guy_y-1;
        guyground(guy_x,guy_y)=blue_guy_pos;
    elseif(yvalue<2 && guy_x>1)
        guyground(guy_x,guy_y)=1;
        guy_x=guy_x-1;
        guyground(guy_x,guy_y)=blue_guy_pos;
    elseif(yvalue>3 && guy_x<max_dim)
        guyground(guy_x,guy_y)=1;
        guy_x=guy_x+1;
       guyground(guy_x,guy_y)=blue_guy_pos;
    elseif(Btnvalue==0)
        mode = 0;
    end

      case(0)%portal mode
    if(xvalue>3 && port_y<max_dim)
       portground(port_y,port_x)=1;
        port_x=port_x+1;
        portground(port_y,port_x)=port_pos;
    elseif(xvalue<2 && port_y>1)
       portground(port_y,port_x)=1;
        port_x=port_x-1;
        portground(port_y,port_x)=port_pos;
    elseif(yvalue<2 && port_x>1)
        portground(port_y,port_x)=1;
        port_y = port_y-1;
      portground(port_y,port_x)=port_pos;
    elseif(yvalue>3 && port_x<max_dim)
         portground(port_y,port_x)=1;
        port_y = port_y+1;
       portground(port_y,port_x)=port_pos;
    % elseif(strcmp(key_down,'m')==1)
    %    portground(orgP_y,orgP_x)=1;
    %     orgP_x=port_x;
    %     orgP_y=port_y;
    %      port_x =1;
    %     port_y =1;
    %      portground(orgP_y,orgP_x)=orgP_pos;
    % elseif(strcmp(key_down,'n')==1)
    %    portground(bluP_y,bluP_x)=1;
    %     bluP_x=port_x;
    %     bluP_y=port_y;
    %      port_x =1;
    %     port_y =1;
    %      portground(bluP_y,bluP_x)=bluP_pos;
     elseif(Btnvalue==0)
        mode = 1;   
    end
  end

   %teleport
    if(guy_x==bluP_y && guy_y==bluP_x)% blu -> org
         guyground(guy_x,guy_y)=1;
        guy_x = orgP_y;
       guy_y = orgP_x;
       guyground(guy_x,guy_y)=blue_guy_pos;
      
    elseif(guy_x==orgP_y && guy_y==orgP_x)%org -> blu
         guyground(guy_x,guy_y)=1;
        guy_x = bluP_y;
       guy_y = bluP_x;
       guyground(guy_x,guy_y)=blue_guy_pos;
    end
    pause(0.1)
%exit room
    if(guy_x==1 && guy_y==5) 
        exit = 1; 
        disp('next room'); 
    end
   
    
    
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
     

