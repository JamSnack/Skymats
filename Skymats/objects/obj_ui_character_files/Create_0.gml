/// @description Insert description here
// You can write your code in this editor

//Init lerping
target_x = pos_x;
target_y = pos_y;
target_width = width;
target_height = height;

//Init dragging
mouse_drag_offset_x = 0;
mouse_drag_offset_y = 0;
dragging = false;

//Init resize
resize_left = false;
resize_right = false;
resize_top = false;
resize_bottom = false;
mouse_resize_offset_x = 0;
mouse_resize_offset_y = 0;
resizing = false;

//Init scrolling
scroll_offset_target = 0;
scroll_offset = 0;
max_scroll_offset = 0;
scroll_length = 40; //How much to scroll

//Constants
_topbar_height = 30;

//Window surface
window_surface = noone;
content_surface = noone;

//Other Window
window_alpha = 0;

//Files and stuff
init_player_stats();
gold = 0;

// - init expedition locally
platform_height = 0;
tutorial_complete = 0;


//Init character files
character_files = [];
character_information = [];
characters = 0;
var file_name = file_find_first(working_directory+"/*.charc", 0);

while (file_name != "")
{
    array_push(character_files, file_name);
	array_push(character_information, read_character(file_name));
    file_name = file_find_next();
}

file_find_close();
characters = array_length(character_files);



//Init expedition files
expedition_files = [];
expedition_information = [];
expeditions = 0;
var file_name = file_find_first(working_directory+"/*.exped", 0);

while (file_name != "")
{
    array_push(expedition_files, file_name);
	array_push(expedition_information, read_expedition(file_name));
    file_name = file_find_next();
}

file_find_close();
expeditions = array_length(expedition_files);


//Local
character_x_offset = 0;
expedition_x_offset = 0;
w_size = 144;
h_size = 192;
w_size_exped = 384;
h_size_exped = 288;

character_selected = -1;
expedition_selected = -1;


//If we have no characters and no expeditions, start the game
if (characters == 0 && expeditions == 0)
{
	//Enter the game
	event_user(0);
}

/*
TODO:
- Collapse Arrow bool
- Widgets
- - Buttons
*/