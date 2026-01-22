# Fork 维护工作流程指南

## 📋 当前 Remote 配置

```
origin    = https://github.com/anthropics/skills.git (官方仓库)
fork      = https://github.com/Clearzero22/skills.git (你的 fork)
```

## 🔄 日常同步工作流程

### 方式 1：手动同步（推荐）

```bash
# 1. 获取官方最新更新
git fetch origin

# 2. 切换到 main 分支
git checkout main

# 3. 合并官方更新（本地）
git merge origin/main

# 4. 推送到你的 fork
git push fork main
```

### 方式 2：使用 rebase（保持线性历史）

```bash
# 1. 获取官方更新
git fetch origin

# 2. 使用 rebase
git checkout main
git rebase origin/main

# 3. 推送到 fork（可能需要 force push）
git push fork main --force-with-lease
```

### 方式 3：一键同步脚本

创建快捷脚本 `sync-fork.sh`：

```bash
#!/bin/bash
set -e

echo "🔄 Syncing with upstream..."

# 获取官方更新
git fetch origin

# 合并到本地
git checkout main
git merge origin/main -m "Sync with upstream anthropics/skills"

# 推送到 fork
git push fork main

echo "✅ Sync complete!"
```

使用方法：
```bash
chmod +x sync-fork.sh
./sync-fork.sh
```

## 🛠️ 添加新 Skill 工作流程

```bash
# 1. 确保在 main 分支且已同步
git checkout main
git fetch origin
git merge origin/main

# 2. 创建新分支（可选，但推荐）
git checkout -b add/my-new-skill

# 3. 创建/修改 skill
# ... 编辑 skills/your-skill/SKILL.md ...

# 4. 提交
git add skills/your-skill/
git commit -m "Add my-new-skill for ..."

# 5. 合并回 main（或直接在 main 提交）
git checkout main
git merge add/my-new-skill

# 6. 推送到 fork
git push fork main
```

## ⚠️ 处理冲突

当官方修改了你也修改的文件时：

```bash
# 1. 尝试合并
git fetch origin
git merge origin/main

# 2. 如果有冲突
# Git 会提示冲突文件
# 编辑冲突文件，解决冲突

# 3. 标记冲突已解决
git add <resolved-files>
git commit

# 4. 推送
git push fork main
```

## 📅 定时同步建议

### 每日同步（手动）

每天开始工作前运行：
```bash
git fetch origin && git checkout main && git merge origin/main && git push fork main
```

### 使用 Cron（Linux/Mac）

编辑 crontab：
```bash
crontab -e
```

添加每日同步任务：
```
0 9 * * * cd /path/to/skills && /path/to/sync-fork.sh >> /tmp/sync.log 2>&1
```

### GitHub Actions 自动同步（可选）

创建 `.github/workflows/sync.yml`：

```yaml
name: Sync with Upstream

on:
  schedule:
    - cron: '0 0 * * *'  # 每天 UTC 00:00 运行
  workflow_dispatch:      # 也支持手动触发

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Sync with upstream
        run: |
          git remote add upstream https://github.com/anthropics/skills.git
          git fetch upstream
          git checkout main
          git merge upstream/main
          git push origin main
```

## 🔍 验证同步状态

```bash
# 检查本地和官方的差异
git log origin/main..HEAD

# 检查官方和本地的差异
git log HEAD..origin/main

# 查看提交历史图表
git log --oneline --graph --all --decorate
```

## 📌 推荐的 Git 别名

在 `~/.gitconfig` 中添加：

```ini
[alias]
    sync = "!f() { git fetch origin && git checkout main && git merge origin/main && git push fork main; }; f"
    stash-all = stash save --include-untracked
    unstage = reset HEAD --
    last = log -1 HEAD
```

使用：
```bash
git sync  # 一键同步
```

## 🎯 最佳实践

1. **每天同步** - 保持你的 fork 与官方同步
2. **使用分支** - 添加 skill 前先创建分支
3. **提交前拉取** - 推送前先 `git pull origin main`
4. **写好提交信息** - 清晰描述你的改动
5. **定期清理** - 删除已合并的分支

## 🚨 故障排查

### 推送被拒绝
```bash
# 如果有人直接在你的 fork 上提交
git fetch fork
git merge fork/main
git push fork main
```

### 搞砸了，想重新开始
```bash
git fetch origin
git reset --hard origin/main
git push fork main --force
```

### 查看远程仓库配置
```bash
git remote -v
git remote show origin
git remote show fork
```
