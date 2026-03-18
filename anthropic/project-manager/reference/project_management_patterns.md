# Project Management Best Practices

## Excel Operations with openpyxl

### Reading the Project Plan
```python
from openpyxl import load_workbook
from datetime import datetime, timedelta

# Load workbook
wb = load_workbook('template/SAP_LeanIX_Integrated_Project_Plan.xlsx')

# Access specific worksheet
task_sheet = wb['Task List']

# Read cell value
task_name = task_sheet['A2'].value
due_date = task_sheet['D2'].value

# Iterate through rows
for row in task_sheet.iter_rows(min_row=2, values_only=True):
    task_id, name, owner, due_date, status = row[:5]
    print(f"{task_id}: {name} - {status}")
```

### Writing Updates
```python
# Update a specific cell
task_sheet['E2'] = 'In Progress'
task_sheet['F2'] = 75  # Completion percentage

# Add timestamp
task_sheet['G2'] = datetime.now()

# Append new row (for action items, decisions, etc.)
action_items = wb['Action Items']
new_row = [
    len(list(action_items.rows)) + 1,  # ID
    'Configure ServiceNow connector',   # Description
    'John',                              # Owner
    datetime.now() + timedelta(days=7), # Due Date
    'High',                              # Priority
    'Open',                              # Status
    'Task-123'                           # Related Task
]
action_items.append(new_row)

# Save workbook
wb.save('LeanIX_Project_Plan_Updated.xlsx')
print("Project plan updated successfully!")
```

### Conditional Formatting and Formulas
```python
from openpyxl.styles import PatternFill

# Apply RAG status coloring
def apply_rag_status(cell, status):
    if status == 'Green':
        cell.fill = PatternFill(start_color='00FF00', fill_type='solid')
    elif status == 'Amber':
        cell.fill = PatternFill(start_color='FFA500', fill_type='solid')
    elif status == 'Red':
        cell.fill = PatternFill(start_color='FF0000', fill_type='solid')

# Update with status coloring
status_cell = task_sheet['H2']
status_cell.value = 'Amber'
apply_rag_status(status_cell, 'Amber')
```

## Timeline Calculations

### Calculate Working Days
```python
from datetime import datetime, timedelta

def add_working_days(start_date, days):
    """Add working days (excluding weekends)"""
    current = start_date
    while days > 0:
        current += timedelta(days=1)
        if current.weekday() < 5:  # Monday = 0, Friday = 4
            days -= 1
    return current

# Example
start = datetime(2026, 3, 18)  # Tuesday
end = add_working_days(start, 10)  # Add 10 working days
print(f"Start: {start.strftime('%Y-%m-%d')}")
print(f"End: {end.strftime('%Y-%m-%d')}")
```

### Calculate Variance
```python
def calculate_variance(planned_date, actual_date):
    """Calculate variance in days"""
    if actual_date is None:
        return None
    delta = (actual_date - planned_date).days
    return delta

# Example
planned = datetime(2026, 3, 20)
actual = datetime(2026, 3, 23)
variance = calculate_variance(planned, actual)
print(f"Variance: {variance} days {'behind' if variance > 0 else 'ahead'}")
```

### Identify Critical Path
```python
def calculate_critical_path(tasks):
    """Simple critical path calculation"""
    # Sort tasks by dependencies
    # Calculate early start/finish
    # Calculate late start/finish
    # Identify tasks with zero slack (critical path)

    critical_tasks = []
    for task in tasks:
        if task['slack'] == 0:
            critical_tasks.append(task)
    return critical_tasks
```

## Action Item Management

### Action Item Structure
```python
action_item = {
    'id': 'AI-001',
    'description': 'Complete data mapping document',
    'owner': 'Sarah Johnson',
    'due_date': datetime(2026, 3, 25),
    'priority': 'High',  # Critical, High, Medium, Low
    'status': 'Open',    # Open, In Progress, Blocked, Completed, Cancelled
    'related_task': 'TASK-015',
    'created_date': datetime(2026, 3, 18),
    'completed_date': None,
    'notes': 'Include all ServiceNow CI classes'
}
```

