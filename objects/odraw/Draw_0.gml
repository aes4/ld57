if instance_exists(oinv) {
    draw_text_transformed(op.px-op.halfvpw+320*3-(320/2), op.py-op.halfvph+128, string(op.idirt), 6, 6, 0)
    draw_text_transformed(op.px-op.halfvpw+320*4-((320/2)-15), op.py-op.halfvph+128, string(op.iwire), 6, 6, 0)
    draw_text_transformed(op.px-op.halfvpw+320*5-((320/2)-30), op.py-op.halfvph+128, string(op.iserver), 6, 6, 0)
    draw_text_transformed(op.px-op.halfvpw+320*7-(320/2), op.py-op.halfvph+128, "$: " + string(op.mon), 6, 6, 0)
}
/*
if instance_exists(ogecko) && op.mgarmour == false && op.mgswim == false {
    draw_text_transformed(ogecko.x + 320, ogecko.y - 300, "   stats:", 5, 5, 0)
    draw_text_transformed(ogecko.x + 320, ogecko.y - 200, "armour: " + string(op.armourstat) + "/3", 6, 6, 0)
    draw_text_transformed(ogecko.x + 320, ogecko.y - 100, "swimming:" + string(op.swimstat) + "/3", 6, 6, 0)
    draw_text_transformed(ogecko.x + 320, ogecko.y - 0, "speed:" + string(op.speedstat) + "/3", 6, 6, 0)
    draw_text_transformed(ogecko.x + 320, ogecko.y + 100, "fortitude:" + string(op.fortstat) + "/1", 6, 6, 0)
}
if op.dvol == true {
    draw_text_transformed(3780, 1400, "Volume:" + string(op.vol * 100) + "%", 7, 7, 0)
}
*/