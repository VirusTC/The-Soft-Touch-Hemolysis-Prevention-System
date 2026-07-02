// --- DESIGN CONFIGURATION ---
$fn = 120; // High resolution for smooth threads and sliding surfaces

// Scaled Shaft Parameters for Wheaton Chuck (0.3125" / 7.94mm Max)
motor_shaft_bore = 8.0;        // Clearance for up to 7.94mm surgical steel shafts

// Collet External Taper (Matches the retention plate sleeve)
collet_height = 10.0;          
collet_max_od = 16.0;          // Increased to accommodate larger 8mm bore
collet_min_od = 13.5;          
taper_angle = 7.0;             // Degree of clamping taper

// Nut Manufacturing Envelope
nut_height = 12.0;             // Total thickness of the hex nut
nut_flat_to_flat = 24.0;       // Wrench size (Standard metric wrench compatibility)

// --- MODULE: FEMALE COMPRESSION NUT ---
// Export this module independently as an STL for 3D printing
module compression_nut() {
    difference() {
        // 1. Outer Hexagonal Nut Body
        cylinder(h = nut_height, d = nut_flat_to_flat / cos(30), center = true, $fn = 6);
        
        // 2. Central Tapered Hole (Compresses the collet when threaded down)
        // Sized 0.2mm larger for mechanical clearance prior to tightening
        translate([0, 0, -nut_height/2 - 0.1])
            cylinder(h = nut_height + 0.2, d1 = collet_max_od + 0.2, d2 = collet_min_od + 0.2, center = false);
            
        // 3. Knurling / Finger Grips (Optional alternative to wrench flats)
        for (i = [0 : 12]) {
            rotate([0, 0, i * (360 / 12)])
                translate([nut_flat_to_flat/1.1, 0, 0])
                    cylinder(h = nut_height + 2, d = 2.0, center = true);
        }
    }
}

// --- MODULE: COMPLEMENTARY COLLET RETENTION PLATE (REVISED) ---
// Use this version to ensure compatibility with the updated 8mm nut dimensions
module scaled_collet_retention_plate() {
    plate_thickness = 3.0;
    rotor_radius = 26.0;
    axle_pin_d = 3.0;
    slot_length = 4.0;
    m3_clearance_d = 3.2;
    collet_slots = 4;
    collet_slot_w = 1.2;
    
    difference() {
        union() {
            // Main Matrix Plate
            cylinder(h = plate_thickness, d = (rotor_radius + 8) * 2, center = true);
            
            // Rising Tapered Clamping Sleeve (Matches Nut ID)
            translate([0, 0, plate_thickness/2])
                cylinder(h = collet_height, d1 = collet_max_od, d2 = collet_min_od, center = false);
        }
        
        // Continuous Through-Bore for Extended Wheaton Shafts (Passes completely through)
        translate([0, 0, -10])
            cylinder(h = collet_height + plate_thickness + 20, d = motor_shaft_bore, center = false);
        
        // Pin tracks and M3 screw clearance holes
        for (i = [0 : 2]) {
            rotate([0, 0, i * (360 / 3)]) {
                translate([rotor_radius - (slot_length/2), 0, 0])
                    hull() {
                        translate([-slot_length/2, 0, 0]) cylinder(h = 20, d = axle_pin_d + 0.2, center = true);
                        translate([slot_length/2, 0, 0]) cylinder(h = 20, d = axle_pin_d + 0.2, center = true);
                    }
                translate([rotor_radius - 15, 0, 0])
                    cylinder(h = 20, d = m3_clearance_d, center = true);
            }
        }
        
        // Expansion Relief Slits
        for (j = [0 : collet_slots - 1]) {
            rotate([0, 0, j * (360 / collet_slots)])
                translate([0, 0, plate_thickness])
                    cube([collet_max_od + 2, collet_slot_w, collet_height + 2], center = false);
        }
    }
}

// --- VISUALIZATION VIEW ---
// Render them separated along the Z-axis to inspect mating surfaces
color("LightSteelBlue") scaled_collet_retention_plate();

translate([0, 0, collet_height + 8])
    color("DarkOrange", 0.8) compression_nut();
