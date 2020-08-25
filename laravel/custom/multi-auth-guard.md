# Laravel 应用配置多个 JWT auth guard

在某些应用场景，`Laravel` 应用会有多个应用主体。最典型的场景就是一个CMS系统，用户前端可能是一个`single page web`，或者是`wechat mini app`，也可能是一个`H5 web`。这些系统的典型特征是有一个或者多个前端应用和一个后台管理系统，用户存储在不同的用户表里。在一套`laravel`代码里实现多个`JWT Auth guard`，以下是操作步骤。

## 前提

微信小程序用户表`t_users`，后台管理用户表`m_users`。首先要明确，这两类用户在访问`api`时，都有各自不同的验证逻辑。

版本: `Laravel >= 5.8.*`，`tymon/jwt-auth : ^1.0`。

## 1. 实现两类用户的认证模型

### 1.1 微信用户

```php
<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{

    use Notifiable;

    protected $table = 't_users';

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * get JWT identifier key.
     *
     * @return string
     */
    public function getKey()
    {
        return $this->wechat_id;
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [
            'user_id' => $this->id,
            'sub' => $this->wechat_id,
        ];
    }

    protected $casts = [
        ...
    ];

    protected $fillable = [
        ...
    ];
}

```

### 1.2 后台用户

```php
<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as AuthenticatableUser;
use Tymon\JWTAuth\Contracts\JWTSubject;

class ManageUser extends AuthenticatableUser implements JWTSubject
{
    protected $table = 'm_user';

    protected $casts = [
        ...
    ];

    protected $fillable = [
        ...
    ];

    public function getKey()
    {
        return $this->id;
    }

    public function getJWTCustomClaims()
    {
        return [
            'user_id' => $this->id,
            'sub' => $this->id,
        ];
    }

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }
}
```

## 2. 实现两类用户认证逻辑

### 2.1 微信登录认证逻辑

```php
<?php

namespace App\Auth;

use Illuminate\Contracts\Auth\UserProvider;
use Illuminate\Contracts\Auth\Authenticatable;
use App\Models\User;
use App\Services\UserCacheService;

/**
 * Class WeChatAuthService.
 */
class WeChatAuthService implements UserProvider
{

    /**
     * user model.
     *
     * @var App\Models\User
     */
    protected $user;

    /**
     * constructor.
     *
     * @param \Illuminate\Contracts\Auth\Authenticatable $user
     */
    public function __construct(Authenticatable $user)
    {
        $this->user = $user;
    }

    /**
     * Retrieve a user by their unique identifier.
     *
     * @param  mixed  $identifier
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveById($identifier)
    {
        $user = []; // todo 通过jwt payload sub 获取用户
        return $user;
    }

    /**
     * Retrieve a user by their unique identifier and "remember me" token.
     *
     * @param  mixed  $identifier
     * @param  string  $token
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveByToken($identifier, $token)
    {
        //
    }

    /**
     * Update the "remember me" token for the given user in storage.
     *
     * @param  \Illuminate\Contracts\Auth\Authenticatable  $user
     * @param  string  $token
     * @return void
     */
    public function updateRememberToken(Authenticatable $user, $token)
    {
        //
    }

    /**
     * Retrieve a user by the given credentials.
     *
     * @param  array  $credentials
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveByCredentials(array $credentials)
    {
        $user = User::where(['wechat_id' => $credentials['open_id']])->first();

        // todo 验证逻辑省略

        $this->user = $user;
        return $user;
    }

    /**
     * Validate a user against the given credentials.
     *
     * @param  \Illuminate\Contracts\Auth\Authenticatable  $user
     * @param  array  $credentials
     * @return bool
     */
    public function validateCredentials(Authenticatable $user, array $credentials)
    {
        if ($user->wechat_id == $credentials['open_id']) {
            return true;
        }
        return false;
    }

}
```

### 2.2 后台管理用户验证逻辑

