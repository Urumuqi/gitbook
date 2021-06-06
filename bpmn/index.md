# BPMN 入门

## 基础概念

### 基础理念

#### BPMN 2.0

#### DDD

### 实现自动化流程

- 业务流程图要规范化，遵守一套规范
- 流程图本质是xml配置文件
- 读取业务流程的过程就是解析xml的过程
- 读取一个业务流程节点就相当于解析一个xml节点，进一步将数据插入到mysql表中，形成一条MySQL记录
- 将所有的节点读取并存入mysql表中
- 读取一行mysql记录，相当于读取一个节点
- 业务流程推进，转化为读取表中的一条记录，并且处理数据，结束后删除数据

### Activiti整合流程

- 整合Activiti
- 实现业务流程建模，使用BPMN实现业务流程图
- 部署业务流程到Activiti
- 启动流程实例
- 查询代办任务
- 处理代办任务
- 循环执行以上两步，直到结束流程

### 环境准备

- Activiti 7.0
- JDK 1.8
- Spring5

### 入门总结

- 什么是工作流？
- 工作流，工作流系统，BPM，BPMN
- 定义流程
- 流程设计器（BPM Modeler）
- 整合Activiti 流程引擎，测试安装成功（25张表创建成功）
- 为什么使用 Activiti 可以实现业务代码不变更，实现流程更新
- Activiti 支持哪些数据库
- 创建Activiti配置，启动Activiti 生成25张表
- 写Java代码创建 ProcessEngineConfiguration, ProcessEngine 类

## Activiti 数据表

### 数据表命名规则

- act_re_* : `re` 表示 `repository`，这个前缀的表包含了流程定义和流程静态资源(图片、规则等)
- act_ru_* : `ru` 表示 `runtime`，这是运行时的表，包含流程实例、任务、变量、异步任务等运行中的数据。Activiti只会在流程实例执行中保存这些数据，在流程结束时就会删除这些记录。这样运行时表一直很小且数据很快
- act_hi_* : `hi` 表示 `history`，这些表包含历史数据，比如历史流程实例、变量、任务等
- act_ge_* : `ge` 表示 `general`，通用数据，用于不同的场景下