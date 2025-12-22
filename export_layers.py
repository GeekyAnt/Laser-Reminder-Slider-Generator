#!/usr/bin/env python3
"""
Laser Reminder Slider Generator - Automated Export Script
Exports all layers of the reminder board as SVG files for laser cutting

Copyright (c) 2025 Alex

This project is licensed under the MIT License.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Repository: https://github.com/GeekyAnt/laser-reminder-slider-generator
"""

import subprocess
import os
import re
import sys

# Configuration
SCAD_FILE = "reminder_board.scad"
OUTPUT_DIR = "laser_cuts"
OPENSCAD_EXECUTABLE = "openscad"  # Change if needed (e.g., "C:\\Program Files\\OpenSCAD\\openscad.exe" on Windows)

# Export modes to process
EXPORT_MODES = ["layer1", "layer2", "layer3", "slider", "knob"]

def modify_export_mode(scad_content, mode):
    """
    Modify the export_mode variable in the SCAD file content
    """
    pattern = r'export_mode\s*=\s*"[^"]*"'
    replacement = f'export_mode = "{mode}"'
    modified = re.sub(pattern, replacement, scad_content)
    return modified

def export_layer(scad_file, mode, output_file):
    """
    Call OpenSCAD to export a specific mode as SVG
    """
    print(f"Exporting {mode}...")
    
    # Read original file
    with open(scad_file, 'r') as f:
        original_content = f.read()
    
    # Modify export mode
    modified_content = modify_export_mode(original_content, mode)
    
    # Write temporary file
    temp_file = f"temp_{mode}.scad"
    with open(temp_file, 'w') as f:
        f.write(modified_content)
    
    # Call OpenSCAD to export
    try:
        cmd = [
            OPENSCAD_EXECUTABLE,
            "-o", output_file,
            "--export-format", "svg",
            temp_file
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            print(f"  ✓ Successfully exported to {output_file}")
        else:
            print(f"  ✗ Error exporting {mode}")
            print(f"    {result.stderr}")
            
    except subprocess.TimeoutExpired:
        print(f"  ✗ Timeout while exporting {mode}")
    except FileNotFoundError:
        print(f"  ✗ OpenSCAD executable not found: {OPENSCAD_EXECUTABLE}")
        print("    Please update OPENSCAD_EXECUTABLE in the script with the correct path")
        return False
    finally:
        # Clean up temp file
        if os.path.exists(temp_file):
            os.remove(temp_file)
    
    return True

def main():
    """
    Main export process
    """
    print("=" * 60)
    print("OpenSCAD Reminder Board - Automated Layer Export")
    print("=" * 60)
    print()
    
    # Check if SCAD file exists
    if not os.path.exists(SCAD_FILE):
        print(f"Error: {SCAD_FILE} not found in current directory")
        print(f"Current directory: {os.getcwd()}")
        sys.exit(1)
    
    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"Output directory: {OUTPUT_DIR}/")
    print()
    
    # Export each layer
    success_count = 0
    for mode in EXPORT_MODES:
        output_file = os.path.join(OUTPUT_DIR, f"reminder_board_{mode}.svg")
        if export_layer(SCAD_FILE, mode, output_file):
            success_count += 1
    
    print()
    print("=" * 60)
    print(f"Export complete! {success_count}/{len(EXPORT_MODES)} files exported successfully")
    print(f"Files saved in: {OUTPUT_DIR}/")
    print("=" * 60)
    
    # Also export DXF option info
    print()
    print("Note: To export as DXF instead of SVG, change '--export-format'")
    print("      in the script from 'svg' to 'dxf'")

if __name__ == "__main__":
    main()