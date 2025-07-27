function Button(_x, _y, _text, _idx, _owner, _onFocus, _disabled=false) constructor {
    baseWidth = 120;
    baseHeight = 70;
    width = baseWidth;
    height = baseHeight;
    scale = 1;
    x = _x;
    y = _y;
    left = x - width / 2;
    right = x + width / 2;
    top = y - height / 2;
    bottom = y + height / 2;
    
    text = _text;
    
    focused = false;
    idx = _idx;
    owner = _owner;
    onFocus = _onFocus;
    disabled = _disabled;
    
    step = function() {
        if (disabled) return;
        var mouseInside = (mouse_x > left && mouse_x < right && mouse_y > top && mouse_y < bottom);
        if (mouseInside) {
            with (owner) {
                other.onFocus(other.idx);
            }
        }
    }
    
    draw = function(_x=x, _y=y, _scale=1) {
        draw_set_color(make_color_rgb(0, 166, 81));
        draw_rectangle(left, top, right, bottom, false);
        
        draw_set_color(focused ? make_color_rgb(255, 125, 199) : c_black);
        var w = 1 * scale;
        draw_rectangle(left, top, right, top + w, false);
        draw_rectangle(left, bottom - w, right, bottom, false);
        draw_rectangle(left, top, left + w, bottom, false);
        draw_rectangle(right - w, top, right, bottom, false);
        
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fTextBox);
        draw_text_transformed(x, y, text, 1/2 * scale, 1/2 * scale, 0);
        
        if (disabled) {
            draw_set_alpha(0.65);
            draw_rectangle(left, top, right, bottom, false);
            draw_set_alpha(1);
        }
    };
    
    update = function(_x, _y, _scale) {
        x = _x;
        y = _y;
        width = baseWidth * _scale;
        height = baseHeight * _scale;
        scale = _scale;
        
        left = x - width / 2;
        right = x + width / 2;
        top = y - height / 2;
        bottom = y + height / 2;
    }
}