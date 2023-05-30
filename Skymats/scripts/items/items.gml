// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum ITEM_ID
{
	none,
	
	grass,
	stone,
	
	coal,
	tin,
	aluminum,
	nickel,
	copper,
	zinc,
	iron,
	silver,
	gold,
	sapphire,
	ruby,
	topaz,
	lapis,
	emerald,
	amethyst,
	diamond,
	garnet,
	beryllium,
	hematite,
	obsidian,
	cobalt,
	void_glass,
	buried_stars,
	moon_cheese,
	typhoonium,
	ground_lemons,
	
	
	enemy_parts, //Used as last_ore in code
	greenthin_legs,
	star_finger,
	pot_of_greed,
	fuel_cell,
	
	last,
}

function get_tile_object_from_item(item_id)
{
	switch item_id
	{
		case ITEM_ID.grass:            { return obj_grass;        } break;
		case ITEM_ID.stone:            { return obj_stone;        } break;
		case ITEM_ID.coal:             { return obj_coal;         } break;
		case ITEM_ID.iron:             { return obj_iron;         } break;
		case ITEM_ID.copper:           { return obj_copper;       } break;
		case ITEM_ID.silver:           { return obj_silver;       } break;
		case ITEM_ID.gold:             { return obj_gold;         } break;
		case ITEM_ID.sapphire:         { return obj_sapphire;     } break;
		case ITEM_ID.ruby:             { return obj_ruby;         } break;
		case ITEM_ID.emerald:          { return obj_emerald;      } break;
		case ITEM_ID.diamond:          { return obj_diamond;      } break;
		case ITEM_ID.pot_of_greed:     { return obj_pot_of_greed; } break;
		
		case ITEM_ID.amethyst:         { return obj_amethyst;     } break;
		case ITEM_ID.tin:		       { return obj_tin;          } break;
		case ITEM_ID.aluminum:	       { return obj_aluminum;     } break;
		case ITEM_ID.nickel:	       { return obj_nickel;       } break;
		case ITEM_ID.beryllium:	       { return obj_beryllium;    } break;
		case ITEM_ID.buried_stars:     { return obj_buried_stars; } break;
		case ITEM_ID.cobalt:	       { return obj_cobalt;       } break;
		case ITEM_ID.garnet:	       { return obj_garnet;       } break;
		case ITEM_ID.ground_lemons:    { return obj_ground_lemons;} break;
		case ITEM_ID.hematite:	       { return obj_hematite;     } break;
		case ITEM_ID.lapis:		       { return obj_lapis_lazuli; } break;
		case ITEM_ID.moon_cheese:      { return obj_moon_cheese;  } break;
		case ITEM_ID.obsidian:		   { return obj_obsidian;     } break;
		case ITEM_ID.topaz:			   { return obj_topaz;        } break;
		case ITEM_ID.typhoonium:	   { return obj_typhoonium;   } break;
		case ITEM_ID.void_glass:	   { return obj_void_glass;   } break;
		case ITEM_ID.zinc:			   { return obj_zinc;         } break;
		
		default:			           { return obj_bedrock;      } break;
	}
}

function get_item_value(item_id)
{
	switch item_id
	{
		//tiles
		case ITEM_ID.grass:					{ return  1;  } break;
		case ITEM_ID.stone:					{ return  1;  } break;
		case ITEM_ID.coal:					{ return  2;  } break;
		case ITEM_ID.tin:					{ return  4;  } break;
		case ITEM_ID.aluminum:				{ return  6;  } break;
		case ITEM_ID.nickel:				{ return  8;  } break;
		case ITEM_ID.copper:				{ return  11; } break;
		case ITEM_ID.zinc:					{ return  13; } break;
		case ITEM_ID.iron:					{ return  16; } break;
		case ITEM_ID.silver:				{ return  19; } break;
		case ITEM_ID.gold:					{ return  21; } break;
		case ITEM_ID.sapphire:				{ return  23; } break;
		case ITEM_ID.ruby:					{ return  25; } break;
		case ITEM_ID.topaz:					{ return  29; } break;
		case ITEM_ID.lapis:					{ return  34; } break;
		case ITEM_ID.emerald:				{ return  38; } break;
		case ITEM_ID.amethyst:				{ return  43; } break;
		case ITEM_ID.diamond:				{ return  49; } break;
		case ITEM_ID.garnet:				{ return  54; } break;
		case ITEM_ID.beryllium:				{ return  59; } break;
		case ITEM_ID.hematite:				{ return  65; } break;
		case ITEM_ID.obsidian:				{ return  70; } break;
		case ITEM_ID.cobalt:				{ return  75; } break;
		case ITEM_ID.void_glass:			{ return  100; } break;
		case ITEM_ID.buried_stars:			{ return  150; } break;
		case ITEM_ID.ground_lemons:			{ return  200; } break;
		case ITEM_ID.moon_cheese:			{ return  127; } break;
		case ITEM_ID.typhoonium:			{ return  300; } break;
		
		//items
		case ITEM_ID.enemy_parts:			{ return  5; } break;
		case ITEM_ID.pot_of_greed:			{ return  250; } break;
		case ITEM_ID.greenthin_legs:        { return  6; } break;
		case ITEM_ID.star_finger:           { return 50; } break;
		case ITEM_ID.fuel_cell:             { return 5;  } break;
		
		default:							{ return -1; } break;
	}
}

