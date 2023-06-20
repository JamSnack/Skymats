/// @description Insert description here
// You can write your code in this editor

image_alpha = 0.25;
display_market_animation = 0;
heal_delay = 100;
upgrade_available = false;

function check_for_upgrades()
{
	with (obj_player)
	{
		for (var i = 1; i < UPGRADE.last; i++)
		{
			if (get_upgrade_cost(i) <= gold)
			{
				other.upgrade_available = true;
				break;
			}
			else if (i+1 == UPGRADE.last)
				other.upgrade_available = false;
		}
	}
}

check_for_upgrades();