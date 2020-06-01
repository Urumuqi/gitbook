# mysql dump

## 导出数据和表结构

```sql
mysqldump -hhostname -uusername -ppassword databasename > /home/some_path/databasename.sql
```

## 导出表结构

```sql
mysqldump -hhostname -uusername -ppassword -d databasename > /home/some_path/databasename.sql
```

## 参数说明

```sql
-d 结构(--no-data:不导出任何数据，只导出数据库表结构)

-t 数据(--no-create-info:只导出数据，而不添加CREATE TABLE 语句)

-n (--no-create-db:只导出数据，而不添加CREATE DATABASE 语句）

-R (--routines:导出存储过程以及自定义函数)

-E (--events:导出事件)

--triggers (默认导出触发器，使用--skip-triggers屏蔽导出)

-B (--databases:导出数据库列表，单个库时可省略）

--tables 表列表（单个表时可省略）
-- 同时导出结构以及数据时可同时省略-d和-t
-- 同时 不 导出结构和数据可使用-ntd
-- 只导出存储过程和函数可使用-R -ntd
-- 导出所有(结构&数据&存储过程&函数&事件&触发器)使用-R -E(相当于①，省略了-d -t;触发器默认导出)
-- 只导出结构&函数&事件&触发器使用 -R -E -d
```

## 恢复

- 连接到数据库，切换到需要导入的数据库

  ```bash
  use database_created;
  source /path_to_export_sql_file.sql
  ```
