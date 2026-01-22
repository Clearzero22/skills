# 🔄 分支隔离快速参考

## 🎯 分支策略

| 分支 | 用途 | 内容 |
|------|------|------|
| **main** | 官方内容镜像 | 纯官方内容，不存放自定义内容 |
| **custom** | 自定义内容 | 你的所有自定义 skills 和工具 |

## 🚀 快速命令

### 日常同步（一键同步两个分支）
```bash
./sync-branches.sh
```

### 切换分支
```bash
git go-main      # 切换到 main
git go-custom    # 切换到 custom
```

### 只同步 main（官方内容）
```bash
git checkout main && git fetch origin && git merge origin/main && git push fork main
```

### 合并 main 到 custom
```bash
git checkout custom && git merge main && git push fork custom
```

## 📂 Remote 配置

| Remote | URL | 用途 |
|--------|-----|------|
| `origin` | anthropics/skills | 官方上游 |
| `fork` | Clearzero22/skills | 你的 fork |

## 📋 添加新 Skill

```bash
# 1. 同步最新官方内容
./sync-branches.sh

# 2. 确保在 custom 分支
git go-custom

# 3. 编辑 skill
# 编辑 skills/your-skill/SKILL.md

# 4. 提交并推送
git add skills/your-skill/
git commit -m "Add my-new-skill"
git push fork custom
```

## 📊 查看分支状态

```bash
# 当前分支
git branch --show-current

# 所有分支
git branch -a

# 分支差异图
git log --oneline --graph --all --decorate

# custom 相比 main 的提交
git log main..custom --oneline

# main 相比 custom 的提交
git log custom..main --oneline
```

## 📅 Git 别名（推荐）

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
git go-main       # 切换到 main
git go-custom     # 切换到 custom
git sync-all      # 同步两个分支
git show-branches # 查看分支图
```

## 🛠️ 故障排查

| 问题 | 解决方案 |
|------|----------|
| 意外在 main 上提交 | `git format-patch -1 -o /tmp/ && git checkout main && git reset --hard origin/main && git checkout custom && git am /tmp/*.patch` |
| 合并冲突 | `git status` 查看冲突，编辑解决后 `git add <files>` |
| custom 分支乱了 | `git checkout main && git branch -D custom && git checkout -b custom` |
| 查看当前分支 | `git branch --show-current` |
| 强制推送 | `git push fork main --force-with-lease` |

## 📌 工作流程速查

```
开发自定义技能:
  git go-custom → 编辑 → commit → push fork custom

同步官方更新:
  ./sync-branches.sh
  或
  git sync-all

查看差异:
  git show-branches
  git diff-branches
```

## 📖 相关文件

- `FORK_MAINTENANCE.md` - 完整维护指南
- `sync-branches.sh` - 双分支同步脚本
- `sync-fork.sh` - 单分支同步脚本（兼容旧版）
- `.github/workflows/auto-sync.yml` - GitHub Actions 配置
