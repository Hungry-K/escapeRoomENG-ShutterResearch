close all
clc
clear

room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,8 ,[255,255,255]);
%room size
%innitial x/y positions
port_x =1;%portal curser x pos
port_y =1;%portal curser y pos
orgP_x =2;%orange portal x pos
orgP_y =1;%orange portal y pos
bluP_x =3;%blue portal x pos
bluP_y =1;%blue portal y pos
exitx =12;%level exit x pos
exity =10;%level exit y pos
guy_y=3;%charicter y
guy_x=2;%charicter x
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
tileext=[32, 40,48,56];%exit tile
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
        4, 3, 3, 3, 3,42, 3, 3, 3, 3, 3, 4;
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
    if(strcmp(key_down,'rightarrow')==1 && guy_x<max_dim && ~(ismember(bcgmx(guy_y,guy_x+1), walls)) && background(guy_y,guy_x+1)~=42)%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x+1; %move eve
        guyground(guy_y,guy_x)=eveR; %uptate eve
    elseif(strcmp(key_down,'leftarrow')==1 && guy_x>1 && ~(ismember(bcgmx(guy_y,guy_x-1), walls))&& background(guy_y,guy_x-1)~=42)%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_x=guy_x-1;%move eve
        guyground(guy_y,guy_x)=eveL;%uptate eve
    elseif(strcmp(key_down,'uparrow')==1 && guy_y>1 && ~(ismember(bcgmx(guy_y-1,guy_x), walls))&& background(guy_y-1,guy_x)~=42)%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_y=guy_y-1;%move eve
        guyground(guy_y,guy_x)=eveU;%uptate eve
    elseif(strcmp(key_down,'downarrow')==1 && guy_y<max_dim && ~(ismember(bcgmx(guy_y+1,guy_x), walls))&& background(guy_y+1,guy_x)~=42)%move conditionals
        guyground(guy_y,guy_x)=1;%set past clear
        guy_y=guy_y+1;%move eve
       guyground(guy_y,guy_x)=eveD;%uptate eve
    elseif(strcmp(key_down,'r')==1)%swich mode conditionals
        mode = 0;%swich mode
        portground(port_y,port_x)=1;%swich 
        port_x = guy_x;%open curser at eve position
        port_y = guy_y;;%open curser at eve position
        portground(port_y,port_x)=port_pos;%update portal
    end

      case(0)%portal mode
    if(strcmp(key_down,'rightarrow')==1 && port_x<max_dim && ~(ismember(bcgmx(port_y, port_x+1), walls)) && port_y==guy_y)%portal conditionals
       portground(port_y,port_x)=1;%set past clear
        port_x=port_x+1;%move portal
        portground(port_y,port_x)=port_pos;%updtae portal
    elseif(strcmp(key_down,'leftarrow')==1 && port_x>1 && ~(ismember(bcgmx(port_y, port_x-1), walls)) && port_y==guy_y)%portal conditionals
       portground(port_y,port_x)=1;%set past clear
        port_x=port_x-1;%move portal
        portground(port_y,port_x)=port_pos;%updtae portal
    elseif(strcmp(key_down,'uparrow')==1 && port_y>1 && ~(ismember(bcgmx(port_y-1, port_x), walls))  && port_x==guy_x)%portal conditionals
        portground(port_y,port_x)=1;%set past clear
        port_y = port_y-1;%move portal
      portground(port_y,port_x)=port_pos;%updtae portal
    elseif(strcmp(key_down,'downarrow')==1 && port_y<max_dim && ~(ismember(bcgmx(port_y+1, port_x), walls))  && port_x==guy_x)%portal conditionals
         portground(port_y,port_x)=1;%set past clear
        port_y = port_y+1;%move portal
       portground(port_y,port_x)=port_pos;%updtae portal
    elseif(strcmp(key_down,'m')==1 && bcgmx(port_y,port_x)==tileplace)%orange portal conditionals
       portground(orgP_y,orgP_x)=1;%clear portal curser
        orgP_x=port_x;  %set org port pos
        orgP_y=port_y; %set org port pos
        port_x = guy_x;%set port curs to guy
        port_y = guy_y;%set port curs to guy
        portground(orgP_y,orgP_x)=orgP_pos;%update org port
        portground(port_y,port_x)=port_pos;%update portcurser
    elseif(strcmp(key_down,'n')==1 && bcgmx(port_y,port_x)==tileplace)%blue portal conditionals
       portground(bluP_y,bluP_x)=1;%clear portal curser
        bluP_x=port_x; %set blue port pos
        bluP_y=port_y;%set blue port pos
        port_x = guy_x;%set port curs to guy
        port_y = guy_y;%set port curs to guy
        portground(bluP_y,bluP_x)=bluP_pos;%update org port
        portground(port_y,port_x)=port_pos;%update portcurser
     elseif(strcmp(key_down,'r')==1)%swich mode conditionals
       mode = 1;   %swich mode
       portground(port_y,port_x)=1;%hide portal curser
       port_x = 1;%move portal curser
       port_y = 1;%move portal curser
    end
  end
   %teleport
    if(guy_y==bluP_y && guy_x==bluP_x)% blu -> org
         guyground(guy_y,guy_x)=1;%set past clear
        guy_y = orgP_y;%move eve
       guy_x = orgP_x;%move eve
       guyground(guy_y,guy_x)=eveR;%update eve  
    elseif(guy_y==orgP_y && guy_x==orgP_x)%org -> blu
         guyground(guy_y,guy_x)=1;%set past clear
        guy_y = bluP_y;%move eve
       guy_x = bluP_x;%move eve
       guyground(guy_y,guy_x)=eveL;%update eve
    end
%level room
    if(ismember(bcgmx(guy_y,guy_x), tileext))%next room condirional
        level = 2; %set level value
        disp('next room'); %display next room
    end
   
    
    
    %Update the matrix image to the screen. 
    drawScene(room, background, portground, guyground)
    
end
     

