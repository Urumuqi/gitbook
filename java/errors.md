# Java 程序常见错误和异常

## 编译&执行

### 1. `Error: Could not find or load main class XXXXXX`

- 问题

为什么会遇到这个错误呢？首要要从脱离IDE开始，以往的Java项目中，都是IDE创建项目集成工具完成编译、打包、执行。以前手动执行`class`文件也遇到过这样的错误，当时没在意。在实验普林斯顿大学大算法包`algs4.jar`的过程中，自己手动导入依赖包，很简单的代码，然后出现这个错误。步骤如下：

```java
// 注意，这里没有package
import edu.princeton.cs.algs4.Knuth;

public class RandomWord {
    public static void main(String[] args) {
        Knuth.shuffle(args);
        for (String s : args) {
            System.out.println(s);
        }
    }
}
```

```bash
javac -cp /Users/wuqi/Code/java-proj/AlgsP1/algs4.jar RandomWord.java
# 执行成功，生成`.class`文件

java -cp /Users/wuqi/Code/java-proj/AlgsP1/algs4.jar RandomWord a b c d
# Error: Could not find or load main class RandomWord
```

- 思路

问题的关键点在于`classpath`，`Java`启动程序是会在`classpath`下去加载类，当前的目录不在`classpath`范围中，所以`Java`虚拟机启动是加载不到`RandomWord`这个类，导致启动失败。解决办法就是把当前目录加入到`classpath`中，通过命令参数的方式：

```bash
# . 把当前目录加入到classpath
$ java -cp /Users/wuqi/Code/java-proj/AlgsP1/algs4.jar:. RandomWord aasdf asdf 23f
$ asdf
  aasdf
  23f
```

为了验证自己对`classpath`充分理解，在代码中加上`package`:

```java
// 这里加了 package test,执行命令编译后会在当前目录下生成test目录
package test;

import edu.princeton.cs.algs4.Knuth;

public class RandomWord {
    public static void main(String[] args) {
        Knuth.shuffle(args);
        for (String s : args) {
            System.out.println(s);
        }
    }
}
```

- 复现、验证

```bash
# 带包名访问
java -cp /Users/wuqi/Code/java-proj/AlgsP1/algs4.jar:. test.RandomWord asdfa adfa adf
# 执行成功

# 不带包名访问
java -cp /Users/wuqi/Code/java-proj/AlgsP1/algs4.jar:. RandomWord asdfa adfa adf
# Error: Could not find or load main class RandomWord
```

- 总结

  在执行代码编译和编译结果执行时，通过`classpath`配置确保需要加载的类库都在`classpath`目录范围内。
