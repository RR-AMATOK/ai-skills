# PowerPoint Best Practices with Pastel Colors

Complete guide for creating professional PowerPoint presentations using python-pptx with a modern pastel color scheme.

## Setup and Imports

```python
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR, MSO_AUTO_SIZE
from pptx.dml.color import RGBColor
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE, XL_LEGEND_POSITION
import os

# Professional Pastel Color Palette
PASTEL_BLUE = RGBColor(147, 197, 253)
PASTEL_LAVENDER = RGBColor(196, 181, 253)
PASTEL_MINT = RGBColor(167, 243, 208)
PASTEL_PEACH = RGBColor(254, 202, 202)
PASTEL_CORAL = RGBColor(252, 165, 165)
PASTEL_SAGE = RGBColor(187, 222, 214)
PASTEL_PERIWINKLE = RGBColor(199, 210, 254)
PASTEL_ROSE = RGBColor(251, 207, 232)

# Text colors
DARK_SLATE = RGBColor(51, 65, 85)
MEDIUM_SLATE = RGBColor(100, 116, 139)
LIGHT_GRAY = RGBColor(241, 245, 249)

# Create presentation (16:9 aspect ratio)
prs = Presentation()
prs.slide_width = Inches(10)
prs.slide_height = Inches(5.625)
```

## Helper Functions

### 1. Title Slide

```python
def create_title_slide(prs, title, subtitle=""):
    """Create professional title slide with pastel colors"""
    slide = prs.slides.add_slide(prs.slide_layouts[6])  # Blank layout

    # Add title
    left = Inches(1)
    top = Inches(2)
    width = Inches(8)
    height = Inches(1)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(44)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = PASTEL_BLUE
    title_frame.paragraphs[0].alignment = PP_ALIGN.CENTER

    # Add subtitle if provided
    if subtitle:
        left = Inches(1)
        top = Inches(3.2)
        width = Inches(8)
        height = Inches(0.8)

        subtitle_box = slide.shapes.add_textbox(left, top, width, height)
        subtitle_frame = subtitle_box.text_frame
        subtitle_frame.text = subtitle
        subtitle_frame.paragraphs[0].font.size = Pt(24)
        subtitle_frame.paragraphs[0].font.color.rgb = MEDIUM_SLATE
        subtitle_frame.paragraphs[0].alignment = PP_ALIGN.CENTER

    # Add decorative pastel rectangle at bottom
    left = Inches(3)
    top = Inches(4.8)
    width = Inches(4)
    height = Inches(0.1)
    shape = slide.shapes.add_shape(1, left, top, width, height)  # Rectangle
    shape.fill.solid()
    shape.fill.fore_color.rgb = PASTEL_LAVENDER
    shape.line.color.rgb = PASTEL_LAVENDER

    return slide
```

### 2. Section Header Slide

```python
def create_section_header(prs, section_title):
    """Create section divider slide with pastel background"""
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add light pastel background
    background = slide.background
    fill = background.fill
    fill.solid()
    fill.fore_color.rgb = LIGHT_GRAY

    # Add centered title
    left = Inches(1)
    top = Inches(2.3)
    width = Inches(8)
    height = Inches(1)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = section_title
    title_frame.paragraphs[0].font.size = Pt(40)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = PASTEL_BLUE
    title_frame.paragraphs[0].alignment = PP_ALIGN.CENTER

    return slide
```

### 3. Content Slide with Bullets

```python
def create_content_slide(prs, title, bullet_points):
    """
    Create content slide with bullet points
    bullet_points: list of tuples [(level, text), ...]
    level: 0=main, 1=sub-bullet, 2=sub-sub-bullet
    """
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Add pastel accent line under title
    left = Inches(0.5)
    top = Inches(1.3)
    width = Inches(2)
    height = Inches(0.05)
    shape = slide.shapes.add_shape(1, left, top, width, height)
    shape.fill.solid()
    shape.fill.fore_color.rgb = PASTEL_BLUE
    shape.line.color.rgb = PASTEL_BLUE

    # Add content area for bullets
    left = Inches(0.8)
    top = Inches(1.6)
    width = Inches(8.5)
    height = Inches(3.5)

    textbox = slide.shapes.add_textbox(left, top, width, height)
    text_frame = textbox.text_frame
    text_frame.word_wrap = True

    for idx, (level, text) in enumerate(bullet_points):
        if idx == 0:
            p = text_frame.paragraphs[0]
        else:
            p = text_frame.add_paragraph()

        p.text = text
        p.level = level
        p.font.size = Pt(18 - (level * 2))  # Decrease size for sub-bullets
        p.font.color.rgb = DARK_SLATE
        p.space_before = Pt(6) if level == 0 else Pt(3)

    return slide
```