function get_item_bonus_fuel(item_id)
{
	switch item_id
	{
		//tiles
		case ITEM_ID.grass:					{ return  15;  } break;
		case ITEM_ID.coal:					{ return  25;  } break;
		
		case ITEM_ID.stone:					
		case ITEM_ID.tin:					
		case ITEM_ID.aluminum:				
		case ITEM_ID.nickel:				
		case ITEM_ID.copper:				
		case ITEM_ID.zinc:					
		case ITEM_ID.iron:					
		case ITEM_ID.silver:				
		case ITEM_ID.gold:					
		case ITEM_ID.sapphire:				
		case ITEM_ID.ruby:					
		case ITEM_ID.topaz:					
		case ITEM_ID.lapis:					
		case ITEM_ID.emerald:				
		case ITEM_ID.amethyst:				
		case ITEM_ID.diamond:				
		case ITEM_ID.garnet:				
		case ITEM_ID.beryllium:				
		case ITEM_ID.hematite:				
		case ITEM_ID.obsidian:				
		case ITEM_ID.cobalt:				
		case ITEM_ID.void_glass:			
		case ITEM_ID.buried_stars:			
		case ITEM_ID.ground_lemons:			
		case ITEM_ID.moon_cheese:			
		case ITEM_ID.typhoonium:			{ return  5; } break;
		
		//items
		case ITEM_ID.enemy_parts:			{ return  8; } break;
		case ITEM_ID.pot_of_greed:			{ return  5; } break;
		case ITEM_ID.greenthin_legs:        { return  9; } break;
		case ITEM_ID.star_finger:           { return 20; } break;
		case ITEM_ID.fuel_cell:             { return 100;} break;
		
		default:							{ return -1; } break;
	}
}

function get_fuel_value(item_id)
{
	switch item_id
	{
		case ITEM_ID.stone:
		case ITEM_ID.grass:		   { return  5; } break;
		case ITEM_ID.coal:         
		case ITEM_ID.copper:	   
		case ITEM_ID.iron:	       
		case ITEM_ID.silver:	   
		case ITEM_ID.gold:		   { return  30; } break;
		case ITEM_ID.sapphire:	   
		case ITEM_ID.ruby:		   
		case ITEM_ID.emerald:	   
		case ITEM_ID.diamond:	   { return  45; } break;
		
		case ITEM_ID.pot_of_greed: { return  150; } break;
		
		case ITEM_ID.enemy_parts:  
		case ITEM_ID.greenthin_legs: { return  5; } break;
		case ITEM_ID.fuel_cell:      { return 1500;} break;
		default:				   { return 30; } break;
	}
}

function get_item_name(item_id)
{
	switch (item_id)
	{
		case ITEM_ID.grass:            { return "Grass";		} break;
		case ITEM_ID.stone:            { return "Stone";		} break;
		case ITEM_ID.coal:             { return "Coal";			} break;
		case ITEM_ID.iron:             { return "Iron";			} break;
		case ITEM_ID.copper:           { return "Copper";		} break;
		case ITEM_ID.silver:           { return "Silver";		} break;
		case ITEM_ID.gold:             { return "Gold";			} break;
		case ITEM_ID.sapphire:         { return "Sapphire";		} break;
		case ITEM_ID.ruby:             { return "Ruby";			} break;
		case ITEM_ID.emerald:          { return "Emerald";		} break;
		case ITEM_ID.diamond:          { return "Diamond";		} break;
		case ITEM_ID.pot_of_greed:     { return "Pot of Greed"; } break;
		case ITEM_ID.enemy_parts:      { return "Enemy Parts";  } break;
		case ITEM_ID.greenthin_legs:   { return "Greenthin Legs"; } break;
		case ITEM_ID.star_finger:      { return "Star Finger"; } break;
		case ITEM_ID.fuel_cell:        { return "Fuel Cell";   } break;

		case ITEM_ID.amethyst:         { return "Amethyst";     } break;
		case ITEM_ID.tin:		       { return "Tin";          } break;
		case ITEM_ID.aluminum:	       { return "Aluminum";     } break;
		case ITEM_ID.nickel:	       { return "Nickel";       } break;
		case ITEM_ID.beryllium:	       { return "Beryllium";    } break;
		case ITEM_ID.buried_stars:     { return "Buried Stars"; } break;
		case ITEM_ID.cobalt:	       { return "Cobalt";       } break;
		case ITEM_ID.garnet:	       { return "Garnet";       } break;
		case ITEM_ID.ground_lemons:    { return "Ground Lemons";} break;
		case ITEM_ID.hematite:	       { return "Hematite";     } break;
		case ITEM_ID.lapis:		       { return "Lapis Lazuli"; } break;
		case ITEM_ID.moon_cheese:      { return "Moon Cheese";  } break;
		case ITEM_ID.obsidian:		   { return "Obsidian";     } break;
		case ITEM_ID.topaz:			   { return "Topaz";        } break;
		case ITEM_ID.typhoonium:	   { return "Typhoonium";   } break;
		case ITEM_ID.void_glass:	   { return "Void Glass";   } break;
		case ITEM_ID.zinc:			   { return "Zinc";         } break;
	}
}


