# 新增运营商初始化流程

每台ECS（1C2G）支撑10个运营商

- 第一步：增加config/opdatabase.php文件配置，增加格式如下

```php
    [
        'redis' => [
            'host'     => env('REDIS_HOST'),
            'password' => env('REDIS_PASSWORD'),
            'port'     => env('REDIS_PORT'),
            'database' => '1', // 区别于其他运营商redis db
        ],
        'mysql' => [
            'host'     => env('DB_HOST'),
            'port'     => env('DB_PORT'),
            'database' => 'slice_01_op_01', // 区别与其他运营商的 mysql db
            'username' => env('DB_USERNAME'),
            'password' => env('DB_PASSWORD'),
        ],
    ],
```

- 第二步：修改运营商配置文件`config/init-project.php`

```php
<?php
return [
    //运营商信息
    'operator'       => [
        'name'                 => 'SpacesForce',  //运营商名称
        'cellphone'            => '13818096187',  //运营商联系方式
        'contacts_person'      => 'Thomas',  //联系人
        'contacts_phone'       => '13818096187',  //联系人手机
        'contacts_email'       => 'xuyf@spacesforce.com',  //联系人邮箱
        'opening_bank'         => '中国工商银行上海分行',  //开户行
        'opening_bank_account' => '6222000001234',  //开户行账号
        'logo'                 => 'https://amc-one.oss-cn-chengdu.aliyuncs.com/logo/spacesforce_white.png',  //logo
        'company'              => 'Spacesforce资产管理有限公司',  //运营商主体
    ],
    // 运营商管理员
    'operator_admin' => [
        [
            'username' => 'user1',  //用户名
            'account'  => '133xxxxxxxx',  //账号
            'phone'    => '133xxxxxxxx',  //手机
            'email'    => 'user1@email.com',  //邮箱
            'is_root'  => '1',  // root用户是系统管理员, 不应该参与业务
        ],
        [
            'username' => 'user2',  //用户名
            'account'  => '183xxxxxxxx',  //账号
            'phone'    => '183xxxxxxxx',  //手机
            'email'    => 'user2@email.com',  //邮箱
            'is_root'  => '0',  // 非root用户
        ],
    ]
];
```

- 第三步：创建运营商数据库，为新开的客户创建数据库

```shell
php artisan one_saas:database
```

- 第四步：修改`.env`数据库名称配置`DB_DATABASE`

```env
# 数据库名称和第一步中 mysql.database同名，主要用于为客户创建数据库表结构
DB_DATABASE=slice_01_op_01
```

- 第五步：执行数据库迁移脚本

```shell
php artisan migrate
```

- 第六步：为新创建的数据库初始化功能模块

```shell
php artisan acl:module --create=1
```

- 第七步：为新创建的数据库初始化客户基础数据

```shell
php artisan command:init_lite
```

- 第八步：更新当前节点服务器客户缓存，重启服务器之后也需要执行这个命令，可以将这个命令配置为定时任务，每小时执行一次

```shell
php artisan one_saas:recovery
```

新开一个运营商，只需要根据运营商数据，更新第一步、第二步、第四步中的数据，依次执行脚本。脚本执行完成就可以用运营商root用户登陆。