### 4. Two Column Comparison Slide

```python
def create_two_column_slide(prs, title, left_title, left_points, right_title, right_points):
    """Create two-column comparison slide with pastel accents"""
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Left column with pastel blue accent
    left = Inches(0.5)
    top = Inches(1.5)
    width = Inches(4.3)
    height = Inches(3.8)

    left_box = slide.shapes.add_shape(1, left, top, width, height)
    left_box.fill.solid()
    left_box.fill.fore_color.rgb = RGBColor(240, 248, 255)  # Very light blue
    left_box.line.color.rgb = PASTEL_BLUE
    left_box.line.width = Pt(2)

    # Left column title
    left_title_box = slide.shapes.add_textbox(Inches(0.7), Inches(1.7), Inches(4), Inches(0.5))
    left_title_frame = left_title_box.text_frame
    left_title_frame.text = left_title
    left_title_frame.paragraphs[0].font.size = Pt(20)
    left_title_frame.paragraphs[0].font.bold = True
    left_title_frame.paragraphs[0].font.color.rgb = PASTEL_BLUE

    # Left column content
    left_content_box = slide.shapes.add_textbox(Inches(0.9), Inches(2.3), Inches(3.6), Inches(2.8))
    left_content_frame = left_content_box.text_frame
    for idx, point in enumerate(left_points):
        if idx == 0:
            p = left_content_frame.paragraphs[0]
        else:
            p = left_content_frame.add_paragraph()
        p.text = point
        p.font.size = Pt(14)
        p.font.color.rgb = DARK_SLATE
        p.space_before = Pt(6)

    # Right column with pastel mint accent
    left = Inches(5.2)
    top = Inches(1.5)
    width = Inches(4.3)
    height = Inches(3.8)

    right_box = slide.shapes.add_shape(1, left, top, width, height)
    right_box.fill.solid()
    right_box.fill.fore_color.rgb = RGBColor(240, 253, 244)  # Very light mint
    right_box.line.color.rgb = PASTEL_MINT
    right_box.line.width = Pt(2)

    # Right column title
    right_title_box = slide.shapes.add_textbox(Inches(5.4), Inches(1.7), Inches(4), Inches(0.5))
    right_title_frame = right_title_box.text_frame
    right_title_frame.text = right_title
    right_title_frame.paragraphs[0].font.size = Pt(20)
    right_title_frame.paragraphs[0].font.bold = True
    right_title_frame.paragraphs[0].font.color.rgb = PASTEL_MINT

    # Right column content
    right_content_box = slide.shapes.add_textbox(Inches(5.6), Inches(2.3), Inches(3.6), Inches(2.8))
    right_content_frame = right_content_box.text_frame
    for idx, point in enumerate(right_points):
        if idx == 0:
            p = right_content_frame.paragraphs[0]
        else:
            p = right_content_frame.add_paragraph()
        p.text = point
        p.font.size = Pt(14)
        p.font.color.rgb = DARK_SLATE
        p.space_before = Pt(6)

    return slide
```

### 5. Table Slide

