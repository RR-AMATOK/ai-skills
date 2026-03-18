# Usage Examples

This document provides practical examples of how to use the AI Skills Framework.

## Example 1: First-Time Setup

After cloning the repository:

```bash
# Navigate to the ai-skills directory
cd ai-skills

# Run the setup script to initialize memory from templates
./setup.sh

# Output:
# 🚀 AI Skills Framework Setup
# ================================
#
# Setting up memory files...
#
# ✅ Created MEMORY.md from template
# ✅ Created patterns.md from template
# ✅ Created debugging.md from template
#
# ================================
# ✨ Setup complete!
```

## Example 2: Agent Auto-Detection (Claude)

When Claude starts:

1. **Reads configuration**:
   ```json
   {
     "providers": {
       "anthropic": {
         "models": ["claude-4", "claude-3", "claude"],
         "skillsPath": "./anthropic",
         "enabled": true
       }
     }
   }
   ```

2. **Detects it's running as "claude-4.5-sonnet"**
   - Matches pattern "claude-4" → Provider: `anthropic`

3. **Loads skills from `./anthropic/`**:
   - All `.md` files in the folder
   - Skills specific to Claude

4. **Loads memory**:
   - Reads `./memory/MEMORY.md`
   - Gets context about user preferences and patterns

## Example 3: Agent Auto-Detection (ChatGPT)

When ChatGPT starts:

1. **Reads the same configuration**
2. **Detects it's running as "gpt-4"**
   - Matches pattern "gpt-4" → Provider: `openai`

3. **Loads skills from `./openai/`**:
   - All `.md` files in the folder
   - Skills specific to GPT models

4. **Loads same memory system**:
   - Same `./memory/MEMORY.md`
   - Shared context across providers

## Example 4: Adding a New Provider

To add support for Mistral AI:

1. **Create provider folder**:
   ```bash
   mkdir mistral
   ```

2. **Add skills to the folder**:
   ```bash
   # Create skill files
   touch mistral/code-review.md
   touch mistral/refactor.md
   ```

3. **Update configuration**:
   ```json
   {
     "providers": {
       "mistral": {
         "models": ["mistral-large", "mistral-medium", "mistral"],
         "skillsPath": "./mistral",
         "enabled": true,
         "description": "Skills for Mistral AI models"
       }
     }
   }
   ```

4. **Agent auto-detects and loads**:
   - When Mistral AI starts, it detects the model name
   - Matches it to the "mistral" provider
   - Loads skills from `./mistral/` folder

## Example 5: Memory System in Action

### Initial State (from template)
```markdown
# AI Skills Memory

## User Preferences

### Communication Style
- [Empty - to be filled in]
```

### After Learning User Preferences
```markdown
# AI Skills Memory

## User Preferences

### Communication Style
- Prefers concise responses without verbose explanations
- Likes code examples over theoretical descriptions
- Wants error messages to include suggested fixes
- Uses Python primarily, with focus on data processing
```

### During Next Session
The agent reads this memory and:
- Provides concise responses
- Includes code examples
- Adds fix suggestions to errors
- Focuses on Python best practices

## Example 6: Multi-Provider Repository

A team has multiple AI tools:

```
ai-skills/
├── anthropic/          # For Claude users
│   ├── claude-code-review.md
│   └── claude-refactor.md
├── openai/             # For ChatGPT users
│   ├── gpt-code-review.md
│   └── gpt-refactor.md
├── shared/             # Works for everyone
│   └── general-helper.md
└── memory/             # Shared learning
    └── MEMORY.md
```

**Benefits**:
- Everyone uses the same repository
- Skills automatically load based on which tool they're using
- Shared memory benefits everyone
- No manual configuration needed

## Example 7: Customizing for Your Project

### Scenario: LeanIX API Development

1. **Update MEMORY.md with project context**:
   ```markdown
   ## Context-Specific Learnings

   ### LeanIX Scripts Project
   - Python-based scripts for SAP LeanIX API
   - Uses GraphQL and REST APIs
   - Located at: `/path/to/LeanIX-Scripts/`
   - Environment configuration in `environment/` folder
   - Uses authentication via lx_Auth.py
   ```

2. **Create project-specific patterns**:
   ```markdown
   # patterns.md

   ## LeanIX API Patterns

   ### Authentication
   - Always use lx_Auth.py for authentication
   - Store credentials in environment/.env.shared
   - Never hardcode API keys

   ### GraphQL Calls
   - Use lx_graphql_call.py helper
   - Structure queries in separate files
   - Handle pagination for large datasets
   ```

3. **Agent uses this context automatically**:
   - Knows where files are located
   - Follows project conventions
   - Applies authentication patterns correctly

## Example 8: Privacy & Git

### What Gets Committed
```bash
git status

# Tracked (committed to git):
✅ agent-config.json
✅ README.md
✅ AGENT_INIT.md
✅ setup.sh
✅ memory/*.template files
✅ anthropic/ folder and skills
✅ openai/ folder and skills
✅ .gitignore
```

### What Stays Local
```bash
# Not tracked (stays on your machine):
❌ memory/MEMORY.md (your personal context)
❌ memory/patterns.md (your project-specific notes)
❌ memory/debugging.md (your solutions)
❌ *.local.* files (your overrides)
❌ secrets/ (your credentials)
```

**Result**: You can share the framework on GitHub without exposing personal/project data!

## Example 9: Team Collaboration

### Team Lead Sets Up Repository
```bash
# Create shared skills
cd anthropic/
touch team-coding-standards.md
touch team-pr-review.md

# Commit to git
git add anthropic/
git commit -m "Add team skills"
git push
```

### Team Member Clones and Uses
```bash
# Clone the repo
git clone <repo-url>
cd ai-skills

# Initialize personal memory
./setup.sh

# Customize memory/MEMORY.md with personal preferences
vim memory/MEMORY.md

# Their agent now has:
# - Team's shared skills ✅
# - Personal memory (not shared) ✅
# - Auto-detection ✅
```

## Example 10: Troubleshooting

### Problem: Skills Not Loading

**Check provider configuration**:
```bash
# Look at agent-config.json
cat agent-config.json | grep -A 5 "anthropic"
```

Output should show:
```json
"anthropic": {
  "models": ["claude-4", "claude-3", "claude"],
  "skillsPath": "./anthropic",
  "enabled": true
}
```

**Verify skills exist**:
```bash
ls -la anthropic/
# Should show .md files
```

### Problem: Memory Not Loading

**Check memory configuration**:
```bash
cat agent-config.json | grep -A 8 "memory"
```

Output should show:
```json
"memory": {
  "enabled": true,
  "path": "./memory",
  "mainFile": "MEMORY.md",
  "autoLoad": true
}
```

**Initialize memory if missing**:
```bash
./setup.sh
```

## Example 11: Advanced - Local Overrides

Want different settings without changing the main config?

Create `agent-config.local.json`:
```json
{
  "providers": {
    "anthropic": {
      "enabled": true
    },
    "openai": {
      "enabled": false
    }
  },
  "memory": {
    "maxMainFileLines": 300
  }
}
```

This file:
- ✅ Overrides main config settings
- ✅ Is `.gitignore`d (won't be committed)
- ✅ Merges with agent-config.json
- ✅ Allows personal customization

---

## More Examples Needed?

Open an issue or PR with your use case!
