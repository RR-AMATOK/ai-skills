# Create Professional PowerPoint Presentations

This skill helps you create professional, beautiful PowerPoint presentations with a modern pastel color scheme. Perfect for any corporate, business, or professional context without being tied to a specific company brand.

## Task

When the user wants to create a PowerPoint presentation:

### Step 1: Gather Requirements
Ask for presentation details (if not provided):
   - **Topic/Purpose**: What is the presentation about?
   - **Target Audience**: Who will view it? (Executives, Technical Teams, Stakeholders)
   - **Key Sections**: What major topics need to be covered?
   - **Content Type**: Text, data visualizations, tables, images?
   - **Data Source**: Should it pull data from external sources? (APIs, databases)
   - **Tone**: Formal/Executive vs. Technical/Detailed
   - **Length**: Approximate number of slides (10-20 typical for business presentations)

### Step 2: Create the Presentation Script
Generate a Python script that:
   - Creates a new blank presentation or optionally loads a template from `../../../template/`
   - Uses the `python-pptx` library for PowerPoint manipulation
   - Follows a beautiful pastel color scheme (defined below)
   - Creates clear, professional slide layouts
   - Saves output to: `../../../output/<descriptive_name>.pptx`

### Step 3: Script Structure and Implementation

#### Template and Color Scheme
```python
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.enum.text import PP_ALIGN
from pptx.dml.color import RGBColor
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE, XL_LEGEND_POSITION
import os

# Professional Pastel Color Palette
# Soft, modern colors that work well for corporate presentations
PASTEL_BLUE = RGBColor(147, 197, 253)      # Soft blue - Primary headings
PASTEL_LAVENDER = RGBColor(196, 181, 253)  # Lavender - Secondary elements
PASTEL_MINT = RGBColor(167, 243, 208)      # Mint green - Success/positive
PASTEL_PEACH = RGBColor(254, 202, 202)     # Peach - Highlights/warnings
PASTEL_CORAL = RGBColor(252, 165, 165)     # Coral - Important/critical
PASTEL_SAGE = RGBColor(187, 222, 214)      # Sage green - Neutral/calm
PASTEL_PERIWINKLE = RGBColor(199, 210, 254) # Periwinkle - Alternative blue
PASTEL_ROSE = RGBColor(251, 207, 232)      # Rose - Accent color

# Dark text colors for readability
DARK_SLATE = RGBColor(51, 65, 85)          # Dark text on light backgrounds
MEDIUM_SLATE = RGBColor(100, 116, 139)     # Secondary text
LIGHT_GRAY = RGBColor(241, 245, 249)       # Light backgrounds

# Create new presentation
prs = Presentation()

# Set default slide width and height (16:9 aspect ratio)
prs.slide_width = Inches(10)
prs.slide_height = Inches(5.625)
```

#### Standard Slide Layouts
When creating from scratch (without a template), use these custom layout patterns:

**Title Slide**:
- Large centered title with PASTEL_BLUE color
- Subtitle in MEDIUM_SLATE
- Optional decorative shapes using pastel colors

**Content Slide**:
- Title at top (DARK_SLATE, 32pt)
- Body content area with bullet points (18-20pt)
- Optional pastel accent line under title

**Section Header**:
- Large centered text (40-44pt)
- Pastel background color (light tint)
- Used as visual breaks between sections

**Two Column**:
- Title at top
- Two side-by-side content areas
- Pastel accent boxes for visual separation

#### Helper Functions to Include
Always define these reusable helper functions in your script:

1. **create_title_slide(prs, title, subtitle)**
   - Creates opening title slide
   - Centers title with PASTEL_BLUE color
   - Adds subtitle in MEDIUM_SLATE
   - Optional: Add decorative pastel shapes

2. **create_section_header(prs, section_title)**
   - Creates section divider slide
   - Large centered text (40pt+)
   - Light pastel background
   - Used for visual breaks

3. **create_content_slide(prs, title, bullet_points)**
   - Standard content slide
   - bullet_points: list of tuples [(level, text), ...]
   - Level 0 = main bullet, 1 = sub-bullet
   - Adds pastel accent line under title

4. **create_two_column_slide(prs, title, left_title, left_points, right_title, right_points)**
   - Comparison slide
   - Two parallel content columns
   - Pastel boxes to separate columns visually

5. **create_table_slide(prs, title, table_data)**
   - Table slide with data
   - table_data: 2D list [[row1], [row2], ...]
   - Auto-formats header row with pastel background
   - Alternating row colors for readability

