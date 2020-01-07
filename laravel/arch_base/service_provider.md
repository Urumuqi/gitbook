# Service Providers

“服务供应”！！！！！，为自己的翻译水平感到着急。

* [介绍](#介绍)
* [编写](#编写)
  * [注册方法](#注册方法)
  * [启动方法](#启动方法)
* [注册服务](#注册服务)
* [延迟的服务](#延迟的服务)

## 介绍

服务供应是`Laravel`应用的引导的核心部分。应用中自定义的服务和框架核心的服务都通过服务供应在引导。

不过，“引导”是什么意思呢？通常来讲，指的是注册，包括注册服务容器绑定，事件监听器，中间件，甚至是路由。服务供应是应用配置的核心部分。

打开`config/app.php`文件，会看到`$providers`这个数组。这是应用需要加载的所有的服务供应。需要注意，这其中有一些是`延迟的服务`，意味着不会每次请求都加载，只在服务实际被需要的时候。

接下来会介绍怎么写一个服务供应并在应用中注册。

## 编写

所有的服务供应都继承了`Illuminate\Support\ServiceProvider`类。大多数的服务供应都有`register`和`boot`方法。在`register`方法中，应该且只做必要的服务容器绑定操作。我们不应该尝试通过`register`方法来注册事件监听，路由或者其他的功能性代码。

通过`make:provider`脚手架，可以快速的生成一个服务供应：

```bash
php artisan make:provider RiakServiceProvider
```

### 注册方法

前面提到过，`register`方法中只应该做一些简单的服务容器绑定的事情。一定要避免通过`register`方法来注册事件监听，路由或者功能性代码块。否则，可能会在某些情况下使用没有被加载的服务。

我们来看一下基础的服务供应。在服务供应的方法中，我们都可以使用`$app`变量来访问服务容器:

```php
<?php

namespace App\Providers;

use Riak\Connection;
use Illuminate\Support\ServiceProvider;

class RiakServiceProvider extends ServiceProvider
{
    /**
     * Register bindings in the container.
     *
     * @return void
     */
    public function register()
    {
        $this->app->singleton(Connection::class, function ($app) {
            return new Connection(config('riak'));
        });
    }
}
```

这个服务供应只提供了一个`register`方法，用来在服务容器中定义一个`Riak\Connection`的具体实现。如果对服务容器有不了解的地方，查看之前的[文档](service_container.md)。

* `bindings` 和 `singletons` 属性

如果服务供应要注册多个简单的服务，我们可以使用`bindings`和`singletons`这两个属性，从而避免手动注册每一个服务到容器。框架在加载服务的时候会检查这两个属性，并注册他们:

```php
<?php

namespace App\Providers;

use App\Contracts\ServerProvider;
use App\Contracts\DowntimeNotifier;
use App\Services\ServerToolsProvider;
use Illuminate\Support\ServiceProvider;
use App\Services\PingdomDowntimeNotifier;
use App\Services\DigitalOceanServerProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * All of the container bindings that should be registered.
     *
     * @var array
     */
    public $bindings = [
        ServerProvider::class => DigitalOceanServerProvider::class,
    ];

    /**
     * All of the container singletons that should be registered.
     *
     * @var array
     */
    public $singletons = [
        DowntimeNotifier::class => PingdomDowntimeNotifier::class,
        ServerToolsProvider::class => ServerToolsProvider::class,
    ];
}
```

### 启动方法

那么，如果我们的服务供应总需要注册一个视图要怎么办呢？应该通过`boot`方法来搞定。这个方法会在所有的服务供应都注册之后被调用，也就是我们可以使用框架所有已经注册的服务：

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class ComposerServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        view()->composer('view', function () {
            //
        });
    }
}
```

* `boot`方法依赖注入

可以通过`boot`方法的参数类型提示来注入依赖。服务容器会自动注入需要的依赖:

```php
use Illuminate\Contracts\Routing\ResponseFactory;

public function boot(ResponseFactory $response)
{
    $response->macro('caps', function ($value) {
        //
    });
}
```

## 注册服务

所有的服务供应都注册在`config/app.php`文件中。文件中的`$providers`数组中是所有需要注册的服务供应的类名。默认情况下，会包含`Laravel`框架默认的服务供应。这些默认服务供应都是`Laravel`框架核心的组件，比如邮件，队列，缓存和其他的一些服务。

通过一下方式注册自定义的服务供应：

```php
'providers' => [
    // Other Service Providers

    App\Providers\ComposerServiceProvider::class,
],
```

## 延迟的服务

如果服务供应的目的是注册服务到服务容器中，那么我们可以选择延迟注册，直到真正被需要的时候在注册。延迟加载服务可以提供应用的性能，因为不用每次请求都从文件系统加载文件。

`Laravel`框架把需要延迟加载的服务供应编译并存储到一个列表中。然后，直到试图获取一个服务实例的时候再加载服务供应。

所有的延迟供应都实现了`\Illuminate\Contracts\Support\DeferrableProvider`接口和一个`provides`方法。`provides`方法会返回服务容器中被注册的服务绑定:

```php
<?php

namespace App\Providers;

use Riak\Connection;
use Illuminate\Support\ServiceProvider;
use Illuminate\Contracts\Support\DeferrableProvider;

class RiakServiceProvider extends ServiceProvider implements DeferrableProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->singleton(Connection::class, function ($app) {
            return new Connection($app['config']['riak']);
        });
    }

    /**
     * Get the services provided by the provider.
     *
     * @return array
     */
    public function provides()
    {
        return [Connection::class];
    }
}
```
