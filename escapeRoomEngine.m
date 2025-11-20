classdef escapeRoomEngine < handle
    properties
        sprites = {}; % color data of the sprites
        sprites_transparency = {}; % transparency data of the sprites
        sprite_width = 0;
        sprite_height = 0;
        background_color = [0, 0, 0]; %default black color
        background_filename = '';
        background_image = {};
        background_image_transparency = {};
        zoom = 1;
        my_figure; % figure identifier
        my_image;  % image data
    end
    
    methods
        function obj = escapeRoomEngine(sprites_fname, sprite_height, sprite_width, sprites_margin, sprites_separation, zoom, background_color)
            % escapeRoomEngine
            % Input: 
            %  1. File name of sprite sheet as a character array
            %  2. Height of the sprites in pixels
            %  3. Width of the sprites in pixels
            %  4. Pixel width of margin
            %  5. Pixel width of separation between sprites
            %  6. (Optional) Zoom factor to multiply image by in final figure (Default: 1)
            %  7. (Optional) Background color in RGB format as a 3 element vector (Default: [0,0,0] i.e. black) or the name of a background image.
            % Output: an SGE scene variable
            % Note: In RGB format, colors are specified as a mixture of red, green, and blue on a scale of 0 to 255. [0,0,0] is black, [255,255,255] is white, [255,0,0] is red, etc.
            % Example:
            %     	room = simpleGameEngine('retro_pack.png',16,16,0,1,16,[255,255,255]);
            
            % load the input data into the object
            obj.sprite_width = sprite_width;
            obj.sprite_height = sprite_height;
            %load in either the background color or image
            if nargin > 6
                if(isstring(background_color) | ischar(background_color))
                    obj.background_filename = background_color; %if string is passed instead of RGB format
                    obj.background_color = [255,255,255]; %default to white for images with transparency 
                else
                    obj.background_color = background_color;
                end
            end
            if nargin > 5
                obj.zoom = zoom;
            end
            
            % read the sprites image data and transparency
            [sprites_image, ~, transparency] = imread(sprites_fname);
            
            %Remove sprite border
            if(sprites_margin~=0)
                sprites_image(1:sprites_margin,:,:)=[]; %top rows
                sprites_image(end-sprites_margin+1:end,:,:)=[]; %bottom rows
                sprites_image(:,1:sprites_margin,:)=[]; %left columns
                sprites_image(:,end-sprites_margin+1:end,:)=[]; %right columns
                if(isempty(transparency)==0)
                    transparency(1:sprites_margin,:)=[]; %top rows
                    transparency(end-sprites_margin+1:end,:)=[]; %bottom rows
                    transparency(:,1:sprites_margin)=[]; %left columns
                    transparency(:,end-sprites_margin+1:end)=[]; %right columns
                end
            end 
            % determine how many sprites there are based on the sprite size
            % and image size
            sprites_size = size(sprites_image);
            sprite_row_max = (sprites_size(1)+sprites_separation)/(sprite_height+sprites_separation);
            sprite_col_max = (sprites_size(2)+sprites_separation)/(sprite_width+sprites_separation);
            
            % Make a transparency layer if there is none (this happens when
            % there are no transparent pixels in the file).
            if isempty(transparency)
                transparency = 255*ones(sprites_size,'uint8');
            else
                % If there is a transparency layer, use repmat() to
                % replicate is to all three color channels
                transparency = repmat(transparency,1,1,3);
            end
            
            % loop over the image and load the individual sprite data into
            % the object
            for r=1:sprite_row_max
                for c=1:sprite_col_max
                    r_min = 1+(sprite_height+sprites_separation)*(r-1);
                    r_max = sprite_height*r+(r-1)*sprites_separation;
                    c_min = 1+(sprite_width+sprites_separation)*(c-1);
                    c_max = sprite_width*c+(c-1)*sprites_separation;
                    obj.sprites{end+1} = sprites_image(r_min:r_max,c_min:c_max,:);
                    obj.sprites_transparency{end+1} = transparency(r_min:r_max,c_min:c_max,:);
                end
            end
        end
        function loadBackgroundImage(obj, numRows, numCols)
            %Read in background image if background_color contains string
            [background, ~, transparency]=imread(obj.background_filename);
            back_size=size(background);
            % Make a transparency layer if there is none (this happens when
            % there are no transparent pixels in the file).
            if isempty(transparency)
                transparency = 255*ones(size(background),'uint8');
            else
                % If there is a transparency layer, use repmat() to
                % replicate is to all three color channels
                transparency = repmat(transparency,1,1,3);
            end
            backheight=floor(back_size(1)/numRows);
            backwidth=floor(back_size(2)/numCols);
            extra_height=mod(back_size(1),numRows);
            extra_width=mod(back_size(2),numCols);
            % loop over the image and load the individual sprite data into
            % the object
            for r=1:numRows
                for c=1:numCols
                    r_min = 1+(backheight)*(r-1);
                    r_max = backheight*r;
                    c_min = 1+(backwidth)*(c-1);
                    c_max = backwidth*c;
                    %Picture pixel size is unlikely to be evenly divisible
                    %by the size of the sprite images and this adds the
                    %last few pixels to be scale for each image.
                    if(r==numRows && c==numCols)
                        sub_pic=background(r_min:r_max+extra_height,c_min:c_max+extra_width,:);
                        sub_pic_trans=transparency(r_min:r_max+extra_height,c_min:c_max+extra_width,:);
                    elseif(r==numRows)
                        sub_pic=background(r_min:r_max+extra_height,c_min:c_max,:);
                        sub_pic_trans=transparency(r_min:r_max+extra_height,c_min:c_max,:);
                    elseif(c==numCols)
                        sub_pic=background(r_min:r_max,c_min:c_max+extra_width,:);
                        sub_pic_trans=transparency(r_min:r_max,c_min:c_max+extra_width,:);
                    else
                        sub_pic=background(r_min:r_max,c_min:c_max,:);
                        sub_pic_trans=transparency(r_min:r_max,c_min:c_max,:);
                    end
                    obj.background_image{end+1}=imresize(sub_pic,[obj.sprite_height,obj.sprite_width]);
                    obj.background_image_transparency{end+1}=imresize(sub_pic_trans,[obj.sprite_height,obj.sprite_width]);
                end
            end
        end
        
        % ----- MODIFIED FUNCTION START -----
        function drawScene(obj, background_sprites, midground_sprites, foreground_sprites)
            % draw_scene 
            % Input: 
            %  1. an SGE scene, which gains focus
            %  2. A matrix of sprite IDs, the arrangement of the sprites in the figure will be the same as in this matrix (background layer)
            %  3. (Optional) A second matrix of sprite IDs of the same size as the first. These sprites will be layered on top of the background. (midground layer)
            %  4. (Optional) A third matrix of sprite IDs of the same size as the first. These sprites will be layered on top of the midground. (foreground layer)
            % Output: None
            % Example: The following will create a figure with 3 rows and 3 columns of sprites
            %     	drawScene(my_scene, bg_layer_matrix, mg_layer_matrix, fg_layer_matrix);
            
            scene_size = size(background_sprites);
            
            % Error checking: make sure all layers are the same size
            if nargin > 2 % Check midground
                if ~isequal(scene_size, size(midground_sprites))
                    error('Background and midground matrices of scene must be the same size.')
                end
            end
            if nargin > 3 % Check foreground
                if ~isequal(scene_size, size(foreground_sprites))
                    error('Background and foreground matrices of scene must be the same size.')
                end
            end
            
            num_rows = scene_size(1);
            num_cols = scene_size(2);
            %if background image was requested and it hasn't be loaded before, load it here
            if(isempty(obj.background_filename)==0 && isempty(obj.background_image))
                loadBackgroundImage(obj, num_rows, num_cols)
            end
            
            % initialize the scene_data array to the correct size and type
            scene_data = zeros(obj.sprite_height*num_rows, obj.sprite_width*num_cols, 3, 'uint8');
            
            % loop over the rows and colums of the tiles in the scene to
            % draw the sprites in the correct locations
            for tile_row=1:num_rows
                for tile_col=1:num_cols
                    
                    % Save the id of the current sprite(s) to make things
                    % easier to read later
                    bg_sprite_id = background_sprites(tile_row,tile_col);
                    if nargin > 2
                        mg_sprite_id = midground_sprites(tile_row,tile_col);
                    end
                    if nargin > 3
                        fg_sprite_id = foreground_sprites(tile_row,tile_col);
                    end
                    
                    % Build the tile layer by layer, starting with the
                    % background color
                    tile_data = zeros(obj.sprite_height,obj.sprite_width,3,'uint8');
                    for rgb_idx = 1:3
                        tile_data(:,:,rgb_idx) = obj.background_color(rgb_idx);
                    end
                    
                    % Layer on background image if needed
                    if(~isempty(obj.background_image))
                        back_id=tile_col+(tile_row-1)*num_cols;
                        tile_data = obj.background_image{back_id} .* (obj.background_image_transparency{back_id}/255) + ...
                        tile_data .* ((255-obj.background_image_transparency{back_id})/255);
                    end
                    
                    % Layer on the background sprite. Note that the tranparency
                    % data also ranges from 0 (transparent) to 255
                    % (visible)
                    tile_data = obj.sprites{bg_sprite_id} .* (obj.sprites_transparency{bg_sprite_id}/255) + ...
                        tile_data .* ((255-obj.sprites_transparency{bg_sprite_id})/255);
                    
                    % If needed, layer on the midground sprite
                    if nargin > 2
                        tile_data = obj.sprites{mg_sprite_id} .* (obj.sprites_transparency{mg_sprite_id}/255) + ...
                            tile_data .* ((255-obj.sprites_transparency{mg_sprite_id})/255);
                    end

                    % If needed, layer on the foreground sprite
                    if nargin > 3
                        tile_data = obj.sprites{fg_sprite_id} .* (obj.sprites_transparency{fg_sprite_id}/255) + ...
                            tile_data .* ((255-obj.sprites_transparency{fg_sprite_id})/255);
                    end
                    
                    % Calculate the pixel location of the top-left corner
                    % of the tile
                    rmin = obj.sprite_height*(tile_row-1);
                    cmin = obj.sprite_width*(tile_col-1);
                    
                    % Write the tile to the scene_data array
                    scene_data(rmin+1:rmin+obj.sprite_height,cmin+1:cmin+obj.sprite_width,:)=tile_data;
                end
            end
            
            % handle zooming
            big_scene_data = imresize(scene_data,obj.zoom,'nearest');
            
            % This part is a bit tricky, but avoids some latency, the idea
            % is that we only want to completely create a new figure if we
            % absolutely have to: the first time the figure is created,
            % when the old figure has been closed, or if the scene is
            % resized. Otherwise, we just update the image data in the
            % current image, which is much faster.
            if isempty(obj.my_figure) || ~isvalid(obj.my_figure)
                % inititalize figure
                obj.my_figure = figure();
                
                % set guidata to the  key press and release functions,
                % this allows keeping track of what key has been pressed
                obj.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
                obj.my_figure.KeyReleaseFcn = @(src,event)guidata(src,0);
                % actually display the image to the figure
                obj.my_image = imshow(big_scene_data,'InitialMagnification', 100);
                
            elseif isempty(obj.my_image)  || ~isprop(obj.my_image, 'CData') || ~isequal(size(big_scene_data), size(obj.my_image.CData))
                % Re-display the image if its size changed
                figure(obj.my_figure);
                obj.my_image = imshow(big_scene_data,'InitialMagnification', 100);
            else
                % otherwise just update the image data
                obj.my_image.CData = big_scene_data;
            end
        end
        % ----- MODIFIED FUNCTION END -----
        
        function key = getKeyboardInput(obj)
            % getKeyboardInput
            % Input: an SGE scene, which gains focus
            % Output: next key pressed while scene has focus
            % Note: the operation of the program pauses while it waits for input
            % Example:
            %     	k = getKeyboardInput(my_scene);
            
            % Bring this scene to focus
            figure(obj.my_figure);
            
            % Pause the program until the user hits a key on the keyboard,
            % then return the key pressed. The loop is required so that
            % we don't exit on a mouse click instead.
            keydown = 0;
            while ~keydown
                keydown = waitforbuttonpress;
            end
            key = get(obj.my_figure,'CurrentKey');
        end
        
        function [row,col,button] = getMouseInput(obj)
            % getMouseInput
            % Input: an SGE scene, which gains focus
            % Output:
            %  1. The row of the tile clicked by the user
            %  2. The column of the tile clicked by the user
            %  3. (Optional) the button of the mouse used to click (1,2, or 3 for left, middle, and right, respectively)
            % 
            % Notes: A set of "crosshairs" appear in the scene's figure,
            % and the program will pause until the user clicks on the
            % figure. It is possible to click outside the area of the
            % scene, in which case, the closest row and/or column is
            % returned.
            % 
            % Example:
            %     	[row,col,button] = getMouseInput (my_scene);
            
            % Bring this scene to focus
            figure(obj.my_figure);
            
            % Get the user mouse input
            [X,Y,button] = ginput(1);
            
            % Convert this into the tile row/column
            row = ceil(Y/obj.sprite_height/obj.zoom);
            col = ceil(X/obj.sprite_width/obj.zoom);
            
            % Calculate the maximum possible row and column from the
            % dimensions of the current scene
            sceneSize = size(obj.my_image.CData);
            max_row = sceneSize(1)/obj.sprite_height/obj.zoom;
            max_col = sceneSize(2)/obj.sprite_width/obj.zoom;
            
            % If the user clicked outside the scene, return instead the
            % closest row and/or column
            if row < 1
                row = 1;
            elseif row > max_row
                row = max_row;
            end
            if col < 1
                col = 1;
            elseif col > max_col
                col = max_col;
            end
        end
    end
end