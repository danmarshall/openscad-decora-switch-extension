/*
Decora Switch Extension
https://github.com/danmarshall/openscad-decora-switch-extension
License: Apache 2.0
*/

use <node_modules/openscad-sliding-bolt/sliding-bolt.scad>;

inner_radius = 7;
travel = 35;
spacing = 96.8375;
height = 6;
standoff = 7;
decora_switch_face = 2;
handle_length = 13;
handle_height = 8;
handle_fillet = 3;
handle_radius = 4;

module main() {
	$fn = 25;
	
	outer_radius = height / 2 + inner_radius + 1.5;
	square = 2 * outer_radius;

	module tcube(x, y, z, tx = 0, ty = 0, tz = 0) {
		translate([tx, ty, tz]) {
			cube([x, y, z]);
		}
	}

	module ccube(x, y, z, ty, tz) {
		tcube(x, y, z, -x / 2, ty, tz);
	}

	module mirror2(v = [1, 0, 0]) {
		children();
		mirror(v) {
			children();
		}
	}

	module slider(action) {
		slidingbolt(travel, inner_radius, height, 1, 0.2, 2, 2.6, standoff, action);
	}

	module roundedslidertracks() {
		difference() {
			union() {
				translate([-outer_radius, -outer_radius, 0]) {
					cube([square, travel + outer_radius + spacing, height]);
				}

				translate([0, spacing + travel, 0]) {
					cylinder(r = outer_radius, h = height);
				}
			}

			slider("track");

			translate([0, spacing, 0]) {
				slider("track");
			}
		}
	}

	module slidemount() {
		rotate([0, 0, 180]) {
			translate([0, outer_radius, 0]) {
				roundedslidertracks();

				translate([0, travel, 0]) {
					slider("bolt");
				}

				translate([0, spacing, 0]) {
					slider("bolt");
				}
			}
		}
	}

	module decoratouch() {
		r = standoff - decora_switch_face;
		translate([0, 0, height]) {
			rotate([0, 90, 0]) {
				cylinder(h = square, r = r, center = true);
			}
		}
	}

	module handle() {
		translate([0, handle_height, 0]) {
			difference() {
				ccube(square + 2 * handle_fillet, handle_fillet + 1, height);

				mirror2() {
					translate([outer_radius + handle_fillet, 0, 0]) {
						cylinder(r = handle_fillet, h = height);
					}
				}
			}
			hull() {
				mirror2() {
					translate([outer_radius + handle_length, handle_fillet + handle_radius, 0]) {
						cylinder(r = handle_radius, h = height);
					}
				}
			}
		}
		ccube(square, handle_height + 1, height, -.01);
	}

	translate([0, outer_radius + travel + (spacing - travel) / 2, 0]) {
		slidemount();
		handle();
	}

	decoratouch();

}

main();
