/// @description show some numbers
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(150,5,"instances: " + string(instance_count) + "  ( including the controller )");
draw_text(150,25,"Speed: " + string(global.speed) + "  [ left-- & right++ ]");


draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(5,5,room_get_name(room));

