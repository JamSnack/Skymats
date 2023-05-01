/// @description Insert description here
// You can write your code in this editor

if (ds_exists(chunk_grid_type, ds_type_grid))
{
	draw_set_alpha(0.5);
	for (var i=0; i<17;i++)
	{
		for (var j=0; j<17;j++)
		{
			draw_sprite(object_get_sprite(get_tile_object_from_item(chunk_grid_type[# i, j])), 0, x+i*16, y+j*16);
		}
	}
}