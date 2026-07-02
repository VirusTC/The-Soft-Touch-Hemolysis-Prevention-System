// --- DESIGN CONFIGURATION ---
$fn = 120; // High resolution for smooth motion

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

// 🔩 RETENTION PLATE HARDWARE (Sized for standard US 2-56 or 4-40 screws)
screw_hole_d = 2.4;            // Clearance hole for retention fasteners

// --- MODULE: HYBRID SPRING-LOADED ROTOR HUB ---
module spring_loaded_rotor_hub() {
    difference() {
        union() {
            // Main drive block collar
            cylinder(h = rotor_thickness, d = metal_core_width + 12, center = true);
            
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
        
        // 2. Linear Slots, Spring Pockets, and Fastener Holes
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
                
                // Fastener Thread Holes to secure the top retention plate
                translate([rotor_radius - slot_length - (spring_pocket_l) - 3, 0, 0])
                    cylinder(h = rotor_thickness + 2, d = screw_hole_d, center = true);
            }
        }
    }
}

// --- MODULE: TOP RETENTION PLATE ---
// Use this to cap the assembly and lock the pins vertically in the tracks
module retention_plate() {
    difference() {
        // Flat matching profile disk
        cylinder(h = 2.0, d = (rotor_radius + 8) * 2, center = true);
        
        // Center shaft clear hole
        cylinder(h = 5, d = metal_core_width + 2, center = true);
        
        // Radial clear slots matching the underlying pin travel track
        for (i = [0 : number_of_rollers - 1]) {
            rotate([0, 0, i * (360 / number_of_rollers)]) {
                // Precision slot for the tip of the moving axle pin
                translate([rotor_radius - (slot_length/2), 0, 0])
                    hull() {
                        translate([-slot_length/2, 0, 0]) cylinder(h = 10, d = axle_pin_d + 0.2, center = true);
                        translate([slot_length/2, 0, 0]) cylinder(h = 10, d = axle_pin_d + 0.2, center = true);
                    }
                // Screw clearance holes
                translate([rotor_radius - slot_length - (spring_pocket_l) - 3, 0, 0])
                    cylinder(h = 10, d = screw_hole_d + 0.3, center = true);
            }
        }
    }
}

// --- VISUALIZATION RENDERING ---
// Separated vertically to display the sandwich design architecture
color("SlateGray") spring_loaded_rotor_hub();

// Ghosted representation of the surgical steel core block inside the hub center
translate([0, 0, -2]) 
    %color("Silver", 0.5) cube([metal_core_width - 0.2, metal_core_width - 0.2, metal_core_depth], center = true);

// Top retention cap plate shown lifted up for visualization clarity
translate([0, 0, (rotor_thickness/2) + 4]) 
    color("LightSteelBlue", 0.7) retention_plate();
