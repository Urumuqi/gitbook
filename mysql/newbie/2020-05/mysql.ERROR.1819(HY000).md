# ERROR 1819 (HY000): Your password does not satisfy the current policy requirements

## 问题原因

很明显，是因为mysql 5.7 的安全规则更严格了，密码不符合安全规范，MySQL的处理方式确实简单粗暴（ERROR）

## 问题解决思路

- 既然是触发了安全规范，那么当前数据库的安全规范是什么呢？MySQL肯定有明确的标记， 要不然我们怎么知道安全规则是什么呢。。。。这里就要涉及到一个MySQL参数：validate_password_policy，默认值如下：
![MySQL密码强度](https://files.jb51.net/file_images/article/201610/2016102293020153.jpg "MySQL密码强度")

```sql
    mysql> select @@validate_password_policy;
    +----------------------------+
    | @@validate_password_policy |
    +----------------------------+
    | MEDIUM                     |
    +----------------------------+
    1 row in set (0.00 sec)
```

- 修改密码强度规则

```sql
    mysql> set global validate_password_policy=0;
    Query OK, 0 rows affected (0.00 sec)
```

- 好了， MySQL密码安全强度已经变弱了，如果你的密码还是过不了的话，那就是你的问题了。接下来，执行关键操作吧。。。。

```sql
    mysql> grant all privileges on test.* to 'root'@'%' identified by 'passwd' with grant otption;
    Query OK, 1 rows affected (0.00 sec)
```

- 然后，一定要密码强度恢复回去，一定要密码强度恢复回去，一定要密码强度恢复回去。3遍，你懂得。

```sql
    mysql> set global validate_password_policy=1;
    Query OK, 0 rows affected (0.00 sec)

    mysql> select @@validate_password_policy;
    +----------------------------+
    | @@validate_password_policy |
    +----------------------------+
    | MEDIUM                     |
    +----------------------------+
    1 row in set (0.00 sec)
```

- 最后，修改root用户的配置成功
