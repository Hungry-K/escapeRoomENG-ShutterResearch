close all
clc

room = escapeRoomEngine('test.png',10,10,0,0,8,[255,255,255]);
%room size
max_dim=9;
%innitial x/y positions
port_x =1;
port_y =1;
orgP_x =2;
orgP_y =1;
bluP_x =3;
bluP_y =1;
exitx =8;
exity =8;
guy_y=3;
guy_x=2;
%sprite locations
blue_guy_pos=5; 
orgP_pos = 4;
bluP_pos = 3;
port_pos = 2;
tileplace=6;
tilena=8;
tileext=7;
%background innitialization
bcgmx=[ 1, 1, 1,20,18,18,18,18,12;
       20,18,18, 6, 6, 6, 6, 6,16;
       24, 6, 6, 6, 6, 6, 6, 6,16;
       24, 6, 6, 9,10,11, 6, 6,16;
       24, 6, 6,13,14,15, 6, 6,16;
       24, 6, 6,17,18,19, 6, 6,16;
       24, 6, 6, 6, 6, 6, 6, 6,16;
       24, 6, 6, 6, 6, 6, 6, 6,16;
       17,18,18,18,18,18,18,18,18; ];
background=bcgmx;
background(exitx,exity)=7;
walls =[9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
%guyground innitializtion
guyground=ones(max_dim,max_dim); 
guyground(guy_y,guy_x)=blue_guy_pos; 
%portground innitializtion
portground =ones(max_dim,max_dim)*1;
portground(port_y, port_x)= port_pos;
portground(orgP_y,orgP_x)=orgP_pos;
portground(bluP_y,bluP_x)=bluP_pos;



%initialize scene
drawScene(room, background, portground,guyground)
%%framerate = 30;
exit=0;
mode = 1; %1==walk,2==portal

%will continuously run until person walks through exit
while(exit==0)
   key_down = getKeyboardInput(room);
   
   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(strcmp(key_down,'rightarrow')==1 && guy_x<max_dim && ~(ismember(bcgmx(guy_y,guy_x+1), walls)))
        guyground(guy_y,guy_x)=1;
        guy_x=guy_x+1;
        guyground(guy_y,guy_x)=blue_guy_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && guy_x>1&& ~(ismember(bcgmx(guy_y,guy_x-1), walls)))
        guyground(guy_y,guy_x)=1;
        guy_x=guy_x-1;
        guyground(guy_y,guy_x)=blue_guy_pos;
    elseif(strcmp(key_down,'uparrow')==1 && guy_y>1 && ~(ismember(bcgmx(guy_y-1,guy_x), walls)))
        guyground(guy_y,guy_x)=1;
        guy_y=guy_y-1;
        guyground(guy_y,guy_x)=blue_guy_pos;
    elseif(strcmp(key_down,'downarrow')==1 && guy_y<max_dim && ~(ismember(bcgmx(guy_y+1,guy_x), walls)))
        guyground(guy_y,guy_x)=1;
        guy_y=guy_y+1;
       guyground(guy_y,guy_x)=blue_guy_pos;
    elseif(strcmp(key_down,'r')==1)
        mode = 0;
        portground(port_y,port_x)=1;
        port_x = guy_x;
        port_y = guy_y;
        portground(port_y,port_x)=port_pos;
    end

      case(0)%portal mode
    if(strcmp(key_down,'rightarrow')==1 && port_x<max_dim && ~(ismember(bcgmx(port_x+1, port_y), walls)))
       portground(port_y,port_x)=1;
        port_x=port_x+1;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && port_x>1 && ~(ismember(bcgmx(port_x-1, port_y), walls)))
       portground(port_y,port_x)=1;
        port_x=port_x-1;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'uparrow')==1 && port_y>1 && ~(ismember(bcgmx(port_x, port_y-1), walls)))
        portground(port_y,port_x)=1;
        port_y = port_y-1;
      portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'downarrow')==1 && port_y<max_dim && ~(ismember(bcgmx(port_x, port_y+1), walls)))
         portground(port_y,port_x)=1;
        port_y = port_y+1;
       portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'m')==1 && bcgmx(port_y,port_x)==6)
       portground(orgP_y,orgP_x)=1;
        orgP_x=port_x;
        orgP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(orgP_y,orgP_x)=orgP_pos;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'n')==1 && bcgmx(port_y,port_x)==6)
       portground(bluP_y,bluP_x)=1;
        bluP_x=port_x;
        bluP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(bluP_y,bluP_x)=bluP_pos;
        portground(port_y,port_x)=port_pos;
     elseif(strcmp(key_down,'r')==1)
       mode = 1;   
       portground(port_y,port_x)=1;
       port_x = 1;
       port_y = 1;
       portground(port_y,port_x)=port_pos;
    end
  end


   %teleport
    if(guy_y==bluP_y && guy_x==bluP_x)% blu -> org
         guyground(guy_y,guy_x)=1;
        guy_y = orgP_y;
       guy_x = orgP_x;
       guyground(guy_y,guy_x)=blue_guy_pos;
    elseif(guy_y==orgP_y && guy_x==orgP_x)%org -> blu
         guyground(guy_y,guy_x)=1;
        guy_y = bluP_y;
       guy_x = bluP_x;
       guyground(guy_y,guy_x)=blue_guy_pos;
    end
%exit room
    if(guy_y==exitx && guy_x==exity) 
        exit = 1; 
        disp('next room'); 
    end
   
    
    
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
     

