# 问题

重启redis之后， 出现报错如下：

```bash
127.0.0.1:6379> set a a
(error) MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails (stop-writes-on-bgsave-error option). Please check the Redis logs for details about the RDB error.
```

## 解决办法

```bash
127.0.0.1:6379> config set stop-writes-on-bgsave-error no
```

## 测试

```bash
┌─[wuqi@wq-osx] - [~] - [Sat May 23, 15:51]
└─[$] <> brew services restart redis
Stopping `redis`... (might take a while)
==> Successfully stopped `redis` (label: homebrew.mxcl.redis)
==> Successfully started `redis` (label: homebrew.mxcl.redis)
┌─[wuqi@wq-osx] - [~] - [Sat May 23, 15:52]
└─[$] <> redis-cli
127.0.0.1:6379> set t t
OK
127.0.0.1:6379>
```
