# AI Skills Framework - Architecture & Flow

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         AI Agent (Claude, GPT, etc.)            │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 │ 1. Start & Initialize
                                 ▼
                    ┌────────────────────────┐
                    │  agent-config.json     │
                    │  ─────────────────     │
                    │  • Provider mappings   │
                    │  • Memory settings     │
                    │  • Auto-detect config  │
                    └────────────┬───────────┘
                                 │
                                 │ 2. Read Configuration
                                 ▼
                    ┌────────────────────────┐
                    │   Model Detection      │
                    │  ─────────────────     │
                    │  "claude-4" → anthropic│
                    │  "gpt-4" → openai      │
                    │  "gemini" → google     │
                    └────────────┬───────────┘
                                 │
                                 │ 3. Determine Provider
                                 ▼
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
        ▼                        ▼                        ▼
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│ anthropic/   │        │   openai/    │        │   google/    │
│ ──────────── │        │ ──────────── │        │ ──────────── │
│ Claude Skills│        │  GPT Skills  │        │Gemini Skills │
│ • skill1.md  │        │ • skill1.md  │        │ • skill1.md  │
│ • skill2.md  │        │ • skill2.md  │        │ • skill2.md  │
└──────┬───────┘        └──────┬───────┘        └──────┬───────┘
       │                       │                        │
       │                       │                        │
       └───────────────────────┼────────────────────────┘
                               │
                               │ 4. Load Provider Skills
                               ▼
                  ┌─────────────────────────┐
                  │     shared/ (Optional)  │
                  │    ──────────────────   │
                  │  Common skills for all  │
                  └────────────┬────────────┘
                               │
                               │ 5. Load Shared Skills
                               ▼
                  ┌─────────────────────────┐
                  │      memory/            │
                  │     ────────            │
                  │  • MEMORY.md (main)     │
                  │  • patterns.md          │
                  │  • debugging.md         │
                  └────────────┬────────────┘
                               │
                               │ 6. Load Memory Context
                               ▼
            ┌──────────────────────────────────────┐
            │   Agent Ready with:                  │
            │  ────────────────────                │
            │  ✅ Provider-specific skills loaded  │
            │  ✅ Memory context loaded            │
            │  ✅ Ready to assist user             │
            └──────────────────────────────────────┘
```

## 🔄 Request Flow

```
┌──────────────┐
│     User     │
│   Request    │
└──────┬───────┘
       │
       │ "Help me with code review"
       ▼
┌─────────────────┐
│   AI Agent      │
│  (Claude/GPT)   │
└────────┬────────┘
         │
         │ Check loaded skills
         ▼
┌─────────────────────────┐
│  Provider Skills        │
│ ─────────────────       │
│ • Code review skill ✓   │
│ • Refactoring skill     │
│ • Debug skill           │
└────────┬────────────────┘
         │
         │ Apply skill
         ▼
┌─────────────────────────┐
│  Memory Context         │
│ ─────────────────       │
│ • User prefers Python   │
│ • Likes concise output  │
│ • Focus on security     │
└────────┬────────────────┘
         │
         │ Apply context
         ▼
┌─────────────────────────┐
│  Generate Response      │
│ ─────────────────       │
│ • Uses skill template   │
│ • Applies preferences   │
│ • Follows patterns      │
└────────┬────────────────┘
         │
         │ Response
         ▼
┌─────────────────────────┐
│      User               │
│ ─────────────────       │
│ Receives tailored       │
│ response based on:      │
│ • Skills                │
│ • Memory                │
│ • Preferences           │
└─────────────────────────┘
         │
         │ Learning
         ▼
┌─────────────────────────┐
│  Update Memory          │
│ ─────────────────       │
│ • New pattern learned   │
│ • Preference recorded   │
│ • Context updated       │
└─────────────────────────┘
```

## 🌳 Directory Hierarchy

```
ai-skills/                           # Root directory
│
├── 📋 Configuration Layer
│   ├── agent-config.json            # Main config (READ FIRST)
│   ├── agent-config.schema.json    # JSON validation
│   └── agent-config.local.json     # Local overrides (optional, gitignored)
│
├── 📚 Documentation Layer
│   ├── README.md                    # Quick start & overview
│   ├── GETTING_STARTED.md          # Setup checklist
│   ├── AGENT_INIT.md               # Technical initialization guide
│   ├── EXAMPLES.md                 # Usage examples
│   ├── STRUCTURE.md                # This file
│   └── LICENSE                     # License info
│
├── 🛠️ Setup Layer
│   └── setup.sh                     # Initialization script
│
├── 🤖 Skills Layer (Provider-Specific)
│   ├── anthropic/                   # Claude skills
│   │   ├── README.md
│   │   ├── skill-1.md
│   │   ├── skill-2.md
│   │   └── ...
│   │
│   ├── openai/                      # GPT skills
│   │   ├── README.md
│   │   ├── skill-1.md
│   │   └── ...
│   │
│   ├── google/                      # Gemini skills
│   │   └── ...
│   │
│   └── shared/                      # Cross-provider skills
│       └── common-skill.md
│
└── 🧠 Memory Layer (Persistent Learning)
    └── memory/
        ├── README.md                # Memory system docs
        ├── MEMORY.md               # Active (gitignored)
        ├── patterns.md             # Active (gitignored)
        ├── debugging.md            # Active (gitignored)
        ├── MEMORY.md.template      # Template (tracked)
        ├── patterns.md.template    # Template (tracked)
        └── debugging.md.template   # Template (tracked)
