/// @description Insert description here
// You can write your code in this editor
time++;

if (!global.is_host)
{
	if (time >= 60)
	{
		time = 0;	
		
		//Request chunk
		send_data({cmd: "request_chunk", x: x, y: y});
	}
}