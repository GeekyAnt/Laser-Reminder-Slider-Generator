// ========================================
// REMINDER BOARD - OPENSCAD MODEL
// ========================================
//
// Laser Reminder Slider Generator
// Parametric design for laser-cut reminder boards with sliding indicators
//
// Copyright (c) 2025 Alex
//
// This project is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Repository: https://github.com/[your-username]/laser-reminder-slider-generator
//
// ========================================

// KEY VARIABLES
// ========================================
material_thickness = 3;  // mm
board_width = 127;       // mm
num_slider_sections = 1; // Number of slider tracks
layer_gap = 0.05;        // mm gap between layers

// EXPORT MODE - Choose which part to export for laser cutting
// Options: "assembly", "layer1", "layer2", "layer3", "slider", "knob"
export_mode = "assembly";

// Section heights
header_height = 30;      // mm
slider_height = 16;      // mm per slider
footer_height = 30;      // mm

// Slider slot dimensions
slot_margin = 6.35;      // mm from left/right edges
slot_height = 12.70;     // mm height of the slot
slot_radius = slot_height / 2;  // radius for rounded ends
slot_width = board_width - (2 * slot_margin);  // calculated slot width

// Slider dimensions
slider_clearance = 0.2;  // mm clearance from slot sides
slider_piece_height = slot_height - slider_clearance;
slider_radius = slider_piece_height / 2;
slider_length = slot_width - (board_width / 3.5);

// Knob cutout dimensions (for top layer)
knob_cutout_width = board_width / 3.5;  // mm width of knob cutout
knob_cutout_margin = 0.5;  // mm from slot edge
knob_height_reduction = 0.5;  // mm reduction top and bottom
knob_cutout_height = slider_piece_height - (2 * knob_height_reduction);
knob_cutout_radius = knob_cutout_height / 2;

// Knob dimensions
knob_clearance = 0.3;  // mm clearance from cutout
knob_diameter = knob_cutout_height - knob_clearance;
knob_radius = knob_diameter / 2;

// Calculated total height
total_height = header_height + (slider_height * num_slider_sections) + footer_height;

// ========================================
// LAYER 1 - BOTTOM LAYER (2D)
// ========================================

module layer1_2d() {
    // Header rectangle
    translate([0, footer_height + (slider_height * num_slider_sections)])
        square([board_width, header_height]);
    
    // Slider section(s)
    translate([0, footer_height])
        square([board_width, slider_height * num_slider_sections]);
    
    // Footer rectangle
    square([board_width, footer_height]);
}

module layer1() {
    linear_extrude(height = material_thickness)
        layer1_2d();
}

// ========================================
// LAYER 2 - SLIDER TRACK LAYER (2D)
// ========================================

module pill_slot_2d() {
    // Create pill shape using hull of two circles
    slot_length = board_width - (2 * slot_margin);
    hull() {
        // Left end
        translate([slot_margin + slot_radius, 0])
            circle(r = slot_radius, $fn = 50);
        // Right end
        translate([board_width - slot_margin - slot_radius, 0])
            circle(r = slot_radius, $fn = 50);
    }
}

module layer2_2d() {
    difference() {
        union() {
            // Header rectangle
            translate([0, footer_height + (slider_height * num_slider_sections)])
                square([board_width, header_height]);
            
            // Slider section(s)
            translate([0, footer_height])
                square([board_width, slider_height * num_slider_sections]);
            
            // Footer rectangle
            square([board_width, footer_height]);
        }
        
        // Cut out pill-shaped slots for each slider
        for (i = [0 : num_slider_sections - 1]) {
            // Center the slot vertically in each slider section
            slot_y_offset = footer_height + (i * slider_height) + (slider_height - slot_height) / 2 + slot_radius;
            translate([0, slot_y_offset])
                pill_slot_2d();
        }
    }
}

module layer2() {
    linear_extrude(height = material_thickness)
        layer2_2d();
}

// ========================================
// LAYER 3 - TOP LAYER WITH KNOB CUTOUTS (2D)
// ========================================

