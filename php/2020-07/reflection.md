# PHP 反射

## PHP 反射API

类型  |  说明
---- | ----
Reflector  |  Reflector 是一个接口，被所有可导出的反射类所实现（implement）
Reflection  |  反射（reflection）类
ReflectionClass  |  报告了一个类的有关信息
ReflectionClassConstant  |  报告有关类常量的信息
ReflectionZendExtension  |  报告Zend扩展的相关信息
ReflectionExtension  |  报告了PHP扩展的有关信息
ReflectionFunction  |  报告了一个函数的有关信息
ReflectionFunctionAbstract  |  ReflectionFunction 的父类
ReflectionMethod  |  报告了一个方法的有关信息
ReflectionObject  |  报告了一个对象（object）的相关信息
ReflectionParameter  |  取回了函数或方法参数的相关信息
ReflectionProperty  |  报告了类的属性的相关信息
ReflectionType  |  获取函数、类方法的参数或者返回值的类型
ReflectionGenerator  |  获取生成器的信息
ReflectionException  |  反射异常类

## 代码测试

```php
<?php
/**
 * 反射.
 */

namespace Test;

use ReflectionClass;
use Exception;

/**
 * Class User.
 * 
 * @property string $username
 * 
 * @method string getUsername()
 * @method void   setUsername($username);
 */
class User {

    const ROLE = 'Developer';
    public $username = '';
    private $password = '';

    public function __construct($username, $password) {
        $this->username = $username;
        $this->password = $password;
    }

    /**
     * get username.
     *
     * @return string
     */
    public function getUsername() {
        return $this->username;
    }

    public function setUsername($username) {
        $this->username = $username;
    }

    private function getPassword() {
        return $this->password;
    }

    private function setPassword($password) {
        $this->password = $password;
    }
}

$class = new ReflectionClass('Test\User');
var_dump($class);
$properties = $class->getProperties();
var_dump($properties);
$property = $class->getProperty('password');
var_dump($property);
$methods = $class->getMethods();
var_dump($methods);
$method = $class->getMethod('setPassword');
var_dump($method);
// consts array
$consts = $class->getConstants();
var_dump($consts);
$const = $class->getConstant('ROLE');
var_dump($const);
$namespace = $class->getNamespaceName();
var_dump($namespace);
$comment_class= $class->getDocComment();
var_dump($comment_class);
$comment_method = $class->getMethod('getUsername')->getDocComment();
var_dump($comment_method);

// 通过反射来执行代码

// demo 1 通过反射获取类实例
$instance = $class->newInstance('you', 'abc');
var_dump($instance);
$instance->setUsername('me');
$username = $instance->getUsername();
var_dump($username);

// demo 2 通过反射类 ReflectionProperty
$class->getProperty('username')->setValue($instance, 'meme');
$username_value = $class->getProperty('username')->getValue($instance);
echo 'username2 = ' . $username_value . PHP_EOL;

// demo 3 通过反射类 ReflectionMethod
$class->getMethod('setUsername')->invoke($instance, 'youyou');
$username_value2 = $class->getMethod('getUsername')->invoke($instance);
echo 'username2 = ' . $username_value2 . PHP_EOL;

// demo 4 通过反射修改类成员的可访问性
try {
    $newPassword = $class->getProperty('password');
    $newPassword->setAccessible(true);
    $newPassword->setValue($instance, 'password_2');
    $newPasswordValue = $newPassword->getValue($instance);
    echo 'new password value = ' . $newPasswordValue . PHP_EOL;

    $class->getProperty('password')->setAccessible(true); // 只修改了ReflectionProperty类的属性可访问性
    $class->getProperty('password')->setValue($instance, 'password_3'); // 不能访问
    // $password3 = $class->getProperty('password')->getValue($instance);
    // $password3_1 = $instance->password; // 不能访问， instance 本身并未修改
    // echo 'password 3 = ' . $password3 . PHP_EOL;
    // echo 'password 3_1 = ' . $password3_1 . PHP_EOL;
} catch (Exception $e) {
    echo $e->getMessage();
}
```