6. **create_bar_chart_slide(prs, title, categories, series_data)**
   - Bar/column chart slide
   - series_data: [(series_name, [values]), ...]
   - Uses pastel colors for data series

7. **create_pie_chart_slide(prs, title, categories, values)**
   - Pie chart for distribution data
   - Each slice uses a different pastel color

8. **create_line_chart_slide(prs, title, categories, series_data)**
   - Line chart for trends over time
   - Multiple series with different pastel colors

9. **add_speaker_notes(slide, notes_text)**
   - Adds presenter notes to any slide
   - Helpful for speaker guidance

Refer to `reference/powerpoint_best_practices.md` for complete implementations.

### Step 4: Content Guidelines

#### Slide Design Principles
- **One Message Per Slide**: Focus on a single key point
- **Visual Hierarchy**: Title (28-32pt) → Subtitle (22-24pt) → Body (18-20pt)
- **Consistent Colors**: Use pastel palette throughout
- **White Space**: Don't overcrowd - leave breathing room
- **5-7-5 Rule**: Max 5 bullets, 7 words per bullet, 5 word slide titles
- **Data Over Text**: Prefer charts/graphs over text-heavy slides

#### Text Formatting Standards
- **Titles**: 28-32pt, Bold, DARK_SLATE with PASTEL_BLUE accents
- **Subtitles**: 22-24pt, MEDIUM_SLATE
- **Body Text**: 18-20pt minimum for readability
- **Bullet Points**:
  - Level 0: 18pt
  - Level 1: 16pt (max 2 sub-levels)
  - Level 2: 14pt
- **Table Text**: 12-14pt for cells, 14pt bold for headers
- **Chart Labels**: 10-12pt

#### Color Usage Guidelines
- **PASTEL_BLUE**: Primary titles, key headings, important data points
- **PASTEL_LAVENDER**: Secondary elements, supporting information
- **PASTEL_MINT**: Success indicators, positive trends, growth
- **PASTEL_PEACH**: Highlights, attention items, caution
- **PASTEL_CORAL**: Important notes, critical items
- **PASTEL_SAGE**: Neutral elements, background accents
- **PASTEL_PERIWINKLE**: Alternative blue, variety in charts
- **PASTEL_ROSE**: Accent color, decorative elements
- **DARK_SLATE**: Primary text color (always readable)
- **MEDIUM_SLATE**: Secondary text, descriptions

#### Common Presentation Structures

**Executive Presentation (15-20 slides)**:
1. Title slide with presentation name and date
2. Agenda/Table of contents
3. Executive summary (1 slide, key takeaways)
4. Section 1: Current state analysis
   - Data visualizations (charts, tables)
   - Key metrics and findings
5. Section 2: Problem statement or opportunity
   - Quantified business impact
6. Section 3: Proposed solution or strategy
   - Approach comparison (if applicable)
   - Implementation details
7. Section 4: Roadmap and timeline
   - Phased approach with milestones
8. Section 5: Resource requirements
   - Budget, team, timeline
9. Section 6: Expected outcomes
   - Business benefits and ROI
   - Success metrics
10. Next steps and recommendations
11. Q&A slide

**Technical Presentation (10-15 slides)**:
1. Title slide
2. Architecture overview
3. Technical components breakdown
4. Data flow diagrams
5. Technology stack details
6. Integration points
7. Security and compliance
8. Performance metrics
9. Implementation considerations
10. Technical roadmap
11. Q&A

**Business Update (8-12 slides)**:
1. Title slide
2. Agenda
3. Key achievements
4. Metrics dashboard
5. Progress vs. goals
6. Challenges and solutions
7. Next period priorities
8. Call to action or decisions needed

### Step 5: Data Visualization Best Practices

When creating charts with pastel colors:

```python
# Example: Multi-series bar chart with pastel colors
def create_multi_series_chart(prs, title, categories, series_data):
    """
    Creates a beautiful multi-series bar chart
    series_data: [("Series 1", [values]), ("Series 2", [values]), ...]
    """
    slide = prs.slides.add_slide(prs.slide_layouts[5])

    # Pastel colors for chart series
    chart_colors = [
        PASTEL_BLUE,
        PASTEL_LAVENDER,
        PASTEL_MINT,
        PASTEL_PEACH,
        PASTEL_PERIWINKLE,
        PASTEL_SAGE
    ]

    # Add chart (implementation details in reference docs)
    # Use chart_colors to style each series
```

### Step 6: Execution and Output

1. **Create the Script**:
   - Write a complete, executable Python script
   - Include all helper functions
   - Add comprehensive comments
   - Handle errors gracefully