```python
def create_table_slide(prs, title, table_data):
    """
    Create table slide with pastel header
    table_data: 2D list [[header_row], [row1], [row2], ...]
    """
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Create table
    rows = len(table_data)
    cols = len(table_data[0])

    left = Inches(0.8)
    top = Inches(1.6)
    width = Inches(8.5)
    height = Inches(3.5)

    table = slide.shapes.add_table(rows, cols, left, top, width, height).table

    # Format table
    for i, row_data in enumerate(table_data):
        for j, cell_value in enumerate(row_data):
            cell = table.cell(i, j)
            cell.text = str(cell_value)

            # Format header row
            if i == 0:
                cell.fill.solid()
                cell.fill.fore_color.rgb = PASTEL_BLUE
                paragraph = cell.text_frame.paragraphs[0]
                paragraph.font.bold = True
                paragraph.font.size = Pt(14)
                paragraph.font.color.rgb = DARK_SLATE
            else:
                # Alternating row colors
                if i % 2 == 0:
                    cell.fill.solid()
                    cell.fill.fore_color.rgb = LIGHT_GRAY
                paragraph = cell.text_frame.paragraphs[0]
                paragraph.font.size = Pt(12)
                paragraph.font.color.rgb = DARK_SLATE

            # Center align text
            paragraph.alignment = PP_ALIGN.CENTER

    return slide
```

### 6. Bar Chart Slide

```python
def create_bar_chart_slide(prs, title, categories, series_data):
    """
    Create bar chart with pastel colors
    series_data: [(series_name, [values]), ...]
    """
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Add chart
    chart_data = CategoryChartData()
    chart_data.categories = categories

    for series_name, values in series_data:
        chart_data.add_series(series_name, values)

    x, y, cx, cy = Inches(1), Inches(1.6), Inches(8), Inches(3.8)
    chart = slide.shapes.add_chart(
        XL_CHART_TYPE.COLUMN_CLUSTERED, x, y, cx, cy, chart_data
    ).chart

    # Style chart with pastel colors
    chart.has_legend = True
    chart.legend.position = XL_LEGEND_POSITION.BOTTOM
    chart.legend.include_in_layout = False

    # Apply pastel colors to series
    pastel_colors = [
        PASTEL_BLUE,
        PASTEL_MINT,
        PASTEL_LAVENDER,
        PASTEL_PEACH,
        PASTEL_SAGE,
        PASTEL_PERIWINKLE
    ]

    for idx, series in enumerate(chart.series):
        color = pastel_colors[idx % len(pastel_colors)]
        fill = series.format.fill
        fill.solid()
        fill.fore_color.rgb = color

    return slide
```

### 7. Pie Chart Slide

```python
def create_pie_chart_slide(prs, title, categories, values):
    """Create pie chart with pastel colors"""
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Add chart
    chart_data = CategoryChartData()
    chart_data.categories = categories
    chart_data.add_series('Values', values)

    x, y, cx, cy = Inches(2), Inches(1.6), Inches(6), Inches(3.8)
    chart = slide.shapes.add_chart(
        XL_CHART_TYPE.PIE, x, y, cx, cy, chart_data
    ).chart

    # Style pie chart
    chart.has_legend = True
    chart.legend.position = XL_LEGEND_POSITION.RIGHT

    # Apply pastel colors to slices
    pastel_colors = [
        PASTEL_BLUE,
        PASTEL_MINT,
        PASTEL_LAVENDER,
        PASTEL_PEACH,
        PASTEL_CORAL,
        PASTEL_SAGE
    ]

    for idx, point in enumerate(chart.series[0].points):
        color = pastel_colors[idx % len(pastel_colors)]
        fill = point.format.fill
        fill.solid()
        fill.fore_color.rgb = color

    # Show data labels with percentages
    chart.plots[0].has_data_labels = True
    data_labels = chart.plots[0].data_labels
    data_labels.number_format = '0%'
    data_labels.font.size = Pt(12)
    data_labels.font.color.rgb = DARK_SLATE

    return slide
```

### 8. Line Chart Slide

