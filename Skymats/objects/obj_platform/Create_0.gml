/// @description
draw_fuel = 0;
fuel = 0;
max_fuel = 1500;
fuel_power_threshold = round(max_fuel*0.1);
fuel_efficieny = 0;
target_y = global.platform_height;
y = target_y+968;

obstruction = false;
waiting_for_pilot = false;
powered = false;
power_delay = 0;

show_engine_tutorial = true;

spawn_high_island_delay = 0;

alarm[0] = 10;

approach_dungeon = false;

fall_amount = 0;
fall_rate = 0;
fall_rate_max = 5;

//Handle platform-scope loading
//load_expedition(networkingControl.exped_name + ".exped");

//init_dungeon_load();