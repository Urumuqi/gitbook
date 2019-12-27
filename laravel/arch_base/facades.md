
# 介绍

`Facades` 是应用框架服务容器中类的静态接口，`laravel` 所有的内置模块都提供了 `facades` 以便于使用。 `laravel` 框架的 `facades` 就像是框架服务容器中类的静态代理，和传统的静态方法相比，更加的简洁明了，更容易测试，更具灵活性。

`laravel` 所有的 `facades` 定义在 `Illuminate\Support\Facades` 名称空间，具体使用方式如下：

```php
use Illuminate\Support\Facades\Cache;

Route::get('/cache', function () {
    return Cache::get('key');
});
```

# 什么时候使用 `Facades`

`facades` 有很多的优势。提供简洁而语义清晰的表达式来使用 `laravel` 的特性，避免了记忆和编码配置较长的类名。此外，由于独特的使用PHP的魔术方法，使得 `facades` 很容易被测试。

然而， 在使用 `facades` 过程中有些方面一定要特别注意。最需要注意的是 `facades` 作用域扩散。鉴于 `facades` 便于使用和不需要注入，在很容易导致一个单一的类中使用了大量的 `facades` 导致类过于臃肿。在使用依赖注入的时候，构造函数可以在视觉上告诉我们当前类已经变得臃肿。所以，我们在使用 `facades` 的时候，一定特别注意保持类的大小合理并且职责单一。

## `Facades` 和 依赖注入

依赖注入的一个主要的优势在于替换需要注入类的不同的实现。这种特性在测试的时候非常有用，我们可以根据需要伪造或者构造一个子类，断言子类的的方法存根。

典型的差别是，`facades` 不可以伪造或者存根一个真正的静态方法。由于 `facades` 是使用魔术方法来调用服务容器中类的方法调用，我们也可以像测试类实例注入一样测试 `facades`。以下是实例：

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

## `Facades` 和 辅助方法

出了 `facades` 以外， `laravel` 还提供了助手方法来执行通用的任务，比如生成视图，启动事件，分发任务，发送 `HTTP` 响应。很多助手函数都要对应的 `facade` 来完成相同的功能，比如以下两个调用是等价的：

```php
return View::make('profile');

return view('profile');
```

在 `facades` 和助手函数之间没有明显的差别。使用助手函数的时候，我们可以通过测试 `facades` 的方式来测试助手函数，以下给出一个实例:

```php
Route::get('/cache', function () {
    return cache('key');
});
```

再深入一些，`cache` 助手函数会掉用 `Cache Facade` 所对应的 `get` 方法。所以，即使我们使用助手函数，我们依然可以通过以下的方式来验证函数是否按照我们的预期参数来调用：

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

# `Facades` 工作原理

# 实时 `Facades`

# `Facades` 使用说明
