// dimensions in mm
//
$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;

bar_width = 30;
clip_dia = 8.3; // diameter of pannier bar
overall_height = 90; //
plate_thickness = 10;

module hook() {
    difference() {
        hull() {
            translate([0,plate_thickness + 12 + clip_dia/2,0])
            cylinder(d = clip_dia, h = bar_width);
            translate([-19,21,0])
            cylinder(d = clip_dia, h = bar_width);
        }
        lock_width = 15;
        translate([0,plate_thickness + 12 + clip_dia/2,0])
        translate([0,0,bar_width / 2 - lock_width/2])
        rotate_extrude(angle = 360, convexity = 2)
        translate([clip_dia/2, 0, 0])
        square(size = [8,lock_width], center = false);
    }    

    hull() {
        translate([-19,21,0])
        cylinder(d = clip_dia, h = bar_width);
        translate([-overall_height/2,plate_thickness,0])
        //cylinder(d = clip_dia*2, h = bar_width);
        cube([bar_width, .001, bar_width], center = false);
    }

}

// screw hole
module screw_hole(head_dia, body_dia) {
    depth = 50;
    cylinder(d = head_dia, h = depth);
    translate([0, 0, -depth])
    cylinder(d = body_dia, h = depth);
    // cone for drywall screws
    translate([0, 0, -body_dia])
    cylinder(d2 = head_dia, d1 = body_dia, h = body_dia);
}

module screws() {
    screw_head_dia = 9;
    screw_body_dia = 5;
    translate([-overall_height/2+screw_head_dia,10-1,bar_width/2]) rotate([-90,0,0]) {
        screw_hole(screw_head_dia, screw_body_dia);
        translate([overall_height-screw_head_dia*2,0,0]) screw_hole(screw_head_dia, screw_body_dia);
    }
}

module body() {
    hook();
    translate([-overall_height/2, 0, 0])
    cube([overall_height, plate_thickness/2, bar_width]);
    hull() {
        translate([overall_height/2-plate_thickness/2,plate_thickness/2,0])
        cylinder(d = plate_thickness, h = bar_width);
        translate([-overall_height/2, 0, 0])
        cube([1, plate_thickness, bar_width]);
    }
}
module side() {
    hull() {
        translate([-overall_height/2, 0, 0])
        cube([overall_height, plate_thickness/2, bar_width/4]);
        translate([overall_height/2-plate_thickness/2,plate_thickness/2,0])
        cylinder(d = plate_thickness, h = bar_width/4);
        translate([-overall_height/2, 0, 0])
        cube([1, plate_thickness, bar_width/4]);
        translate([0,plate_thickness + 12 + clip_dia/2,0])
        cylinder(d = clip_dia, h = bar_width/4);
        translate([-19,21,0])
        cylinder(d = clip_dia, h = bar_width/4);
    }
}
translate([0,0,bar_width])
side();
translate([0,0,-bar_width/4])
side();

difference() {
    body();
    screws();
}

