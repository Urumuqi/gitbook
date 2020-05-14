# docker-compose run elasticsearch cluster

## docker-compose file

es编排的[docker-compose.yml](docker-compose.yml)

执行一下命令启动服务:

```bash
docker-compose up -d
```

## Troubles

### max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

#### 思路

  第一次遇到这个问题时，一直以为时 `docker` 配置的内存不足，执行 `docker info` 输出如下， 已经为 `docker` 配置了全部的物理内存可用

```bash
┌─[root@sf-dev] - [~] - [Thu May 14, 12:04]
└─[$] <> docker info
Client:
 Debug Mode: false

Server:
 Containers: 5
  Running: 5
  Paused: 0
  Stopped: 0
 Images: 5
 Server Version: 19.03.6
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version:
 runc version:
 init version:
 Security Options:
  apparmor
  seccomp
   Profile: default
 Kernel Version: 4.15.0-97-generic
 Operating System: Ubuntu 18.04.4 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 11.65GiB
 Name: sf-dev
 ID: UUEP:KIJA:33V2:57D4:2N3K:ZI4U:OXXZ:WSPG:VZSE:TI2O:F3LX:T42E
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Username: wuqi226
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

WARNING: No swap limit support
```

这里排除了 `docker` 启动配置的内存限制，觉得可能时宿主机的问题， 一番Google之后，确定是宿主机内存限制问题，解决方案如下。

#### 解决方案

- 临时生效

```bash
# 重启之后失效
sysctl -w vm.max_map_count=262144
```

- 永久生效

```bash
# 重启之后有效
# /etc/sysctl.conf 文件配置中 追加一行 vm.max_map_count=262144
echo "vm.max_map_count=262144" > /etc/sysctl.conf
sysctl -p
```
