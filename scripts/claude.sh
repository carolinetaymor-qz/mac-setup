#!/bin/bash

set -euo pipefail

ensure_claude_directory_initialized() {
    if [ ! -d "$HOME/.claude" ]; then
        echo "~/.claude directory not found. Running 'claude init'..."
        claude init
    fi
}

get_dotfiles_claude_directory() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    local repo_dir
    repo_dir="$(dirname "$script_dir")"

    echo "$repo_dir/dotfiles/claude"
}

create_required_directories() {
    local directories=(
        "$HOME/.claude/custom-snippets"
        "$HOME/.claude/context"
        "$HOME/.claude/context/reference-docs"
        "$HOME/.claude/context/preferences"
    )

    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            echo "Created directory: $dir"
        fi
    done
}

create_symlink_if_needed() {
    local source_item="$1"
    local target_path="$2"

    if [ -L "$target_path" ]; then
        echo "Symlink already exists: $target_path"
    elif [ -e "$target_path" ]; then
        echo "Warning: $target_path already exists and is not a symlink. Skipping."
    else
        ln -s "$source_item" "$target_path"
        echo "Created symlink: $target_path -> $source_item"
    fi
}

symlink_custom_snippets() {
    local dotfiles_claude_dir="$1"
    local source_snippets_dir="$dotfiles_claude_dir/custom-snippets"
    local target_snippets_dir="$HOME/.claude/custom-snippets"

    if [ ! -d "$source_snippets_dir" ]; then
        echo "Warning: $source_snippets_dir not found. Skipping custom snippets."
        return
    fi

    echo "Symlinking custom snippets..."
    for snippet_file in "$source_snippets_dir"/*; do
        [ -e "$snippet_file" ] || continue
        [ -f "$snippet_file" ] || continue

        local filename
        filename=$(basename "$snippet_file")
        create_symlink_if_needed "$snippet_file" "$target_snippets_dir/$filename"
    done
}

symlink_claude_md() {
    local dotfiles_claude_dir="$1"
    local source_claude_md="$dotfiles_claude_dir/CLAUDE.md"

    if [ ! -f "$source_claude_md" ]; then
        echo "Warning: $source_claude_md not found. Skipping CLAUDE.md."
        return
    fi

    echo "Symlinking CLAUDE.md..."
    create_symlink_if_needed "$source_claude_md" "$HOME/.claude/CLAUDE.md"
}

symlink_preferences() {
    local dotfiles_claude_dir="$1"
    local source_preferences_dir="$dotfiles_claude_dir/context/preferences"
    local target_preferences_dir="$HOME/.claude/context/preferences"

    if [ ! -d "$source_preferences_dir" ]; then
        echo "Warning: $source_preferences_dir not found. Skipping preferences."
        return
    fi

    echo "Symlinking preferences..."
    for preference_item in "$source_preferences_dir"/*; do
        [ -e "$preference_item" ] || continue

        local item_name
        item_name=$(basename "$preference_item")
        create_symlink_if_needed "$preference_item" "$target_preferences_dir/$item_name"
    done
}

main() {
    ensure_claude_directory_initialized

    create_required_directories

    local dotfiles_claude_dir
    dotfiles_claude_dir=$(get_dotfiles_claude_directory)

    if [ ! -d "$dotfiles_claude_dir" ]; then
        echo "Error: $dotfiles_claude_dir directory not found" >&2
        exit 1
    fi

    symlink_custom_snippets "$dotfiles_claude_dir"
    symlink_claude_md "$dotfiles_claude_dir"
    symlink_preferences "$dotfiles_claude_dir"

    echo "Done!"
}

main "$@"
