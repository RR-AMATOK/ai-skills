#!/bin/bash
# AI Skills Setup Script
# This script initializes the memory system from templates

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MEMORY_DIR="$SCRIPT_DIR/memory"

echo "🚀 AI Skills Framework Setup"
echo "================================"
echo ""

# Check if memory directory exists
if [ ! -d "$MEMORY_DIR" ]; then
    echo "❌ Error: Memory directory not found at $MEMORY_DIR"
    exit 1
fi

cd "$MEMORY_DIR"

# Function to copy template if target doesn't exist
copy_template() {
    local template=$1
    local target=$2

    if [ -f "$template" ]; then
        if [ -f "$target" ]; then
            echo "⏭️  Skipping $target (already exists)"
        else
            cp "$template" "$target"
            echo "✅ Created $target from template"
        fi
    else
        echo "⚠️  Warning: Template $template not found"
    fi
}

echo "Setting up memory files..."
echo ""

# Copy all templates
copy_template "MEMORY.md.template" "MEMORY.md"
copy_template "patterns.md.template" "patterns.md"
copy_template "debugging.md.template" "debugging.md"

echo ""
echo "================================"
echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Review and customize memory/MEMORY.md with your preferences"
echo "2. Check agent-config.json to configure providers"
echo "3. Add your skills to the appropriate provider folder"
echo ""
echo "For more information, see README.md"
