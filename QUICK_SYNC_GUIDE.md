# 🔄 Fork 同步快速参考

## 🚀 快速命令

### 日常同步（一键）
```bash
./sync-fork.sh
```

### 手动同步
```bash
git fetch origin && git checkout main && git merge origin/main && git push fork main
```

### 检查同步状态
```bash
git log origin/main..HEAD    # 你的独有提交
git log HEAD..origin/main    # 官方的新提交
```

## 📂 当前配置

| Remote | URL | 用途 |
|--------|-----|------|
| `origin` | anthropics/skills | 官方上游仓库 |
| `fork` | Clearzero22/skills | 你的 fork |

## 📋 添加新 Skill

```bash
# 1. 同步最新代码
./sync-fork.sh

# 2. 创建新分支（推荐）
git checkout -b add/my-new-skill

# 3. 编辑 skill
# ... 编辑 skills/your-skill/SKILL.md ...

# 4. 提交
git add skills/your-skill/
git commit -m "Add my-new-skill for..."

# 5. 合并并推送
git checkout main
git merge add/my-new-skill
git push fork main
```

## 📅 自动同步选项

### 方式 1：GitHub Actions（推荐）
已创建 `.github/workflows/auto-sync.yml`
- 每天 UTC 09:00 自动同步
- 支持手动触发
- 查看同步记录：Actions 标签页

### 方式 2：Cron 任务
```bash
# 编辑 crontab
crontab -e

# 添加（每天 9:00 运行）
0 9 * * * cd /home/clearzero22/github_projects/01_ai_project/skills && ./sync-fork.sh >> /tmp/sync.log 2>&1
```

### 方式 3：手动运行
每天工作前运行：`./sync-fork.sh`

## 🛠️ 故障排查

| 问题 | 解决方案 |
|------|----------|
| 推送被拒绝 | `git fetch fork && git merge fork/main && git push fork main` |
| 搞砸了想重来 | `git reset --hard origin/main && git push fork main --force` |
| 查看差异 | `git diff origin/main` |
| 查看历史图 | `git log --oneline --graph --all --decorate` |

## 📌 相关文件

- `FORK_MAINTENANCE.md` - 完整维护指南
- `sync-fork.sh` - 自动同步脚本
- `.github/workflows/auto-sync.yml` - GitHub Actions 配置
