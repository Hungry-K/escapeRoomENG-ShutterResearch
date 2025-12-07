close all
clc

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
guy_x=2;
%sprite locations
eveU=30; 
eveD=31;
eveL=39;
eveR=38;
orgP_pos = 26;
bluP_pos = 25;
port_pos = 34;
tileplace=29;
tilena=2;
tileext=[32, 40,48,56];
walls =[4,11,12,41];%wall sprits
%background innitialization
bcgmx=[ 4, 4, 4, 4, 4, 4, 4, 3, 4, 3, 3, 3;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4;
        4, 3, 3, 2,29,29, 3, 3, 3, 3, 3, 3;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4;
        3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,48;
        4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,56;
        4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4;];
max_dim=12;%dimmention of room
background=bcgmx;%set backround as matrix
%guyground innitializtion
guyground=ones(max_dim,max_dim); %make guyground clear
guyground(guy_y,guy_x)=eveR; %put eve on starting quardinate
%portground innitializtion
portground =ones(max_dim,max_dim);%make portground clear




%initialize scene
drawScene(room, background, portground,guyground)

level=1;%level is false
mode = 1; %1==walk,0==portal

%will continuously run until person walks through level
while(level==1)
   key_down = getKeyboardInput(room);% get keybord imput and set value
   
   %swich between walk and portal mode
  switch mode 
      
      case(1)%walk mode
    if(strcmp(key_down,'rightarrow')==1 && guy_x<max_dim && ~(ismember(bcgmx(guy_y,guy_x+1), walls)))
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x+1; %move eve
        guyground(guy_y,guy_x)=eveR; 
    elseif(strcmp(key_down,'leftarrow')==1 && guy_x>1 && ~(ismember(bcgmx(guy_y,guy_x-1), walls)))
        guyground(guy_y,guy_x)=1;
        guy_x=guy_x-1;
        guyground(guy_y,guy_x)=eveL;
    elseif(strcmp(key_down,'uparrow')==1 && guy_y>1 && ~(ismember(bcgmx(guy_y-1,guy_x), walls)))
        guyground(guy_y,guy_x)=1;
        guy_y=guy_y-1;
        guyground(guy_y,guy_x)=eveU;
    elseif(strcmp(key_down,'downarrow')==1 && guy_y<max_dim && ~(ismember(bcgmx(guy_y+1,guy_x), walls)))
        guyground(guy_y,guy_x)=1;
        guy_y=guy_y+1;
       guyground(guy_y,guy_x)=eveD;
    elseif(strcmp(key_down,'r')==1)
        mode = 0;
        portground(port_y,port_x)=1;
        port_x = guy_x;
        port_y = guy_y;
        portground(port_y,port_x)=port_pos;
    end

      case(0)%portal mode
    if(strcmp(key_down,'rightarrow')==1 && port_x<max_dim && ~(ismember(bcgmx(port_y, port_x+1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x+1;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && port_x>1 && ~(ismember(bcgmx(port_y, port_x-1), walls)) && port_y==guy_y)
       portground(port_y,port_x)=1;
        port_x=port_x-1;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'uparrow')==1 && port_y>1 && ~(ismember(bcgmx(port_y-1, port_x), walls))  && port_x==guy_x)
        portground(port_y,port_x)=1;
        port_y = port_y-1;
      portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'downarrow')==1 && port_y<max_dim && ~(ismember(bcgmx(port_y+1, port_x), walls))  && port_x==guy_x)
         portground(port_y,port_x)=1;
        port_y = port_y+1;
       portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'m')==1 && bcgmx(port_y,port_x)==tileplace)
       portground(orgP_y,orgP_x)=1;
        orgP_x=port_x;  
        orgP_y=port_y;
        port_x = guy_x;
        port_y = guy_y;
        portground(orgP_y,orgP_x)=orgP_pos;
        portground(port_y,port_x)=port_pos;
    elseif(strcmp(key_down,'n')==1 && bcgmx(port_y,port_x)==tileplace)
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
    end
  end
   %teleport
    if(guy_y==bluP_y && guy_x==bluP_x)% blu -> org
         guyground(guy_y,guy_x)=1;
        guy_y = orgP_y;
       guy_x = orgP_x;
       guyground(guy_y,guy_x)=eveR;
    elseif(guy_y==orgP_y && guy_x==orgP_x)%org -> blu
         guyground(guy_y,guy_x)=1;
        guy_y = bluP_y;
       guy_x = bluP_x;
       guyground(guy_y,guy_x)=eveL;
    end
%level room
    if(ismember(bcgmx(guy_y,guy_x), tileext))
        level = 2; 
        disp('next room'); 
    end
   
    
    
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
     

