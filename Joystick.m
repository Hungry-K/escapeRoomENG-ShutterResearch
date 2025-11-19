
%load arduino
clear
Joystick_arduino= arduino("/dev/cu.usbmodem144101","Uno");

%set values for pins
xPin= 'A0';
yPin= 'A1';
swPin= 'A2';
while 1==1 % Infinite loop so code runs continuously 
xvalue= readVoltage(Joystick_arduino,xPin); %read the values of the voltage
yvalue= readVoltage(Joystick_arduino,yPin);
Btnvalue= readVoltage(Joystick_arduino,swPin);
if xvalue>2.4445 %when voltage changes display movement 
    disp('moving right')
elseif xvalue<2.4430
    disp('moving left')
elseif yvalue>2.4780
    disp('moving down')
elseif yvalue<2.4275
    disp('moving up')
elseif Btnvalue==0
    disp('Button')
end
end

