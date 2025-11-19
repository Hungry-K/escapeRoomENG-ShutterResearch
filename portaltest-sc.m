%This demo shows how to layer sprites on top of each other and use a
%keyboard to control character movement. 
%In this simple demo a wizard sprite is put on top of a grass backround and
%is able to walk around the image using the arrow keys until reaching the 
% door at which point you "win"

function [] = Example_KeyboardInput()

close all

%initialize sprites
room = escapeRoomEngine('test.png',10,10,0,0,8,[255,255,255]);
port_x =1
port_y =1
%Set room to a dim x dim filled with background
max_dim=5;
background=ones(max_dim,max_dim)*6; %Checkered background
%background(2,3)=22;
background(end, end)=3; %initialize bottom corner to a door image to navigate to
background(port_y, port_x)= 2;
%fill the foreground matrix with blank cells except 1 which is the wizard
foreground=ones(max_dim,max_dim)*1; %the 1st cell is a blank cell
wizard_r=1;
wizard_c=1;
blue_guy_pos=5; 
foreground(wizard_r,wizard_c)=blue_guy_pos; %initialize the first cell to the little wizard. 
background(1, 5)=7;
%initialize scene
drawScene(room, background, foreground)

framerate = 30; % frames per second
in_door=0;
mode = 1;
%will continuously run until person walks through door
while(in_door==0)
   key_down = getKeyboardInput(room);
   
   
  if(mode == 1)
    
    if(strcmp(key_down,'rightarrow')==1 && wizard_c<max_dim)
        foreground(wizard_r,wizard_c)=1;
        wizard_c=wizard_c+1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && wizard_c>1)
        foreground(wizard_r,wizard_c)=1;
        wizard_c=wizard_c-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'uparrow')==1 && wizard_r>1)
        foreground(wizard_r,wizard_c)=1;
        wizard_r=wizard_r-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'downarrow')==1 && wizard_r<max_dim)
        foreground(wizard_r,wizard_c)=1;
        wizard_r=wizard_r+1;
       foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'r')==1)
        mode = 0;
        
   
    end
   end
    
  if(mode == 0)
   
    if(strcmp(key_down,'rightarrow')==1 && wizard_c<max_dim)
        background(port_y,port_x)=6;
        port_x=port_x+1;
        background(port_y,port_x)=2;
    elseif(strcmp(key_down,'leftarrow')==1 && wizard_c>1)
       background(port_y,port_x)=6;
        port_x=port_x-1;
        background(port_y,port_x)=2;
    elseif(strcmp(key_down,'uparrow')==1 && wizard_r>1)
         background(port_y,port_x)=6;
        port_y = port_y-1;
        background(port_y,port_x)=2;
    elseif(strcmp(key_down,'downarrow')==1 && wizard_r<max_dim)
         background(port_y,port_x)=6;
        port_y=port_y+1;
        background(port_y,port_x)=2;
     elseif(strcmp(key_down,'e')==1)
        mode = 1;
        
    else
   
    end
    end
   %teleport
    if(wizard_r==max_dim && wizard_c==max_dim)
         foreground(wizard_r,wizard_c)=1;
        wizard_r = port_y;
       wizard_c = port_x;
       foreground(wizard_r,wizard_c)=blue_guy_pos;
    end

    if(wizard_r==1 && wizard_c==5) 
        in_door = 1; % Set in_door to 1 to indicate the wizard has reached the door
        disp('next room'); % Display a winning message
    end
    %Update the matrix image to the screen. 
    drawScene(room, background, foreground)
    
end
     

