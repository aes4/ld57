//1440
//810
//room_goto(pre)
randomize()
room_goto(mm)
mapmulitplier = 8
o = 8 * mapmulitplier  // dsgridoffset for negatives
mapmulitplier = 8
mw = 17  // map width
mw = ((mw - 1) * mapmulitplier) + 1
wmap = ds_grid_create(16, 16) // world map
nmap = ds_grid_create(mw, mw)  // new blank map
ds_grid_set_region(nmap, -o+o, -o+o, o+o, o+o, 0)
map = nmap  // current map
rrw = 46080
rrh = 25920
hrrw = 23040
hrrh = 12960
px = 46080 / 2 // 2880
py = 25920 / 2 // 1620
calctime = (60*15)/10
halfvpw=1440  // half viewport width
halfvph=810
breaktimer = 60*1  // 60*1  // if change here change in code
breakanimtimer = breaktimer/3
currentblock = "None"
invslot = "1"
idirt = 0
iwire = 50
iserver = 0
mon = 0
health = 60*3
mainx = -1
mainy = -1
clients = 0
iii = noone
nextstep = false
currentroom = "mm"
vol = 1/2
a = audio_play_sound(alol, 1, true)
audio_sound_gain(a, vol, 0)


// player movement vars
// need vars g, h, v, dh, um, hm, gain, hops, r, l, s, ss, c
// 0.2, 0(init), 0(i), 4, -7, 1, 1/100, false(i), r-c = false
dir = 2
vel = 0
velstart = 15
velcap = 28
velinc = 1 + (1/2)
g = 1
h = 0
v = 0
dh = 16
um = -31  // 28
hm = 1
gain = 1/100  // 200 just for testing 80 for final
hops = false
r = false
s = false
sss = false
c = false
/*hardcoded map elements
e
eeeseeeb
  3    4
*/
/*
i = 0
repeat (ds_grid_width(map)) {
    ds_grid_set(map, i, 5, 1)
    i += 1
}
*/
for (i = o-2; i < o+8; i++) { ds_grid_set(map, i, o-2, 4) }
for (i = o-2; i < o+8; i++) { ds_grid_set(map, i, o-1, 7) }
for (i = o-2; i < o+8; i++) { ds_grid_set(map, i, o-0, 7) }
for (i = o-2; i < o+8; i++) { ds_grid_set(map, i, o+1, 4) }
ds_grid_set(map, o+8, o-2, 4)
ds_grid_set(map, o+8, o-1, 4)
ds_grid_set(map, o+8, o-0, 4)
ds_grid_set(map, o+8, o+1, 4)
ds_grid_set(map, o+2, o, 11)  //server on this grid on map
ds_grid_set(map, o+6, o, 5)

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

gc(map, o-10, o)
gc(map, o-10, o+4)
repeat 50 {
    gc(map, o+irandom_range(-(8*5), 8*5), o+irandom_range(-(8*5), 8*5)) //i know its prob in the corners
}
// gen more randomly
//buttons
bshop = false
start = false
circle = false
quit = false
/*map legend
(r)solid
(e)empty
(+)wire
(c)client
(s)server
(b)shop*/
/*map data
0 bdirt+dirt
1 bdirt
2 bdirt+wire
3 bdirt+server
4 bmet+met
5 bmet+shop
6 bmet+dirt
7 bmet
8 bmet+wire
9 bmet+client
10 bmet+server */
//5760
//3240
//46080
//25920