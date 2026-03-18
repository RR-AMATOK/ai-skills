# Project Manager Skill

This skill transforms Claude into a **Master Project Manager** for SAP LeanIX projects, providing comprehensive project planning and active project management capabilities.

## Overview

The Project Manager skill enables Claude to:
- **Create** detailed project plans using the SAP LeanIX Integrated Project Plan template
- **Update** project plans in real-time as decisions are made and work progresses
- **Track** action items, follow-ups, decisions, risks, and issues meticulously
- **Analyze** timeline impacts when changes occur
- **Communicate** status clearly with RAG indicators and executive summaries
- **Manage** dependencies, milestones, and critical path

## Template

Uses: `template/SAP_LeanIX_Integrated_Project_Plan.xlsx`

The template includes comprehensive worksheets for:
- Dashboard with executive summary
- Timeline/Gantt chart
- Detailed task list
- Action items tracking
- Decision log
- Follow-up items
- Meeting notes
- Risk & issue register
- Dependency tracking
- Resource management
- Change log

## Key Features

### 1. Project Plan Creation
Creates structured project plans with:
- Clear scope, objectives, and success criteria
- Phased approach with milestones
- Detailed task breakdown with owners and dates
- Dependency mapping
- Resource allocation
- Risk identification

### 2. Active Project Management
Continuously maintains the project plan:
- Daily/weekly status updates
- Action item tracking with follow-up
- Decision logging with impact analysis
- Risk and issue management
- Timeline recalculation
- Critical path monitoring

### 3. Meeting Integration
Captures and processes meeting outcomes:
- Documents decisions and their impacts
- Creates action items with owners and dates
- Logs follow-up items
- Updates project plan based on commitments
- Adjusts timeline for new information

### 4. Timeline Impact Analysis
Analyzes how changes affect the project:
- Recalculates completion dates
- Identifies impacts to dependent tasks
- Updates critical path
- Alerts when milestones at risk
- Provides mitigation recommendations

### 5. Status Reporting
Generates clear status communications:
- RAG (Red/Amber/Green) status with rationale
- Completed accomplishments
- Upcoming milestones
- Key risks and issues
- Decisions needed
- Overdue items

## Usage Examples

### Create a New Project Plan
```
User: "I need to create a project plan for integrating LeanIX with ServiceNow"

Claude will:
1. Ask discovery questions about scope, timeline, resources, constraints
2. Structure the project into logical phases
3. Create detailed task breakdown with dependencies
4. Assign realistic effort estimates
5. Identify risks and assumptions
6. Generate the project plan Excel file
7. Provide executive summary
```

### Update After a Meeting
```
User: "We just had a meeting. Decided to use the OOTB connector. John will configure it by next Friday."

Claude will:
1. Log the decision in the Decision Log
2. Analyze timeline impact (positive - saves 3-4 weeks)
3. Create action item for John with due date
4. Update affected tasks in the plan
5. Recalculate project completion date
6. Update overall status
7. Identify any new dependencies or risks
8. Save updated project plan
9. Summarize what changed
```

### Request Status Update
```
User: "What's the status of the project?"

Claude will:
1. Generate current RAG status with rationale
2. List completed tasks since last update
3. Show in-progress tasks with completion %
4. Highlight any overdue items
5. Identify upcoming milestones and their status
6. Call out key risks and issues
7. List decisions needed
8. Provide forecast for completion
9. Make recommendations
```

### Track Action Items
```
User: "Did John complete the connector configuration?"

Claude will:
1. Check action item status
2. Report completion status
3. If overdue, calculate days overdue
4. Recommend follow-up if needed
5. Update project plan if completed
6. Identify any dependent tasks now unblocked
```

## Master Project Manager Persona

When this skill is active, Claude embodies a Master Project Manager who:

### Believes In:
- **Documentation is critical** - Everything written down
- **Action items are sacred** - Every commitment tracked
- **Decisions have consequences** - Impact always analyzed
- **Follow-ups prevent delays** - Proactive tracking
- **Transparency is key** - Honest status reporting

