// --- DESIGN CONFIGURATION ---
$fn = 120; // High resolution for smooth motion and threads

// Rotor Structural Dimensions
rotor_thickness = 14.0;         // Total height of the rotor block
rotor_radius = 26.0;            // Maximum travel radius for the axle pin
number_of_rollers = 3;          // 3-roller design for stable occlusion

// 🔩 SPRING-LOADED SLOT SPECIFICATIONS
slot_length = 4.0;             // Total travel distance allowed for housing clearance
axle_pin_d = 3.0;              // Ground stainless steel pin diameter (matches US bearing ID)
spring_pocket_w = 4.5;         // Pocket width for compression spring
spring_pocket_l = 8.0;         // Pocket length for spring pre-load

// ⚙️ SURGICAL STEEL CORE SPECIFICATIONS
metal_core_width = 16.0;       // Width of square metal core block
metal_core_depth = 10.0;       // Depth/thickness of the metal insert
motor_shaft_bore = 5.0;        // Clearance for NEMA shaft through the center

// 🔩 FASTENER HARDWARE (Standard M3 Metrics)
m3_clearance_d = 3.2;         // Smooth bore for M3 screw pass-through
m3_tap_d = 2.5;               // Pilot bore for tapping M3 threads directly into plastic

// 🔩 INTEGRATED THREADED COLLET CONFIGURATION
collet_height = 10.0;          // Height of the clamping sleeve above the plate
collet_max_od = 12.0;          // Base diameter of the tapered cone
collet_min_od = 9.5;           // Top diameter of the tapered cone
collet_slots = 4;              // Number of expansion/compression relief slits
collet_slot_w = 1.2;           // Width of the compression slits

// --- MODULE: HYBRID M3 SPRING-LOADED ROTOR HUB ---
module m3_spring_loaded_rotor_hub() {
    difference() {
        union() {
            // Main drive block collar
            cylinder(h = rotor_thickness, d = metal_core_width + 14, center = true);
            
            // Radiating structural arms with linear guides
            for (i = [0 : number_of_rollers - 1]) {
                rotate([0, 0, i * (360 / number_of_rollers)]) {
                    translate([rotor_radius/2, 0, 0])
                        cube([rotor_radius, axle_pin_d + 10, rotor_thickness], center = true);
                    translate([rotor_radius, 0, 0])
                        cylinder(h = rotor_thickness, d = axle_pin_d + 10, center = true);
                }
            }
        }
        
        // 1. Central Pocket for Surgical Steel Core Insert (Square Profile)
        cube([metal_core_width, metal_core_width, metal_core_depth * 2], center = true);
        
        // Through-bore for the motor drive shaft
        cylinder(h = rotor_thickness + 2, d = motor_shaft_bore, center = true);
        
        // 2. Linear Slots, Spring Pockets, and M3 Thread Pathways
        for (i = [0 : number_of_rollers - 1]) {
            rotate([0, 0, i * (360 / number_of_rollers)]) {
                
                // Axle Pin Slide Slot (Allows pin to move radially)
                translate([rotor_radius - (slot_length/2), 0, 0])
                    hull() {
                        translate([-slot_length/2, 0, 0]) cylinder(h = rotor_thickness + 2, d = axle_pin_d, center = true);
                        translate([slot_length/2, 0, 0]) cylinder(h = rotor_thickness + 2, d = axle_pin_d, center = true);
                    }
                
                // Internal Compression Spring Chamber
                translate([rotor_radius - slot_length - (spring_pocket_l/2), 0, 0])
                    cube([spring_pocket_l, spring_pocket_w, rotor_thickness - 4], center = true);
                
                // Fastener Pilot Holes (Tapped to M3 on assembly)
                translate([rotor_radius - slot_length - (spring_pocket_l) - 3, 0, 0])
                    cylinder(h = rotor_thickness + 2, d = m3_tap_d, center = true);
            }
        }
    }
}

// --- MODULE: TOP RETENTION PLATE WITH INTEGRATED EXPANSION COLLET ---
module collet_retention_plate() {
    plate_thickness = 3.0;
    
    difference() {
        union() {
            // Main Flat Matrix Plate
            cylinder(h = plate_thickness, d = (rotor_radius + 8) * 2, center = true);
            
            // Rising Clamping Collet Sleeve (Tapered Cone)
            translate([0, 0, plate_thickness/2])
                cylinder(h = collet_height, d1 = collet_max_od, d2 = collet_min_od, center = false);
        }
        
        // Continuous central drive shaft bore passing through plate and collet sleeve
        translate([0, 0, -5])
            cylinder(h = collet_height + plate_thickness + 10, d = motor_shaft_bore + 0.2, center = false);
        
        // Radial clear slots matching the underlying pin travel track
        for (i = [0 : number_of_rollers - 1]) {
            rotate([0, 0, i * (360 / number_of_rollers)]) {
                // Precision slot for moving axle pin
                translate([rotor_radius - (slot_length/2), 0, 0])
                    hull() {
                        translate([-slot_length/2, 0, 0]) cylinder(h = 20, d = axle_pin_d + 0.2, center = true);
                        translate([slot_length/2, 0, 0]) cylinder(h = 20, d = axle_pin_d + 0.2, center = true);
                    }
                // M3 Smooth Clearance Screwholes
                translate([rotor_radius - slot_length - (spring_pocket_l) - 3, 0, 0])
                    cylinder(h = 20, d = m3_clearance_d, center = true);
            }
        }
        
        // Cutting the Compression Relief Slits into the Collet Sleeve
        for (j = [0 : collet_slots - 1]) {
            rotate([0, 0, j * (360 / collet_slots)])
                translate([0, 0, plate_thickness])
                    cube([collet_max_od + 2, collet_slot_w, collet_height + 2], center = false);
        }
    }
}

// --- VISUALIZATION RENDERING ---
color("SlateGray") m3_spring_loaded_rotor_hub();

// Ghosted representation of the surgical steel core block inside the hub center
translate([0, 0, -2]) 
    %color("Silver", 0.5) cube([metal_core_width - 0.2, metal_core_width - 0.2, metal_core_depth], center = true);

// Top retention cap plate with collet mechanism shown lifted up for visualization clarity
translate([0, 0, (rotor_thickness/2) + 6]) 
    color("LightSteelBlue", 0.8) collet_retention_plate();
