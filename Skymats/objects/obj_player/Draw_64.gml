/// @description Insert description here
// You can write your code in this editor
draw_rectangle_color(0, 0, 300, 24, c_black, c_black, c_black, c_black, false);
draw_rectangle_color(2, 2, 296*(hp/max_hp), 22, c_green, c_green, c_green, c_green, false);
/*
draw_text(10, 10, 
"Health: " + string(hp) + "/" + string(max_hp) + "\n" +
"X Speed: " + string(hspd) + "\n" +
"Y Speed: " + string(vspd) + "\n" +
"( " + string(x) + ", " + string(y) +" )\n" +
"Gold: " + string(gold)
);