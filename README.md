# Zsh Environment Manager

A modern, standards-compliant Zsh plugin for managing environment variable profiles.

## Features

- 🚀 **Profile Management**: Create and manage multiple environment variable profiles
- 🔄 **Session Control**: Load and unload profiles in your current shell session
- ✏️ **Easy Editing**: Edit profiles with your favorite editor
- 📦 **Import/Export**: Share profiles across machines
- 🎯 **Smart Completion**: Full tab completion for all commands and profile names
- ⚡ **Fast**: Uses autoload for zero startup overhead
- 📏 **Standards-Compliant**: Follows [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)

## Installation

### oh-my-zsh

```shell
git clone https://github.com/NanoBoom/zem ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zem
```

Then add `zem` to your plugins array in `~/.zshrc`:

```shell
plugins=(... zem)
```

### zinit

```shell
zinit light NanoBoom/zem
```

### Antigen

```shell
antigen bundle NanoBoom/zem
```

### Manual

```shell
git clone https://github.com/NanoBoom/zem ~/zem
echo 'source ~/zem/zem.plugin.zsh' >> ~/.zshrc
```

## Usage

### Basic Commands

```shell
# Add environment variables to a profile
zem add work API_KEY "sk-123456"
zem add work DATABASE_URL "postgres://localhost/mydb"

# Load profile into current session
zem load work

# List all profiles
zem list

# Show profile content
zem show work

# Edit profile with $EDITOR
zem edit work

# Unload profile from current session
zem unload work

# Remove profile
zem rm work
```

### Import/Export

```shell
# Export profile to file
zem export work ~/backup/work.env

# Import file as profile
zem import ~/backup/work.env work
```

### Help

```shell
# Show general help
zem help

# Show help for specific command
zem help add
zem help load
```

## Configuration

### Storage Location

Profiles are stored in:
```
${XDG_CONFIG_HOME:-$HOME/.config}/zem/profiles/
```

### Environment Variables

- `ZEM_CONFIRM_LOAD`: Set to `1` to enable confirmation prompt before loading profiles
  ```shell
  export ZEM_CONFIRM_LOAD=1
  ```

- `EDITOR`: Used by `zem edit` command (defaults to `vi`)
  ```shell
  export EDITOR=nvim
  ```

## Profile Format

Profiles are simple shell scripts containing `export` statements:

```shell
# work profile
export API_KEY="sk-123456"
export DATABASE_URL="postgres://localhost/mydb"
export DEBUG="true"
```

## Command Reference

| Command | Description |
|---------|-------------|
| `zem add <profile> <key> <value>` | Add environment variable to profile |
| `zem load <profile>` | Load profile into current session |
| `zem unload <profile>` | Unload profile from current session |
| `zem list` | List all profiles |
| `zem rm <profile>` | Remove profile |
| `zem edit <profile>` | Edit profile with $EDITOR |
| `zem show <profile>` | Display profile content |
| `zem export <profile> [file]` | Export profile to file |
| `zem import <file> <profile>` | Import file as profile |
| `zem help [command]` | Show help message |

### Command Aliases

- `zem ls` → `zem list`
- `zem remove` → `zem rm`
- `zem delete` → `zem rm`
- `zem cat` → `zem show`
- `zem view` → `zem show`

## Examples

### Development Workflow

```shell
# Create development profile
zem add dev NODE_ENV "development"
zem add dev DEBUG "true"
zem add dev API_URL "http://localhost:3000"

# Load when starting work
zem load dev

# Unload when done
zem unload dev
```

### Multiple Projects

```shell
# Project A
zem add project-a DATABASE_URL "postgres://localhost/project_a"
zem add project-a API_KEY "key-a"

# Project B
zem add project-b DATABASE_URL "postgres://localhost/project_b"
zem add project-b API_KEY "key-b"

# Switch between projects
zem load project-a
# ... work on project A ...
zem unload project-a

zem load project-b
# ... work on project B ...
zem unload project-b
```

### Backup and Restore

```shell
# Backup all profiles
for profile in $(ls ~/.config/zem/profiles/); do
    zem export $profile ~/backup/$profile.env
done

# Restore on new machine
for file in ~/backup/*.env; do
    zem import $file $(basename $file .env)
done
```

## Migration from demo.sh

If you're migrating from the original `demo.sh` script:

1. **Command changes**: Commands now use subcommand syntax
   - `env_add` → `zem add`
   - `env_load` → `zem load`
   - `env_unload` → `zem unload`
   - `env_list` → `zem list`
   - `env_rm` → `zem rm`

2. **Storage location**: Profiles moved to XDG-compliant location
   ```shell
   # Copy existing profiles
   mkdir -p ~/.config/zem/profiles
   cp -r ~/.my_envs/* ~/.config/zem/profiles/
   ```

3. **Bug fixes**: The `unload` command now works correctly in Zsh (fixed `BASH_REMATCH` issue)

## Requirements

- Zsh >= 5.0
- No external dependencies

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Created by [NanoBoom](https://github.com/NanoBoom)

## Acknowledgments

- Inspired by the original `demo.sh` script
- Follows [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)