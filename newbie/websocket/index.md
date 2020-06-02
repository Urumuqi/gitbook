# STOMP Flow of Messages

当 `STOMP` 访问接入点配置完成, Spring 应用就作为 `STOMP` 到客户端之间的代理。这个章节展示了 `message` 在应用的处理流程的整体情况。

`spring-messaging` 模块提供了应用处理异步消息的基础。这个模块中包含了几个 [`Spring Integration`](https://spring.io/spring-integration)项目的抽象组件，旨在为消息应用提供一下几个 `block`:

- [Message](https://docs.spring.io/spring-framework/docs/5.0.0.BUILD-SNAPSHOT/javadoc-api/org/springframework/messaging/Message.html) - 包含 request header 和 request payload
- [MessageHandler](https://docs.spring.io/spring-framework/docs/5.0.0.BUILD-SNAPSHOT/javadoc-api/org/springframework/messaging/MessageHandler.html) - 定义了消息的标准处理操作
- [MessageChannel](https://docs.spring.io/spring-framework/docs/5.0.0.BUILD-SNAPSHOT/javadoc-api/org/springframework/messaging/MessageChannel.html) - 在消息发送者和接收者之间低耦合的消息发送定义
- [SubscribableChannel](https://docs.spring.io/spring-framework/docs/5.0.0.BUILD-SNAPSHOT/javadoc-api/org/springframework/messaging/SubscribableChannel.html) - 继承自 `MessageChannel`, 将消息传递给注册的 `MessageHandler` 消息订阅者
- [ExecutorSubscribableChannel](https://docs.spring.io/spring-framework/docs/5.0.0.BUILD-SNAPSHOT/javadoc-api/org/springframework/messaging/support/ExecutorSubscribableChannel.html) - `SubscribleChannel` 的一个具体实现类，通过连接池异步传递消息

`@EnableWebSocketMessageBroker` 注解和 `<websocket:message-broker>` xml 配置文件组装除了一个消息的流转过程。下图展示一个使用简单的内存代理的流程示例：

  ![img1](img/../../../img/websocket/message-flow-simple-broker.png)

上图的流程中包含了3类 `channel`:

- `clientInboundChannel` 处理来自 ws 客户端的消息
- `clientOutboundChannle` 处理发送到 ws 客户端的消息
- `brokerChannel` 用来将应用中的消息发送到 `broker`

这三个 `channel` 同样可以用于其他专用的 `broker`，下图中用 `StompBrokerRelay` 取代了 `SimpleBroker`:

  ![img2](img/../../../img/websocket/message-flow-broker-relay.png)

`clientInboundChannel` 中的消息可以流向应用的注解方法，或者可以转发到 `broker`。`STOMP` 的消息目的地使用简单的前缀路由。比如 `/app` 前缀会将消息路由到注解方法，而 `/topic` 和 `/queue` 前缀会讲消息路由到 `broker`。

如果有消息处理注解的函数有返回值类型，返回值会作为 `Message` 的 `payload` 部分，并将消息传递到 `brokerChannel`。`broker` 会按顺序将消息通知到客户端。在应用任何地方需要将消息发送到目的地，都可以使用消息发送模版 `messaging template`。比如，一个 `HTTP POST` 方法可以将消息通知到所有已链接的客户端，一个服务可以规律的广播通知股票报价。

下面一个简单的示例说明消息处理流程:

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/portfolio");
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		registry.setApplicationDestinationPrefixes("/app");
		registry.enableSimpleBroker("/topic");
	}

}

@Controller
public class GreetingController {

	@MessageMapping("/greeting") {
	public String handle(String greeting) {
		return "[" + getTimestamp() + ": " + greeting;
	}

}
```

接下来说明示例的消息处理流程：

- ws 客户端链接到 ws 接入点 `/portfolio`
- `/topic/greeting` 路由进来的订阅通过 `clientInboundChannel` 被转发到 `broker`
- 发送到 `/app/greeting` 的请求通过 `clientInboundChannel` 被转发到 `GreetingController`。控制器添加时间戳信息之后，返回的消息内容通过 `brokerChannel` 被发送给 `/topic/greeting`(目的地也可以通过`@SendTo`来重写)
- `broker` 按顺序将消息通知到订阅者，都是通过`clientOutboundChanneld`发送

**PS**: translate from [docs.spring.io:websocket](https://docs.spring.io/spring/docs/5.0.0.BUILD-SNAPSHOT/spring-framework-reference/html/websocket.html)
