#!/bin/bash
set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Syncing fork with upstream...${NC}"

# 检查是否在正确的目录
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# 获取当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${BLUE}Current branch: ${CURRENT_BRANCH}${NC}"

# 获取官方更新
echo -e "${BLUE}📥 Fetching updates from origin (upstream)...${NC}"
git fetch origin

# 检查是否有更新
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ $LOCAL = $REMOTE ]; then
    echo -e "${GREEN}✅ Already up to date!${NC}"
    exit 0
fi

# 显示将要合并的提交
echo -e "${BLUE}📋 Incoming commits:${NC}"
git log ${LOCAL}..${REMOTE} --oneline

# 切换到 main 分支（如果不在）
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${BLUE}🔄 Switching to main branch...${NC}"
    git checkout main
fi

# 合并官方更新
echo -e "${BLUE}🔀 Merging origin/main into main...${NC}"
git merge origin/main -m "Sync with upstream anthropics/skills

Auto-sync on $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到 fork
echo -e "${BLUE}📤 Pushing to fork...${NC}"
git push fork main

echo -e "${GREEN}✅ Sync complete!${NC}"
echo -e "${GREEN}🌐 Your fork is now up to date: https://github.com/Clearzero22/skills${NC}"

# 显示一些统计
if command -v git-summary &> /dev/null; then
    git-summary
else
    echo -e "${BLUE}📊 Repository status:${NC}"
    echo "  - Latest commit: $(git log -1 --pretty='%h - %s')"
    echo "  - Total commits: $(git rev-list --count HEAD)"
fi
