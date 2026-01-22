#!/bin/bash
# Git 别名配置脚本
# 使用方法: source setup-git-aliases.sh 或将内容添加到 ~/.gitconfig

echo "配置分支隔离 Git 别名..."

# 检查是否已配置
if git config --global alias.go-main > /dev/null 2>&1; then
    echo "⚠️  别名已存在，跳过配置"
    echo "如需重新配置，请先删除现有别名："
    echo "  git config --global --unset alias.go-main"
    echo "  git config --global --unset alias.go-custom"
    echo "  git config --global --unset alias.sync-main"
    echo "  git config --global --unset alias.sync-custom"
    echo "  git config --global --unset alias.sync-all"
    echo "  git config --global --unset alias.show-branches"
    echo "  git config --global --unset alias.diff-branches"
    exit 0
fi

# 配置别名
git config --global alias.go-main "checkout main"
git config --global alias.go-custom "checkout custom"
git config --global alias.sync-main "!f() { git checkout main && git fetch origin && git merge origin/main && git push fork main; }; f"
git config --global alias.sync-custom "!f() { git checkout custom && git merge main && git push fork custom; }; f"
git config --global alias.sync-all "!f() { git sync-main && git sync-custom; }; f"
git config --global alias.show-branches "log --oneline --graph --all --decorate"
git config --global alias.diff-branches "diff main custom"

echo "✅ Git 别名配置完成！"
echo ""
echo "可用命令："
echo "  git go-main       - 切换到 main 分支"
echo "  git go-custom     - 切换到 custom 分支"
echo "  git sync-main     - 同步 main 分支"
echo "  git sync-custom   - 合并 main 到 custom"
echo "  git sync-all      - 同步两个分支"
echo "  git show-branches - 显示分支历史图"
echo "  git diff-branches - 显示分支差异"
