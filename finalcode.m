clear all
clc 
close all

a = arduino("COM7","Uno")


bensroom(a);
SimonsRoom(a);
TysRoom(a);
SilemsRoom(a);
final_room(a);

room = escapeRoomEngine('PortalSprites-265x265.png',32,32,1,1,8 ,[255,255,255]);
portground=[4];
forground=[25];
background=[33];
     drawScene(room, portground,forground,background)