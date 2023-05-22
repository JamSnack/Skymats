/// @description Clamp stuff

target_x = clamp(target_x, 0, display_get_gui_width() - width);
target_y = clamp(target_y, 0, display_get_gui_height() - height);
target_width = clamp(target_width, 32, display_get_gui_width());
target_height = clamp(target_height, 32, display_get_gui_height());