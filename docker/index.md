# local service with docker

## RabbitMQ

```bash
docker run --rm -d --hostname local-rabbitmq --name rabbitmq -p 5672:5672 -p 5673:5673 -p 15672:15672 rabbitmq:3-management
```
