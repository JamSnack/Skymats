/// @description
depth = 99;

//Init inventory
//Fill inventory with emptiness
global.inventory = {
	contents    : array_create(10, 0),
	size        : 10,
	selected_slot : -1,
	held_value: 0,
	
	deleteItemAtSlot : function(slot) {
		delete contents[slot];
		contents[slot] = new item();
	},
	
	subtractItemAtSlot : function(slot, _amount){
		contents[slot].amount -= _amount;
		
		if (contents[slot].amount <= 0)
			deleteItemAtSlot(slot);
	},
	
	subtractItem : function(item_id, _amount){
		for (var i = 0; i < size; i++)
		{
			if (contents[i].item_id == item_id)
			{
				subtractItemAtSlot(i, _amount);
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
	
	createItem : function(_name, _item_id, _amount) {
		var _f = firstEmptySlot();
		
		if (_f != -1)
		{
			contents[_f].item_id = _item_id;
			contents[_f].amount = _amount;
			return true;
			//obj_player.weight += _amount/10; //TODO: Replace this with an encumberance mechanic. Probably some add_weight() function that uses a player's capacity stat
		} else return false;
	},
	
	addItem : function(_name, _item_id, _amount) {
		
		for (var i = 0; i < size; i++)
		{
			if (contents[i].equals(_name, _item_id))
			{
				contents[i].amount += _amount;
				//obj_player.weight += _amount/10;
				held_value += get_item_value(_item_id)*_amount;
				return i;
			}
		}
		
		if (createItem(_name, _item_id, _amount))
			held_value += get_item_value(_item_id)*_amount;
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

//Init game
init_game();