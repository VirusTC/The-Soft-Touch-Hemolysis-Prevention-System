// =========================================================================
// MODULE: HYBRID SPRING-LOADED ROTOR CHASSIS WITH SURGICAL STEEL POCKET
// =========================================================================
$fn = 120; 

// Rotor Structural Dimensions
rotor_thickness = 14.0;         // Total height of the rotor block
rotor_radius = 26.0;            // Maximum travel radius for the axle pin
number_of_rollers = 3;          // 3-roller configuration

// Spring-Loaded Slot Specifications
slot_length = 4.0;             // Total linear travel distance for housing clearance
axle_pin_d = 3.0;              // Ground surgical stainless steel pin diameter
spring_pocket_w = 4.5;         // Pocket width for compression spring
spring_pocket_l = 8.0;         // Pocket length for spring pre-load

// Surgical Steel Core Specifications
metal_core_width = 16.0;       // Width of square metal core block
metal_core_depth = 10.0;       // Depth/thickness of the metal insert
motor_shaft_bore = 8.0;        // Clean clearance for up to 7.94mm shafts

// Fastener Hardware (Standard M3 Metrics)
m3_tap_d = 2.5;               // Pilot bore for tapping M3 threads directly

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

// Render Main Hub Block
color("SlateGray") m3_spring_loaded_rotor_hub();

// Ghosted view of inside metal drive block cavity
translate([0, 0, -2]) 
    %color("Silver", 0.5) cube([metal_core_width - 0.2, metal_core_width - 0.2, metal_core_depth], center = true);
