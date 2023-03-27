/// @description

//Init inventory
function item(_name = "", _item_id = 0, _amount = 0) constructor
{
	name      =    _name;
	item_id   = _item_id;
	amount    =  _amount;
	
	static isEmpty = function()
	{
		return (name == "" && item_id == 0 && amount = 0);
	}
	
	static equals = function(_name, _item_id)
	{
		return (name == _name && item_id == _item_id);	
	}
	
	static toString = function()
	{
		return string("Item is: { Name:" + name + ", Item ID: " + string(item_id)) + "}";	
	}
}


//Fill inventory with emptiness
global.inventory = {
	contents    : array_create(40, 0),
	size        : 40,
	selected_slot : 0,
	
	deleteItemAtSlot : function(slot) {
		delete contents[slot];
		contents[slot] = new item();
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
		}
	},
	
	addItem : function(_name, _item_id, _amount) {
		
		for (var i = 0; i < size; i++)
		{
			if (contents[i].equals(_name, _item_id))
			{
				show_debug_message("add");
				contents[i].amount += _amount;
				return i;
			}
		}
		
		createItem(_name, _item_id, _amount);
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
inventory_open_animation = 0;
inventory_open = true;

inventory_open_animcurve_channel = animcurve_get_channel(curve, 0);