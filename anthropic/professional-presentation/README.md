# Professional PowerPoint Presentation Skill

Create beautiful, professional PowerPoint presentations with a modern pastel color scheme. Perfect for any corporate or business context without being tied to a specific company brand.

## Overview

This skill enables automated creation of stunning PowerPoint presentations with:
- **Modern Pastel Color Scheme** - Soft, professional colors that work for any audience
- **Multiple Slide Types** - Titles, content, charts, tables, comparisons, and more
- **Flexible & Generic** - Not tied to any specific company or brand
- **Professional Formatting** - Consistent colors, fonts, and layouts
- **Data Visualization** - Beautiful charts and graphs with pastel colors
- **Customizable Content** - Adapt to any use case or audience

## Quick Start

### Prerequisites
```bash
python3 -m pip install python-pptx --user --break-system-packages
```

### Usage
Simply ask Claude to create a presentation:
```
Create a presentation about Q1 business results
```

Claude will:
1. Ask clarifying questions about content and audience
2. Generate a complete Python script with pastel color scheme
3. Execute the script to create the .pptx file
4. Save output to `../../../output/<name>.pptx`

## Files

- **SKILL.md** - Main skill definition and comprehensive instructions
- **README.md** - This file (quick overview)
- **reference/powerpoint_best_practices.md** - Complete guide to PowerPoint manipulation
- **reference/example_presentation.py** - Working example with pastel colors
- **reference/QUICK_START.md** - Fast introduction guide

## Pastel Color Palette

The skill uses a carefully selected palette of professional pastel colors:

- **Pastel Blue** `RGB(147, 197, 253)` - Primary headings, key data
- **Pastel Lavender** `RGB(196, 181, 253)` - Secondary elements
- **Pastel Mint** `RGB(167, 243, 208)` - Success, positive trends
- **Pastel Peach** `RGB(254, 202, 202)` - Highlights, attention
- **Pastel Coral** `RGB(252, 165, 165)` - Important, critical
- **Pastel Sage** `RGB(187, 222, 214)` - Neutral, calm
- **Pastel Periwinkle** `RGB(199, 210, 254)` - Alternative blue
- **Pastel Rose** `RGB(251, 207, 232)` - Accent color

### Text Colors
- **Dark Slate** `RGB(51, 65, 85)` - Primary text
- **Medium Slate** `RGB(100, 116, 139)` - Secondary text
- **Light Gray** `RGB(241, 245, 249)` - Light backgrounds

## Features

### Slide Types Available
- Title slides with centered text
- Section headers for visual breaks
- Content slides with bullet points (multi-level)
- Two-column comparison layouts
- Tables with formatted headers and alternating rows
- Bar charts (grouped, stacked) with pastel colors
- Pie charts with percentage labels
- Line charts for trends over time
- Custom layouts for images and diagrams

### Professional Design
- Consistent pastel color theme throughout
- Readable fonts with proper contrast
- Clean, modern layouts with white space
- Data visualizations with coordinated colors
- Professional typography hierarchy

### Flexible & Generic
- Not tied to any specific company or brand
- Works for any professional context
- Adaptable to any audience (executives, technical teams, general)
- Can be customized with your own templates
- Compatible with PowerPoint, Keynote, and Google Slides

## Example Use Cases

### Business Presentations
- Quarterly business reviews
- Sales pitches and proposals
- Investor presentations
- Board meetings
- Strategic planning sessions

### Technical Presentations
- Architecture reviews
- System design proposals
- Technical training
- Conference talks
- Engineering updates

### General Professional
- Project status updates
- Workshop materials
- Team trainings
- Conference presentations
- Stakeholder communications

## Color Usage Guidelines

- **Pastel Blue**: Titles, primary data, key points
- **Pastel Mint**: Positive metrics, success stories, growth
- **Pastel Peach**: Highlights, warnings, attention items
- **Pastel Coral**: Critical issues, important notes
- **Pastel Lavender**: Supporting information, secondary elements
- **Pastel Sage**: Neutral content, background accents
- **Dark Slate**: All body text (ensures readability)

## Best Practices

### Content
- **One message per slide** - Keep focus clear
- **5-7 bullets max** - Avoid overwhelming the audience
- **Use visuals** - Charts over text when possible
- **Tell a story** - Beginning, middle, end
- **Consider your audience** - Match tone and detail level

### Design
- **Consistent colors** - Use pastel palette throughout
- **Readable fonts** - Minimum 18pt for body text
- **White space** - Don't overcrowd slides
- **Visual hierarchy** - Larger = more important
- **High contrast** - Dark text on light backgrounds

### Presentation Types
- **Executive (15-20 slides)**: High-level, business-focused, ROI-driven
- **Technical (10-15 slides)**: Architecture, specs, implementation details
- **Update (8-12 slides)**: Progress, metrics, next steps
- **Training (20-30 slides)**: Educational content, exercises, examples

## Example Output

A presentation created with this skill includes:
- Professional pastel color scheme throughout
- Clear, readable typography
- Beautiful data visualizations
- Consistent formatting and layout
- Speaker notes for presenters
- Ready to present immediately

All presentations are saved to: `../../../output/<descriptive_name>.pptx`

## Customization

### Use Your Own Template
1. Create a .potx template in PowerPoint with pastel colors
2. Save it to `../../../template/`
3. Reference it in your script: `Presentation('path/to/template.potx')`

### Adjust Colors
Modify the RGB color values in your script to match your preferences while maintaining the soft, pastel aesthetic.

### Add Custom Layouts
Create your own slide layouts with custom positioning and styling using python-pptx.

## Troubleshooting

**Module not found**: Install python-pptx with `pip install python-pptx`

**Colors look different**: RGB values are consistent, but test on your target platform

**Text overflow**: Reduce font size or split into multiple slides

**Charts not rendering**: Ensure data is numeric, not strings

**Images not loading**: Use absolute paths or verify relative paths

## Resources

- [python-pptx documentation](https://python-pptx.readthedocs.io/)
- Skill documentation: `SKILL.md`
- Best practices guide: `reference/powerpoint_best_practices.md`
- Working example: `reference/example_presentation.py`
- Quick start: `reference/QUICK_START.md`

## Why Pastel Colors?

Pastel colors provide a modern, professional look that:
- ✓ Works for any corporate or business context
- ✓ Easy on the eyes during long presentations
- ✓ Creates a calm, professional atmosphere
- ✓ Differentiates from standard corporate blues
- ✓ Appeals to diverse audiences
- ✓ Not tied to any specific brand
- ✓ Looks great in both digital and print formats

## Support

For issues or questions:
1. Check the troubleshooting section in SKILL.md
2. Review the example script for implementation patterns
3. Consult the best practices guide for formatting help

---

**Create beautiful, professional presentations with modern pastel colors!**
