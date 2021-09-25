# 认识Activiti

## 什么是 `Activiti`

## 工作流基础

### 什么是 `BPM` ? 

### 工作流生命周期

  1. **定义**
  2. **发布**
  3. **执行**
  4. **监控**
  5. **优化**

### 什么是 `BPMN` ?

## Activiti 的特点

### 数据持久化

  - MyBatis

### 引擎 `Service` 接口

`Activiti` 引擎提供了七大 `Service` 接口，均通过 `ProcessEngine` 获取，并且支持链式 API 编程风格 

Service 接口 | 作用
--- | ---
`RepositoryService` | 流程仓库 `Service`，用于管理流程仓库，例如，部署、删除、读取流程资源
`IdentifyService` | 身份 `Service`，可以管理和查询用户、组之间的关系
`RuntimeService` | 运行时 `Service`，可以处理所有正在运行状态的流程实例、任务等
`TaskService` | 任务 `Service`，用于管理、查询任务，例如，签收、办理、指派等
`FormService` | 表单 `Service`，用于读取和流程、任务相关的表单数据
`HistoryService` | 历史 `Service`，可以查询所有历史数据，例如，流程实例、任务、活动、变量、附件等
`ManagementService` | 引擎管理 `Service`，和具体业务无关，主要是可以查询引擎配置、数据库、作业等

### 流程设计器

### 原生支持 `Spring`

### 分离运行时与历史数据

## Activiti 的应用

## Activiti 架构和组件

- Activiti Engine
- Activiti Modeler
- Activiti Designer
- Activiti Explorer
- Activiti REST
