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


function cursordistance(x, y){  // if ok add later
    return point_distance(x, y, mouse_x, mouse_y)
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


function gc(map, ox, oy){  // generate client
    /* random offset?
    ssssss
    seeeee
    serece
    ssssss
    */
    yo = [
        [4, 4, 4, 4, 4, 4],
        [4, 7, 7, 7, 7, 7],
        [4, 7, 7, 7, 10, 7],
        [4, 4, 4, 4, 4, 4],
    ]
    for (i = 0; i < array_length(yo); i++) {
        for (ii = 0; ii < array_length(yo[0]); ii++) {
            mapv = yo[i][ii]
            ds_grid_set(map, ox + ii, oy + i, mapv)
        }
    }
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
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", oinv)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", odraw)
    currentroom = "main"
    nextstep = false
}
if circle {
    oslidercircle.x = mouse_x
    if (2880/2) < oslidercircle.x && oslidercircle.x < 2780 {
        vol = (oslidercircle.x - (2880/2)) / (2780 - (2880/2))
        audio_sound_gain(a, vol, 0)
    }
    circle = false
    if mouse_check_button_pressed(mb_left) && mouse_x > (2880/2) {
        oslidercircle.x = mouse_x - ((2880/1.5)+92)
    }
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
// if keyboard_check(vk_escape) { game_end() }  // remove before final verison
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
    if d != 0 { oplr.image_xscale = d }
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
if keyboard_check(ord("1")) {
    invslot = "1"
}
if keyboard_check(ord("2")) {
    invslot = "2"
}
if keyboard_check(ord("3")) {
    invslot = "3"
}
if keyboard_check(ord("4")) {
    invslot = "4"
}

if instance_exists(oslidercircle) {
    if mouse_check_button_pressed(mb_left) && mouse_x > (2880/2) {
        oslidercircle.x = mouse_x - ((2880/1.5)+92)
    }
}
if currentblock == "None" and mouse_check_button_pressed(mb_left) and cursordistance(px, py) < (320 * 1.5) and invslot == "1" {
    currentblock = instance_position(mouse_x, mouse_y, odirt)
    if currentblock == noone {
        currentblock = instance_position(mouse_x, mouse_y, owire)
    } else {  // autoclicker here breaks the game
        idirt += 1
    }
    if currentblock == noone {
        currentblock = instance_position(mouse_x, mouse_y, oserver)
    } else {
        iwire += 1
    }
}
if currentblock == -4 {
    currentblock = "None"
}
if currentblock != "None" {
    breaktimer -= 1
    if breaktimer < 0 {
        if currentblock != noone {
            instance_destroy(currentblock)
            currentblock = "None"
        }
        breaktimer = 60*1
    }
}
if mouse_check_button_pressed(mb_left) && place_meeting(mouse_x, mouse_y, obdirt) && invslot == "2" and cursordistance(px, py) < (320 * 1.5) and idirt > 0 {
    idk = instance_position(mouse_x, mouse_y, obdirt)
    instance_create_layer(idk.x, idk.y, "Instances", obdirt)
}
if mouse_check_button_pressed(mb_left) && place_meeting(mouse_x, mouse_y, obdirt) && invslot == "3" {
    clients += 1;
}
if mouse_check_button_pressed(mb_left) && invslot == "3" and cursordistance(px, py) < (320 * 1.5) and iwire > 0 {
    idk = instance_position(mouse_x, mouse_y, obdirt)
    if idk == -4 { idk = instance_position(mouse_x, mouse_y, obmet) }
    idkk = instance_create_layer(idk.x, idk.y, "Instances", owire)
    plsx = (idk.x - (px - o * 320)) div 320
    plsy = (idk.y - (py - o * 320)) div 320
    ds_grid_set(map, plsx, plsy, 2)
    //map
    // logic to make wire the right sprite, this code is so bad but I have no time to do it right
    t = instance_position(idk.x, idk.y-(320), owire)
    r = instance_position(idk.x+(320), idk.y, owire)
    b = instance_position(idk.x, idk.y+(320), owire)
    l = instance_position(idk.x-(320), idk.y, owire)
    if !t && !r && !b && !l { idkk.sprite_index = sw0
    } else if t && !r && !b && !l { idkk.sprite_index = swtdl  // incorrect sprite but I don't have the correct one fix later
    } else if !t && r && !b && !l { idkk.sprite_index = swrl
    } else if !t && !r && b && !l { idkk.sprite_index = swtdl  // same with this one
    } else if !t && !r && !b && l { idkk.sprite_index = swrl
    } else if !t && !r && b && l { idkk.sprite_index = swdl
    } else if t && !r && !b && l { idkk.sprite_index = swlu  // misnamed rip me
    } else if !t && r && b && !l { idkk.sprite_index = swrd
    } else if t && r && !b && !l { idkk.sprite_index = swtr  // there is more but who is gonna connect more than two wires together
    }
}
if mouse_check_button_pressed(mb_left) && invslot == "4" and cursordistance(px, py) < (320 * 1.5) and iserver > 0{
    idk = instance_position(mouse_x, mouse_y, obdirt)
    instance_create_layer(idk.x, idk.y, "Instances", oserver)
    plsx = (idk.x - (px - o * 320)) div 320
    plsy = (idk.y - (py - o * 320)) div 320
    ds_grid_set(map, plsx, plsy, 3)
}
if bshop == true {
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obshop)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obsell)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obbuy1)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obbuy2)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obbuy3)
    instance_create_layer(px-halfvpw, py-halfvpw, "Instances", obbuy4)
    bshop = false
}
calctime -= 1
if calctime < 0 {
    mon += clients * 15
    calctime = (60*15)/10
}
/*
calctime -= 1
if calctime < 0 {
    for (i = 0; i < mw; i++) {
        for (ii = 0; ii < mw; ii++) {
            if ds_grid_get(map, i, ii) == 11 {
                mainx = i
                mainy = ii
                break
            }
        }
        if mainx != -1 { break }
    }
    walk = ds_grid_create(mw, mw)
    ds_grid_set_region(walk, 0, 0, mw-1, mw-1, 0)

    thing = ds_list_create()
    ds_list_add(thing, mainx)
    ds_list_add(thing, mainy)
    clients = 0

    while(ds_list_size(thing) > 0) {
        fy = ds_list_find_value(thing, ds_list_size(thing) - 1)
        fx = ds_list_find_value(thing, ds_list_size(thing) - 2)
        ds_list_delete(thing, ds_list_size(thing) - 1)
        ds_list_delete(thing, ds_list_size(thing) - 1)

        if (fx < 0 || fy < 0 || fx >= mw || fy >= mw) {
            continue
        }
        if (ds_grid_get(walk, fx, fy)) {
            continue
        }
        tile = ds_grid_get(map, fx, fy)


        ds_grid_set(walk, fx, fy, 1)
        if tile == 10 {
            out("client found")
            clients += 1
            continue
        }
        if tile == 2 || tile == 9 || tile == 11 || tile == 10 {
            ds_list_add(thing, fx+1); ds_list_add(thing, fy)
            ds_list_add(thing, fx - 1); ds_list_add(thing, fy)
            ds_list_add(thing, fx); ds_list_add(thing, fy + 1)
            ds_list_add(thing, fx); ds_list_add(thing, fy - 1)
        }
    }
    ds_list_destroy(thing)
    ds_grid_destroy(walk)
    mon += clients * 15
    calctime = (60*15)/10
    clients = 0
}*/

