# Facades

## 介绍

`Facades` 是应用框架服务容器中类的静态接口，`laravel` 所有的内置模块都提供了 `facades` 以便于使用。 `laravel` 框架的 `facades` 就像是框架服务容器中类的静态代理，和传统的静态方法相比，更加的简洁明了，更容易测试，更具灵活性。

`laravel` 所有的 `facades` 定义在 `Illuminate\Support\Facades` 名称空间，具体使用方式如下：

```php
use Illuminate\Support\Facades\Cache;

Route::get('/cache', function () {
    return Cache::get('key');
});
```

## 什么时候使用 `Facades`

`facades` 有很多的优势。提供简洁而语义清晰的表达式来使用 `laravel` 的特性，避免了记忆和编码配置较长的类名。此外，由于独特的使用PHP的魔术方法，使得 `facades` 很容易被测试。

然而， 在使用 `facades` 过程中有些方面一定要特别注意。最需要注意的是 `facades` 作用域扩散。鉴于 `facades` 便于使用和不需要注入，很容易导致一个单一的类中使用了大量的 `facades` 导致类过于臃肿。在使用依赖注入的时候，构造函数可以在视觉上告诉我们当前类已经变得臃肿。所以，我们在使用 `facades` 的时候，一定特别注意保持类的大小合理并且职责单一。

### `Facades` 和 依赖注入

依赖注入的一个主要的优势在于替换需要注入类的不同的实现。这种特性在测试的时候非常有用，我们可以根据需要伪造或者构造一个子类，断言子类的的方法存根。

典型的差别是，`facades` 不可以伪造或者存根一个真正的静态方法。由于 `facades` 是使用魔术方法来调用服务容器中类的方法，我们也可以像测试类注入一样测试 `facades`。以下是示例：

```php
use Illuminate\Support\Facades\Cache;

Route::get('/cache', function () {
    return Cache::get('key');
});
```

可以通过以下给出的方式来测试 `Cache::get` 方法，传入我们预期的参数：

```php
use Illuminate\Support\Facades\Cache;

/**
 * A basic functional test example.
 *
 * @return void
 */
public function testBasicExample()
{
    Cache::shouldReceive('get')
         ->with('key')
         ->andReturn('value');

    $this->visit('/cache')
         ->see('value');
}
```

### `Facades` 和 辅助方法

除了 `facades` 以外， `laravel` 还提供了助手方法来执行通用的任务，比如生成视图，启动事件，分发任务，发送 `HTTP` 响应。很多助手函数都有对应的 `facade` 来完成相同的功能，比如以下两个调用是等价的：

```php
return View::make('profile');

return view('profile');
```

在 `facades` 和助手函数之间没有实质的差别。使用助手函数的时候，我们可以通过测试 `facades` 的方式来测试助手函数，以下给出一个实例:

```php
Route::get('/cache', function () {
    return cache('key');
});
```

再深入一些，`cache` 助手函数会调用 `Cache Facade` 所对应的 `get` 方法。所以，即使我们使用助手函数，我们依然可以通过以下的方式来验证函数是否按照我们的预期参数来调用：

```php
use Illuminate\Support\Facades\Cache;

/**
 * A basic functional test example.
 *
 * @return void
 */
public function testBasicExample()
{
    Cache::shouldReceive('get')
         ->with('key')
         ->andReturn('value');

    $this->visit('/cache')
         ->see('value');
}
```

## `Facades` 工作原理

在 `laravel` 应用中，`facade` 类提供了一个访问容器内部对象的方法。具体的实现原理可以在 `Facade` 类定义文件中找到。`laravel` 框架和用户自定义的 `facades` 都必须继承 `Illuminate\Support\Facades\Facade`。

`Facade` 基类使用 `__callStatic()` 魔术方法，通过定义的 `facade` 来延迟服务容器中对象的调用。下面提供一个示例，展示调用 `laravel` 缓存。从代码的语义来看，就像是在 `Cache` 类上调用了静态的 `get` 方法：

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Cache;

class UserController extends Controller
{
    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return Response
     */
    public function showProfile($id)
    {
        $user = Cache::get('user:'.$id);

        return view('profile', ['user' => $user]);
    }
}
```

这里需要注意文件顶部 `导入` 了 `Cache Facade`。这个 `Facade` 提供了一个代理来方便访问 `Illuminate\Contracts\Cache\Factory` 接口的具体实现。任何对当前 `Facade` 的调用都会访问到 `laravel` 的缓存服务实例.

我们去阅读 `Illuminate\Support\Facades\Cache` 类的源码， 会发现这个类里并没有 `get` 这个静态方法:

```php
class Cache extends Facade
{
    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor() { return 'cache'; }
}
```

而是继承了 `Facade` 基类的 `Cache`，`Cache` 类中只定了一个方法 `getFacadeAccessor()` 。这个方法的目的是返回服务容器中绑定的服务名称。当从 `Cache` 访问任何静态方法时，`laravel` 都会从服务容器中找到与之（绑定的服务名称）绑定的服务，并在服务上执行方法调用。

## 实时 `Facades`

使用实时 `facades` ，可以把应用中所有的类都当作是 `facade`。为了阐明怎么产生作用，我们从另外一个角度来验证。通过一个示例来说明，假设 `Podcast` 这个模型有一个 `publish` 方法。然而，为了发布这个广播，我们需要注入一个 `Publisher` 实例:

```php
<?php

namespace App;

