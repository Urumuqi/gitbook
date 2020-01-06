# Service Container

* [介绍](#介绍)
* [绑定](#绑定)
  * [基础绑定](#基础绑定)
  * [绑定接口和实现](#绑定接口和实现)
  * [上下文绑定](#上下文绑定)
  * [标签](#标签)
  * [绑定继承](#绑定继承)
* [提取](#提取)
  * [make方法](#make方法)
  * [自动注入](#自动注入)
* [容器事件](#容器事件)
* [PSR-11](#psr-11)

## 介绍

`Laravel` 服务容器是管理对象依赖和执行依赖注入的强大工具。依赖注入是一个时髦的词汇，基础的意思是：类的依赖通过类的构造函数或者`setter`方法注入到类中。看一下示例：

```php
<?php

namespace App\Http\Controllers;

use App\User;
use App\Repositories\UserRepository;
use App\Http\Controllers\Controller;

class UserController extends Controller
{
    /**
     * The user repository implementation.
     *
     * @var UserRepository
     */
    protected $users;

    /**
     * Create a new controller instance.
     *
     * @param  UserRepository  $users
     * @return void
     */
    public function __construct(UserRepository $users)
    {
        $this->users = $users;
    }

    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
        $user = $this->users->find($id);

        return view('user.profile', ['user' => $user]);
    }
}
```

在这个示例中，`UserController`需要从数据源中加载`user`数据，所以注入了一个可以获取用户的服务。在这个场景下，`UserRepository`类似于`Eloquent`对象，可以从数据库中获取用户信息。虽然数据仓库被注入了，也可以很容易替换一个其他的实现类。在测试的时候，也可以轻易的构造或者生成一个假的`UserRepository`.

深入的了解`Laravel`服务容器对于帮助我们构建一个强大的大型应用十分必要，同时也可以为`laravel core`提交贡献。

## 绑定

### 基础绑定

几乎所有的服务容器绑定关系都通过服务供应来注册，接下来的大多数示例都会展示容器的使用场景。

    如果类没有依赖任何的接口，不需要将类绑定到服务容器中（所有的类都到服务容器中，未免太臃肿了吧！！！）。容器并不需要知道如何构建这些对象，因为可以通过反射来自动的加载这些对象（这里提到了反射，效率略低，看下源码）。

* 简单绑定

在服务供应中，可以通过`$this->app`来使用服务容器。可以使用`bind`方法来注册一个绑定，通过传入一个类或者接口名到闭包函数，闭包函数会返回一个类的实例：

```php
$this->app->bind('HelpSpot\API', function ($app) {
    return new HelpSpot\API($app->make('HttpClient'));
});
```

注意，我们可以接受容器本身作为构造器的参数。我们可以通过容器来构造一个对象的子依赖。

* 绑定单列

`singleton`方法绑定一个类或接口到容器只会构造一次。一旦一个单列被创建，容器中后续所有的调用都是使用同一个对象的实例：

```php
$this->app->singleton('HelpSpot\API', function ($app) {
    return new HelpSpot\API($app->make('HttpClient'));
});
```

* 绑定实例

`instance`方法可以绑定一个对象实例到容器中。在容器后续的调用中，绑定的对象将会被使用到：

```php
$api = new HelpSpot\API(new HttpClient);

$this->app->instance('HelpSpot\API', $api);
```

* 绑定主数据类型

在某些情况下类需要接收一些类的注入，同时也需要一些主数据类型的注入，比如一个整型的数据。可以通过上下文绑定注入类需要的任何的值：

```php
$this->app->when('App\Http\Controllers\UserController')
          ->needs('$variableName')
          ->give($value);
```

### 绑定接口和实现

服务容器一个很强大的特性是，可以将接口和某个特定的实现绑定。比如，我们为`EventPusher`接口指定一个`RedisEventPusher`实现。编写`RedisEventPusher`实现了`EventPusher`接口，我们可以通过一下的方式在容器中注册：

```php
$this->app->bind(
    'App\Contracts\EventPusher',
    'App\Services\RedisEventPusher'
);
```

以上代码的意思是，当类需要`EventPusher`实现的时候，就会注入一个`RedisEventPusher`类。我们可以在构造函数中类型提示或者其他的依赖注入的方式来完整类的注入：

```php
use App\Contracts\EventPusher;

/**
 * Create a new class instance.
 *
 * @param  EventPusher  $pusher
 * @return void
 */
public function __construct(EventPusher $pusher)
{
    $this->pusher = $pusher;
}
```

### 上下文绑定

### 标签

### 绑定继承

## 提取

### make方法

### 自动注入

## 容器事件

## PSR-11
