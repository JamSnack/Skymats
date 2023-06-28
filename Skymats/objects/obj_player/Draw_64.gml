/// @description Insert description here
// You can write your code in this editor
var _x = 2;
var _y = 2;

draw_rectangle_color(_x, _y, _x+300, _y+24, c_black, c_black, c_black, c_black, false);
draw_rectangle_color(_x+2, _y+2, _x+296*(draw_hp_red/max_hp), _y+22, c_red, c_red, c_red, c_red, false);
draw_rectangle_color(_x+2, _y+2, _x+296*(draw_hp/max_hp), _y+22, c_green, c_green, c_lime, c_lime, false);
/*
draw_text(10, 10, 
"Health: " + string(hp) + "/" + string(max_hp) + "\n" +
"X Speed: " + string(hspd) + "\n" +
"Y Speed: " + string(vspd) + "\n" +
"( " + string(x) + ", " + string(y) +" )\n" +
"Gold: " + string(gold)
);