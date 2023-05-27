/// @description Draw Window and its contents
draw_set_alpha(window_alpha);

var _w = display_get_gui_width();
var _h = display_get_gui_height();

draw_set_halign(fa_center);

//CHARACTERS 
var _x = _w/2 - w_size/2 + character_x_offset;
var _y = _h/6 - 60;

for (var i=-1; i<characters; i++)
{
	var card_size = 1;
	var center_x = _x + (w_size/2)*card_size;
	var center_y = _y + (h_size/2)*card_size;
	
	if (character_selected == i)
	{
		draw_rectangle(center_x - (w_size/2)*card_size, center_y - (h_size/2)*card_size, center_x + (w_size/2)*card_size, center_y + (h_size/2)*card_size, false);
	}
	
	if (i != -1)
	{
		var _d = character_information[i];
		
		if (_d != -1)
		{
			//draw_rectangle(_x, _y, _x + w_size, _y + h_size, false);
			draw_text_scribble_ext(_x + w_size/2, _y - 48, "[default_outlined]"+string(_d.username), 190);
			draw_sprite_ext(spr_player_run, i + current_time/100, _x + w_size/2, _y + h_size/2, 12*card_size, 12*card_size, 0, c_white, 1.0);
			draw_text_scribble(_x + w_size/2, _y + h_size + 32, "[default_outlined]Gold: " + string(_d.gold));
			draw_text_scribble(_x + w_size/2, _y + h_size + 48, "[default_outlined]Level: " + string(_d.player_level));
		}
		else
		{
			draw_text_scribble(_x + w_size/2, _y - 48, "[default_outlined]Error Loading File");
			draw_sprite_ext(spr_player_error, i + current_time/100, _x + w_size/2, _y + h_size/2, 12*card_size, 12*card_size, 0, c_white, 1.0);
			draw_text_scribble(_x + w_size/2, _y + h_size + 32, "[default_outlined]Some data could\nnot be loaded.");
		}
	}
	else
	{
		//New character button
		draw_text_transformed(_x + w_size/2, _y, "+", 8, 8, 0);
	}
	
	_x += h_size;
}

//EXPEDITIONS
var _x = _w/2 - w_size_exped/2 + expedition_x_offset;
var _y = _h - _h/6 - 200;

for (var i=-1; i<expeditions; i++)
{
	var card_size = 1;
	var center_x = _x + (w_size_exped/2)*card_size;
	var center_y = _y + (h_size_exped/2)*card_size;
	
	//Background
	draw_sprite_stretched(spr_ui_background_2, 0, _x, _y, w_size_exped, h_size_exped);


	//Innerds
	if (expedition_selected == i)
	{
		draw_rectangle(center_x - (w_size_exped/2)*card_size, center_y - (h_size_exped/2)*card_size, center_x + (w_size_exped/2)*card_size, center_y + (h_size_exped/2)*card_size, true);
	}
	
	if (i != -1)
	{
		//read_expedition(expedition_files[i]);
		var _d = expedition_information[i];
		
		if (_d != -1)
		{
			var _c = _d.colors;
			draw_rectangle_color(_x + 2, _y + 2, _x + w_size_exped-2, _y + h_size_exped-2, _c[0], _c[0], _c[1], _c[1], false);
			
			draw_text(_x + w_size_exped/2, _y + 16, "Height: " + string(-_d.platform_height));
		}
	}
	else
	{
		//New expedition button
		draw_text_transformed(_x + w_size_exped/2, _y, "+", 8, 8, 0);
	}
	
	_x += w_size_exped + 32;
}

//Start game
draw_rectangle(_w/2 - 80, _h/2 - 40, _w/2 + 80, _h/2 + 30, true);
draw_text(_w/2, _h/2, "Embark!");

//reset
draw_set_alpha(1);
draw_set_halign(fa_left);