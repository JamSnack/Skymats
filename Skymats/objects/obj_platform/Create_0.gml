/// @description
draw_fuel = 0;
fuel = 0;
max_fuel = 1500;
fuel_power_threshold = round(max_fuel*0.1);
fuel_efficieny = 0;
target_y = y;

obstruction = false;
waiting_for_pilot = false;
powered = false;
power_delay = 0;

show_engine_tutorial = false;

spawn_high_island_delay = 0;

alarm[0] = 10;

approach_dungeon = false;

//Handle platform-scope loading
load_expedition(networkingControl.exped_name + ".exped");

//init_dungeon_load();