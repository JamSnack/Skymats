// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//Define each progress point in the game. Tutorial not included because it does not use the dungeon systems
enum PROGRESS
{
	first, //The 0 index is unused. See check_height_for_dungeon() for more info
	star_dungeon,
	last
}

global.dungeon_names = [ "NONE",
	"temp_dungeon",
	"NONE"
	];

//An array telling us whether or not a progress point has been cleared.
global.game_progress = array_create(PROGRESS.last, 0);
global.progress_index_to_check = 1;

//This function will be used inside obj_platform, although it is defined here.
//Used in conjunction with global.game_progress to load dungeons which are necessary for game progress.
function check_height_for_dungeon()
{
	static heights = [0,
		-4500,
		0
	];
	
	if (!global.dungeon)
	{
		//show_debug_message("checking dungeon to load: "+ string(global.progress_index_to_check));
		var height = global.platform_height;
	
		if (global.game_progress[global.progress_index_to_check] == 0 && height < heights[global.progress_index_to_check])
		{
			init_dungeon_load();
			load_dungeon(global.dungeon_names[global.progress_index_to_check]);
		}
		else if (global.game_progress[global.progress_index_to_check] == 1 && global.progress_index_to_check+1 < PROGRESS.last)
			global.progress_index_to_check++;
	}
	
}