/// @description Insert description here
// You can write your code in this editor

if (room == Room2)
{
	if (keyboard_check_released(vk_numpad1))
	{
		event_user(0);
		room_goto(Room1);
	}
	else if (keyboard_check_released(vk_numpad2))
	{
		event_user(1);
		room_goto(Room1);
	}
}
else
{
	if (!global.is_host && global.client_id == -1 && global.multiplayer && current_time mod 4 == 0)
		send_data({cmd: "request_client_id"});
}