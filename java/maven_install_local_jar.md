# maven install jar package to local repository

## command

```bash
mvn install:install-file -Dfile=./cat-client-3.0.0.jar -DgroupId=com.dianping.cat -DartifactId=cat-client -Dversion=3.0.0 -Dpackaging=jar
```

## 小插曲

生产环境安装cat监控后，本地`mac os: big sur`调试代码，由于无法在本地创建目录`/data/applogs/cat`目录（可以的，太折腾了），本地注释cat代码也很麻烦。然后想到去看`cat-client`源码，找到了定义的路径常量`CAT_HOME`，以及相关的和`/data/applogs/cat`目录配置有关的定义，改了本地用户路径，重新编译`cat-client`安装到本地maven仓库，问题解决。