### Follow-Up Tracking
```python
def get_overdue_items(action_items):
    """Return action items past due date"""
    today = datetime.now()
    overdue = []
    for item in action_items:
        if item['status'] not in ['Completed', 'Cancelled']:
            if item['due_date'] < today:
                days_overdue = (today - item['due_date']).days
                overdue.append({
                    **item,
                    'days_overdue': days_overdue
                })
    return sorted(overdue, key=lambda x: x['days_overdue'], reverse=True)

def get_upcoming_items(action_items, days_ahead=7):
    """Return action items due in next N days"""
    today = datetime.now()
    deadline = today + timedelta(days=days_ahead)
    upcoming = []
    for item in action_items:
        if item['status'] not in ['Completed', 'Cancelled']:
            if today <= item['due_date'] <= deadline:
                upcoming.append(item)
    return sorted(upcoming, key=lambda x: x['due_date'])
```

## Decision Logging

### Decision Log Structure
```python
decision = {
    'id': 'DEC-001',
    'date': datetime(2026, 3, 18),
    'decision': 'Use out-of-box ServiceNow connector instead of custom integration',
    'context': 'Evaluated custom vs OOTB. Custom provides more flexibility but OOTB is proven and faster.',
    'decided_by': 'Sarah Johnson (IT Director)',
    'attendees': ['Sarah', 'Mike', 'John', 'Lisa'],
    'impact_timeline': 'Positive - Saves 3-4 weeks',
    'impact_scope': 'Minor reduction in customization options',
    'impact_cost': 'Neutral - Connector included in license',
    'affected_tasks': ['TASK-008', 'TASK-009', 'TASK-010'],
    'rationale': 'Speed to market prioritized. OOTB connector meets 95% of requirements.',
    'alternatives_considered': [
        'Custom Python integration',
        'Third-party middleware',
        'OOTB connector (selected)'
    ]
}
```

### Impact Analysis
```python
def analyze_decision_impact(decision, project_plan):
    """Analyze and report impact of decision on project"""

    affected_tasks = []
    timeline_change = 0

    for task_id in decision['affected_tasks']:
        task = project_plan.get_task(task_id)
        if task:
            # Determine impact
            if 'remove' in decision['decision'].lower():
                timeline_change -= task['duration']
                task['status'] = 'Cancelled'
            elif 'add' in decision['decision'].lower():
                # New task may be added
                pass

            affected_tasks.append(task)

    return {
        'affected_tasks': affected_tasks,
        'timeline_change_days': timeline_change,
        'new_completion_date': project_plan.end_date + timedelta(days=timeline_change),
        'critical_path_affected': any(t['is_critical'] for t in affected_tasks)
    }
```

## Risk Management

### Risk Register Structure
```python
risk = {
    'id': 'RISK-001',
    'title': 'API rate limits may impact data import performance',
    'description': 'LeanIX API has rate limits. Large data imports may trigger throttling.',
    'category': 'Technical',  # Technical, Resource, Schedule, Scope, External
    'identified_date': datetime(2026, 3, 10),
    'identified_by': 'John Developer',
    'probability': 'High',  # High (>70%), Medium (30-70%), Low (<30%)
    'impact': 'Medium',     # High, Medium, Low
    'risk_score': 'High',   # Probability x Impact
    'status': 'Mitigating', # Identified, Analyzing, Mitigating, Monitoring, Closed
    'mitigation_plan': 'Implement batch processing with delays between API calls',
    'mitigation_owner': 'John Developer',
    'mitigation_due_date': datetime(2026, 3, 20),
    'contingency_plan': 'If throttling occurs, split imports into smaller batches overnight',
    'actual_outcome': None,
    'closed_date': None
}
```

### Risk Assessment Matrix
```python
def calculate_risk_score(probability, impact):
    """Calculate risk score"""
    scores = {'Low': 1, 'Medium': 2, 'High': 3}
    score = scores[probability] * scores[impact]

    if score >= 6:
        return 'High'
    elif score >= 3:
        return 'Medium'
    else:
        return 'Low'

def prioritize_risks(risks):
    """Sort risks by score and probability"""
    return sorted(risks,
                  key=lambda r: (r['risk_score'], r['probability']),
                  reverse=True)
```

## Meeting Notes Template

