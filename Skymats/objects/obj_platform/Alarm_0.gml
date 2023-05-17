/// @description Turn resources into fuel

//Accrue fuel from resource storage
if (global.stored_resource_to_burn != 0 && global.stored_resources[global.stored_resource_to_burn] > 0)
{
	if (powered && !obstruction && power_delay <= 0 && fuel > 1)
	{
		//TODO: Implement consumption chance
		global.stored_resources[global.stored_resource_to_burn]--;
	
		fuel_efficieny = get_item_bonus_fuel(global.stored_resource_to_burn);
	
		//Reset relevant ui
		if (instance_exists(obj_ui_fuel_menu))
				with (obj_ui_fuel_menu) { surface_free(window_surface) };
	}
			
	alarm[0] = 45;
}
else 
{
	fuel_efficieny = 0;
	alarm[0] = 1;
}

