# AI Skills Framework - Complete Structure

## 📁 Directory Structure

```
ai-skills/
│
├── 📄 README.md                      # Main documentation
├── 📄 AGENT_INIT.md                  # How agents should initialize
├── 📄 EXAMPLES.md                    # Usage examples
├── 📄 LICENSE                        # License file
│
├── ⚙️ agent-config.json              # Main configuration (READ THIS FIRST!)
├── ⚙️ agent-config.schema.json      # JSON schema for validation
├── 🚀 setup.sh                       # Setup script (run on first use)
│
├── 📂 anthropic/                     # Skills for Claude (Anthropic)
│   ├── README.md
│   ├── analyze-script.md
│   ├── create-script.md
│   ├── debug-auth.md
│   ├── setup-env.md
│   ├── validate-setup.md
│   └── [other Claude-specific skills]
│
├── 📂 openai/                        # Skills for ChatGPT (OpenAI)
│   └── [GPT-specific skills]         # Create as needed
│
├── 📂 google/                        # Skills for Gemini (Google)
│   └── [Gemini-specific skills]      # Create as needed
│
├── 📂 shared/                        # Provider-agnostic skills
│   └── [common skills]               # Create as needed
│
└── 📂 memory/                        # Persistent memory system
    ├── README.md                     # Memory system docs
    ├── MEMORY.md                     # Main memory (git-ignored)
    ├── patterns.md                   # Detailed patterns (git-ignored)
    ├── debugging.md                  # Troubleshooting (git-ignored)
    ├── MEMORY.md.template           # Template for MEMORY.md ✅ tracked
    ├── patterns.md.template         # Template for patterns.md ✅ tracked
    └── debugging.md.template        # Template for debugging.md ✅ tracked
```

## 🎯 Key Files Explained

### Configuration Files

| File | Purpose | Git Tracked? |
|------|---------|--------------|
| `agent-config.json` | Main configuration - defines providers, memory settings | ✅ Yes |
| `agent-config.schema.json` | JSON schema for validation | ✅ Yes |
| `agent-config.local.json` | Local overrides (optional) | ❌ No |

### Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Main documentation, quick start guide |
| `AGENT_INIT.md` | Technical guide for how agents initialize |
| `EXAMPLES.md` | Practical usage examples |
| `LICENSE` | License information |

### Setup Files

| File | Purpose |
|------|---------|
| `setup.sh` | Initialization script - copies templates to memory files |

### Provider Folders

| Folder | Purpose | When Used |
|--------|---------|-----------|
| `anthropic/` | Claude-specific skills | When model is "claude-*" |
| `openai/` | GPT-specific skills | When model is "gpt-*" or "chatgpt" |
| `google/` | Gemini-specific skills | When model is "gemini" or "palm" |
| `shared/` | Cross-provider skills | Always (if enabled) |

### Memory System

| File | Purpose | Git Tracked? |
|------|---------|--------------|
| `memory/README.md` | Memory system documentation | ✅ Yes |
| `memory/MEMORY.md` | Active memory file (personal) | ❌ No |
| `memory/patterns.md` | Detailed patterns (personal) | ❌ No |
| `memory/debugging.md` | Troubleshooting notes (personal) | ❌ No |
| `memory/*.template` | Templates for memory files | ✅ Yes |

## 🔄 How It Works

### 1. Agent Startup
```
Agent starts → Reads agent-config.json → Detects model → Loads provider skills → Loads memory
```

### 2. Model Detection
```json
Model: "claude-4.5-sonnet"
  ↓ matches pattern "claude-4"
  ↓
Provider: "anthropic"
  ↓
Skills Path: "./anthropic"
  ↓
Loads: All .md files in ./anthropic/
```

### 3. Memory Loading
```
If memory.enabled = true AND memory.autoLoad = true:
  → Load ./memory/MEMORY.md
  → Apply learned patterns and preferences
  → Update memory as new patterns emerge
```

## 🎨 Design Principles

### 1. **Provider-Agnostic**
- Works with any AI provider (Anthropic, OpenAI, Google, etc.)
- Automatically detects which model is running
- Loads appropriate skills for that model

### 2. **Privacy-First**
- Personal data (memory files) never committed to git
- Templates are tracked, actual data is not
- `.gitignore` configured to protect sensitive information

### 3. **Zero-Configuration**
- Works out of the box after cloning
- No manual setup required (optional setup.sh for memory)
- Automatic provider detection

### 4. **Extensible**
- Easy to add new providers
- Easy to add new skills
- Easy to customize for your projects

### 5. **Shareable**
- Share framework structure without sharing personal data
- Team can collaborate on skills
- Individual memory stays local

## 📋 Git Tracking Strategy

### ✅ Tracked (Committed to Git)
- Configuration files (`agent-config.json`, schema)
- Documentation (`README.md`, `AGENT_INIT.md`, `EXAMPLES.md`)
- Setup scripts (`setup.sh`)
- Provider folders (`anthropic/`, `openai/`, etc.)
- Skill definition files (`*.md` in provider folders)
- Memory templates (`*.template` files)
- `.gitignore` rules

### ❌ Not Tracked (Local Only)
- Active memory files (`MEMORY.md`, `patterns.md`, `debugging.md`)
- Local overrides (`*.local.*`)
- Personal notes (`notes/`, `drafts/`)
- Temporary files (`*.tmp`, `*.temp`)
- Secrets and credentials (`*.key`, `.env`)
- OS files (`.DS_Store`, `Thumbs.db`)

## 🚀 Quick Start Commands

```bash
# Clone repository
git clone <your-repo-url>
cd ai-skills

# Initialize memory system (optional)
./setup.sh

# Start using your AI agent - it will:
# 1. Auto-detect which model it is
# 2. Load appropriate skills from provider folder
# 3. Load memory system
# 4. Be ready to help!
```

## 🔧 Customization

### For Individual Users
1. Run `./setup.sh` to create memory files from templates
2. Edit `memory/MEMORY.md` with your preferences
3. Add project-specific context to memory files
4. Your changes stay local (not committed)

### For Teams
1. Add skills to provider folders
2. Update `agent-config.json` if adding new providers
3. Commit and push changes
4. Team members pull and get updates automatically

### For New Providers
1. Create folder: `mkdir my-provider`
2. Add skills to that folder
3. Update `agent-config.json`:
   ```json
   "my-provider": {
     "models": ["my-model"],
     "skillsPath": "./my-provider",
     "enabled": true
   }
   ```

## 📊 File Count Summary

```
Total Structure:
- 5 Documentation files
- 3 Configuration files
- 1 Setup script
- 4 Provider folders (1 active, 3 ready for use)
- 1 Memory system (with templates)
- Multiple skill files per provider
```

## 🎓 Learning Path

1. **Start Here**: Read [README.md](README.md)
2. **Understand Initialization**: Read [AGENT_INIT.md](AGENT_INIT.md)
3. **See Examples**: Read [EXAMPLES.md](EXAMPLES.md)
4. **Configure**: Review [agent-config.json](agent-config.json)
5. **Customize Memory**: Edit `memory/MEMORY.md`
6. **Add Skills**: Create skills in provider folders

## 🆘 Support

- **Issues**: Check [EXAMPLES.md](EXAMPLES.md) troubleshooting section
- **Questions**: Review [AGENT_INIT.md](AGENT_INIT.md) for technical details
- **Memory Help**: See [memory/README.md](memory/README.md)

---

**Ready to use!** Your AI agent will automatically detect its provider, load the appropriate skills, and use the memory system to improve over time. 🚀
