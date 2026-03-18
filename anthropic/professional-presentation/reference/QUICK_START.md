# Quick Start Guide: Professional Presentations with Pastel Colors

Get started creating beautiful PowerPoint presentations in minutes!

## Installation

```bash
python3 -m pip install python-pptx --user --break-system-packages
```

## Basic Usage

### 1. Create Your First Presentation

```python
#!/usr/bin/env python3
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

# Pastel colors
PASTEL_BLUE = RGBColor(147, 197, 253)
DARK_SLATE = RGBColor(51, 65, 85)

# Create presentation
prs = Presentation()
prs.slide_width = Inches(10)
prs.slide_height = Inches(5.625)

# Add a blank slide
slide = prs.slides.add_slide(prs.slide_layouts[6])

# Add title
title_box = slide.shapes.add_textbox(Inches(1), Inches(2), Inches(8), Inches(1))
title_frame = title_box.text_frame
title_frame.text = "My First Presentation"
title_frame.paragraphs[0].font.size = Pt(44)
title_frame.paragraphs[0].font.bold = True
title_frame.paragraphs[0].font.color.rgb = PASTEL_BLUE
title_frame.paragraphs[0].alignment = PP_ALIGN.CENTER

# Save
prs.save('my_presentation.pptx')
print("✓ Created: my_presentation.pptx")
```

### 2. Run the Example

```bash
cd reference
python3 example_presentation.py
```

This creates a full 17-slide business presentation with charts, tables, and comparisons!

## Pastel Color Palette

Copy these into your script:

```python
# Professional Pastel Colors
PASTEL_BLUE = RGBColor(147, 197, 253)      # Primary
PASTEL_LAVENDER = RGBColor(196, 181, 253)  # Secondary
PASTEL_MINT = RGBColor(167, 243, 208)      # Success
PASTEL_PEACH = RGBColor(254, 202, 202)     # Highlight
PASTEL_CORAL = RGBColor(252, 165, 165)     # Important
PASTEL_SAGE = RGBColor(187, 222, 214)      # Neutral
PASTEL_PERIWINKLE = RGBColor(199, 210, 254)# Alt Blue
PASTEL_ROSE = RGBColor(251, 207, 232)      # Accent

# Text Colors
DARK_SLATE = RGBColor(51, 65, 85)          # Body text
MEDIUM_SLATE = RGBColor(100, 116, 139)     # Secondary text
LIGHT_GRAY = RGBColor(241, 245, 249)       # Light bg
```

## Common Patterns

### Add a Title Slide

```python
slide = prs.slides.add_slide(prs.slide_layouts[6])

# Title
title_box = slide.shapes.add_textbox(Inches(1), Inches(2), Inches(8), Inches(1))
title_frame = title_box.text_frame
title_frame.text = "Quarterly Review"
title_frame.paragraphs[0].font.size = Pt(44)
title_frame.paragraphs[0].font.bold = True
title_frame.paragraphs[0].font.color.rgb = PASTEL_BLUE
title_frame.paragraphs[0].alignment = PP_ALIGN.CENTER

# Subtitle
subtitle_box = slide.shapes.add_textbox(Inches(1), Inches(3.2), Inches(8), Inches(0.8))
subtitle_frame = subtitle_box.text_frame
subtitle_frame.text = "Q1 2026 Results"
subtitle_frame.paragraphs[0].font.size = Pt(24)
subtitle_frame.paragraphs[0].font.color.rgb = MEDIUM_SLATE
subtitle_frame.paragraphs[0].alignment = PP_ALIGN.CENTER
```

### Add Bullet Points

```python
slide = prs.slides.add_slide(prs.slide_layouts[6])

# Title
title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.5), Inches(9), Inches(0.8))
title_frame = title_box.text_frame
title_frame.text = "Key Points"
title_frame.paragraphs[0].font.size = Pt(32)
title_frame.paragraphs[0].font.bold = True
title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

# Bullets
textbox = slide.shapes.add_textbox(Inches(0.8), Inches(1.6), Inches(8.5), Inches(3.5))
text_frame = textbox.text_frame

bullets = [
    "Revenue increased 23% YoY",
    "Acquired 1,250 new customers",
    "Launched 3 new product features",
    "Expanded team by 25%"
]

for idx, bullet_text in enumerate(bullets):
    if idx == 0:
        p = text_frame.paragraphs[0]
    else:
        p = text_frame.add_paragraph()
    p.text = bullet_text
    p.level = 0
    p.font.size = Pt(18)
    p.font.color.rgb = DARK_SLATE
    p.space_before = Pt(6)
```

### Add a Bar Chart