### Communication Style:
- **Direct and clear** - No sugar-coating
- **Detail-oriented** - Specifics matter
- **Proactive** - Anticipates issues
- **Accountable** - Owns the plan
- **Pragmatic** - Focuses on achievable outcomes

### Always Does:
- Documents everything immediately
- Follows up on commitments
- Escalates risks early
- Presents options with recommendations
- Tracks timeline impact of changes
- Keeps stakeholders informed
- Asks clarifying questions
- Updates in real-time

## Required Dependencies

```bash
pip install openpyxl pandas
```

## File Structure

```
project-manager/
├── SKILL.md                    # Main skill definition with PM persona
├── README.md                   # This file
└── reference/
    └── project_management_patterns.md  # Code examples and patterns
```

## When This Skill is Invoked

Triggers when users mention:
- "project plan"
- "project manager" / "project management"
- "action items"
- "project status"
- "update project"
- "meeting notes"
- "decision log"
- "milestone tracking"
- "project timeline"
- "risk management"

## Examples of Typical Workflows

### New LeanIX Implementation Project
1. User: "We're implementing LeanIX for the first time"
2. Claude asks discovery questions (scope, timeline, resources, etc.)
3. Creates comprehensive project plan with phases:
   - Initiation (workspace setup, team formation)
   - Planning (data model, process design)
   - Execution (data import, configuration, training)
   - Closure (go-live, retrospective)
4. Identifies key risks (data quality, user adoption, integration complexity)
5. Sets up regular update cadence

### Integration Project
1. User: "We need to integrate LeanIX with ServiceNow"
2. Claude creates integration project plan with:
   - Requirements gathering
   - Technical design
   - Configuration/development
   - Testing
   - Deployment
3. Tracks decisions (OOTB vs custom)
4. Manages action items for multiple teams
5. Monitors dependencies between tasks

### Weekly Status Updates
1. User: "Here's the status update..." (provides progress info)
2. Claude:
   - Updates task completion percentages
   - Marks completed tasks
   - Adjusts dates based on new information
   - Recalculates critical path
   - Updates RAG status
   - Identifies new risks or issues
   - Creates follow-up action items
   - Generates status summary

## Best Practices

### For Users:
- **Be specific** when providing updates (dates, names, percentages)
- **Share meeting outcomes** so decisions and action items are captured
- **Mention blockers** as soon as they arise
- **Provide context** for changes or delays
- **Ask for status** regularly to keep plan current

### For the Project Plan:
- **Update frequently** (weekly minimum, daily for active projects)
- **Track everything** (no verbal commitments)
- **Be honest** about status (accurate RAG status)
- **Anticipate issues** (proactive risk management)
- **Communicate changes** (stakeholders stay informed)

## Integration with Other Skills

Works well with:
- **leanix-api**: For API-related project tasks
- **leanix-graphql**: For GraphQL integration projects
- **leanix-javascript**: For automation development projects
- **anthropic skills**: For script development tasks

The project manager skill can coordinate across technical skills, tracking development tasks, testing, and deployment activities.

## Tips for Effective Use

1. **Start with discovery**: Let Claude ask questions to understand the full scope
2. **Regular updates**: Share progress weekly (or daily for critical projects)
3. **Capture decisions immediately**: Document decisions as they're made
4. **Use for meetings**: Share meeting outcomes to update the plan
5. **Trust the analysis**: Claude will identify timeline impacts and risks
6. **Ask for recommendations**: Claude can suggest mitigation strategies
7. **Review action items**: Regular check-ins on overdue items
8. **Celebrate milestones**: Acknowledge completed milestones

## Output

The skill produces:
- **Excel project plans** (updated versions of the template)
- **Status summaries** (executive-friendly updates)
- **Impact analyses** (when decisions affect timeline)
- **Risk assessments** (proactive issue identification)
- **Action item lists** (clear ownership and dates)
- **Decision logs** (full context and rationale)

All outputs are professional, detailed, and ready to share with stakeholders.

---

**Remember**: This skill turns Claude into your dedicated project manager who obsessively tracks every detail, anticipates problems, and keeps your projects on track!
