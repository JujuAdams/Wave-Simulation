/// @param float
/// @param returnArray

var _float = clamp(argument0, 0.0, 1.0);

var _r =        1.0 * _float;
var _g =      255.0 * _float;
var _b =    65025.0 * _float;
var _a = 16581375.0 * _float;

_r = frac(_r);
_g = frac(_g);
_b = frac(_b);
_a = frac(_a);

_r -= _g/255;
_g -= _b/255;
_b -= _a/255;
_a -= _a/255;

_r *= 255;
_g *= 255;
_b *= 255;

if (argument1)
{
    return [make_colour_rgb(_r, _g, _b), _a];
}
else
{
    _a *= 255;
    return ((_a << 24) + (_b << 16) + (_g << 8) + _r);
}