if keyboard_check(ord("E")) {
    // minimap
    // was gonna be but now its jetpack
    topdown()
}

function topdown(){  // need vars dir, vel, velstart, velcap, velinc
    switch(keyboard_key){
        case ord("W"):
            if vel < velcap {
                vel += velstart
                vel *= velinc
            }
            py -= vel  // normally this is in a !place meeting check
            dir = 0
        break
        case ord("S"):
            if vel < velcap {
                vel += velstart
                vel *= velinc
            }
            py += vel  // normally this is in a !place meeting check
            dir = 2
            //sprite_index = splayerd
        break
        case ord("A"):
            if vel < velcap {
                vel += velstart
                vel *= velinc
            }
            px -= vel  // normally this is in a !place meeting check
            dir = 3
            //sprite_index = splayerl
        break
        case ord("D"):
            if vel < velcap {
                vel += velstart
                vel *= velinc
            }
            px += vel  // normally this is in a !place meeting check
            dir = 1
            //sprite_index = splayerr
        break
    }
    oplr.x = px
    oplr.y = py
}

if currentroom == "main" {
    side()
    oplr.x = px
    oplr.y = py
    oinv.x = px-halfvpw
    oinv.y = py-halfvph
    if instance_exists(obshop) {
        obshop.x = px-halfvpw
        obshop.y = py-halfvph
        obsell.x = px-halfvpw
        obsell.y = py-halfvph
        obbuy1.x = px-halfvpw+1700
        obbuy1.y = py-halfvph+500
        obbuy2.x = px-halfvpw+1700
        obbuy2.y = py-halfvph+200+500
        obbuy3.x = px-halfvpw+1800
        obbuy3.y = py-halfvph+800
        obbuy3.x = px-halfvpw+1700
        obbuy3.y = py-halfvph+80+800
        obbuy4.x = px-halfvpw+1700
        obbuy4.y = py-halfvph+220+800
    }
}