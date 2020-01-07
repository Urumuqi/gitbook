# Service Container

* [介绍](#介绍)
* [绑定](#绑定)
  * [基础绑定](#基础绑定)
  * [绑定接口和实现](#绑定接口和实现)
  * [上下文绑定](#上下文绑定)
  * [标签绑定](#标签绑定)
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

某些情况下对相同的接口有不同的实现，我们希望在不同的类中加载不同的实现。比如，有两个控制器依赖`Illuminate\Contracts\Filesystem\Filesystem` 这个`contract`。`Laravel`提供了简洁方便的方式来实现这种行为：

```php
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\PhotoController;
use App\Http\Controllers\VideoController;
use Illuminate\Contracts\Filesystem\Filesystem;

$this->app->when(PhotoController::class)
          ->needs(Filesystem::class)
          ->give(function () {
              return Storage::disk('local');
          });

$this->app->when([VideoController::class, UploadController::class])
          ->needs(Filesystem::class)
          ->give(function () {
              return Storage::disk('s3');
          });
```

### 标签绑定

偶尔，我们也需要通过标签来完成依赖绑定关系。比如，我们需要构造一个告警接收器来接收`Report`接口的不同的具体告警消息。在注册了`Report`具体实现之后，我们通过`tag`方法来完成依赖指定：

```php
$this->app->bind('SpeedReport', function () {
    //
});

$this->app->bind('MemoryReport', function () {
    //
});

$this->app->tag(['SpeedReport', 'MemoryReport'], 'reports');
```

一旦服务被打上标记之后，我们就能简单的通过`tagged`方法来调用这些绑定的服务对象。

### 绑定继承

`extend`方法可以允许修改要实现的服务。比如，当一个服务被应用的时候，我们可以通过额外的代码来完善或者配置服务。`extend`方法接收闭包作为唯一的参数，同时闭包必须返回被修改过的服务对象：

```php
$this->app->extend(Service::class, function ($service) {
    return new DecoratedService($service);
});
```

## 提取

### make方法

可以通过`make`方法从容器中提取出一个类的实例。`make`方法接收要提取的类命或者接口名作为参数:

```php
$api = $this->app->make('HelpSpot\API');
```

如果当前的代码环境无法使用`$app`全局变量，可以使用`resolve`这个助手函数:

```php
$api = resolve('HelpSpot\API');
```

如果当前的类依赖环境下无法从容器中提取对象，可以通过`makeWith`方法加额外的参数数组来获取服务的实例:

```php
$api = $this->app->makeWith('HelpSpot\API', ['id' => 1]);
```

### 自动注入

另外，更重要的是，我们可以在构造函数中通过类型提示来注入容器中的类，包括控制器，事件监听器，中间件，等。另外，可以通过`handle`方法的类型提示来注入队列任务的依赖。总之，这是通常情况下容器管理对象的方式。

比如，我们在控制器的构造方法中通过类型提示来注入数据源。数据源对象将被自动的实例化并注入到控制器类中：

```php
<?php

namespace App\Http\Controllers;

use App\Users\Repository as UserRepository;

class UserController extends Controller
{
    /**
     * The user repository instance.
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
     * Show the user with the given ID.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
        //
    }
}
```

## 容器事件

服务容器每次对对象的操作都会触发一个事件。可以通过`resolving`方法来监听事件:

```php
$this->app->resolving(function ($object, $app) {
    // Called when container resolves object of any type...
});

$this->app->resolving(HelpSpot\API::class, function ($api, $app) {
    // Called when container resolves objects of type "HelpSpot\API"...
});
```

正如看到的情况，对象被实例化的事件会被传达到回调函数，这就允许我们在对象被正式使用前修改它的属性。

## PSR-11

`Laravel` 服务容器实现了`PSR-11`接口。所以，我们可以通过`PSR-11`容器接口来获取一个`Laravel`的容器:

```php
use Psr\Container\ContainerInterface;

Route::get('/', function (ContainerInterface $container) {
    $service = $container->get('Service');

    //
});
```

如果给出的标识符代表的对象不能被实例化将抛出异常。如果标识符代表的对象在同其中不存在，异常将是`Psr\Container\NotFoundExceptionInterface`的一个实例。如果标识符代表的对象存在，但是不能被提取实例，将会抛出一个`Psr\Container\ContainerExceptionInterface`异常。
