# Fork 分支隔离维护指南

## 🎯 分支策略

本仓库使用**分支隔离**策略，将官方内容和自定义内容完全分离：

| 分支 | 用途 | 内容来源 |
|------|------|----------|
| **main** | 官方内容镜像 | 仅从 `anthropics/skills` 同步，**不存放自定义内容** |
| **custom** | 自定义 skills 和工具 | 你的所有自定义内容 |

```
┌─────────────────────────────────────────────────────────────┐
│                    Clearzero22/skills                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  main分支          ←  ←  ←  anthropics/skills (官方)        │
│  ────────                                                  │
│  仅官方内容                                                  │
│  不存放任何自定义内容                                         │
│                                                               │
│  custom分支                                                  │
│  ─────────                                                  │
│  ├─ skills/claude-project-analyzer/  (你的自定义技能)        │
│  ├─ sync-fork.sh                      (维护工具)             │
│  ├─ FORK_MAINTENANCE.md                                     │
│  └─ .github/workflows/auto-sync.yml                         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Remote 配置

```
origin  = https://github.com/anthropics/skills.git (官方上游)
fork    = https://github.com/Clearzero22/skills.git (你的 fork)
```

## 🔄 日常工作流程

### 同步官方内容（main 分支）

```bash
# 1. 切换到 main 分支
git checkout main

# 2. 获取并合并官方更新
git fetch origin
git merge origin/main

# 3. 推送干净的 main 到 fork
git push fork main
```

**重要：** main 分支始终保持官方内容，不要在 main 上添加自定义内容！

### 开发自定义内容（custom 分支）

```bash
# 1. 切换到 custom 分支
git checkout custom

# 2. （可选）如果需要合并官方最新更新到自定义分支
git merge main

# 3. 创建/修改你的 skills
# 编辑 skills/your-skill/SKILL.md

# 4. 提交并推送
git add skills/your-skill/
git commit -m "Add my-new-skill"
git push fork custom
```

### 从官方更新合并到自定义分支

```bash
# 1. 确保 main 是最新的
git checkout main
git fetch origin
git merge origin/main
git push fork main

# 2. 切换到 custom 并合并 main
git checkout custom
git merge main

# 3. 解决可能的冲突（如果有）
git push fork custom
```

## 🛠️ 添加新 Skill

### 完整流程

```bash
# 1. 同步官方内容
git checkout main
git fetch origin
git merge origin/main
git push fork main

# 2. 切换到 custom 分支
git checkout custom

# 3. 合并官方更新（保持 custom 基于 latest main）
git merge main

# 4. 创建并编辑新 skill
mkdir -p skills/my-new-skill
# 编辑 skills/my-new-skill/SKILL.md

# 5. 提交
git add skills/my-new-skill/
git commit -m "Add my-new-skill for..."

# 6. 推送
git push fork custom
```

### 快速添加（假设 main 已同步）

```bash
git checkout custom
# ... 编辑 skill ...
git add skills/my-new-skill/
git commit -m "Add my-new-skill"
git push fork custom
```

## 📁 分支内容说明

### main 分支内容

```
skills/
├── algorithmic-art/
├── brand-guidelines/
├── canvas-design/
├── doc-coauthoring/
├── docx/
├── frontend-design/
├── internal-comms/
├── mcp-builder/
├── pdf/
├── pptx/
├── skill-creator/
├── slack-gif-creator/
├── theme-factory/
├── webapp-testing/
└── web-artifacts-builder/
```

### custom 分支内容

```
skills/
├── [所有官方 skills]
├── claude-project-analyzer/    ← 你的自定义技能
└── ...

sync-fork.sh                     ← 维护工具
FORK_MAINTENANCE.md             ← 本文档
QUICK_SYNC_GUIDE.md             ← 快速参考
.github/
└── workflows/
    └── auto-sync.yml           ← 自动同步配置
```

## ⚠️ 处理冲突

当合并 main 到 custom 时可能出现冲突：

```bash
# 1. 尝试合并
git checkout custom
git merge main

# 2. 如果有冲突，Git 会提示
# 查看冲突文件
git status