```php
<?php

namespace App\Auth;

use Illuminate\Contracts\Auth\UserProvider;
use Illuminate\Contracts\Auth\Authenticatable;
use App\Models\ManageUser;
use Tymon\JWTAuth\Exceptions\JWTException;

/**
 * Class ManageAuthService.
 */
class ManageAuthService implements UserProvider
{

    /**
     * user model.
     *
     * @var App\Models\ManageUser
     */
    protected $manageUser;

    /**
     * constructor.
     *
     * @param \Illuminate\Contracts\Auth\Authenticatable $user
     */
    public function __construct(Authenticatable $user)
    {
        $this->manageUser = $user;
    }

    /**
     * Retrieve a user by their unique identifier.
     *
     * @param  mixed  $identifier
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveById($identifier)
    {
        return ManageUser::where('id', $identifier)->first();
    }

    /**
     * Retrieve a user by their unique identifier and "remember me" token.
     *
     * @param  mixed  $identifier
     * @param  string  $token
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveByToken($identifier, $token)
    {
        //
    }

    /**
     * Update the "remember me" token for the given user in storage.
     *
     * @param  \Illuminate\Contracts\Auth\Authenticatable  $user
     * @param  string  $token
     * @return void
     */
    public function updateRememberToken(Authenticatable $user, $token)
    {
        //
    }

    /**
     * Retrieve a user by the given credentials.
     *
     * @param  array  $credentials
     * @return \Illuminate\Contracts\Auth\Authenticatable|null
     */
    public function retrieveByCredentials(array $credentials)
    {
        $user = ManageUser::where('user_name', $credentials['username'])->first();
        // todo 省略用户认证逻辑
        $this->manageUser = $user;
        return $user;
    }

    /**
     * Validate a user against the given credentials.
     *
     * @param  \Illuminate\Contracts\Auth\Authenticatable  $user
     * @param  array  $credentials
     * @return bool
     */
    public function validateCredentials(Authenticatable $user, array $credentials)
    {
        if ($user->user_name == $credentials['username']) {
            return true;
        }
        return false;
    }

}
```

## auth.php 配置

```php
<?php

return [
    'defaults' => [
        'guard' => 'api', // 这是默认 auth guard, 后续需要变更默认值
        'passwords' => 'users',
    ],

    'guards' => [

        'api' => [ // wechat api auth guard
            'driver' => 'wechat', // 下一步通过provider 注册 auth driver
            'provider' => 'users',
        ],
        'manage_api' => [ // backend api auth guard
            'driver' => 'manage',
            'provider' => 'manage_users',
        ],
    ],

    'providers' => [
        'users' => [
            'driver' => 'eloquent',
            'model' => App\Models\User::class,
        ],
        'manage_users' => [
            'driver' => 'eloquent',
            'model' => App\Models\ManageUser::class,
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table' => 'password_resets',
            'expire' => 60,
        ],
    ],

];
```

## 3. 通过`Provider`注册`auth driver`

### 3.1 微信`auth driver`

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Auth;
use App\Auth\WeChatAuthService;
use Tymon\JWTAuth\JWTGuard;

/**
 * Class WeChatAuthProvider.
 */
class WechatAuthProvider extends ServiceProvider
{
    public function register()
    {
        //
    }

    public function boot()
    {
        Auth::extend('wechat', function ($app, $name, array $config) {
            return new JWTGuard(
                $app['tymon.jwt'],
                new WeChatAuthService($app->make('App\Models\User')),
                $app['request']
            );
        });
    }
}
```

### 3.2 后台`auth driver`

```php
<?php

namespace App\Providers;

use App\Auth\ManageAuthService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\ServiceProvider;
use Tymon\JWTAuth\JWTGuard;

class ManageAuthProvider extends ServiceProvider
{
    public function register()
    {
        //
    }

    public function boot()
    {
        Auth::extend('manage', function ($app, $name, array $config) {
            return new JWTGuard(
                $app['tymon.jwt'],
                new ManageAuthService($app->make('App\Models\ManageUser')),
                $app['request']
            );
        });
    }
}
```

## 4. 创建`JWT`中间件

### 4.1 微信`JWT`中间件

```php
<?php
namespace App\Http\Middleware;

use App\Exceptions\ApiException;
use App\Services\ByPassService;
use Closure;
use Exception;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Http\Middleware\BaseMiddleware;

/**
 * Class JWTMiddleware.
 */
class JWTMiddleware extends BaseMiddleware
{
    public function handle($request, Closure $next)
    {
        // 路由白名单配置
        if ((new ByPassService)->isJWTByPass($request)) {
            return $next($request);
        }
        try {
            $this->checkForToken($request);
            // 这样用，可以在验证token 之后返回用户信息
            $user = $this->auth->parseToken()->authenticate();
        } catch (Exception $e) {
            if ($e instanceof JWTException) {
                throw new ApiException('Token验证失败', 401);
            } else {
                throw new ApiException('登陆验证失败', 401);
            }
        }
        $request->user = $user;
        return $next($request);
    }
}
```

### 4.2 后台`JWT`中间件

```php
<?php

namespace App\Http\Middleware;

use App\Exceptions\ApiException;
use Closure;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Http\Middleware\BaseMiddleware;
use Tymon\JWTAuth\JWTAuth;

class ManageJWTMiddleware extends BaseMiddleware
{

