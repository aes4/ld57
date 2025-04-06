/* tdl:
    do buttons
*/
if nextstep {
    instance_create_layer(2555, 1555, "Instances", oplr)
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
/* some ld56 code
if quit { game_end() }
if keyboard_check(vk_escape) { game_end() }
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
/* some ld56 code