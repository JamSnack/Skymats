/// @description Drop associted item

instance_create_layer(x, y, "Instances", obj_item, { item_id: item_id });
audio_play_sound_in_world(break_sound, 10, false, false, x, y);