use App\Contracts\Publisher;
use Illuminate\Database\Eloquent\Model;

class Podcast extends Model
{
    /**
     * Publish the podcast.
     *
     * @param  Publisher  $publisher
     * @return void
     */
    public function publish(Publisher $publisher)
    {
        $this->update(['publishing' => now()]);

        $publisher->publish($this);
    }
}
```

我们通过注入一个构造的 `Publisher` 类来独立的测试这个 `发布` 方法。然而，却需要我们每次在调用 `publish` 方法是都传入一个 `Publisher` 实例。使用实时 `Facades` 时，我们可以保持这种测试便利性，同时不需要显式地传入一个 `Publisher` 实例。通过在需要导入的类名称空间增加前缀 `Facades` 来创建一个实时 `Facade`:

```php
<?php

namespace App;

use Facades\App\Contracts\Publisher;
use Illuminate\Database\Eloquent\Model;

class Podcast extends Model
{
    /**
     * Publish the podcast.
     *
     * @return void
     */
    public function publish()
    {
        $this->update(['publishing' => now()]);

        Publisher::publish($this);
    }
}
```

当使用了实时 `Facade`，`Publisher` 类的的实例会根据导入语句中 `Facades` 后出现的接口或者类名来自动的从服务容器中导入到当前类。测试的时候，可以使用 `laravel` 内置的测试助手函数来构造调用方法:

```php
<?php

namespace Tests\Feature;

use App\Podcast;
use Tests\TestCase;
use Facades\App\Contracts\Publisher;
use Illuminate\Foundation\Testing\RefreshDatabase;

class PodcastTest extends TestCase
{
    use RefreshDatabase;

    /**
     * A test example.
     *
     * @return void
     */
    public function test_podcast_can_be_published()
    {
        $podcast = factory(Podcast::class)->create();

        Publisher::shouldReceive('publish')->once()->with($podcast);

        $podcast->publish();
    }
}
```

## `Facade` 类说明

以下给出了框架中所有 `Facade` 对应的类文件。阅读 `Facade` 目录下的源码可以帮助我们快速的了解 `Facade`。包含服务容器中绑定的名称。

Facade    |     Class    |     Service Container Binding
------------- | ---------------------- | -------------------
App    |     Illuminate\Foundation\Application    |     app
Artisan    |     Illuminate\Contracts\Console\Kernel    |     artisan
Auth    |     Illuminate\Auth\AuthManager    |     auth
Auth (Instance)    |     Illuminate\Contracts\Auth\Guard    |     auth.driver
Blade    |     Illuminate\View\Compilers\BladeCompiler    |     blade.compiler
Broadcast    |     Illuminate\Contracts\Broadcasting\Factory |
Broadcast (Instance)    |     Illuminate\Contracts\Broadcasting\Broadcaster |
Bus    |     Illuminate\Contracts\Bus\Dispatcher |
Cache    |     Illuminate\Cache\CacheManager    |     cache
Cache (Instance)    |     Illuminate\Cache\Repository    |     cache.store
Config    |     Illuminate\Config\Repository    |     config
Cookie    |     Illuminate\Cookie\CookieJar    |     cookie
Crypt    |     Illuminate\Encryption\Encrypter    |     encrypter
DB    |     Illuminate\Database\DatabaseManager    |     db
DB (Instance)    |     Illuminate\Database\Connection    |     db.connection
Event    |     Illuminate\Events\Dispatcher    |     events
File    |     Illuminate\Filesystem\Filesystem    |     files
Gate    |     Illuminate\Contracts\Auth\Access\Gate
Hash    |     Illuminate\Contracts\Hashing\Hasher    |     hash
Lang    |     Illuminate\Translation\Translator    |     translator
Log    |     Illuminate\Log\LogManager    |     log
Mail    |     Illuminate\Mail\Mailer    |     mailer
Notification    |     Illuminate\Notifications\ChannelManager |
Password    |     Illuminate\Auth\Passwords\PasswordBrokerManager    |     auth.password
Password (Instance)    |     Illuminate\Auth\Passwords\PasswordBroker    |     auth.password.broker
Queue    |     Illuminate\Queue\QueueManager    |     queue
Queue (Instance)    |     Illuminate\Contracts\Queue\Queue    |     queue.connection
Queue (Base Class)    |     Illuminate\Queue\Queue |
Redirect    |     Illuminate\Routing\Redirector    |     redirect
Redis    |     Illuminate\Redis\RedisManager    |     redis
Redis (Instance)    |     Illuminate\Redis\Connections\Connection    |     redis.connection
Request    |     Illuminate\Http\Request    |     request
Response    |     Illuminate\Contracts\Routing\ResponseFactory |
Response (Instance)    |     Illuminate\Http\Response |
Route    |     Illuminate\Routing\Router    |     router
Schema    |     Illuminate\Database\Schema\Builder |
Session    |     Illuminate\Session\SessionManager    |     session
Session (Instance)    |     Illuminate\Session\Store    |     session.store
Storage    |     Illuminate\Filesystem\FilesystemManager    |     filesystem
Storage (Instance)    |     Illuminate\Contracts\Filesystem\Filesystem    |     filesystem.disk
URL    |     Illuminate\Routing\UrlGenerator    |     url
Validator    |     Illuminate\Validation\Factory    |     validator
Validator (Instance)    |     Illuminate\Validation\Validator |
View    |     Illuminate\View\Factory    |     view
View (Instance)    |     Illuminate\View\View    |
