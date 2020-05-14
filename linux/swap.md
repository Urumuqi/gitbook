# 增加ubuntu server swap

## 第一步 创建swap文件

```bash
mkswap /swap-sf.img
```

## 第二步 设置swap文件权限

```bash
sudo chmod 600 /swap-sf.img
```

## 第三步 启用刚才创建的swap文件

```bash
swapon /swap-sf.img
```

## 第四步 设置开机自动加载swap文件

```bash
vim /etc/fstab

# 在fstab文件结尾 追加下面这行配置
/swap-sf.img	none	swap	sw	0	0
```

## 最后 验证swap生效

```bash
free -h
```
