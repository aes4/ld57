//room_goto(pre)
room_goto(mm)
o = 8  // dsgridoffset for negatives
wmap = ds_grid_create(16, 16) // world map
nmap = ds_grid_create(17, 17)  // new blank map
ds_grid_set_region(nmap, -8+o, -8+o, 8+o, 8+o, 0)
map = nmap  // current map
px = 2880
py = 1620
nextstep = false
currentroom = "mm"
// player movement vars
// need vars g, h, v, dh, um, hm, gain, hops, r, l, s, ss, c
// 0.2, 0(init), 0(i), 4, -7, 1, 1/100, false(i), r-c = false
g = 1
h = 0
v = 0
dh = 16
um = -31  // 28
hm = 1
gain = 1/200  // 200 just for testing 80 for final
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
ds_grid_set(map, o+2, o, 10)
ds_grid_set(map, o+6, o, 5)
//buttons
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