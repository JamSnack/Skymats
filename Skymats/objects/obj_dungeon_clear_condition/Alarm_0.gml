/// @description Delayed create event
if (instance_exists(watch_this1))
	ds_list_add(inst_list, watch_this1);
	
if (instance_exists(watch_this2))
	ds_list_add(inst_list, watch_this2);
	
number_of_watching = ds_list_size(inst_list);
show_debug_message("watch_list initialized");