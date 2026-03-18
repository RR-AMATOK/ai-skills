# AI Skills Framework

A multi-provider AI skills framework that automatically loads the appropriate skills based on the AI model being used.

## Quick Start

1. **Clone this repository**
   ```bash
   git clone <your-repo-url>
   cd ai-skills
   ```

2. **The agent will automatically**:
   - Read `agent-config.json` on startup
   - Detect which AI model is running (Claude, GPT, etc.)
   - Load skills from the appropriate provider folder
   - Load the memory system for persistent learning

3. **No configuration needed** - it works out of the box!

## How It Works

### Automatic Provider Detection

When an AI agent starts, it:
1. Reads [`agent-config.json`](./agent-config.json)
2. Detects the model being used (e.g., "claude-4", "gpt-4")
3. Maps the model to its provider folder:
   - **Claude** → `./anthropic/` folder
   - **GPT** → `./openai/` folder
   - **Gemini** → `./google/` folder
4. Loads all skills from that provider's folder
5. Loads the `./memory/` folder for persistent context

### Directory Structure

```
ai-skills/
├── agent-config.json          # Main configuration (read this first!)
├── agent-config.schema.json   # JSON schema for validation
├── README.md                  # This file
│
├── anthropic/                 # Skills for Claude (Anthropic)
│   ├── skill1.md
│   └── skill2.md
│
├── openai/                    # Skills for ChatGPT/GPT-4 (OpenAI)
│   ├── skill1.md
│   └── skill2.md
│
├── google/                    # Skills for Gemini (Google)
│   └── skill1.md
│
├── shared/                    # Skills that work across all providers
│   └── common-skill.md
│
└── memory/                    # Persistent memory system
    ├── README.md
    ├── MEMORY.md              # Main memory file (auto-loaded)
    └── *.md.template          # Memory templates
```

## Configuration

### agent-config.json

The main configuration file that defines:

```json
{
  "providers": {
    "anthropic": {
      "models": ["claude-4", "claude-3", "claude"],
      "skillsPath": "./anthropic",
      "enabled": true
    }
  },
  "memory": {
    "enabled": true,
    "path": "./memory",
    "autoLoad": true
  }
}
```

### Adding a New Provider

To add support for a new AI provider:

1. Create a folder for the provider (e.g., `./mistral/`)
2. Add skills to that folder
3. Update `agent-config.json`:
   ```json
   "mistral": {
     "models": ["mistral-large", "mistral"],
     "skillsPath": "./mistral",
     "enabled": true
   }
   ```

## Memory System

The `memory/` folder provides persistent learning across sessions:

- **MEMORY.md** - Main memory file (auto-loaded, keep under 200 lines)
- **patterns.md** - Detailed patterns and best practices
- **debugging.md** - Troubleshooting solutions
- Use `.template` files as starting points (git tracked)
- Actual memory files are `.gitignore`d (local to your machine)

## Template System

Use `.template` files to share structure without sharing personal data:

1. **Copy templates on first use**:
   ```bash
   cp memory/MEMORY.md.template memory/MEMORY.md
   ```

2. **Templates are git-tracked**, actual files are not
3. This allows sharing the framework without sharing personal context

## Privacy & Security

The framework automatically excludes personal data from git:

- ✅ **Tracked**: Templates, configs, skill definitions, documentation
- ❌ **Not tracked**: Actual memory files, local overrides, personal notes

See [`.gitignore`](./.gitignore) for details.

## For Repository Maintainers

When someone clones your repo:
1. They get the framework structure (config + templates)
2. Their agent auto-detects which provider they're using
3. Skills load automatically from the correct folder
4. Memory system initializes from templates
5. Personal data stays local (not committed to git)

## Contributing

To contribute skills:
1. Add skills to the appropriate provider folder
2. Update templates if needed
3. Don't commit actual memory files (only `.template` versions)
4. Update `agent-config.json` if adding new providers

## License

[LICENSE](https://github.com/RR-AMATOK/ai-skills/blob/main/LICENSE)
