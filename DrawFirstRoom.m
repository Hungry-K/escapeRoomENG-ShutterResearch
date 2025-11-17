myRoom = escapeRoomEngine('RPGsprites.png',8,8,0,0,32,[255,255,255]);

  % Create a figure and assign the callback function
   
h = myRoom

background = [2 2 2 2;2 2 2 2;2 2 2 2;2 2 2 2];


 drawScene(myRoom,background);
    set(h, 'KeyPressFcn', @KeyPressCb);
row = 1
col = 1

    % The callback function handles the key events
    function KeyPressCb(~, event)
        fprintf('Key pressed: %s\n', event.Key);
       
        if strcmpi(event.Key, 'leftarrow')
            col = col - 1;
        elseif strcmpi(event.Key, 'rightarrow')
            col = col + 1;
        elseif strcmpi(event.Key, 'space')
            row = row + 1
        end
    end