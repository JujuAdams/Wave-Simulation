if (keyboard_check_released(vk_escape)) game_end();
if (keyboard_check_released(vk_space)) water_play = !water_play;
if (keyboard_check_released(ord("W"))) water_wind = !water_wind;

smoothed_fps_real = lerp(smoothed_fps_real, fps_real, 0.01);