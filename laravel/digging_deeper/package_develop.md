- [Introduction](#introduction)
  - [A Note On Facades](#a-note-on-facades)
- [Package Discovery](#package-discovery)
  - [Opting Out Of Package Discovery](#opting-out-of-package-discovery)
- [Service Providers](#service-providers)
- [Resources](#resources)
  - [Configuration](#configuration)
  - [Routes](#routes)
  - [Migrations](#migrations)
  - [Translations](#translations)
  - [Views](#views)
- [Commands](#commands)
- [Public Assets](#public-assets)
- [Publish File Groups](#publish-file-groups)

# Introduction

包扩展是`Laravel`主要扩展功能的方式。包可以包含任何东西，比如`Carbon`处理时间，`Behat`是`BDD(Behavior-driven Development)`测试框架。

有很多类型的包。一些标准独立包，能够集成到任何的 PHP 框架中。`Carbon`和`Behat`就是两个标准独立包。这些包可以通过在`composer.json`文件中定义，并安装。

另一方面，有些包是专门为`Laravel`而存在的。这些包中，可能会包含路由，控制器，视图甚至是扩充`Laravel`应用的配置。这个手册的主要目的是引导开发基于`Laravel`的包。

## A Note On Facades

开发`Laravel`应用的时候，到底是使用`Contracts`还是`Facades`，都无所谓，他们拥有相同的可可测试性。然而，我们正在开发的包不一定能够利用`Laravel`所有的测试助手函数。如果你期待开发的包存在于一个具体的`Laravel`应用，可以使用[orchestra/testbench](https://github.com/orchestral/testbench)测试包。

# Package Discovery

## Opting Out Of Package Discovery

# Service Providers

# Resources

## Configuration

## Routes

## Migrations

## Translations

## Views

# Commands

# Public Assets

# Publish File Groups
