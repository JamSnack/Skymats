// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//Enum for enemy ids
enum ENEMY
{
	balloonimal,
	greenthin, 
	vector_weevil,
	last
}

//List of enemy information structs
global.enemies = array_create(last, 0);

//Default enemy information struct
function enemyInformation(_name, _object_index, _cost, _height_min, _height_max) constructor
{
	name = name;
	object_index = _object_index;
	cost = _cost;
	height_max = _height_max;
	height_min = _height_min;
}

//Populate the enemies list.
global.enemies[ENEMY.balloonimal  ] = enemyInformation("Balloonimal"  , obj_balloonimal  , 0, 0    , -10000);
global.enemies[ENEMY.greenthin    ] = enemyInformation("Greenthin"    , obj_greenthin    , 2, -5000, -10000); 
global.enemies[ENEMY.vector_weevil] = enemyInformation("Vector Weevil", obj_vector_weevil, 2, -5000, -10000);