```

## 🎯 Decision Flow - Provider Selection

```
Agent Starts
     │
     ▼
Read agent-config.json
     │
     ▼
Get Model Name
     │
     ▼
┌────────────────────────────────────┐
│ For each provider in config:       │
│                                     │
│ Does model name match any pattern? │
│ • "claude-4" matches "claude-*"?   │
│ • "gpt-4" matches "gpt-*"?         │
│ • "gemini" matches "gemini"?       │
└─────────────┬──────────────────────┘
              │
              ├─── YES ──► Use this provider
              │            │
              │            ▼
              │      Load skills from
              │      provider's skillsPath
              │
              └─── NO ──► Try next provider
                         │
                         ▼
                    No match found?
                         │
                         ▼
                    Use fallbackProvider
                    (default: "anthropic")
```

## 🔐 Privacy & Security Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                          Git Repository                          │
│                                                                   │
│  ✅ TRACKED (Shared with team):                                  │
│  ─────────────────────────────                                  │
│  • agent-config.json          • Documentation files             │
│  • Provider folders            • Skill definitions              │
│  • Memory templates            • Setup scripts                  │
│  • .gitignore rules                                             │
│                                                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ❌ NOT TRACKED (Local only):                                    │
│  ──────────────────────────────                                 │
│  • memory/MEMORY.md            • Local overrides                │
│  • memory/patterns.md          • Personal notes                 │
│  • memory/debugging.md         • Secrets/credentials            │
│  • *.local.* files             • Temp/debug files               │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Memory System Lifecycle

```
First Session (No memory exists)
         │
         ▼
    Run ./setup.sh
         │
         ▼
Copy templates → Create MEMORY.md, patterns.md, debugging.md
         │
         ▼
Agent loads template-based memory
         │
         ▼
Agent learns during session
    • User preferences
    • Project patterns
    • Successful approaches
         │
         ▼
Agent updates memory files
         │
         ▼
Session ends, memory persists
         │
         ▼
Next Session (Memory exists)
         │
         ▼
Agent loads existing memory
         │
         ▼
Agent applies learned context
         │
         ▼
Better responses based on history
         │
         ▼
Continue learning and updating...
```

## 🚀 Multi-Provider Support Flow

```
              Team Repository
                    │
                    ├─── Developer 1 (Uses Claude)
                    │         │
                    │         ├─ Clones repo
                    │         ├─ Claude auto-detects "anthropic"
                    │         ├─ Loads anthropic/ skills
                    │         └─ Works with Claude-specific skills
                    │
                    ├─── Developer 2 (Uses ChatGPT)
                    │         │
                    │         ├─ Clones same repo
                    │         ├─ GPT auto-detects "openai"
                    │         ├─ Loads openai/ skills
                    │         └─ Works with GPT-specific skills
                    │
                    └─── Developer 3 (Uses Gemini)
                              │
                              ├─ Clones same repo
                              ├─ Gemini auto-detects "google"
                              ├─ Loads google/ skills
                              └─ Works with Gemini-specific skills

All developers share:
• Same repository
• Same configuration structure
• Team-defined skills
• But each uses provider-specific skills automatically!
```

## 📊 Data Flow Summary

```
┌─────────────┐
│ Git Repo    │ ─── Clone ──► ┌──────────────┐
│ (Templates) │                │ Local Copy   │
└─────────────┘                └──────┬───────┘
                                      │
                                      │ ./setup.sh
                                      ▼
                               ┌──────────────┐
                               │ Memory Files │ ◄─── Agent updates
                               │ (Local only) │ ─┐
                               └──────┬───────┘  │
                                      │          │
                                      │          │
                                      ▼          │
                               ┌──────────────┐  │
                               │   AI Agent   │──┘
                               │              │
                               │ • Loads      │
                               │ • Applies    │
                               │ • Updates    │
                               └──────┬───────┘
                                      │
                                      ▼
                               ┌──────────────┐
                               │     User     │
                               │  Gets better │
                               │  responses!  │
                               └──────────────┘
```

---

## 🎓 Summary

The AI Skills Framework is designed with these key flows:

1. **Initialization**: Agent → Config → Provider Detection → Skill Loading → Memory Loading
2. **Request Handling**: User → Agent → Skills → Memory → Response
3. **Learning**: Interaction → Pattern Recognition → Memory Update → Improved Future Responses
4. **Privacy**: Templates (shared) → Memory Files (local) → Never committed to git
5. **Multi-Provider**: One repo → Multiple providers → Auto-detection → Right skills for each user

This architecture ensures:
- ✅ Zero configuration for users
- ✅ Automatic provider detection
- ✅ Privacy protection
- ✅ Team collaboration
- ✅ Continuous learning