global.ore_distribution = array_create(ITEM_ID.enemy_parts);
global.ore_distribution[ITEM_ID.coal] =       { high: -50000, low: 3000  };
global.ore_distribution[ITEM_ID.tin] =     { high: -12000, low: 1000  };
global.ore_distribution[ITEM_ID.aluminum] =		  { high: -13500, low: 500   };
global.ore_distribution[ITEM_ID.nickel] =     { high: -15000, low: -1500  };
global.ore_distribution[ITEM_ID.copper] =       { high: -16500, low: -3000 };
global.ore_distribution[ITEM_ID.zinc] =		  { high: -17500, low: -4500 };
global.ore_distribution[ITEM_ID.iron] =   { high: -18500, low: -6500 };
global.ore_distribution[ITEM_ID.silver] =    { high: -19000, low: -8000 };
global.ore_distribution[ITEM_ID.gold] =    { high: -20000, low: -8500 };
global.ore_distribution[ITEM_ID.sapphire] =    { high: -21000, low: -9500 };
global.ore_distribution[ITEM_ID.ruby] =    { high: -23000, low: -10500 };
global.ore_distribution[ITEM_ID.topaz] =    { high: -25000, low: -12500 };
global.ore_distribution[ITEM_ID.lapis] =    { high: -27000, low: -14500 };
global.ore_distribution[ITEM_ID.emerald] =    { high: -29000, low: -15000 };
global.ore_distribution[ITEM_ID.amethyst] =    { high: -31000, low: -16500 };
global.ore_distribution[ITEM_ID.diamond] =    { high: -33000, low: -17500 };
global.ore_distribution[ITEM_ID.garnet] =    { high: -35000, low: -19500 };
global.ore_distribution[ITEM_ID.beryllium] =    { high: -37000, low: -21500 };
global.ore_distribution[ITEM_ID.hematite] =    { high: -39000, low: -23500 };
global.ore_distribution[ITEM_ID.obsidian] =    { high: -41000, low: -25500 };
global.ore_distribution[ITEM_ID.cobalt] =    { high: -43000, low: -27500 };
global.ore_distribution[ITEM_ID.void_glass] =    { high: -45000, low: -29500 };
global.ore_distribution[ITEM_ID.buried_stars] =    { high: -50000, low: -31500 };
global.ore_distribution[ITEM_ID.moon_cheese] =    { high: -50000, low: -32500 };
global.ore_distribution[ITEM_ID.typhoonium] =    { high: -60000, low: -33500 };
global.ore_distribution[ITEM_ID.ground_lemons] =    { high: -60000, low: -34500 };


function choose_ore(y)
{
	var _g = global.ore_distribution;
	
	show_debug_message("y is: ");
	show_debug_message(y);
	
	for (var _i = ITEM_ID.enemy_parts-1; _i > ITEM_ID.stone; _i--)
	{
		if (y < _g[_i].low && y <= irandom_range(_g[_i].high, _g[_i].low))
			return _i;	
	}
	
	return ITEM_ID.stone;
}


function item(_item_id = 0, _amount = 0) constructor
{
	item_id   = _item_id;
	amount    =  _amount;
	
	static isEmpty = function()
	{
		return (item_id == 0 && amount = 0);
	}
	
	static equals = function(_item_id)
	{
		return (item_id == _item_id);	
	}
	
	/*static toString = function()
	{
		return string("Item is: { Name:" + name + ", Item ID: " + string(item_id)) + "}";	
	}*/
}