# 🚀 Getting Started Checklist

Use this checklist when setting up the AI Skills Framework for the first time.

## ✅ Initial Setup (One-Time)

- [ ] **Clone the repository**
  ```bash
  git clone <your-repo-url>
  cd ai-skills
  ```

- [ ] **Run setup script** (creates memory files from templates)
  ```bash
  ./setup.sh
  ```
  This will create:
  - `memory/MEMORY.md` (from template)
  - `memory/patterns.md` (from template)
  - `memory/debugging.md` (from template)

- [ ] **Verify configuration**
  ```bash
  cat agent-config.json
  ```
  Check that your AI provider is enabled

- [ ] **Review documentation**
  - [ ] Read [README.md](README.md) - Main overview
  - [ ] Skim [AGENT_INIT.md](AGENT_INIT.md) - How it works
  - [ ] Check [EXAMPLES.md](EXAMPLES.md) - Usage examples

## 🎨 Customization (Optional)

- [ ] **Customize memory/MEMORY.md**
  - [ ] Add your name/preferences
  - [ ] Add project-specific context
  - [ ] Add workflow preferences
  - [ ] Remove example content

- [ ] **Customize memory/patterns.md**
  - [ ] Document your coding patterns
  - [ ] Add project architecture notes
  - [ ] List integration patterns

- [ ] **Customize memory/debugging.md**
  - [ ] Add known issues and solutions
  - [ ] Document troubleshooting steps
  - [ ] List useful commands

## 🔧 Provider-Specific Setup

### If Using Claude (Anthropic)
- [ ] Verify skills exist in `anthropic/` folder
- [ ] Review skills: `ls -la anthropic/`
- [ ] Test: Start Claude and verify skills load

### If Using ChatGPT (OpenAI)
- [ ] Create `openai/` folder if it doesn't exist
  ```bash
  mkdir -p openai
  ```
- [ ] Add skills to `openai/` folder
- [ ] Update `agent-config.json` to enable OpenAI provider

### If Using Gemini (Google)
- [ ] Create `google/` folder if it doesn't exist
  ```bash
  mkdir -p google
  ```
- [ ] Add skills to `google/` folder
- [ ] Update `agent-config.json` to enable Google provider

### If Using Another Provider
- [ ] Create folder for your provider
  ```bash
  mkdir -p my-provider
  ```
- [ ] Add skills to that folder
- [ ] Add provider to `agent-config.json`:
  ```json
  "my-provider": {
    "models": ["my-model-name"],
    "skillsPath": "./my-provider",
    "enabled": true
  }
  ```

## 🧪 Testing

- [ ] **Test agent initialization**
  - [ ] Start your AI agent
  - [ ] Verify it reads `agent-config.json`
  - [ ] Confirm it loads skills from correct provider folder
  - [ ] Check that memory/MEMORY.md is loaded

- [ ] **Test a skill**
  - [ ] Try using a skill from your provider folder
  - [ ] Verify it works as expected

- [ ] **Test memory system**
  - [ ] Update `memory/MEMORY.md` with a test note
  - [ ] Restart agent
  - [ ] Confirm it remembers the note

## 📦 Team Setup (If Applicable)

- [ ] **Share with team**
  - [ ] Push to shared git repository
  - [ ] Share repository URL with team
  - [ ] Document team-specific setup steps

- [ ] **Document team conventions**
  - [ ] Add team coding standards to shared skills
  - [ ] Document PR review process
  - [ ] Add team-specific patterns

## 🔒 Security Check

- [ ] **Verify .gitignore**
  ```bash
  cat .gitignore
  ```
  - [ ] Memory files are ignored (MEMORY.md, patterns.md, debugging.md)
  - [ ] Local overrides are ignored (*.local.*)
  - [ ] Secrets are ignored (.env, *.key)

- [ ] **Check what's tracked**
  ```bash
  git status
  ```
  - [ ] Templates are tracked (*.template)
  - [ ] Memory files are NOT tracked
  - [ ] No secrets in git

- [ ] **Review memory content**
  - [ ] Ensure no sensitive data in memory files
  - [ ] Remove any credentials or secrets
  - [ ] Keep project-specific but non-sensitive info

## 🎯 Ready to Use!

Once you've completed these steps:

✅ Your framework is set up
✅ Memory system is initialized
✅ Provider-specific skills are loaded
✅ Agent will auto-detect and use correct skills
✅ Personal data stays local

## 📚 Next Steps

Now that you're set up:

1. **Use your AI agent** - It will automatically use the skills
2. **Update memory** - As you learn patterns, update memory files
3. **Add skills** - Create new skills in your provider folder
4. **Contribute** - Share useful skills with the team

## 🆘 Troubleshooting

### Skills not loading?
- Verify `agent-config.json` has correct provider configuration
- Check skills exist in the correct folder
- Ensure provider is `enabled: true`

### Memory not loading?
- Confirm `memory/MEMORY.md` exists (run `./setup.sh` if not)
- Check `agent-config.json` has `memory.enabled: true`
- Verify `memory.autoLoad: true`

### Agent can't find configuration?
- Ensure you're in the `ai-skills/` directory
- Check `agent-config.json` is in current directory
- Verify JSON is valid: `cat agent-config.json | python -m json.tool`

### Need help?
- Review [EXAMPLES.md](EXAMPLES.md) for usage examples
- Check [AGENT_INIT.md](AGENT_INIT.md) for technical details
- See [memory/README.md](memory/README.md) for memory system help

---

**🎉 You're all set! Your AI agent is ready to use the skills framework!**
