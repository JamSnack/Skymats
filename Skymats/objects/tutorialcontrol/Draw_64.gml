/// @description Insert description here
// You can write your code in this editor
draw_set_halign(fa_center);

var _x = 1366/2;
var _y = 200;

switch stage
{
	case 0:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Use WASD to move. Jump with W or SPACE.");
		draw_text_scribble(_x, _y, "[font]Use [c_red]WASD[/c] to move. Jump with [c_red]W[/c] or [c_red]SPACE[/c].");
	}
	break;
	
	case 1:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Use LMB to activate your mining laser and break the tiles!");
		draw_text_scribble(_x, _y, "[font]Use [c_red]LMB[/c] to activate your [c_orange]mining laser[/c] and break the tiles!");
	}
	break;
		
	case 2:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Hold SHIFT to activate your airpack. Move in a direction to fly.");
		draw_text_scribble(_x, _y, "[font]Hold [c_red]SHIFT[/c] to activate your [c_orange]airpack[/c]. Move in a direction to fly.");
	}
	break;
	
	case 3:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Hold RMB to launch your grapple-claw. Try grappling to surfaces like the ceiling!");
		draw_text_scribble(_x, _y, "[font]Hold [c_red]RMB[/c] to launch your [c_orange]grapple-claw[/c]. Try grappling to surfaces like the ceiling!");
	}
	break;
	
	case 4:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Get close to the enemy to activate your auto-attack. You are vulnerable while it recharges.");
		draw_text_scribble(_x, _y, "[font]Get close to the [c_orange]enemy[/c] to activate your [c_red]auto-attack[/c]. You are vulnerable while it recharges.");
	}
	break;
	
	case 5:
	{
		draw_text_scribble(_x + 2, _y + 2, "[font][c_black]Fuel the SKYMAT and leave the facility!");
		draw_text_scribble(_x, _y, "[font]Fuel the [c_teal]SKYMAT[/c] and leave the facility!");
	}
	break;
}

//reset
draw_set_halign(fa_left);