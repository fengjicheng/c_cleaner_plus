#!/bin/bash

# ============================================
# 自动 Git 提交与推送脚本（简化版）
# 功能：检测变更 -> 自动生成 commit 信息 -> 推送 -> 触发 Actions
# 注意：不推送 .github/workflows 目录的修改
# ============================================

set -e

# 配置
REPO_DIR="/root/test"
LOG_FILE="/root/test/auto_commit.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 进入仓库目录
cd "$REPO_DIR"

log "========== 开始自动提交流程 =========="

# 配置 Git 用户信息
git config user.name "Auto Commit Bot" 2>/dev/null || true
git config user.email "autocommit@local" 2>/dev/null || true

# 拉取最新代码
log "正在拉取最新代码..."
git pull origin main --rebase 2>&1 | tee -a "$LOG_FILE" || {
    log "⚠️ 拉取失败，尝试 master..."
    git pull origin master --rebase 2>&1 | tee -a "$LOG_FILE" || log "⚠️ master 分支也不存在"
}

# 检查是否有变更（排除 .github/workflows 目录）
if [ -z "$(git status --porcelain | grep -v '.github/workflows/')" ]; then
    log "✅ 没有检测到文件变更（workflow 文件除外），跳过提交"
    exit 0
fi

# 显示变更文件（排除 workflows）
log "📝 检测到以下文件变更："
git status --porcelain | grep -v '.github/workflows/' | tee -a "$LOG_FILE"

# 添加所有变更（排除 .github/workflows 目录）
log "📦 正在添加所有变更（排除 workflows 目录）..."
git add -A
git reset HEAD .github/workflows/ 2>/dev/null || true

# 自动生成 commit 信息
COMMIT_DATE=$(date '+%Y-%m-%d %H:%M')
CHANGED_FILES=$(git diff --cached --name-only | head -5 | tr '\n' ',' | sed 's/,$//')
FILE_COUNT=$(git diff --cached --name-only | wc -l)

if [ "$FILE_COUNT" -eq 0 ]; then
    log "✅ 没有需要提交的文件（workflow 文件已排除）"
    exit 0
fi

COMMIT_MSG="🤖 Auto commit at $COMMIT_DATE

Modified $FILE_COUNT file(s): $CHANGED_FILES

- Automated daily commit
- Triggered by cron job"

log "📝 生成 Commit 信息："
echo "$COMMIT_MSG" | tee -a "$LOG_FILE"

# 提交
log "💾 正在提交..."
git commit -m "$COMMIT_MSG" 2>&1 | tee -a "$LOG_FILE"

# 推送
log "🚀 正在推送到远程仓库..."
git push origin HEAD:main 2>&1 | tee -a "$LOG_FILE" || {
    log "⚠️ main 分支推送失败，尝试 master..."
    git push origin HEAD:master 2>&1 | tee -a "$LOG_FILE"
}

log "✅ 自动提交完成！"
log "🔗 GitHub Actions 将自动触发 build workflow"
log "========== 流程结束 =========="
log ""

exit 0
