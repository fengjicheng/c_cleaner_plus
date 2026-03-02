# GitHub 认证配置指南

## 方式一：Personal Access Token (推荐)

### 1. 生成 Token
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 填写：
   - **Note**: `CoPaw Auto Commit`
   - **Expiration**: `No expiration` (或自定义)
   - **Select scopes**: 勾选 `repo` (完整控制私有仓库)
4. 点击 "Generate token"
5. **复制生成的 token**（只显示一次！）

### 2. 配置 Git 使用 Token
```bash
# 设置全局凭证存储
git config --global credential.helper store

# 修改 remote URL 为包含 token 的格式
cd /root/test
git remote set-url origin https://<YOUR_TOKEN>@github.com/Kiowx/c_cleaner_plus.git

# 测试推送
git push -u origin main
# 或
git push -u origin master
```

---

## 方式二：SSH Key

### 1. 生成 SSH Key（如果还没有）
```bash
ssh-keygen -t ed25519 -C "copaw@local" -f ~/.ssh/id_ed25519
```

### 2. 添加 SSH Key 到 GitHub
1. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
2. 访问 https://github.com/settings/keys
3. 点击 "New SSH key"
4. 粘贴公钥内容，保存

### 3. 修改 Git Remote 为 SSH
```bash
cd /root/test
git remote set-url origin git@github.com:Kiowx/c_cleaner_plus.git
```

### 4. 测试连接
```bash
ssh -T git@github.com
# 应该显示：Hi Kiowx! You've successfully authenticated...
```

---

## 验证配置

```bash
cd /root/test

# 查看当前 remote
git remote -v

# 测试推送（手动执行一次脚本）
./auto_commit.sh
```

如果看到 `✅ 自动提交完成！` 说明配置成功！
