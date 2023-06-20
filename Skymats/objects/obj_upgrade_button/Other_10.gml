/// @description Insert description here
// You can write your code in this editor
event_inherited();

if (instance_exists(obj_player))
{
	var _g = obj_player.gold;
	var _cost = get_upgrade_cost(upgrade_id);
	
	if (_g >= _cost)
	{
		obj_player.gold -= _cost;
		obj_player.upgrades_purchased[upgrade_id]++;
		apply_upgrade(upgrade_id);
		
		obj_player.player_level = calculate_player_level();
		//with (obj_player)
			//init_player();
			
		with (obj_market)
			check_for_upgrades();
	}
}