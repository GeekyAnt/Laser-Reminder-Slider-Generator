# Laser Reminder Slider Generator

A parametric laser-cut reminder board designer with interactive 3D preview and SVG export. Create custom sliding message boards for tracking daily tasks, pet care, baby schedules, and more.

![Reminder Board Example](images/example_board.png)
*Example: AM/PM and Fed/Hungry slider board*

## Features

- **Interactive 3D Preview** - See your design in real-time as you adjust parameters
- **Layer Visibility Controls** - Toggle individual layers on/off to inspect the design
- **Fully Parametric** - Customize every dimension with easy-to-use sliders
- **Custom Text & Fonts** - Add text to headers, footers, sliders, and backgrounds with 27+ font choices
- **Individual Font Control** - Select different fonts for each text element
- **Settings Management** - Save/load configurations and set personal defaults
- **Multiple Export Options** - Export individual layers or all layers in one optimized SVG
- **Web-Based** - No installation required, runs entirely in your browser
- **OpenSCAD Integration** - Includes .scad file for advanced users
- **Python Automation** - Batch export script for OpenSCAD workflow
- **Precision Design** - All dimensions in millimeters with configurable tolerances

## Quick Start

### Web Designer (Recommended)

1. Download `reminder_board_designer_threejs.html`
2. Open it in any modern web browser
3. Adjust parameters using the sliders and controls
4. Add custom text and select fonts for each element
5. Toggle layer visibility to inspect your design
6. Click "Export All (One File)" to download your laser-ready SVG

That's it. No installation, no dependencies.

**Pro Tips:**
- Use the layer visibility checkboxes to inspect individual layers
- Save your configurations for reuse across multiple projects
- Set your preferred defaults to speed up future designs
- Export individual layers if you need to modify specific parts

### OpenSCAD Workflow

1. Download `reminder_board.scad`
2. Open in OpenSCAD
3. Modify variables at the top of the file
4. Use Python script `export_layers.py` to batch export all layers

## What You Get

The design generates 5 laser-cut pieces per slider section:

1. **Layer 1 (Base)** - Bottom/back panel with optional background text
2. **Layer 2 (Slots)** - Middle layer with pill-shaped slider tracks
3. **Layer 3 (Top)** - Top layer with knob cutouts, header/footer text, and slider labels
4. **Slider** - Sliding piece with optional hidden text that reveals when moved
5. **Knob** - Control knob (glues to slider, protrudes through Layer 3)

Stack order: Layer 1 → Slider → Layer 2 → Layer 3 with Knob

**Text Placement:**
- **Layer 1**: Background text visible through the slider track
- **Layer 3**: Header text, footer text, and slider section labels
- **Slider**: Hidden text that appears when the slider is moved

## Use Cases

Perfect for creating reminder boards for:
- Baby care (Fed/Hungry, Clean/Dirty, AM/PM naps)
- Pet care (Fed/Not Fed, In/Out, Walked/Not Walked)
- Medication tracking (Taken/Not Taken)
- Household tasks (Done/To Do)
- Daily routines (Morning/Evening tasks)
- Any binary or multiple-choice reminders

## Customizable Parameters

### Basic Dimensions
- **Material Thickness** - Thickness of your laser-cut material (default: 3mm)
- **Board Width** - Overall width of the board (default: 127mm)
- **Number of Slider Sections** - How many sliders to include (1-5)

### Section Heights
- **Header Height** - Top section for labels/text (default: 30mm)
- **Slider Height** - Height of each slider track (default: 16mm)
- **Footer Height** - Bottom section for labels/text (default: 30mm)

### Text Customization
- **Header Text** - Custom text for the top section with independent font selection
- **Footer Text** - Custom text for the bottom section with independent font selection
- **Slider Section Labels** - Label each slider track (visible on Layer 3)
- **Slider Hidden Text** - Text on the slider that reveals when moved
- **Slider Background Text** - Text visible in the track on Layer 1
- **Font Families** - 27 fonts including web-safe and Google Fonts options
- **Font Sizes** - Independent size control for header, footer, and slider text
- **Text Positioning** - Fine-tune X and Y positions for all text elements

### Slider Positioning
- **Slider Position (%)** - Set initial position of each slider (-18% to 50%)
- **Hidden Text Position (%)** - Control where hidden text appears on slider (10-90%)
- **Label X Position** - Horizontal offset for slider labels (0-70mm)
- **Background Text X Position** - Horizontal offset for background text (30-60mm)

### Layer Visibility
- **Show/Hide Layer 1** - Toggle base layer visibility in 3D preview
- **Show/Hide Layer 2** - Toggle slot layer visibility in 3D preview
- **Show/Hide Layer 3** - Toggle top layer visibility in 3D preview

