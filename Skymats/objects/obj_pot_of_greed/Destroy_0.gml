/// @description Insert description here
// You can write your code in this editor


// Inherit the parent event
event_inherited();

var _p = instance_nearest(x, y, PLAYER);

if (_p != noone)
	instance_create_layer(x, y, "Instances", efct_greed, {target: _p.id});