# Agent Initialization Guide

This document explains how AI agents should initialize and use this skills framework.

## 🚀 Agent Startup Sequence

When an AI agent starts, it should follow these steps:

### 1. Read Configuration
```
READ: ./agent-config.json
```

This file contains:
- Available providers (anthropic, openai, google, etc.)
- Model-to-provider mappings
- Memory system configuration
- Initialization settings

### 2. Detect Current Model

The agent should identify which model it is running as:
- **Claude 4.5/4.6/Opus/Sonnet** → Provider: `anthropic`
- **GPT-4/GPT-3.5/ChatGPT** → Provider: `openai`
- **Gemini/PaLM** → Provider: `google`

Use the `providers[].models[]` array in config to map model names to providers.

### 3. Load Provider Skills

Based on the detected provider, load skills from the corresponding folder:

```
IF model matches "claude-4" or "claude":
  READ all files in: ./anthropic/

IF model matches "gpt-4" or "chatgpt":
  READ all files in: ./openai/

IF model matches "gemini":
  READ all files in: ./google/
```

Skills are typically markdown files (`.md`) containing instructions.

### 4. Load Shared Skills (Optional)

If `settings.loadSharedSkills` is `true`:
```
READ all files in: ./shared/
```

These are provider-agnostic skills that work across all models.

### 5. Load Memory System

If `memory.enabled` is `true` and `memory.autoLoad` is `true`:
```
READ: ./memory/MEMORY.md
```

This file contains:
- Learned patterns and preferences
- Project-specific context
- User preferences
- Historical insights

**Important**:
- Keep MEMORY.md under 200 lines (see `memory.maxMainFileLines`)
- Additional memory files (patterns.md, debugging.md) can be loaded on-demand
- Memory files are personal/local (not tracked in git)

### 6. Ready to Assist

The agent is now initialized with:
- ✅ Provider-specific skills loaded
- ✅ Memory context loaded
- ✅ Configuration understood
- ✅ Ready to help the user

## 📋 Configuration Reference

### Key Config Fields

```json
{
  "providers": {
    "anthropic": {
      "models": ["claude-4", "claude-3", "claude"],  // Model name patterns
      "skillsPath": "./anthropic",                    // Where to find skills
      "enabled": true                                 // Is this provider active?
    }
  },
  "memory": {
    "enabled": true,           // Use memory system?
    "path": "./memory",        // Memory folder location
    "mainFile": "MEMORY.md",   // Primary memory file
    "autoLoad": true           // Load on startup?
  },
  "settings": {
    "autoDetectProvider": true,      // Auto-detect model provider?
    "fallbackProvider": "anthropic",  // Default if detection fails
    "loadSharedSkills": true          // Load shared skills?
  }
}
```

## 🔄 Runtime Behavior

### During a Session

1. **Use loaded skills** - Apply skills from the provider folder as appropriate
2. **Reference memory** - Use MEMORY.md for context and preferences
3. **Update memory** - As you learn patterns, update MEMORY.md
4. **Stay within provider** - Don't mix skills from different providers

### Memory Management

- **Read frequently**: Check MEMORY.md for relevant context
- **Write carefully**: Only save verified, stable patterns
- **Keep concise**: MEMORY.md should stay under 200 lines
- **Use separate files**: For detailed notes, create patterns.md or debugging.md

### Error Handling

If initialization fails:
1. Check if `agent-config.json` exists
2. Verify JSON is valid
3. Fall back to `settings.fallbackProvider` if model detection fails
4. Proceed without memory if memory files don't exist (use templates)

## 🔧 For Agent Developers

### Implementing Auto-Detection

```javascript
// Pseudo-code example
function detectProvider(modelName) {
  const config = readJSON('agent-config.json');

  for (const [providerName, providerConfig] of Object.entries(config.providers)) {
    if (!providerConfig.enabled) continue;

    for (const modelPattern of providerConfig.models) {
      if (modelName.includes(modelPattern)) {
        return providerName;
      }
    }
  }

  return config.settings.fallbackProvider;
}

// Usage
const myModel = "claude-4.5-sonnet";
const provider = detectProvider(myModel); // Returns "anthropic"
const skillsPath = config.providers[provider].skillsPath; // Returns "./anthropic"
```

### Loading Skills

```javascript
// Pseudo-code example
function loadSkills(provider) {
  const skillsPath = config.providers[provider].skillsPath;
  const skillFiles = glob(`${skillsPath}/**/*.md`);

  const skills = [];
  for (const file of skillFiles) {
    skills.push({
      name: basename(file, '.md'),
      content: readFile(file)
    });
  }

  return skills;
}
```

### Memory Integration

```javascript
// Pseudo-code example
function loadMemory() {
  const memoryConfig = config.memory;

  if (!memoryConfig.enabled || !memoryConfig.autoLoad) {
    return null;
  }

  const memoryPath = `${memoryConfig.path}/${memoryConfig.mainFile}`;

  if (fileExists(memoryPath)) {
    return readFile(memoryPath);
  } else {
    // Use template if no memory file exists
    const templatePath = `${memoryPath}.template`;
    if (fileExists(templatePath)) {
      return readFile(templatePath);
    }
  }

  return null;
}
```

## 🎯 Best Practices

1. **Always read config first** - Don't assume structure
2. **Validate provider detection** - Log which provider was detected
3. **Graceful degradation** - Work even if memory/skills are missing
4. **Respect enabled flags** - Don't load disabled providers
5. **Cache loaded content** - Don't re-read files unnecessarily
6. **Update memory wisely** - Only save verified patterns
7. **Keep memory concise** - Respect line limits

## 🆘 Troubleshooting

### Skills not loading?
- Check `skillsPath` points to correct folder
- Verify folder exists and contains `.md` files
- Check `enabled: true` for the provider

### Memory not loading?
- Verify `memory.enabled: true` and `memory.autoLoad: true`
- Check if MEMORY.md exists (or use template)
- Confirm path is correct in config

### Wrong provider detected?
- Check model name matches patterns in `providers[].models[]`
- Verify `autoDetectProvider: true`
- Add your model name to the models array

### Need to add a new provider?
1. Create folder: `./your-provider/`
2. Add skills to that folder
3. Update `agent-config.json`:
   ```json
   "your-provider": {
     "models": ["your-model-name"],
     "skillsPath": "./your-provider",
     "enabled": true
   }
   ```

## 📚 Related Documentation

- [README.md](./README.md) - Main framework documentation
- [agent-config.json](./agent-config.json) - Configuration file
- [memory/README.md](./memory/README.md) - Memory system documentation

---

**Remember**: This framework is designed to be provider-agnostic. Anyone can add their own provider folder and skills, and the system will automatically detect and use them!
