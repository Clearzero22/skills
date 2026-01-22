#!/bin/bash
set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Branch Isolation Sync Script${NC}"
echo -e "${BLUE}=================================${NC}"

# 检查是否在 git 仓库中
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# 显示当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Current branch: ${CURRENT_BRANCH}${NC}"

# 同步 main 分支
echo ""
echo -e "${BLUE}📥 Step 1: Syncing main with upstream...${NC}"
git checkout main
git fetch origin

MAIN_LOCAL=$(git rev-parse HEAD)
MAIN_UPSTREAM=$(git rev-parse origin/main)

if [ "$MAIN_LOCAL" = "$MAIN_UPSTREAM" ]; then
    echo -e "${GREEN}✅ main is already up to date${NC}"
else
    echo -e "${YELLOW}📋 New commits in upstream:${NC}"
    git log ${MAIN_LOCAL}..${MAIN_UPSTREAM} --oneline
    git merge origin/main -m "Sync with upstream anthropics/skills"
    echo -e "${GREEN}✅ main synced${NC}"
fi

# 推送 main 到 fork
echo ""
echo -e "${BLUE}📤 Step 2: Pushing main to fork...${NC}"
git push fork main

# 切换到 custom 并合并 main
echo ""
echo -e "${BLUE}🔀 Step 3: Merging main into custom...${NC}"
git checkout custom

# 检查是否需要合并
CUSTOM_MAIN=$(git rev-parse custom)
MAIN_CURRENT=$(git rev-parse main)

if [ "$CUSTOM_MAIN" = "$MAIN_CURRENT" ]; then
    echo -e "${GREEN}✅ custom is already up to date with main${NC}"
else
    echo -e "${YELLOW}📋 Merging main changes into custom...${NC}"
    git merge main -m "Merge upstream updates into custom" || {
        echo -e "${RED}⚠️  Merge conflicts detected! Please resolve manually.${NC}"
        echo -e "${YELLOW}After resolving conflicts, run:${NC}"
        echo "  git add <resolved-files>"
        echo "  git commit"
        echo "  git push fork custom"
        exit 1
    }
    echo -e "${GREEN}✅ Merged main into custom${NC}"
fi

# 推送 custom 到 fork
echo ""
echo -e "${BLUE}📤 Step 4: Pushing custom to fork...${NC}"
git push fork custom

# 显示状态
echo ""
echo -e "${GREEN}✅ All branches synced successfully!${NC}"
echo ""
echo -e "${BLUE}📊 Current Status:${NC}"
echo -e "  • main:  $(git rev-parse --short main) - $(git log -1 --pretty='%s' main)"
echo -e "  • custom: $(git rev-parse --short custom) - $(git log -1 --pretty='%s' custom)"
echo ""
echo -e "${YELLOW}💡 Quick commands:${NC}"
echo -e "  ${BLUE}git go-main${NC}     - Switch to main branch"
echo -e "  ${BLUE}git go-custom${NC}   - Switch to custom branch"
echo -e "  ${BLUE}git show-branches${NC} - Show branch history"
echo ""
echo -e "${GREEN}🌐 Your fork: https://github.com/Clearzero22/skills${NC}"
