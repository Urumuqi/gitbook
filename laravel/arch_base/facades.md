
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

## `Facades` 和 辅助方法

# `Facades` 工作原理

# 实时 `Facades`

# `Facades` 使用说明