# 3. 解决冲突
# 编辑冲突文件，保留你的自定义更改

# 4. 标记冲突已解决
git add <resolved-files>
git commit -m "Merge upstream updates"

# 5. 推送
git push fork custom
```

**常见冲突场景：**
- 官方新增了和你同名的 skill
- 官方修改了你也修改的文件
- 解决时优先保留你的 custom 内容

## 📅 定时同步

### 每日同步命令

```bash
# 同步 main
git checkout main && git fetch origin && git merge origin/main && git push fork main

# （可选）合并到 custom
git checkout custom && git merge main && git push fork custom
```

### 使用更新的同步脚本

创建 `sync-branches.sh`：

```bash
#!/bin/bash
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔄 Syncing main with upstream...${NC}"
git checkout main
git fetch origin
git merge origin/main
git push fork main

echo -e "${BLUE}🔄 Merging main to custom...${NC}"
git checkout custom
git merge main -m "Merge upstream updates"
git push fork custom

echo -e "${GREEN}✅ Both branches synced!${NC}"
```

使用：
```bash
chmod +x sync-branches.sh
./sync-branches.sh
```

## 🔍 验证分支状态

```bash
# 查看所有分支
git branch -a

# 查看分支差异
git diff main custom

# 查看分支历史图
git log --oneline --graph --all --decorate

# 查看 custom 相比 main 的差异
git log main..custom --oneline

# 查看 main 相比 custom 的差异
git log custom..main --oneline
```

## 📌 Git 别名

在 `~/.gitconfig` 中添加：

```ini
[alias]
    # 分支切换
    go-main = checkout main
    go-custom = checkout custom

    # 同步
    sync-main = "!f() { git checkout main && git fetch origin && git merge origin/main && git push fork main; }; f"
    sync-custom = "!f() { git checkout custom && git merge main && git push fork custom; }; f"
    sync-all = "!f() { git sync-main && git sync-custom; }; f"

    # 查看
    show-branches = log --oneline --graph --all --decorate
    diff-branches = diff main custom
```

使用：
```bash
git go-main      # 切换到 main
git go-custom    # 切换到 custom
git sync-main    # 同步 main
git sync-custom  # 合并 main 到 custom
git sync-all     # 同步两个分支
```

## 🎯 最佳实践

1. **main 保持纯净** - main 分支仅用于同步官方内容
2. **custom 用于开发** - 所有自定义内容在 custom 分支
3. **定期同步** - 定期从 main 合并更新到 custom
4. **明确分支** - 提交前确认自己在正确的分支
5. **测试合并** - 在合并前先查看将要引入的变化

## 🚨 故障排查

### 意外在 main 上提交了

```bash
# 1. 创建补丁保存你的更改
git checkout main
git format-patch -1 -o /tmp/

# 2. 重置 main
git reset --hard origin/main
git push fork main --force

# 3. 在 custom 上应用更改
git checkout custom
git am /tmp/*.patch
git push fork custom
```

### custom 分支乱了

```bash
# 重新基于 main 创建 custom
git checkout main
git branch -D custom           # 删除旧的 custom
git checkout -b custom         # 基于 main 创建新 custom
# ... 重新添加你的自定义内容 ...
```

### 查看当前在哪个分支

```bash
git branch --show-current
git status
```

## 📊 工作流程图

```
┌─────────────┐
│ 开始工作     │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌──────────────┐
│ go-custom   │────▶│  开发自定义  │
└─────────────┘     │  skills      │
       ▲            └──────┬───────┘
       │                   │
       │                   ▼
       │            ┌──────────────┐
       │            │  commit +    │
       │            │  push custom │
       │            └──────┬───────┘
       │                   │
       ▼                   ▼
┌─────────────┐     ┌──────────────┐
│ sync-main   │────▶│  定期同步    │
└─────────────┘     │  官方更新    │
       ▲            └──────┬───────┘
       │                   │
       │                   ▼
       │            ┌──────────────┐
       │            │ merge main   │
       │            │ to custom    │
       │            └──────┬───────┘
       │                   │
       └───────────────────┘
           循环持续
```