### Structured Meeting Notes
```python
meeting = {
    'date': datetime(2026, 3, 18, 14, 0),  # March 18, 2:00 PM
    'title': 'ServiceNow Integration - Design Review',
    'attendees': ['Sarah (IT Director)', 'Mike (PM)', 'John (Dev)', 'Lisa (BA)'],
    'objective': 'Review integration design and finalize approach',
    'agenda': [
        'Review current design',
        'Discuss OOTB vs custom integration',
        'Define data mapping requirements',
        'Agree on timeline'
    ],
    'discussion_summary': """
    - Reviewed ServiceNow connector capabilities
    - Consensus that OOTB connector meets requirements
    - Data mapping needs to include all CI classes
    - Timeline can be accelerated with OOTB approach
    """,
    'decisions': ['DEC-001'],  # Reference to decision IDs
    'action_items': ['AI-001', 'AI-002', 'AI-003'],  # Reference to action item IDs
    'follow_ups': [
        'Schedule configuration workshop with ServiceNow admin',
        'Review connector documentation and share with team'
    ],
    'next_meeting': datetime(2026, 3, 25, 14, 0),
    'notes': 'Positive momentum. Team aligned on approach.'
}
```

## Status Reporting

### Executive Summary Template
```python
def generate_status_report(project_plan, as_of_date):
    """Generate executive status report"""

    report = {
        'as_of_date': as_of_date,
        'overall_status': project_plan.overall_status,  # Green, Amber, Red
        'completion_percentage': project_plan.calculate_completion(),

        'milestones': {
            'completed': project_plan.get_completed_milestones(),
            'upcoming': project_plan.get_upcoming_milestones(days=30),
            'at_risk': project_plan.get_at_risk_milestones()
        },

        'accomplishments': project_plan.get_completed_tasks(since=as_of_date - timedelta(days=7)),
        'planned_next_period': project_plan.get_planned_tasks(until=as_of_date + timedelta(days=7)),

        'issues': {
            'critical': project_plan.get_issues(severity='Critical'),
            'high': project_plan.get_issues(severity='High')
        },

        'risks': {
            'high': project_plan.get_risks(score='High'),
            'medium': project_plan.get_risks(score='Medium')
        },

        'metrics': {
            'tasks_completed': project_plan.count_completed_tasks(),
            'tasks_remaining': project_plan.count_remaining_tasks(),
            'budget_consumed': project_plan.calculate_budget_consumed(),
            'schedule_variance': project_plan.calculate_schedule_variance()
        },

        'decisions_needed': project_plan.get_pending_decisions(),
        'overdue_action_items': project_plan.get_overdue_action_items(),

        'forecast': {
            'completion_date': project_plan.forecast_completion_date(),
            'confidence': project_plan.calculate_forecast_confidence()
        }
    }

    return report
```

### RAG Status Logic
```python
def determine_rag_status(project_plan):
    """Determine overall RAG status"""

    # Critical issues = Red
    if project_plan.has_critical_issues():
        return 'Red'

    # High risks not mitigated = Red
    if project_plan.has_unmitigated_high_risks():
        return 'Red'

    # More than 2 weeks behind = Red
    if project_plan.schedule_variance_days() > 14:
        return 'Red'

    # Budget overrun > 10% = Red
    if project_plan.budget_variance_percent() > 10:
        return 'Red'

    # 1-2 weeks behind = Amber
    if 7 <= project_plan.schedule_variance_days() <= 14:
        return 'Amber'

    # High priority action items overdue = Amber
    if project_plan.has_overdue_high_priority_items():
        return 'Amber'

    # Medium/high risks = Amber
    if project_plan.has_medium_or_high_risks():
        return 'Amber'

    # Otherwise = Green
    return 'Green'
```

## Common Project Management Patterns

### Weekly Status Update Pattern
1. Review completed tasks since last update
2. Update in-progress task completion percentages
3. Check for overdue action items and follow up
4. Review risks - any new or changed status?
5. Check upcoming milestones - on track?
6. Identify any blockers or issues
7. Update overall status (RAG)
8. Prepare summary for stakeholders

### Decision-Making Pattern
1. Frame the decision clearly
2. Present 2-4 options with pros/cons
3. Provide recommendation with rationale
4. Identify who needs to decide
5. Set decision deadline
6. Document the decision once made
7. Update project plan based on decision
8. Communicate decision and impacts

### Risk Management Pattern
1. Identify risk early
2. Assess probability and impact
3. Determine if mitigation needed
4. Assign mitigation owner and due date
5. Track mitigation progress
6. Monitor for risk realization
7. Close when no longer relevant
8. Capture lessons learned

### Issue Resolution Pattern
1. Log issue immediately
2. Assess severity and urgency
3. Assign owner for resolution
4. Determine workaround if needed
5. Track resolution progress
6. Update dependent tasks/timeline
7. Communicate resolution
8. Close with root cause analysis