module knob_cutout_2d() {
    // Create pill shape for knob cutout
    hull() {
        // Left end
        translate([knob_cutout_radius, 0])
            circle(r = knob_cutout_radius, $fn = 50);
        // Right end
        translate([knob_cutout_width - knob_cutout_radius, 0])
            circle(r = knob_cutout_radius, $fn = 50);
    }
}

module layer3_2d() {
    difference() {
        union() {
            // Header rectangle
            translate([0, footer_height + (slider_height * num_slider_sections)])
                square([board_width, header_height]);
            
            // Slider section(s)
            translate([0, footer_height])
                square([board_width, slider_height * num_slider_sections]);
            
            // Footer rectangle
            square([board_width, footer_height]);
        }
        
        // Cut out knob slots for each slider
        for (i = [0 : num_slider_sections - 1]) {
            // Position knob cutout - right side of slot, 0.5mm from edge
            knob_x_offset = board_width - slot_margin - knob_cutout_margin - knob_cutout_width;
            // Center the cutout vertically in each slider section
            knob_y_offset = footer_height + (i * slider_height) + (slider_height - knob_cutout_height) / 2 + knob_cutout_radius;
            
            translate([knob_x_offset, knob_y_offset])
                knob_cutout_2d();
        }
    }
}

module layer3() {
    linear_extrude(height = material_thickness)
        layer3_2d();
}

// ========================================
// SLIDER - Movable piece in the slot (2D)
// ========================================

module slider_2d() {
    // Create pill shape for slider
    hull() {
        // Left end
        translate([slider_radius, 0])
            circle(r = slider_radius, $fn = 50);
        // Right end
        translate([slider_length - slider_radius, 0])
            circle(r = slider_radius, $fn = 50);
    }
}

module slider() {
    linear_extrude(height = material_thickness)
        slider_2d();
}

// ========================================
// KNOB - Glued to slider, goes through top cutout (2D)
// ========================================

module knob_2d() {
    circle(r = knob_radius, $fn = 50);
}

module knob() {
    linear_extrude(height = material_thickness)
        knob_2d();
}

// ========================================
// RENDER ASSEMBLY OR EXPORT MODE
// ========================================

if (export_mode == "assembly") {
    // Full 3D assembly view
    
    // Layer 1 - Bottom
    layer1();
    
    // Layer 2 - On top with gap
    translate([0, 0, material_thickness + layer_gap])
        layer2();
    
    // Sliders - positioned in the slots
    for (i = [0 : num_slider_sections - 1]) {
        // Center slider horizontally in the slot
        slider_x_offset = slot_margin + (slot_width - slider_length) / 2;
        // Center slider vertically in the slider section
        slider_y_offset = footer_height + (i * slider_height) + (slider_height - slider_piece_height) / 2 + slider_radius;
        
        translate([slider_x_offset, slider_y_offset, material_thickness])
            slider();
    }
    
    // Layer 3 - Top layer with gap
    translate([0, 0, (2 * material_thickness) + (2 * layer_gap)])
        layer3();
    
    // Knobs - flush with layer 3, at right end of sliders
    for (i = [0 : num_slider_sections - 1]) {
        // Position at right end of slider
        slider_x_offset = slot_margin + (slot_width - slider_length) / 2;
        knob_x_offset = slider_x_offset + slider_length - slider_radius;
        // Center vertically in the slider section
        knob_y_offset = footer_height + (i * slider_height) + (slider_height / 2);
        
        translate([knob_x_offset, knob_y_offset, (2 * material_thickness) + (2 * layer_gap)])
            knob();
    }
    
} else if (export_mode == "layer1") {
    // Export Layer 1 as 2D
    layer1_2d();
        
} else if (export_mode == "layer2") {
    // Export Layer 2 as 2D
    layer2_2d();
        
} else if (export_mode == "layer3") {
    // Export Layer 3 as 2D
    layer3_2d();
        
} else if (export_mode == "slider") {
    // Export all sliders as 2D, spaced out
    for (i = [0 : num_slider_sections - 1]) {
        translate([0, i * (slider_piece_height + 5)])
            slider_2d();
    }
    
} else if (export_mode == "knob") {
    // Export all knobs as 2D, spaced out
    for (i = [0 : num_slider_sections - 1]) {
        translate([i * (knob_diameter + 5), 0])
            knob_2d();
    }
}