```python
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE

slide = prs.slides.add_slide(prs.slide_layouts[6])

# Title
title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.5), Inches(9), Inches(0.8))
title_frame = title_box.text_frame
title_frame.text = "Revenue Growth"
title_frame.paragraphs[0].font.size = Pt(32)
title_frame.paragraphs[0].font.bold = True
title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

# Chart data
chart_data = CategoryChartData()
chart_data.categories = ['Q1', 'Q2', 'Q3', 'Q4']
chart_data.add_series('2025', [12.5, 14.2, 15.8, 18.1])
chart_data.add_series('2026', [15.3, 17.8, 19.2, 21.5])

# Add chart
x, y, cx, cy = Inches(1), Inches(1.6), Inches(8), Inches(3.8)
chart = slide.shapes.add_chart(
    XL_CHART_TYPE.COLUMN_CLUSTERED, x, y, cx, cy, chart_data
).chart

# Color the series
colors = [PASTEL_BLUE, PASTEL_MINT]
for idx, series in enumerate(chart.series):
    fill = series.format.fill
    fill.solid()
    fill.fore_color.rgb = colors[idx]
```

### Add a Table

```python
slide = prs.slides.add_slide(prs.slide_layouts[6])

# Title
title_box = slide.shapes.add_textbox(Inches(0.5), Inches(0.5), Inches(9), Inches(0.8))
title_frame = title_box.text_frame
title_frame.text = "Financial Summary"
title_frame.paragraphs[0].font.size = Pt(32)
title_frame.paragraphs[0].font.bold = True
title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

# Table data
data = [
    ['Metric', 'Q1', 'Q2', 'Q3', 'Q4'],
    ['Revenue', '$12.5M', '$14.2M', '$15.8M', '$18.1M'],
    ['Profit', '$3.2M', '$3.8M', '$4.5M', '$5.1M'],
    ['Margin', '26%', '27%', '28%', '28%']
]

# Create table
rows = len(data)
cols = len(data[0])
table = slide.shapes.add_table(
    rows, cols, Inches(0.8), Inches(1.6), Inches(8.5), Inches(3.5)
).table

# Fill and format
for i, row_data in enumerate(data):
    for j, cell_value in enumerate(row_data):
        cell = table.cell(i, j)
        cell.text = cell_value

        # Header row
        if i == 0:
            cell.fill.solid()
            cell.fill.fore_color.rgb = PASTEL_BLUE
            paragraph = cell.text_frame.paragraphs[0]
            paragraph.font.bold = True
            paragraph.font.size = Pt(14)
            paragraph.font.color.rgb = DARK_SLATE
        else:
            # Alternating rows
            if i % 2 == 0:
                cell.fill.solid()
                cell.fill.fore_color.rgb = LIGHT_GRAY
            paragraph = cell.text_frame.paragraphs[0]
            paragraph.font.size = Pt(12)
            paragraph.font.color.rgb = DARK_SLATE

        paragraph.alignment = PP_ALIGN.CENTER
```

## Using Helper Functions

For reusable code, copy the helper functions from `powerpoint_best_practices.md`:

- `create_title_slide()`
- `create_section_header()`
- `create_content_slide()`
- `create_two_column_slide()`
- `create_table_slide()`
- `create_bar_chart_slide()`
- `create_pie_chart_slide()`
- `add_speaker_notes()`

Then your script becomes much simpler:

```python
from helpers import *  # Import your helper functions

prs = Presentation()
prs.slide_width = Inches(10)
prs.slide_height = Inches(5.625)

# Now it's easy!
create_title_slide(prs, "My Presentation", "Subtitle here")
create_content_slide(prs, "Overview", [
    (0, "Point 1"),
    (0, "Point 2"),
    (0, "Point 3")
])
create_bar_chart_slide(prs, "Revenue", ['Q1', 'Q2', 'Q3'], [
    ('2026', [10, 15, 20])
])

prs.save('presentation.pptx')
```

## Tips for Success

1. **Start Simple**: Begin with title and bullet slides
2. **Use Helper Functions**: Copy from the best practices guide
3. **Test As You Go**: Run the script after each slide
4. **Color Consistently**: Stick to the pastel palette
5. **Keep Text Readable**: Minimum 18pt for body text
6. **Limit Bullets**: Max 5-7 per slide
7. **Preview Often**: Open in PowerPoint to check appearance

## Common Issues

**Import Error**: `ModuleNotFoundError: No module named 'pptx'`
```bash
python3 -m pip install python-pptx --user --break-system-packages
```

**Colors Wrong**: Make sure you're using `RGBColor()` not strings

**Text Too Small**: Increase font size with `Pt(18)` or higher

**Chart Not Showing**: Verify data is numeric, not strings

**Overlapping Elements**: Check your `Inches()` positioning

## Next Steps

1. ✓ Run the example script to see what's possible
2. ✓ Read `powerpoint_best_practices.md` for complete patterns
3. ✓ Copy helper functions into your own scripts
4. ✓ Experiment with different pastel color combinations
5. ✓ Check `SKILL.md` for comprehensive documentation

## Resources

- **Full Documentation**: `SKILL.md`
- **Best Practices**: `reference/powerpoint_best_practices.md`
- **Working Example**: `reference/example_presentation.py`
- **python-pptx Docs**: https://python-pptx.readthedocs.io/

---

**You're ready to create beautiful presentations! Start with the example and customize from there.**
