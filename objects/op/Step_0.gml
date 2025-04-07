/* tdl:
    do buttons
*/

function out(str) {  // show_debug_message str
    show_debug_message(str)
}

function inste(obj) {  // instance_exists obj
    return instance_exists(obj)
}

function instd(obj) {  // instance_destroy obj
    instance_destroy(obj)
}


function pmr(o, x, y, to) {  // place_meeting_redo
    rx = x - o.x
    ry = y - o.y
    l = o.bbox_left + rx
    t = o.bbox_top + ry
    r = o.bbox_right + rx
    b = o.bbox_bottom + ry
    return (collision_rectangle(l, t, r, b, to, false, true) != noone);
}


function ns(n) {  // number to sprite
    u0 = "0"  // to do for later restructure switch cleaner
    u1 = "1"
    switch(n) {
        case 0:
            u0 = obdirt;
            u1 = odirt;
            break;
        case 1:
            u0 = obdirt;
            u1 = oi;
            break;
        case 2:
            u0 = obdirt;
            u1 = owire;
            break;
        case 3:
            u0 = obdirt;
            u1 = oserver;
            break;
        case 4:
            u0 = obmet;
            u1 = omet;
            break;
        case 5:
            u0 = obmet;
            u1 = oshop;
            break;
        case 6:
            u0 = obmet;
            u1 = odirt;
            break;
        case 7:
            u0 = obmet;
            u1 = oi;
            break;
        case 8:
            u0 = obmet;
            u1 = oarrow;
            break;
        case 9:
            u0 = obmet;
            u1 = owire;
            break;
        case 10:
            u0 = obmet;
            u1 = oclient;
            break;
        case 11:
            u0 = obmet;
            u1 = oserver;
            break;
    }
    return [u0, u1]; // thought i could return from the case but maybe not
}

if nextstep {
    for (i = 0; i < ds_grid_width(map); i++) {
        for (ii = 0; ii < ds_grid_height(map); ii++) {
            instance_create_layer(px+(i-o)*320, py+(ii-o)*320, "Instances", ns(ds_grid_get(map, i, ii))[0]) // yes i know to set ns to are so don't switch twice maybe later
            instance_create_layer(px+(i-o)*320, py+(ii-o)*320, "Instances", ns(ds_grid_get(map, i, ii))[1])
        }
    }
    instance_create_layer(px, py, "Instances", oplr)
    py -= 24
    oplr.y -= 24
    currentroom = "main"
    nextstep = false
}
if circle {
    oslidercircle.x = mouse_x
    if 2942 < oslidercircle.x && oslidercircle.x < 5200 {
        //vol = (oslidercircle.x - 2942) / (5200 - 2942)
        //audio_sound_gain(aud, vol, 0)
    }
    circle = false
}
if start {
    //dvol = false
    //audio_stop_sound(aud)
    //audd = audio_play_sound(amain, 2, true)
    //audio_sound_gain(audd, vol, 0)
    //et = true
    room_goto(main)
    nextstep = true
    start = false
}
if quit { game_end() }
if keyboard_check(vk_escape) { game_end() }  // remove before final verison
/* some ld56 code
if inc {
    vol += 0.1
    audio_sound_gain(aud, vol, 0)
    inc = false
}
if dec {
    vol -= 0.1
    audio_sound_gain(aud, vol, 0)
    dec = false
}
*/

function side(){
    // need vars g, h, v, dh, um, hm, gain, hops, r, l, s, ss, c
    // 0.2, 0(init), 0(i), 4, -7, 1, 1/100, false(i), r-c = false
    // grav, horizontal, vertical, default horizontal (speed)
    // upwards momentum, h multiplier, hmadd 2 = 2xspeed
    r = keyboard_check(ord("D"))  // change back to wasd when done
    l = keyboard_check(ord("A"))
    s = keyboard_check(vk_space)
    sss = keyboard_check_pressed(vk_space)
    c = keyboard_check(vk_shift)
    h = (r - l) * dh  // L
    //if c { sprite_index = splayerc
    //} else { sprite_index = splayer }
    //if sss {
        //i = audio_play_sound(a, 1, false)
        //audio_sound_gain(i, op.vol, 0)
    //}
    if hops {
        h = (r - l) * dh * hm
        hm += gain  // continually increasing speed as in air and (s)hop
        if c {
            hm -= 1/80
            if hm < 0.5 { hm = 0.5 }
            //if hm > 2 && gain > 1/800 { becomes too difficult too quickly
                //gain -= 1/1000
            //}
            // set equal to hm+ to gain speed and control and stay at that same
            // speed, set greater than to discourage holding shift
        }
    }
    v += g
    if pmr(oplr, px, py + 1, odirt) and !s and !c {
        if hm > 1 { hm -= 1/8 }
        hops = false
    }
    if pmr(oplr, px, py + 1, odirt) and s and !c {
        v = um
        if hm > 1 { hm -= 1/22 }  // this is here for bhop
        hops = false
    }
    if pmr(oplr, px, py + 1, odirt) and s and c {
        v = um
        hops = true
    }
    if pmr(oplr, px, py + 1, omet) and !s and !c {
        if hm > 1 { hm -= 1/8 }
        hops = false
    }
    if pmr(oplr, px, py + 1, omet) and s and !c {
        v = um
        if hm > 1 { hm -= 1/22 }  // this is here for bhop
        hops = false
    }
    if pmr(oplr, px, py + 1, omet) and s and c {
        v = um
        hops = true
    }
    d = sign(h)  // returns -1 or 1
    if pmr(oplr, px + h, py, odirt) {
        while !pmr(oplr, px + d, py, odirt) { px += d }
        h = 0
        if sss {
            v = um
            if hm > 2 { hm = 2 }  // hit wall stop momentum
        }
    }
    if pmr(oplr, px + h, py, omet) {
        while !pmr(oplr, px + d, py, omet) { px += d }
        h = 0
        if sss {
            v = um
            if hm > 2 { hm = 2 }  // hit wall stop momentum
        }
    }
    if d != 0 { image_xscale = d }  // sprite flips
    d = sign(v)
    if pmr(oplr, px, py + v, odirt) or pmr(oplr, px, py + v, omet) {
        while !pmr(oplr, px, py + d, odirt) and !pmr(oplr, px, py + d, omet) { py += d }
        v = 0
    }
    px += h
    py += v
}
if currentroom == "main" {
    side()
    oplr.x = px
    oplr.y = py
}