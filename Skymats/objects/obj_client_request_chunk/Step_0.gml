/// @description Insert description here
// You can write your code in this editor
time--;

if (!requested && !global.is_host)
{
	//Request chunk
	send_data({cmd: "request_chunk", x: x, y: y});
	
	requested = true;
}


//Request time-out
if (time <= 0)
{
	requested = false;
	time = 10*60;
}

//Move along
x += SCROLL_SPEED;