    public function handle($request, Closure $next)
    {
        Log::info('step in ------------manage jwt middleware------------');
        $path = $request->path();
        if ($path == 'manager/login') {
            return $next($request);
        }
        try {
            $this->checkForToken($request);
            // 这样用，可以在验证token 之后返回用户信息
            $user = $this->auth->parseToken()->authenticate();
        } catch (Exception $e) {
            throw $e;
            if ($e instanceof JWTException) {
                throw new ApiException('Token验证失败', 401);
            } else {
                throw new ApiException('登陆验证失败', 401);
            }
        }
        $request->user = $user;
        return $next($request);
    }
}
```

## 5. 配置中间件和加载`Provider`

创建中间件之后需要将两个中间件配置为路由中间件，将配置的`auth guard provider`注册到容器中。

### 5.1 路由中间件

```php
<?php

namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel
{
    protected $middleware = [
        ...
    ];

    protected $middlewareGroups = [
        'web' => [
            ...
        ],

        'wechat_api' => [ // wechat mini app api route middleware
            'throttle:60,1',
            'bindings',
        ],
        'manage_api' => [ // backend manager api route middleware
            'throttle:60,1',
            'bindings',
        ],
    ];

    protected $routeMiddleware = [
        ...
        'setguard' => \App\Http\Middleware\SetDefaultGuard::class,
        'jwt.wechat' => \App\Http\Middleware\JWTMiddleware::class,
        'jwt.manage' => \App\Http\Middleware\ManageJWTMiddleware::class,
    ];

    protected $middlewarePriority = [
        ...
    ];
}
```

### 5.2 加载`provider`

```php
<?php

return [

    ...

    'providers' => [
        ...
        /*
         * Package Service Providers...
         */
        // JWT-AUTH
        Tymon\JWTAuth\Providers\LaravelServiceProvider::class,
        // wechat login
        Urumuqi\Wxxcx\WxxcxServiceProvider::class,
        // wechat auth guard provider
        App\Providers\WechatAuthProvider::class, // wechat auth guard
        // manage auth guard provider
        App\Providers\ManageAuthProvider::class, // manage auth guard

        /*
         * Application Service Providers...
         */
        App\Providers\AppServiceProvider::class,
        App\Providers\AuthServiceProvider::class,
        App\Providers\EventServiceProvider::class,
        App\Providers\RouteServiceProvider::class, // wechat 路由注册
        App\Providers\ManageRouteServiceProvider::class, // backend 路由注册

    ],
    'aliases' => [
        ...
        'JWTAuth' => Tymon\JWTAuth\Facades\JWTAuth::class,
        'JWTFactory' => Tymon\JWTAuth\Facades\JWTFactory::class,
    ],
];
```

## 6. 配置路由中间件

### 6.1 微信路由

```php
<?php

namespace App\Providers;

use Illuminate\Support\Facades\Route;
use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;

class RouteServiceProvider extends ServiceProvider
{
    protected $namespace = 'App\Http\Controllers\Wechat';

    public function boot()
    {
        parent::boot();
    }

    public function map()
    {
        $this->mapUserApiRoutes();
    }

    protected function mapUserApiRoutes()
    {
        Route::middleware(['setguard:api', 'jwt.wechat']) // 设置auth guard 和 jwt.wechat 中间件
            ->namespace($this->namespace)
            ->group(base_path('routes/wechat/user.php'));
    }
}
```

### 6.2 后台路由

```php
<?php

namespace App\Providers;

use Illuminate\Support\Facades\Route;
use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;

class ManageRouteServiceProvider extends ServiceProvider
{

    protected $namespace = 'App\Http\Controllers\Manage';

    public function register()
    {
    }

    public function boot()
    {
        parent::boot();
    }

    public function map()
    {
        $this->mapUserApiRoutes();
    }

    protected function mapUserApiRoutes()
    {
        Route::prefix('manager')
            ->middleware(['setguard:manage_api', 'jwt.manage']) // 注册中间件,这里有一个非常关键的中间件 setguard
            ->namespace($this->namespace)
            ->group(base_path('routes/manage/user.php'));
    }
}
```

## 7. SetDefaultGuard

这个中间件会根据不同的api路由，加载不用的`auth guard`.

```php
<?php
/**
 * 设置默认 auth guard.
 */

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Log;

class SetDefaultGuard
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next, $guard)
    {
        Log::info('-------------step in set guard------------------' . $guard . '-------------');
        config(['auth.defaults.guard' => $guard]); // 通过切换请求生命周期里默认的auth guard 到达切换auth guard 的目的
        return $next($request);
    }
}
```

## 结束

到这里所有的关键配置都已完成，然后通过自定一的api来测试jwt即可.
