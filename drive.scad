// --- DESIGN CONFIGURATION ---
$fn = 120; // High resolution for smooth surfaces

// Wheel Dimensions (Matches the rotor kit specifications)
wheel_od = 16.0;         // Outside diameter of rubber wheel
wheel_height = 11.5;     // Total height of the rubber wheel

// Bearing Pocket Dimensions (Sized for a press-fit)
bearing_od = 6.0;        // Outer diameter of bearing
bearing_depth = 2.5;     // Thickness of bearing
center_pin_d = 3.5;      // Inner hole diameter (clearance for axle pin)

// Mold Parameters
mold_wall = 5.0;         // Thickness of the mold walls
alignment_pin_d = 3.0;   // Pins to align the two mold halves

// --- VISUALIZATION SELECTOR ---
// Change this variable to preview different parts: "assembly", "top_half", "bottom_half"
mold_view = "assembly";

module wheel_positive() {
    // This is the shape the rubber will take
    difference() {
        cylinder(h = wheel_height, d = wheel_od, center = true);
        // Center pin core
        cylinder(h = wheel_height + 2, d = center_pin_d, center = true);
        // Top bearing seat
        translate([0, 0, (wheel_height/2) - (bearing_depth/2) + 0.01])
            cylinder(h = bearing_depth + 0.02, d = bearing_od, center = true);
        // Bottom bearing seat
        translate([0, 0, -((wheel_height/2) - (bearing_depth/2) + 0.01)])
            cylinder(h = bearing_depth + 0.02, d = bearing_od, center = true);
    }
}

module mold_half(is_top = true) {
    mold_size_d = wheel_od + (mold_wall * 2);
    mold_height = (wheel_height / 2) + mold_wall;
    
    difference() {
        // Main block of the mold
        translate([0, 0, mold_height / 2])
            cylinder(h = mold_height, d = mold_size_d, center = true);
        
        // Subtract half of the wheel positive
        translate([0, 0, is_top ? 0 : 0])
            wheel_positive();
            
        // Cutout for the pouring/vent gate (only needed in the top half)
        if (is_top) {
            translate([0, 0, mold_height - 2])
                cylinder(h = mold_wall + 2, d1 = 2, d2 = 6, center = true);
        }
        
        // Registration/Alignment holes (4 corners/sides)
        for (a =) {
            rotate([0, 0, a])
                translate([(mold_size_d / 2) - (mold_wall / 2), 0, mold_height / 2])
                    cylinder(h = mold_height + 2, d = alignment_pin_d, center = true);
        }
    }
}

// --- RENDERING LOGIC ---
if (mold_view == "assembly") {
    // Visualized as open so you can see the cavity inside
    color("LightGray", 0.6) mold_half(is_top = false);
    translate([0, 0, 15]) color("DarkGray", 0.6) rotate([180, 0, 0]) mold_half(is_top = true);
    translate([0, 0, 0]) color("Amber", 0.9) wheel_positive(); // The resulting latex wheel
} else if (mold_view == "top_half") {
    mold_half(is_top = true);
} else if (mold_view == "bottom_half") {
    mold_half(is_top = false);
}
