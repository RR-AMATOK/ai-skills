# LeanIX Scripts - Claude Skills

This folder contains custom Claude Skills for the LeanIX Scripts project. These skills help with common tasks and workflows.

## Available Skills

### Configuration & Setup

- **setup-env** - Set up and validate environment configuration files
  ```
  /setup-env
  ```

- **validate-setup** - Comprehensive validation of project setup
  ```
  /validate-setup
  ```

- **debug-auth** - Troubleshoot authentication and API connection issues
  ```
  /debug-auth
  ```

### Development

- **create-script** - Create a new LeanIX script following project conventions
  ```
  /create-script
  ```

- **analyze-script** - Analyze and explain what an existing script does
  ```
  /analyze-script
  ```

## How to Use Skills

In your Claude Code conversation, invoke a skill by typing:
```
/<skill-name>
```

For example:
```
/setup-env
/create-script
/analyze-script lx_documentsCreate.py
```

## Creating New Skills

To add a new skill:
1. Create a markdown file in this directory: `<skill-name>.md`
2. Follow the structure:
   - Clear title
   - Task description with numbered steps
   - Expected output format
3. Skills should be focused on a single, well-defined task
4. Include examples when relevant

Skills are automatically discovered by Claude Code and can be invoked with `/<skill-name>`.
