#!/bin/bash

# ============================================
# 安装自动提交定时任务
# 功能：每天凌晨 00:00 执行 auto_commit.sh
# ============================================

CRON_JOB="0 0 * * * /root/test/auto_commit.sh >> /root/test/auto_commit.log 2>&1"

# 检查 crontab 是否已存在该任务
if crontab -l 2>/dev/null | grep -q "auto_commit.sh"; then
    echo "⚠️ 定时任务已存在"
    crontab -l | grep "auto_commit.sh"
else
    # 添加定时任务
    (crontab -l 2>/dev/null | grep -v "auto_commit.sh"; echo "$CRON_JOB") | crontab -
    echo "✅ 定时任务已创建！"
    echo "📅 执行时间：每天凌晨 00:00"
    echo "📜 查看任务：crontab -l"
    echo "📝 日志文件：/root/test/auto_commit.log"
fi

# 显示当前所有定时任务
echo ""
echo "========== 当前所有定时任务 =========="
crontab -l