2. **Execute the Script**:
   ```bash
   python3 script_name.py
   ```

3. **Verify Output**:
   - Check that file is created in `../../../output/` directory
   - Confirm all slides are present
   - Validate formatting and content

4. **Report to User**:
   - Show file location
   - Summarize slide count and structure
   - Provide any presenter notes or tips
   - Suggest improvements if applicable

### Step 7: Post-Creation Review

After creating the presentation:
- **Content Review**: Ensure all requested topics are covered
- **Visual Consistency**: Check that pastel colors are used consistently
- **Data Accuracy**: Verify any data/metrics are correct
- **Flow**: Confirm logical progression of ideas
- **Suggestions**: Offer optional enhancements

## Required Dependencies

Ensure `python-pptx` is installed:
```bash
python3 -m pip install python-pptx --user --break-system-packages
```

Dependencies automatically installed with python-pptx:
- Pillow (image handling)
- lxml (XML processing)
- XlsxWriter (Excel chart data)

## Reference Materials

- **Comprehensive Guide**: [reference/powerpoint_best_practices.md](reference/powerpoint_best_practices.md)
  - Complete patterns for all slide types
  - Advanced formatting techniques
  - Chart and table creation with pastel colors
  - Helper function implementations

- **Working Example**: [reference/example_presentation.py](reference/example_presentation.py)
  - Full presentation script demonstrating all features
  - Professional business presentation with pastel theme
  - Multiple slide types and visualizations

- **Quick Start**: [reference/QUICK_START.md](reference/QUICK_START.md)
  - Fast introduction to creating presentations
  - Common patterns and snippets

## Example Usage Scenarios

### Scenario 1: Business Proposal
**User**: "Create a presentation for a new product launch proposal"

**Assistant Actions**:
1. Ask clarifying questions:
   - Product details and target market
   - Audience (executives, investors, team)
   - Key messages to convey

2. Create presentation with:
   - Title slide: "New Product Launch Proposal"
   - Executive summary with key points
   - Market opportunity (chart showing market size)
   - Product overview and features
   - Competitive analysis (comparison table)
   - Go-to-market strategy
   - Financial projections (line chart)
   - Timeline and milestones
   - Investment requirements
   - Expected outcomes and ROI

### Scenario 2: Quarterly Review
**User**: "Create our Q1 2026 business review presentation"

**Assistant Actions**:
1. Create structured quarterly review:
   - Title slide: "Q1 2026 Business Review"
   - Agenda
   - Executive summary (achievements)
   - Financial performance (multiple charts)
   - Key metrics dashboard
   - Department highlights
   - Challenges and learnings
   - Q2 priorities and goals
   - Resource needs
   - Q&A slide

### Scenario 3: Training Presentation
**User**: "I need a training presentation on project management best practices"

**Assistant Actions**:
1. Create educational presentation:
   - Title: "Project Management Excellence"
   - Learning objectives
   - Module 1: Planning fundamentals
   - Module 2: Execution strategies
   - Module 3: Risk management
   - Module 4: Team collaboration
   - Module 5: Monitoring and control
   - Case study examples
   - Tools and resources
   - Summary and key takeaways
   - Assessment questions

### Scenario 4: Conference Presentation
**User**: "Create a presentation for a tech conference about AI in business"

**Assistant Actions**:
1. Create engaging conference presentation:
   - Eye-catching title slide
   - Speaker introduction
   - Current AI landscape (statistics)
   - Business use cases (with examples)
   - Implementation strategies
   - ROI and business impact (charts)
   - Challenges and solutions
   - Future trends
   - Live demo or case study
   - Q&A and contact information

### Scenario 5: Sales Pitch
**User**: "I need a sales deck for our consulting services"

**Assistant Actions**:
1. Create compelling sales presentation:
   - Title with company positioning
   - The problem we solve
   - Our unique approach
   - Service offerings overview
   - Success stories and testimonials
   - Process and methodology
   - Team and expertise
   - Pricing and packages
   - Client results (before/after metrics)
   - Next steps and call to action

## Output

A professionally formatted PowerPoint presentation (`.pptx` file) that:
- Uses a beautiful, modern pastel color scheme
- Contains clear, focused slides with consistent formatting
- Includes appropriate data visualizations when applicable
- Follows presentation best practices
- Is ready to present or share with stakeholders
- Can be opened in Microsoft PowerPoint, Apple Keynote, or Google Slides
- Works for any professional context (not tied to a specific brand)

## Tips for Creating Beautiful Presentations

