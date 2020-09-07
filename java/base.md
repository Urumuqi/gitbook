# Java 语言基础

## 基础语法

### 数据类型

- 基本数据类型
  - 数值类型
    - 整数类型：byte, short, int, long
    - 浮点类型：float, double
  - 字符类型：char
  - 布尔类型：boolean
- 引用类型
  - 类 class
  - 接口 interface
  - 数据 []

#### Java基本数据类型宽度

![java基本数据类型](img/java_base_type.png)

#### 典型问题

- 用最高效的方法计算 2 * 8

  2 << 3 (左移3位相当于乘以2的3次方，右移3位相当于除以2的3次方)

- Math.round(11.5)等于多少？Math.round(-11.5)等于多少？

  Math.round(11.5) = 12 , Math.round(-11.5) = -11. 四舍五入的原理是在参数上 +0.5 然后向下取整

- float f = 3.4 是否正确？
  
  不正确。3.4 是双精度数，将双精度(double)赋值给浮点数(float)属于下转型(down-casting)会造成精度损失，因此需要强制类型转换 float f = (float) 3.4 或者 float f = 3.4F

- short s = 1; s = s + 1; 有错吗？ short s = 1; s += 1; 有错吗？
  
  short s = 1; s = s + 1;由于 1 是 int 型， 因此运算 s + 1 也是 int 型，需要强制类型转换才能将 int 赋值给 short
  short s = 1; s += 1;可以正确编译，s += 1 相当于 s = (short)(s + 1),隐含了强制类型转换

#### 关键字

- final 作用
  
  用于修饰类、属性和方法

  - 被final修饰的类不可以被继承
  - 被final修饰的方法不可以被重写
  - 被final修饰的变量不可以被改变，被final修饰不可变的是变量的引用，而不是引用指向的内容，引用指向的内容是可以改变的

- final, finally, finalize 区别

  - final可以修饰类、变量、方法，修饰类表示类不能被继承、修饰方法表示该方法不能被重写、修饰变量表示该变量是一个常量不能被重新赋值
  - finally一般作用在try-catch代码块，在处理异常时，通常将一定要执行的代码块放到finally代码块中，表示不管是否出现异常，该代码都会执行，一般用来放一些关闭资源的代码
  - finalize是一个方法，属于Object类的一个方法，而Object类是所有类的父类，该方法一般由垃圾回收器来调用，当我们调用 System.gc() 方法时，由垃圾回收器调用 finalize()，回收垃圾，一个对象是否可以回收的最后判断

- this 关键字的用法
  
  this 是自身的一个对象，代表对象本身，可以理解为：指向对象本身的一个指针。this用法在 java 中大体分为3种：
  1. 普通的直接引用，this相当于当前对象本身
  2. 形参与成员变量重名，用this来区分

    ```java
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    ```

  3. 引用本类的构造函数

    ```java
    class Person{
        private String name;
        private int age;
        public Person() {
        }
        public Person(String name) {
            this.name = name;
        }
        public Person(String name, int age) {
            this(name);
            this.age = age;
        }
    }
    ```

- super 关键字用法
  
  super可以理解为指向自己父类对象的一个指针，而且这个父类是离自己最近的一个父类, super 三种用法:

  1. 普通的直接引用，与this类似，super相当于指向当前对象的父类的引用，这样就可以用 super.xxx来引用父类的成员
  2. 子类的成员变量或者方法与父类中的成员变量或方法同名时，用super来区分
  3. 引用父类构造函数；super(...params)应该为构造函数的第一语句；this(...params)同理也应该为构造函数的第一条语句

- static 关键字
