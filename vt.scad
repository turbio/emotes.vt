screen_inset = 1;
screen_height = 35;
body_depth = 20;
body_width = 44;
lower_body_height = 13.5;

crt_cover_depth = 12;
crt_cover_side_angle = 30;

vent_p = 4;

bezel = 4;

emotions = [
	"uwu",
	"joy",
	"happy",
	"meh",
	"sad",
	"angry",
];

for (i = [0 : len(emotions)-1]) translate([(body_width+20)*i, 0, 0]) {
	intersection() {
		color([.5, .5, .5])
			translate([-21, 10, -7])
			rotate([90])
			linear_extrude(height=20)
			import(str("vector/", emotions[i], "_face.svg"));

		translate([body_width/2, 10+screen_inset, lower_body_height+screen_height/2]) cube([screen_height,20,20], center = true);
	}


	difference() {
		//body
		union() {
			// back thingy
			translate([0, body_depth, 0]) difference() {
				cube([body_width, crt_cover_depth, screen_height]);
				// left
				translate([0, 0, -10]) rotate([0, 0, 90-crt_cover_side_angle]) cube([100, 100, 100]);
				// right
				translate([body_width, 0, -10]) rotate([0, 0, crt_cover_side_angle]) cube([100, 100, 100]);

				// bottom
				translate([0, 0, 0]) rotate([-90+15, 0, 0]) cube([100, 100, 100]);
				// top
				translate([0, 0, screen_height]) rotate([-90+75, 0, 0]) cube([100, 100, 100]);
				}

				// lower body
				cube([body_width, body_depth, lower_body_height]);

				// screen
				translate([0, screen_inset, lower_body_height]) difference() {
				screen_dim = [body_width, body_depth-screen_inset, 32];
				cube(screen_dim);
				minkowski() {
					translate([bezel, 0, bezel]) cube([screen_dim.x - bezel*2, 2, screen_dim.z - bezel*2]);
					rotate([90, 0, 0]) cylinder(r=2, h=1, $fn=20);
				}
			}
		}

		// vents
		for (venty = [30, screen_height, 40])
			translate([-1, (body_depth)/2 + screen_inset/2, venty]) minkowski() {
				cube([3, (body_depth - screen_inset) - vent_p*2, 1], center=true);
				rotate([0, 90, 0]) cylinder(r=1, h=1, $fn=20);
			}

		// disk slot
		translate([32.5, -10, 8]) minkowski() {
			cube([7.5, 12, 1.5]);
			rotate([90, 0, 0]) cylinder(r=1, h=1, $fn=20);
		}
	}
}
