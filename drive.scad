// --- CUSTOMIZABLE PERFORMANCE PARAMETERS ---
$fn = 100;                      // Resolution

// Rotor Core Settings
motor_shaft_diameter = 5.0;    // Matches your motor shaft (e.g., NEMA 17)
rotor_radius = 25.0;           // Distance from center to roller axle center
rotor_thickness = 12.0;        // Total height of the rotor assembly

// Roller Wheel Settings (Based on your math)
roller_outer_diameter = 16.0;  // Outside diameter of your soft wheel
roller_inner_diameter = 4.0;   // Axle pin diameter (rigid core)
number_of_rollers = 3;         // Number of occlusion points (3-4 is typical)

// --- MODULE: COMPLIANT ROLLER WHEEL ---
// Export this separately to cast/mold your soft material
module roller_wheel() {
    difference() {
        cylinder(h = rotor_thickness - 0.5, d = roller_outer_diameter, center = true);
        cylinder(h = rotor_thickness + 1.0, d = roller_inner_diameter, center = true);
    }
}

// --- MODULE: MAIN ROTOR HUB ---
module rotor_hub() {
    difference() {
        union() {
            // Central drive collar
            cylinder(h = rotor_thickness, d = motor_shaft_diameter + 8, center = true);
            
            // Radiating arms to support the roller axles
            for (i = [0 : number_of_rollers - 1]) {
                rotate([0, 0, i * (360 / number_of_rollers)]) {
                    translate([0, 0, 0])
                        cube([rotor_radius, roller_inner_diameter + 4, rotor_thickness], center = true);
                    translate([rotor_radius, 0, 0])
                        cylinder(h = rotor_thickness, d = roller_inner_diameter + 4, center = true);
                }
            }
        }
        
        // D-Shaft / Round Motor Bore
        cylinder(h = rotor_thickness + 2, d = motor_shaft_diameter, center = true);
        
        // Axle holes for the rollers
        for (i = [0 : number_of_rollers - 1]) {
            rotate([0, 0, i * (360 / number_of_rollers)]) {
                translate([rotor_radius, 0, 0])
                    cylinder(h = rotor_thickness + 2, d = roller_inner_diameter, center = true);
            }
        }
    }
}

// --- VISUALIZATION ASSEMBLY ---
// Main drive hub
color("SlateGray") rotor_hub();

// Ghosted rollers shown in position
for (i = [0 : number_of_rollers - 1]) {
    rotate([0, 0, i * (360 / number_of_rollers)]) {
        translate([rotor_radius, 0, 0])
            color("Tomato", 0.8) roller_wheel(); // Soft wheels
    }
}
