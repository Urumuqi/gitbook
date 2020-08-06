# Java + Kotlin 部署备忘

## 项目打包

- manager-api
  
  ```bash
  # 编译打包 java + kotlin 混合项目并指定环境
  mvn clean kotlin:compile package -Dmaven.test.skip=true -Pproduct
  # 域名证书过期，导出并替换域名证书，执行命令之后，输入证书密码，将导出的`jks`证书更新到项目配置中
  keytool -importkeystore -srckeystore 4314873_hn.zsshuo.com.pfx -destkeystore hn.zsshuo.lcom.jks -srcstoretype PKCS12 -deststoretype JKS
  ```