### Advanced Settings
- **Slot Margin** - Distance from edges to slider track (default: 6.35mm)
- **Slot Height** - Height of the slider track (default: 12.70mm)
- Layer gaps, clearances, and knob dimensions (in the code)

### Settings Management
- **Save Configuration** - Export all settings to a JSON file
- **Load Configuration** - Import previously saved settings
- **Set as Default** - Save current settings as your personal defaults
- **Reset to Factory** - Restore original default settings

## Design Details

- **Layer Gap**: 0.05mm between layers for smooth sliding
- **Slider Clearance**: 0.2mm to prevent binding
- **Knob Clearance**: 0.3mm for easy finger access
- **Pill-Shaped Tracks**: Rounded ends prevent sharp corners

## Materials & Assembly

### Recommended Materials
- 3mm plywood, MDF, or acrylic
- Wood glue or CA glue for assembly

### Assembly Instructions
1. Cut all pieces on your laser cutter
2. Test-fit slider in Layer 2 tracks (should slide smoothly)
3. Glue knob to right end of slider (centered)
4. Stack layers: Layer 1 (bottom) → Layer 2 → Layer 3 (top)
5. Glue layers together, ensuring slider moves freely
6. Add labels to header/footer sections

### Tips
- Test cut one slider section before cutting the full design
- Adjust clearance parameters if slider is too tight/loose
- Consider adding magnets to bottom for mounting on refrigerator

## File Structure

```
Claude-Code-AutoSlider/
├── reminder_board_designer_threejs.html  # Web-based designer with 3D preview (recommended)
├── reminder_board.scad                   # OpenSCAD parametric model
├── export_layers.py                      # Python batch export script
├── readme.md                             # This file
├── LICENSE                               # MIT License
└── images/                               # Example images and screenshots
    ├── example_board.png
    ├── web_interface.png
    └── assembly_diagram.png
```

## Browser Compatibility

The web designer works in all modern browsers:
- Chrome/Edge (recommended)
- Firefox
- Safari
- Opera

Requires JavaScript enabled and WebGL support.

## Python Export Script Usage

For OpenSCAD users who want to automate exports:

```bash
python export_layers.py
```

**Requirements:**
- Python 3.x
- OpenSCAD installed and in PATH (or update `OPENSCAD_EXECUTABLE` in script)

The script will generate all 5 layers as SVG files in the `laser_cuts/` folder.

## OpenSCAD Tips

Edit the variables at the top of `reminder_board.scad`:

```openscad
// KEY VARIABLES
material_thickness = 3;
board_width = 127;
num_slider_sections = 1;
// ... etc
```

Set `export_mode` to preview individual layers:
- `"assembly"` - Full 3D preview
- `"layer1"`, `"layer2"`, `"layer3"` - Individual layers
- `"slider"`, `"knob"` - Slider components

## Contributing

Contributions are welcome. Feel free to:
- Report bugs or request features via Issues
- Submit pull requests for improvements
- Share your designs and modifications
- Improve documentation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Advanced Features

### Font Options
The web designer includes 27 carefully curated fonts organized into categories:
- **Sans-Serif (Web Safe)**: Arial, Helvetica, Verdana, Tahoma, Trebuchet MS, Century Gothic, Franklin Gothic Medium
- **Serif (Web Safe)**: Times New Roman, Georgia, Palatino Linotype, Garamond, Book Antiqua
- **Monospace (Web Safe)**: Courier New, Lucida Console, Monaco, Consolas
- **Display (Web Safe)**: Impact, Comic Sans MS
- **Google Fonts**: Roboto, Open Sans, Lato, Montserrat, Oswald, Raleway, Playfair Display, Bebas Neue, Pacifico, Dancing Script

Each text element can use a different font, allowing for creative typography combinations.

### Configuration Management
- **Persistent Defaults**: Your preferences are saved in the browser and automatically loaded
- **JSON Export/Import**: Share configurations between devices or with others
- **Version Tracking**: Configuration files include timestamps for organization
- **Factory Reset**: Always able to return to original settings

### 3D Preview Controls
- **Orbit**: Left-click and drag to rotate the view
- **Pan**: Right-click and drag to move the camera
- **Zoom**: Scroll wheel to zoom in/out
- **Layer Isolation**: Hide layers to inspect specific components
- **Real-time Updates**: All changes reflect instantly in the 3D view

## Acknowledgments

- Built with Three.js for interactive 3D visualization
- Font rendering powered by HTML5 Canvas API
- Inspired by the need for simple, customizable reminder boards
- Thanks to the laser cutting and maker communities

## Gallery

Share your creations by opening an issue or discussion with photos of your finished boards.

---

Questions? Open an issue or start a discussion.

