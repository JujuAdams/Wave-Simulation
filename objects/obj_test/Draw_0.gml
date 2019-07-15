var _x_scale = water_width / water_resolution;

//Keep surface alive
if (!surface_exists(water_surface_src ))
{
    water_surface_src = surface_create(water_resolution, 2);
    surface_set_target(water_surface_src);
    draw_clear_alpha(make_color_rgb(127, 127, 127), 127/255);
    surface_reset_target();
}

if (!surface_exists(water_surface_dest)) water_surface_dest = surface_create(water_resolution, 2);


if (water_play)
{
    //Make splashes
    if (mouse_check_button_pressed(mb_any))
    {
        var _x1 = (mouse_x - 15) div _x_scale;
        var _x2 = (mouse_x + 15) div _x_scale;
        var _y  = clamp((mouse_y - 100)/600, 0.001, 0.999);
        var _rgba_array = float_to_rgba(_y, true);
        
        surface_set_target(water_surface_src);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        draw_set_colour(_rgba_array[0]);
        draw_set_alpha(_rgba_array[1]);
        draw_line(_x1-3, 0, _x2+3, 0); //Make splashes bigger than a single pixel
        gpu_set_blendmode(bm_normal);
        draw_set_colour(c_white);
        draw_set_alpha(1.0);
        surface_reset_target();
    }
}
else
{
    //Draw waves
    if (mouse_check_button(mb_any))
    {
        var _x = mouse_x div _x_scale;
        var _y = clamp((mouse_y - 100)/600, 0.001, 0.999);
        var _rgba_array = float_to_rgba(_y, true);
        
        surface_set_target(water_surface_src);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        draw_set_colour(_rgba_array[0]);
        draw_set_alpha(_rgba_array[1]);
        draw_point(_x, 0);
        gpu_set_blendmode(bm_normal);
        draw_set_colour(c_white);
        draw_set_alpha(1.0);
        surface_reset_target();
    }
}

//Debug draw surface
draw_surface_ext(water_surface_src, 0, 0, _x_scale, 10, 0, c_white, 1.0);
shader_set(shd_water_debug);
draw_surface_ext(water_surface_src, 0, 20, _x_scale, 10, 0, c_white, 1.0);
shader_reset();

//Perform one step of water simulation
if (water_play || keyboard_check_pressed(ord("S")))
{
    var _old_tex_filter = gpu_get_tex_filter();
    gpu_set_tex_filter(false);
    surface_set_target(water_surface_dest);
    shader_set(shd_water_step);
    var _texture = surface_get_texture(water_surface_dest);
    shader_set_uniform_f(shader_get_uniform(shd_water_step, "u_fWind"), water_wind? 0.001 : 0.0);
    shader_set_uniform_f(shader_get_uniform(shd_water_step, "u_fTime"), current_time/1000);
    shader_set_uniform_f(shader_get_uniform(shd_water_step, "u_fTexelX"), texture_get_texel_width(_texture));
    gpu_set_blendmode_ext(bm_one, bm_zero);
    draw_surface(water_surface_src, 0, 0);
    gpu_set_blendmode(bm_normal);
    shader_reset();
    surface_reset_target();
    gpu_set_tex_filter(_old_tex_filter);
    
    //Swap source and destination surfaces
    var _temp = water_surface_src;
    water_surface_src  = water_surface_dest;
    water_surface_dest = _temp;
}

//Draw output
var _old_tex_filter = gpu_get_tex_filter();
gpu_set_tex_filter(true);
shader_set(shd_water_draw);
draw_surface_ext(water_surface_src, 0, 100, _x_scale, 300, 0, c_white, 1.0);
shader_reset();
gpu_set_tex_filter(_old_tex_filter);

//Draw info text
var _x = 10;
var _y = 50;
var _string  = "Fragment Shader Water Simulation";
    _string += "\n@jujuadams    2019/07/15";
    _string += "\n(fps=" + string(fps) + " / real=" + string(smoothed_fps_real) + ")\n";
    _string += "\n<mouse> : " + (water_play? "Splash" : "Draw wave");
    _string += "\n<space> : " + (water_play? "Running" : "Paused");
    _string += "\n<W> : " + (water_wind? "Wind on" : "Wind off");
    if (!water_play) _string += "\n<S> : Step simulation";

draw_set_colour(c_black);
draw_text(_x + 1, _y    , _string);
draw_text(_x    , _y - 1, _string);
draw_text(_x - 1, _y    , _string);
draw_text(_x    , _y + 1, _string);
draw_set_alpha(0.5);
draw_text(_x, _y + 2, _string);
draw_set_colour(c_white);
draw_set_alpha(1.0);
draw_text(_x, _y, _string);