```python
def create_line_chart_slide(prs, title, categories, series_data):
    """
    Create line chart for trends with pastel colors
    series_data: [(series_name, [values]), ...]
    """
    slide = prs.slides.add_slide(prs.slide_layouts[6])

    # Add title
    left = Inches(0.5)
    top = Inches(0.5)
    width = Inches(9)
    height = Inches(0.8)

    title_box = slide.shapes.add_textbox(left, top, width, height)
    title_frame = title_box.text_frame
    title_frame.text = title
    title_frame.paragraphs[0].font.size = Pt(32)
    title_frame.paragraphs[0].font.bold = True
    title_frame.paragraphs[0].font.color.rgb = DARK_SLATE

    # Add chart
    chart_data = CategoryChartData()
    chart_data.categories = categories

    for series_name, values in series_data:
        chart_data.add_series(series_name, values)

    x, y, cx, cy = Inches(1), Inches(1.6), Inches(8), Inches(3.8)
    chart = slide.shapes.add_chart(
        XL_CHART_TYPE.LINE, x, y, cx, cy, chart_data
    ).chart

    # Style chart
    chart.has_legend = True
    chart.legend.position = XL_LEGEND_POSITION.BOTTOM

    # Apply pastel colors to lines
    pastel_colors = [
        PASTEL_BLUE,
        PASTEL_MINT,
        PASTEL_CORAL,
        PASTEL_LAVENDER
    ]

    for idx, series in enumerate(chart.series):
        color = pastel_colors[idx % len(pastel_colors)]
        line = series.format.line
        line.color.rgb = color
        line.width = Pt(3)

    return slide
```

### 9. Add Speaker Notes

```python
def add_speaker_notes(slide, notes_text):
    """Add presenter notes to a slide"""
    notes_slide = slide.notes_slide
    text_frame = notes_slide.notes_text_frame
    text_frame.text = notes_text
```

## Complete Example Script

```python
#!/usr/bin/env python3
"""
Example: Professional Business Presentation with Pastel Colors
"""

from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.enum.text import PP_ALIGN
from pptx.dml.color import RGBColor
import os

# Import all helper functions here
# (Include all the functions defined above)

# Main execution
def main():
    # Create presentation
    prs = Presentation()
    prs.slide_width = Inches(10)
    prs.slide_height = Inches(5.625)

    # Slide 1: Title
    create_title_slide(prs, "Q1 2026 Business Review", "Quarterly Performance and Strategy Update")

    # Slide 2: Agenda
    create_content_slide(prs, "Agenda", [
        (0, "Executive Summary"),
        (0, "Financial Performance"),
        (0, "Key Achievements"),
        (0, "Challenges and Solutions"),
        (0, "Q2 Priorities"),
        (0, "Q&A")
    ])

    # Slide 3: Section header
    create_section_header(prs, "Financial Performance")

    # Slide 4: Bar chart
    create_bar_chart_slide(
        prs,
        "Revenue by Quarter",
        ['Q1 2025', 'Q2 2025', 'Q3 2025', 'Q4 2025', 'Q1 2026'],
        [('Revenue ($M)', [12.5, 14.2, 15.8, 18.1, 20.3])]
    )

    # Slide 5: Pie chart
    create_pie_chart_slide(
        prs,
        "Market Share Distribution",
        ['Product A', 'Product B', 'Product C', 'Product D', 'Others'],
        [0.30, 0.25, 0.20, 0.15, 0.10]
    )

    # Save presentation
    output_dir = os.path.join(os.path.dirname(__file__), '../../../../output')
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, 'Business_Review_Q1_2026.pptx')
    prs.save(output_path)
    print(f"✓ Presentation created: {output_path}")

if __name__ == "__main__":
    main()
```

## Best Practices Summary

1. **Color Consistency**: Use the same pastel colors throughout
2. **Text Contrast**: Always use DARK_SLATE for body text on light backgrounds
3. **Font Sizes**: Title (32pt), Subtitle (24pt), Body (18pt), Table (12-14pt)
4. **White Space**: Leave breathing room around elements
5. **Chart Colors**: Rotate through pastel colors for data series
6. **Alignment**: Keep elements consistently aligned
7. **Speaker Notes**: Add notes for complex slides

## Tips

- Test your presentation on the target platform (PowerPoint/Keynote)
- Use high contrast between text and background
- Limit to 5-7 bullets per slide
- Keep chart data simple and focused
- Add subtle borders for visual definition
- Use section headers to break up long presentations

---

**Remember**: The pastel color scheme provides a modern, professional look while being easy on the eyes. Keep designs clean and focused!
