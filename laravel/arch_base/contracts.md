# Contracts

## 介绍
`Laravel Contracts` 是框架核心服务的一组接口集合。比如，`Illuminate\Contracts\Queue\Queue` 定义了队列任务需要的操作方法，`Illuminate\Contracts\Mail\Mailer` 定义了发送邮件需要的方法。

每一个 `Contract` 都有框架提供的对应的实现。比如，`Laravel` 提供了不同的驱动来实现统一的队列服务，框架中默认提供了 `SwiftMailer` 的邮件服务。

所有的 `Laravel Contracts` 都有对应的 `GitHub` [仓库](https://github.com/illuminate/contracts)。这个仓库可以帮助包作者快速的了解并使用这些独立的，低耦合的 `Contract` 包。

## Contracts Vs. Facades
`Laravel` 中 `Facades` 和助手函数提供了一种简单的方式来使用 `Laravel` 提供的服务，避免了类型提示和服务容器中复制一个对象。在大多数情况下，每个 `facade` 都有对应的 `contract`。

和 `Facades` 不同的是，`Contracts` 不需要在构造函数中注入依赖，`Contracts` 允许在类中透明的定义依赖项。一些开发者倾向于使用透明的依赖注入，因此更喜欢使用 `Contracts`，而另外一些开发者喜欢 `Facades`的便利性。

**PS**: 在大多数的应用中，不要可以区别`Facades` 或是 `Contracts`。特别要注意，如果是在构建一个组件包，强烈推荐使用 `Contracts`，因为这样的方式在包所提供的环境中更容易测试。

## When To Use Contracts
正如之前讨论到的，到底是使用 `Contracts` 还是 `Facades` 可以根据个人的喜好或者团队的喜好来决定。两者都能用来构建可靠且容易测试的应用。只要我们在开发中持续的关注类的职责范围，会发现 `Contracts` 和 `Facades` 并没有多少本质的差别。

到目前为止，你一定对 `Contracts` 有些疑问。比如，为什么一直都在使用 `interface`？使用 `interface` 不是增加了复杂度吗？留住疑问，我们继续看下面两个部分：`Loose Coupling` 和 `Simplicity`。

### Loose Coupling
首先，我们看一些关于缓存的深度耦合的代码，思考下面的代码:
```php
<?php

namespace App\Orders;

class Repository
{
    /**
     * The cache instance.
     */
    protected $cache;

    /**
     * Create a new repository instance.
     *
     * @param  \SomePackage\Cache\Memcached  $cache
     * @return void
     */
    public function __construct(\SomePackage\Cache\Memcached $cache)
    {
        $this->cache = $cache;
    }

    /**
     * Retrieve an Order by ID.
     *
     * @param  int  $id
     * @return Order
     */
    public function find($id)
    {
        if ($this->cache->has($id))    {
            //
        }
    }
}
```
在上面的示例中，代码和缓存的实现密切耦合。之所以说密切耦合，是因为这个包源码依赖一个具体的缓存实现。如果缓存中的 `api` 发生变更，使用缓存包的代码也需要跟着变更。

同样的，如果我们要替换使用的缓存技术，比如从 `Memcached` 到 `Redis`，我们又一次需要修改包中的代码。我们的代码包不应该依赖谁来提供数据或者他们怎么提供数据。

另外一种方式，通过依赖简单的，底层实现无关的方式来优化代码：
```php
<?php

namespace App\Orders;

use Illuminate\Contracts\Cache\Repository as Cache;

class Repository
{
    /**
     * The cache instance.
     */
    protected $cache;

    /**
     * Create a new repository instance.
     *
     * @param  Cache  $cache
     * @return void
     */
    public function __construct(Cache $cache)
    {
        $this->cache = $cache;
    }
}
```
现在代码没有和任何特定的实现代码绑定，甚至没有和 `Laravel` 绑定。因为 `contracts` 包没有包含任何的实现和依赖，所以可以为任何你需要的 `contracts` 编写具体的实现逻辑，你可以在不改变任何业务代码的情况下更换缓存组件。

### Simplicity
当所有的 `Laravel` 服务都有序的通过 `interface` 来定义，就会很容易实现服务提供的功能。`Contracts` 可以被当作是 `Laravel` 框架的简易说明书。

## How To Use Contracts
接下来，我们怎么使用 `Contracts` 呢？ 其实也非常简单。

`Laravel` 中很多类都通过服务容器来管理，包括 `Controllers`, `event listeners`, `middleware`, `queued jobs`, `event route Closures` 等。要获取一个 `contract` 的实例，只需要在构造函数中加入用到的类的类型提示接口。

以下是一个事件监听器的实例：
```php
<?php

namespace App\Listeners;

use App\User;
use App\Events\OrderWasPlaced;
use Illuminate\Contracts\Redis\Factory;

class CacheOrderInformation
{
    /**
     * The Redis factory implementation.
     */
    protected $redis;

    /**
     * Create a new event handler instance.
     *
     * @param  Factory  $redis
     * @return void
     */
    public function __construct(Factory $redis)
    {
        $this->redis = $redis;
    }

    /**
     * Handle the event.
     *
     * @param  OrderWasPlaced  $event
     * @return void
     */
    public function handle(OrderWasPlaced $event)
    {
        //
    }
}
```
当事件监听器生效之后，服务容器会通过构造函数的类型提示来注入需要的值。查看服务容器注册的[文档](./service_container.md)了解更多。

## Contract Reference
以下是所有的 `Contracts` 列表，以及对应的 `Facades`:

Contract    |    References Facade
------------|------------------|--------------------------
Illuminate\Contracts\Auth\Access\Authorizable |
Illuminate\Contracts\Auth\Access\Gate    |    Gate
Illuminate\Contracts\Auth\Authenticatable |
Illuminate\Contracts\Auth\CanResetPassword |
Illuminate\Contracts\Auth\Factory    |    Auth
Illuminate\Contracts\Auth\Guard    |    Auth::guard()
Illuminate\Contracts\Auth\PasswordBroker    |    Password::broker()
Illuminate\Contracts\Auth\PasswordBrokerFactory    |    Password
Illuminate\Contracts\Auth\StatefulGuard |
Illuminate\Contracts\Auth\SupportsBasicAuth |
Illuminate\Contracts\Auth\UserProvider |
Illuminate\Contracts\Bus\Dispatcher    |    Bus
Illuminate\Contracts\Bus\QueueingDispatcher    |    Bus::dispatchToQueue()
Illuminate\Contracts\Broadcasting\Factory    |    Broadcast
Illuminate\Contracts\Broadcasting\Broadcaster    |    Broadcast::connection()
Illuminate\Contracts\Broadcasting\ShouldBroadcast |
Illuminate\Contracts\Broadcasting\ShouldBroadcastNow |
Illuminate\Contracts\Cache\Factory    |    Cache
Illuminate\Contracts\Cache\Lock |
Illuminate\Contracts\Cache\LockProvider |
Illuminate\Contracts\Cache\Repository    |    Cache::driver()
Illuminate\Contracts\Cache\Store |
Illuminate\Contracts\Config\Repository    |    Config
Illuminate\Contracts\Console\Application |
Illuminate\Contracts\Console\Kernel    |    Artisan
Illuminate\Contracts\Container\Container    |    App
Illuminate\Contracts\Cookie\Factory    |    Cookie
Illuminate\Contracts\Cookie\QueueingFactory    |    Cookie::queue()
Illuminate\Contracts\Database\ModelIdentifier |
Illuminate\Contracts\Debug\ExceptionHandler |
Illuminate\Contracts\Encryption\Encrypter    |    Crypt
Illuminate\Contracts\Events\Dispatcher    |    Event
Illuminate\Contracts\Filesystem\Cloud    |    Storage::cloud()
Illuminate\Contracts\Filesystem\Factory    |    Storage
Illuminate\Contracts\Filesystem\Filesystem    |    Storage::disk()
Illuminate\Contracts\Foundation\Application    |    App
Illuminate\Contracts\Hashing\Hasher    |    Hash
Illuminate\Contracts\Http\Kernel |
Illuminate\Contracts\Mail\MailQueue    |    Mail::queue()
Illuminate\Contracts\Mail\Mailable |
Illuminate\Contracts\Mail\Mailer    |    Mail
Illuminate\Contracts\Notifications\Dispatcher    |    Notification
Illuminate\Contracts\Notifications\Factory    |    Notification
Illuminate\Contracts\Pagination\LengthAwarePaginator |
Illuminate\Contracts\Pagination\Paginator |
Illuminate\Contracts\Pipeline\Hub |
Illuminate\Contracts\Pipeline\Pipeline |
Illuminate\Contracts\Queue\EntityResolver |
Illuminate\Contracts\Queue\Factory    |    Queue
Illuminate\Contracts\Queue\Job |
Illuminate\Contracts\Queue\Monitor    |    Queue
Illuminate\Contracts\Queue\Queue    |    Queue::connection()
Illuminate\Contracts\Queue\QueueableCollection |
Illuminate\Contracts\Queue\QueueableEntity |
Illuminate\Contracts\Queue\ShouldQueue |
Illuminate\Contracts\Redis\Factory    |    Redis
Illuminate\Contracts\Routing\BindingRegistrar    |    Route
Illuminate\Contracts\Routing\Registrar    |    Route
Illuminate\Contracts\Routing\ResponseFactory    |    Response
Illuminate\Contracts\Routing\UrlGenerator    |    URL
Illuminate\Contracts\Routing\UrlRoutable |
Illuminate\Contracts\Session\Session    |    Session::driver()
Illuminate\Contracts\Support\Arrayable |
Illuminate\Contracts\Support\Htmlable |
Illuminate\Contracts\Support\Jsonable |
Illuminate\Contracts\Support\MessageBag |
Illuminate\Contracts\Support\MessageProvider |
Illuminate\Contracts\Support\Renderable |
Illuminate\Contracts\Support\Responsable |
Illuminate\Contracts\Translation\Loader |
Illuminate\Contracts\Translation\Translator    |    Lang
Illuminate\Contracts\Validation\Factory    |    Validator
Illuminate\Contracts\Validation\ImplicitRule |
Illuminate\Contracts\Validation\Rule |
Illuminate\Contracts\Validation\ValidatesWhenResolved |
Illuminate\Contracts\Validation\Validator    |    Validator::make()
Illuminate\Contracts\View\Engine |
Illuminate\Contracts\View\Factory    |    View
Illuminate\Contracts\View\View    |    View::make()
