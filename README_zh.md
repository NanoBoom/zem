# Zsh Environment Manager

一个现代的、符合标准的 Zsh 插件，用于管理环境变量配置（profile）。

## 特性

- :rocket: **配置管理**：创建和管理多个环境变量配置
- :arrows_counterclockwise: **会话控制**：在当前 shell 会话中加载和卸载配置
- :pencil2: **便捷编辑**：使用你喜欢的编辑器编辑配置
- :package: **导入/导出**：跨设备共享配置
- :dart: **智能补全**：所有命令和配置名称均支持 tab 补全
- :zap: **快速**：使用 autoload 实现零启动开销
- :straight_ruler: **符合标准**：遵循 [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)

## 安装

### oh-my-zsh

```shell
git clone https://github.com/NanoBoom/zem ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zem
```

然后在 `~/.zshrc` 的插件列表中添加 `zem`：

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

### zimfw

在 `~/.zimrc` 中添加：

```shell
zmodule NanoBoom/zem
```

然后运行：

```shell
zimfw install
```

### 手动安装

```shell
git clone https://github.com/NanoBoom/zem ~/zem
echo 'source ~/zem/zem.plugin.zsh' >> ~/.zshrc
```

## 使用方法

### 基本命令

```shell
# 添加环境变量到配置
zem add work API_KEY "sk-123456"
zem add work DATABASE_URL "postgres://localhost/mydb"

# 加载配置到当前会话
zem load work

# 列出所有配置
zem list

# 显示配置内容
zem show work

# 使用 $EDITOR 编辑配置
zem edit work

# 从当前会话卸载配置
zem unload work

# 删除配置
zem rm work
```

### 导入/导出

```shell
# 导出配置到文件
zem export work ~/backup/work.env

# 从文件导入为配置
zem import ~/backup/work.env work
```

### 默认配置（新 Shell 自动加载）

```shell
# 显示当前默认配置列表
zem default

# 追加一个或多个配置到默认值（自动去重）
zem default work
zem default work personal

# 从默认值中移除一个或多个配置
zem default --remove work

# 清除所有默认配置
zem default --unset
```

默认配置会在启动新 shell 时自动加载，包括从父会话继承 `ZEM_LOADED_PROFILES` 的新 shell（例如新的 tmux 窗格）。
如需替换整个默认列表，请先运行 `zem default --unset`，然后再添加新配置。

### 帮助

```shell
# 显示通用帮助
zem help

# 显示特定命令的帮助
zem help add
zem help load
```

## 配置

### 存储位置

配置存储在：
```
${XDG_CONFIG_HOME:-$HOME/.config}/zem/profiles/
```

### 环境变量

- `ZEM_CONFIRM_LOAD`：设为 `1` 启用加载前的确认提示
  ```shell
  export ZEM_CONFIRM_LOAD=1
  ```

- `EDITOR`：`zem edit` 命令使用的编辑器（默认为 `vi`）
  ```shell
  export EDITOR=nvim
  ```

## 配置格式

配置是包含 `export` 语句的简单 shell 脚本：

```shell
# work 配置
export API_KEY="sk-123456"
export DATABASE_URL="postgres://localhost/mydb"
export DEBUG="true"
```

## 命令参考

| 命令 | 说明 |
|------|------|
| `zem add <配置> <键> <值>` | 添加环境变量到配置 |
| `zem load <配置>` | 加载配置到当前会话 |
| `zem unload <配置>` | 从当前会话卸载配置 |
| `zem list` | 列出所有配置 |
| `zem rm <配置>` | 删除配置 |
| `zem edit <配置>` | 使用 $EDITOR 编辑配置 |
| `zem show <配置>` | 显示配置内容 |
| `zem export <配置> [文件]` | 导出配置到文件 |
| `zem import <文件> <配置>` | 从文件导入为配置 |
| `zem default [<配置> ...]` | 追加/管理新 shell 的默认配置 |
| `zem help [命令]` | 显示帮助信息 |

### 命令别名

- `zem ls` → `zem list`
- `zem remove` → `zem rm`
- `zem delete` → `zem rm`
- `zem cat` → `zem show`
- `zem view` → `zem show`

## 示例

### 开发工作流

```shell
# 创建开发配置
zem add dev NODE_ENV "development"
zem add dev DEBUG "true"
zem add dev API_URL "http://localhost:3000"

# 开始工作时加载
zem load dev

# 工作完成后卸载
zem unload dev
```

### 多项目切换

```shell
# 项目 A
zem add project-a DATABASE_URL "postgres://localhost/project_a"
zem add project-a API_KEY "key-a"

# 项目 B
zem add project-b DATABASE_URL "postgres://localhost/project_b"
zem add project-b API_KEY "key-b"

# 在项目间切换
zem load project-a
# ... 在项目 A 上工作 ...
zem unload project-a

zem load project-b
# ... 在项目 B 上工作 ...
zem unload project-b
```

### 备份与恢复

```shell
# 备份所有配置
for profile in $(ls ~/.config/zem/profiles/); do
    zem export $profile ~/backup/$profile.env
done

# 在新设备上恢复
for file in ~/backup/*.env; do
    zem import $file $(basename $file .env)
done
```

## 从 demo.sh 迁移

如果你从原始的 `demo.sh` 脚本迁移：

1. **命令变化**：命令现在使用子命令语法
   - `env_add` → `zem add`
   - `env_load` → `zem load`
   - `env_unload` → `zem unload`
   - `env_list` → `zem list`
   - `env_rm` → `zem rm`

2. **存储位置**：配置已移至 XDG 规范目录
   ```shell
   # 复制现有配置
   mkdir -p ~/.config/zem/profiles
   cp -r ~/.my_envs/* ~/.config/zem/profiles/
   ```

3. **Bug 修复**：`unload` 命令现在在 Zsh 中正常工作（修复了 `BASH_REMATCH` 问题）

## 系统要求

- Zsh >= 5.0
- 无外部依赖

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 贡献

欢迎贡献！请提交 Pull Request。

## 作者

由 [NanoBoom](https://github.com/NanoBoom) 创建。

## 致谢

- 灵感来自原始的 `demo.sh` 脚本
- 遵循 [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)