### Visual Design
1. **Color Strategy**:
   - Use PASTEL_BLUE for primary elements (titles, key data)
   - Use PASTEL_MINT for positive/success indicators
   - Use PASTEL_PEACH for highlights/attention items
   - Use PASTEL_CORAL sparingly for critical items
   - Vary pastel colors in charts for visual interest
   - Always use DARK_SLATE for body text (readability)
   - Maintain consistent color meaning throughout

2. **Typography**:
   - Limit to 2-3 font sizes per slide
   - Use bold for emphasis, not underline
   - Left-align body text for readability
   - Center-align titles and section headers
   - Ensure high contrast between text and background

3. **Data Visualization**:
   - Choose chart type based on data story:
     - **Pie charts**: Proportions/distribution (max 5-6 slices)
     - **Bar charts**: Comparisons across categories
     - **Line charts**: Trends over time
     - **Tables**: Exact values, detailed data (limit rows to 7-10)
   - Always include labels, legends, and units
   - Use different pastel colors for each data series
   - Add subtle borders or shadows for depth

4. **Layout Balance**:
   - Follow the rule of thirds
   - Group related information
   - Use whitespace intentionally
   - Align elements consistently
   - Add subtle pastel accents for visual interest

### Content Strategy
1. **Tell a Story**:
   - Beginning: Set context, state problem
   - Middle: Present analysis, show options
   - End: Recommend action, define next steps

2. **Audience-Centric**:
   - **Executives**: Focus on business impact, ROI, strategic implications
   - **Technical**: Include architecture, detailed specs, technical trade-offs
   - **Mixed**: Start high-level, provide technical appendix
   - **General**: Focus on clarity and accessibility

3. **Engagement**:
   - Ask rhetorical questions in titles
   - Use concrete examples and case studies
   - Include testimonials or quotes when relevant
   - Add speaker notes for presenter guidance
   - Use visuals to break up text-heavy sections

## Troubleshooting

### Common Issues

**Issue**: python-pptx not installed
```
ModuleNotFoundError: No module named 'pptx'
```
**Solution**: Install with `python3 -m pip install python-pptx --user --break-system-packages`

**Issue**: Chart data not displaying correctly
**Solution**: Ensure data is properly formatted as numbers (not strings) and categories match values length.

**Issue**: Text overflow or truncation
**Solution**: Reduce font size slightly, use fewer bullet points, or split content across multiple slides.

**Issue**: Images not loading
**Solution**: Verify image file paths are absolute or correct relative paths. Check file permissions.

**Issue**: Colors look different in PowerPoint vs. Keynote
**Solution**: RGB colors are generally consistent, but test on target platform. Some pastel gradients may render differently.

**Issue**: Slide layouts not appearing correctly
**Solution**: When creating from scratch (no template), use custom positioning with Inches() for precise placement.

## Advanced Techniques

### Dynamic Content from APIs
- Integrate with REST APIs or GraphQL
- Transform API responses into charts/tables
- Cache data to avoid repeated API calls
- Handle pagination for large datasets

### Custom Templates
- Create your own .potx template with pastel theme in PowerPoint
- Save custom slide masters with pastel colors
- Reference template in script: `Presentation('path/to/template.potx')`

### Adding Images and Icons
```python
# Add image to slide
img_path = 'path/to/image.png'
left = Inches(1)
top = Inches(2)
pic = slide.shapes.add_picture(img_path, left, top, width=Inches(4))
```

### Gradient Backgrounds (Advanced)
- Create gradient backgrounds using pastel colors
- Combine multiple pastel shades for depth
- Use subtle gradients, not overwhelming

### Batch Presentation Generation
- Create scripts to generate multiple presentations from data
- Use templates for recurring reports (monthly, quarterly)
- Automate stakeholder updates

## Related Skills

- **claude-api**: For integrating AI-generated content into presentations
- **analyze-script**: Review presentation scripts for quality

## Success Metrics

A successful presentation creation includes:
- ✓ All requested content covered comprehensively
- ✓ Consistent pastel color theme throughout
- ✓ Appropriate use of visualizations for data
- ✓ Clear narrative flow and logical structure
- ✓ Readable fonts with proper contrast
- ✓ Professional appearance ready for any audience
- ✓ File successfully created and accessible
- ✓ Speaker notes added where helpful
- ✓ Works across PowerPoint, Keynote, and Google Slides

---

**Remember**: A great presentation is clear, focused, and visually engaging. The pastel color scheme provides a modern, professional look that works for any corporate or business context. Less is often more—prioritize quality over quantity of slides.
