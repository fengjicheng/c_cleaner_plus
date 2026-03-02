#!/bin/bash

# ============================================
# GitHub Token 配置脚本
# 使用方法：./setup_github_token.sh <你的_TOKEN>
# ============================================

if [ -z "$1" ]; then
    echo "❌ 使用方法："
    echo "   ./setup_github_token.sh <你的_TOKEN>"
    echo ""
    echo "示例："
    echo "   ./setup_github_token.sh ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    exit 1
fi

TOKEN="$1"
REPO_URL="https://${TOKEN}@github.com/Kiowx/c_cleaner_plus.git"

echo "🔧 正在配置 GitHub 认证..."

# 进入仓库目录
cd /root/test

# 配置凭证保存
git config --global credential.helper store
echo "✅ 已配置凭证保存"

# 设置远程仓库 URL
git remote set-url origin "$REPO_URL"
echo "✅ 已设置远程仓库 URL"

# 验证配置
echo ""
echo "📋 当前远程仓库配置："
git remote -v

# 测试推送
echo ""
echo "🧪 正在测试推送..."
./auto_commit.sh

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 认证成功！自动提交流程已就绪！"
    echo "⏰ 明天凌晨 00:00 将自动执行第一次提交"
else
    echo ""
    echo "⚠️ 测试失败，请检查 Token 是否正确"
    echo "📋 确保 Token 有以下权限：repo (完整控制私有仓库)"
fi
