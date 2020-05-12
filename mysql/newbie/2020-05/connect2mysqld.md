# mysql 连接到 mysqld 服务的两种方式

## 通过socket连接

```bash
mysql -uroot -p --protocol=socket --socket=/tmp/mysql.sock
```

## 通过tcp连接

```bash
mysql -uroot -p --protocol=tcp --host=127.0.0.1 --port=3306
```
