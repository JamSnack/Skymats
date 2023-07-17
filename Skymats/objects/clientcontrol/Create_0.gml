/// @description
depth = 99;

//Init inventory
//Fill inventory with emptiness
global.inventory = {
	contents    : array_create(10, 0),
	size        : 10,
	held_value: 0,
	held_fuel: 0,
	held_bonus: 0,
	held_item_count: 0,
	
	deleteItemAtSlot : function(slot) {
		held_value -= get_item_value(contents[slot])*contents[slot].amount;
		held_fuel -= get_fuel_value(contents[slot])*contents[slot].amount;
		held_item_count -= contents[slot].amount;
		calculateBonus();
		delete contents[slot];
		contents[slot] = new item();
	},
	
	subtractItemAtSlot : function(slot, _amount){
		contents[slot].amount -= _amount;
		held_item_count -= _amount;
		calculateBonus();
		
		if (contents[slot].amount <= 0)
			deleteItemAtSlot(slot);
	},
	
	subtractItem : function(item_id, _amount){
		for (var i = 0; i < size; i++)
		{
			if (contents[i].item_id == item_id)
			{
				subtractItemAtSlot(i, _amount);
				held_item_count -= _amount;
				calculateBonus();
				return i;
			}
		}
	},
	
	firstEmptySlot : function() {
		
		for (var i = 0; i < size; i++)
		{
			if (contents[i].isEmpty())
			{
				return i;
			}
		}
		
		return -1;
	},
	
	createItem : function(_item_id, _amount) {
		var _f = firstEmptySlot();
		
		if (_f != -1)
		{
			contents[_f].item_id = _item_id;
			contents[_f].amount = _amount;
			held_item_count += _amount;
			calculateBonus();
			return true;
			//obj_player.weight += _amount/10; //TODO: Replace this with an encumberance mechanic. Probably some add_weight() function that uses a player's capacity stat
		} else return false;
	},
	
	addItem : function(_item_id, _amount) {
		
		for (var i = 0; i < size; i++)
		{
			if (contents[i].equals(_item_id))
			{
				contents[i].amount += _amount;
				//obj_player.weight += _amount/10;
				held_value += get_item_value(_item_id)*_amount;
				held_fuel += get_fuel_value(_item_id)*_amount;
				held_item_count += _amount;
				calculateBonus();
				return i;
			}
		}
		
		if (createItem(_item_id, _amount))
		{
			held_value += get_item_value(_item_id)*_amount;
			held_fuel += get_fuel_value(_item_id)*_amount;
			held_item_count += _amount;
			calculateBonus();
		}
	},
	clear : function() {
		for (var i = 0; i < size; i++)
			deleteItemAtSlot(i);
		
		held_value = 0;
		held_fuel = 0;
		held_item_count = 0;
		calculateBonus();
	},
	calculateBonus : function() {
		held_bonus = 0;//round((held_item_count/2000)*100);
	}
	
}


//Init inventory contents
for (var i = 0; i < global.inventory.size; i++)
{
	global.inventory.contents[i] = new item();	
}

//Fill with random gear
/*for (var _i = 1; _i < sprite_get_number(spr_items); _i++)
{
	show_debug_message(string(_i));
	global.inventory.createItem("what",_i,1);
}*/


//Animation
inventory_open_animation = 1;

inventory_open_animcurve_channel = animcurve_get_channel(curve, 0);

//Frame skip
frame = 0;

//Background
last_height = -1;
background_colors=0;
height_range = 1000;

//Init game
//init_expedition();
//load_expedition("exped.exped"); //TODO: This is temporary