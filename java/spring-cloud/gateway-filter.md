# spring cloud gateway filter 自定义编程

这部分的内容除了官方文档，看`spring-cloud-gateway` filter 部分的源码是一个很好的方式。

## 自定义 `Gateway Filter`

自定义 `Global Filter` 需要继承 `GlobalFilter, Ordered`。

自定义`Global Filter`代码如下：

```java
/**
 * @author wuqi
 * @desc 自定义网关过滤器，计算请求完成时间.
 * @class DurationFilter
 * @date 2020/8/3 17:34
 **/
public class DurationFilter implements GatewayFilter, Ordered {

    private static final String ELAPSED_TIME_BEGIN = "elapsedTimeBegin";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        exchange.getAttributes().put(ELAPSED_TIME_BEGIN, System.currentTimeMillis());
        return chain.filter(exchange)
                .then(
                        Mono.fromRunnable(() -> {
                            Long startTime = exchange.getAttribute(ELAPSED_TIME_BEGIN);
                            if (startTime != null) {
                                System.out.println(exchange.getRequest().getURI().getRawPath() + " : " + (System.currentTimeMillis() - startTime) + " ms");
                            }
                        })
                );
    }

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }
}
```

使用需要结合`Route`：

```java
@Bean
public RouteLocator myLocator(RouteLocatorBuilder builder) {
    return builder.routes()
            .route(r -> r.path("/hello")
                    .uri("http://localhost:8903/hello")
                    .filters(new DurationFilter())
                    .id("order-srv")
            )
            .build();
}
```

## 自定义 `Global Filter`

自定义 `Global Filter`需要继承`GlobalFilter, Ordered`。代码如下：

```java
/**
 * @author wuqi
 * @desc 自定义全局Filter.
 * @class MyGlobalFilter
 * @date 2020/8/3 18:46
 **/
@Component
public class MyGlobalFilter implements GlobalFilter, Ordered {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        System.out.println(" Step In MyGlobalFilter");
        return chain.filter(exchange);
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
```

## 自定义 `Gateway Filter Factory`

自定义的`Gateway Filter`并不能在`application.yml`配置文件中使用，需要在配置中使用需要配置`Gateway Filter Factory`。代码如下：

```java
/**
 * @author wuqi
 * @desc 自定义 Gateway Filter Factory.
 * @class MyGatewayFilterFactory
 * @date 2020/8/4 09:07
 **/
@Component
public class MyGatewayFilterFactory extends AbstractGatewayFilterFactory<MyGatewayFilterFactory.Config> {

    private static final Logger log = LoggerFactory.getLogger(MyGatewayFilterFactory.class);

    public MyGatewayFilterFactory() {
        super(Config.class);
        log.info("initialize MyGatewayFilterFactory");
    }

    @Override
    public GatewayFilter apply(Config config) {
        log.info("step in MyGatewayFilterFactory apply func");
        return (exchange, chain) -> {
            return chain.filter(exchange);
        };
    }

    public static class Config {
        private boolean enabled;

        public Config() {
            // new instance
        }

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }
    }
}
```

使用方式如下：

```xml
# spring config
spring:
  cloud:
    gateway:
      routes:
        - id: order-srv1
          uri: http://localhost:8903/hello
          predicates:
            - Path=/order/hello
          filters:
            - My=false
```
