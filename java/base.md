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

- this 和 super 的区别

  - super 引用当前对象的直接父类
  - this 引用当前对象
  - super() 在子类中调用父类的构造方法， this() 在当前类调用当前类的构造方法
  - super() 和 this()  都需要放在构造方法内第一行
  - 可以用this调用一个构造器，却不能调用两个
  - this() 和 super() 不能同时出现在一个构造函数里，因为 this() 必然会调用其他构造函数，其他的构造函数必然也会有 super() 语句存在，所以在同一个构造函数里有相同的语句，编译器不会通过
  - this() 和 super() 都是指的对象， 所以，都不能在 static 环境中使用。包括：static变量、static方法、static 语句块
  - 从本质上讲，this 是一个指向本对象的指针， 然而 super 是一个 Java 关键字

- static 关键字
  
  static 的主要意义在于创建独立于具体对象的域变量或者方法。以致于及时没有创建对象，也能使用属性和调用方法；static 还有一个比较关键的作用是 **用来形成静态代码块以优化程序性能**。 static 块可以置于类中的任何地方，类可以有多个 static 块。在类初次被加载的时候，会按照 static 块的顺序来执行每个 static 块，并且只会执行一次。由于 static 块的这种特性，所以说 static 块能够优化程序性能。因此在很时候会将一些只需要进行一次的初始化操作放到 static 代码块中进行。

- staic 独特之处
  
  1. 被 static 修饰的变量或者方法独立于该类的任何对象。也就是说这些变量和方法 **不属于任何一个实例对象，而是被类的实例所共享**
  2. 在该类被第一次加载的时候，就会去加载被 static 修饰的部分，而且只会在类第一次使用时加载并进行初始化。注意这只是在第一次使用时初始化，后面根据需要是可以再次赋值的。
  3. static 变量挂在类加载的时候分配空间，以后在创建类的对象时不会重新分配。可以任意赋值
  4. 被static 修饰的变量或者方法优先于对象存在，也就是说在类被加载完毕之后，及时没有创建对象也可以访问

- static 应用场景

  static 注意事项：静态只能访问静态；非静态可以访问非静态和静态

  1. 修饰成员变量
  2. 修饰成员方法
  3. 静态代码块
  4. 修饰类（修饰类的内部内，也就是静态内部类）
  5. 静态导包 ？

## 面向对象

**封装、继承、多态**

- 封装：隐藏对象的属性和实现细节，今对外提供公共的访问方式，将变化隔离，便于使用，提高复用性和安全性
- 继承：在已存在的类定义的基础上建立新类的技术，新类可以增加新的数据或者新的功能，也可以使用父类的功能，但不能选择性的继承父类。可以通过继承提高代码的复用性。继承是多态的前提
- 多态：父类或者接口定义的引用变量可以指向子类或者具体实现类的实例对象。提高了程序的扩展性

  在 Java中有两种形式可以实现多态：继承（多个子类对同一方法的重写）和接口（实现接口并覆盖接口中的同一方法）。方法重载(overload)实现的是编译时的多态性（也称为前绑定）；方法重写(override)实现的是运行时的多态性（也称为后绑定）。

  一个引用变量到底会指向哪个类的实例对象，该引用变量发出的方法调用到底是哪个类中实现的方法，必须在由程序运行期间才能决定。运行时的多态是面向对象最精髓的东西，要实现多态需要做两件事：

    - 方法重写（子类继承父类并重写父类中已有的或抽象的方法）
    - 对象造型（用父类型引用子类行对象，这样同样的引用调用同样的方法就会根据子类对象的不同而表现出不同的行为）

### 什么是多态机制？Java语言是如何实现多态的？

  所谓多态是指程序中定义的引用比变量所指向的具体类型和通过该引用变量发出的方法调用在编程时并不确定，而是在程序运行期间才确定。即一个引用变量到底指向哪个类的实例对象，该引用变量发出的方法调用到底是哪个类中实现的方法，必须在程序运行期间才能决定。因此在程序运行时才能确定具体的类，这样不用修改程序源代码，就可以让引用变量绑定到各种不同的类实现上，从而导致该引用调用的具体方法随之改变。即不修改程序代码就可以改变程序运行时所绑定的具体代码，让程序可以选择多个运行状态，这就是 **多态**
  
  **多态**分为 **运行时多态** 和 **编译时多态**。编译时多态是静态的，主要指方法重载，它是根据参数列表不同来区别不同的函数，通过编译之后成为不同的函数，在运行时算不上多态；运行时多态是动态的，它是通过动态绑定来实现的，也就是我们常说的多态

#### 多态的实现

  Java 实现多态有三个必要条件：继承、重写、向上转型
  
  - 继承： 多态中必须存在有继承关系的子类和父类
  - 重写：子类对父类的某些方法进行重新定义，在调用这些方法是会调用子类方法
  - 向上转型：在多态中需要将子类的引用赋给父类对象，只有这样该引用才能够具备能力调用父类和子类的方法
  
  在Java语言中，实现多态遵循一个原则：当超类对象引用变量引用子类对象时，被引用对象的类型决定了调用谁的成员方法，而不是由引用变量的类型来决定。但是这个被调用的方法必须在超类中定义过，也就是被子类覆盖的方法

#### 面向对象的五大基本原则

- 单一职责原则（single responsibility principle）: 类的功能单一
- 开闭原则（open-close principle）: 对扩展开放，对修改封闭
- 里氏替换原则（the Liskov substitution principle）: 子类可以替换父类出现在父类能够出现的地方
- 依赖倒置原则（the dependency inversion princple）: 具体实现依赖与抽象，而抽象不能依赖于具体实现；高层次模块和低层次模块都应该依赖于抽象
- 接口分离原则(the interface segregation princple) : 设计时多采用与特定的客户类相关的接口比采用一个通用的接口好

### 类和接口

#### 抽象类和接口对比

  抽象类是用于捕捉子类的通用特性；接口是抽象方法的集合。从设计层面来讲，抽象类是对类的抽象，是一种模版设计；接口是行为抽象，是一种行为规范

- 相同点
  
  - 接口和抽象类都不能实例化
  - 都位于继承的顶端，用于被实现或继承
  - 都包含抽方法，其子类都必须覆写这些抽象方法

- 不同点

参数 | 抽象类 | 接口
----- | ----- | -----
声明 | 抽象类使用abstract关键字声明 | 接口使用interface关键字声明
实现 | 子类使用extends关键字来继承抽象类。如果子类不是抽象类的话，它需要提供抽象类中所有声明的方法的实现 | 子类使用implements关键字来实现接口。它需要提供接口中所有声明的方法的实现
构造器 | 抽象类可以有构造器 | 接口不能有构造器
访问修饰符 | 抽象类中的方法可以是任意访问修饰符 | 接口方法默认修饰符是public。并且不允许定义为 private 或者 protected
多继承 | 一个类最多只能继承一个抽象类 | 一个类可以实现多个接口
字段声明 | 抽象类的字段声明可以是任意的 | 接口的字段默认都是 static 和 final 的

**备注**: Java8 中接口中引入了默认方法和静态方法，以减少抽象类和接口之间的差异。在Java8中可以为接口提供默认实现的方法，而不用强制子类来实现它。

接口和抽象类各有取舍，在接口和抽象类的选择上，必须遵守这样一个原则：

- 行为模型应该总是通过接口来定义，优先选用接口，尽量少用抽象类
- 需要定义子类的行为，又要为子类提供通用的功能时，优先选择抽象类

#### 抽象类和普通类

- 普通类不能包含抽象方法，抽象类可以包含抽象方法
- 抽象类不能实例化，普通类可以直接实例化
- 抽象类不能用 final 修饰。抽象类就是让其他类继承的，与 final 约束矛盾
  
#### 对象实例和对象引用

- new 关键字创建对象实例，对象实例在堆内存中；对象引用指向对象实例，对象引用在栈内存中
- 一个对象引用可以指向0个或者1个对象；一个对象可以有n个引用指向它

#### 变量与方法

- 成员变量与局部变量

  - 成员变量针对整个类有效；局部变量一般在方法和语句块有效
  - 成员变量随对象创建而存在，对象销毁而小时，存储在 **堆内存**；局部变量在方法被调用或者语句被执行是存在，方法调用完成和语句执行完成就自动释放，存储在 **栈内存**
  - 在使用变量是遵循 **就近原则**，首先在局部范围找，然后在成员范围找

- Java中定义一个不做事且没有参数的构造方法的作用
  
  Java 程序在执行子类的构造方法之前，如果没有用 super() 来调用父类的特定构造方法，则会调用父类 **没有参数的构造函数方法**。因此，如果父类只定义了有参数的构造方法，而在子类的构造方法中又没有用 super() 来调用父类中特定的构造方法，则编译时将发生错误，因为Java程序在父类中找不到没有参数的构造方法可执行。解决办法是在父类加一个不做事且没有参数的构造函数

  在调用子类构造方法之前会调用父类没有参数的构造方法，其目的是帮助子类做初始化

  构造方法的主要作用是完成类对象的初始化工作；即使一个类没有声明构造方法，也可以实例化，因为会有默认的不带参数的构造方法

  构造方法与类名相同；没有返回值，但不能用void声明构造函数；生成类的对象时自动执行，无需调用

- 静态变量、实例变量

  - **静态变量**: 不属于任何对象，只属于类，在内存中只有一份，在类的加载过程中，JVM只为静态变量分配一次内存空间
  - **实例变量**: 每次创建对象，都会为每个对象分配成员变量内存空间，实例变量属于实例对象。在内存中创建几次对象就会有几份实例变量

- 静态方法、实例方法

  - 在外部调用静态方法，可以使用 **类名.方法名** 或者 **对象名.方法名**；而实例方法只能通过后者
  - 静态方法在访问本类的成员时，只允许访问静态成员（静态成员变量和静态方法），而不允许访问实例成员变量和实例方法；实例方法则无此限制

#### 内部类

Java中可以讲一个类定义在另外一个类的内部，就是 **内部类**。内部类本身就是类的一个属性，与其他属性定义方式一致

内部类分为四种：成员内部类、局部内部类、匿名内部类、静态内部类

- 静态内部类
  
  ```java
    public class Outer {

        private static int radius = 1;

        static class StaticInner {
            public void visit() {
                System.out.println("visit outer static  variable:" + radius);
            }
        }
    }
  ```

  静态内部类可以访问外部类所有的静态变量，而不可以访问外部类的非静态变量；静态内部类的创建方式：`new OuterClass.InnerClass()`

- 成员内部类
  
  ```java
    public class Outer {

        private static  int radius = 1;
        private int count =2;
        
        class Inner {
            public void visit() {
                System.out.println("visit outer static  variable:" + radius);
                System.out.println("visit outer   variable:" + count);
            }
        }
    }
  ```

  成员内部类可以访问外部类的所有变量和方法，包括静态和非静态，私有和公有；成员内部类依赖于外部类的实例，创建方式： `OuterClassObj.new InnerClass()`

  ```java
    Outer outer = new Outer();
    Outer.Inner inner = outer.new Inner();
    inner.visit();
  ```

- 局部内部类
  
  定义在方法中的内部类

  ```java
    public class Outer {

        private  int out_a = 1;
        private static int STATIC_b = 2;

        public void testFunctionClass(){
            int inner_c =3;
            class Inner {
                private void fun(){
                    System.out.println(out_a);
                    System.out.println(STATIC_b);
                    System.out.println(inner_c);
                }
            }
            Inner  inner = new Inner();
            inner.fun();
        }
        public static void testStaticFunctionClass(){
            int d =3;
            class Inner {
                private void fun(){
                    // System.out.println(out_a); 编译错误，定义在静态方法中的局部类不可以访问外部类的实例变量
                    System.out.println(STATIC_b);
                    System.out.println(d);
                }
            }
            Inner  inner = new Inner();
            inner.fun();
        }
    }
  ```

  定义在实例方法重的局部类可以访问外部类的所有变量和方法，定义在静态方法重的局部类只能访问外部类的静态变量和方法。局部内部类对象创建：`new InnerClass()`

  ```java
    public static void testStaticFuncClass() {
        class Inner {
        }
        Inner inner = new Inner();
    }
  ```

- 匿名内部类

  匿名内部类就是没有名字的内部类，日常开发中经常使用

  ```java
    public class Outer {
        private void test(final int i) {
            new Service() {
                public void method() {
                    for (int j = 0; j < i; j ++) {
                        System.out.println("匿名内部类");
                    }
                }
            }.method();
        }
    }

    // 匿名内部类必须继承或者实现一个已有的接口
    interface Service {
        void method();
    }
  ```

  除了没有名字，匿名类还有一下特点：

  - 匿名内部类必须继承一个抽象类或者实现一个接口
  - 匿名内部类不能定义任何静态成员和静态方法
  - 当所在的方法的形参需要被匿名内部类使用时，必须声明为 `final`
  - 匿名内部类不能是抽象的，它必须实现继承的类或者实现的接口的所有抽象方法

  匿名内部类创建方式

  ```java
    new class/interface {
        // 匿名内部类实现部分
    }
  ```

- 内部类的优点
  
  - 一个内部类对象可以访问创建它的外部类的对象的内容，包括私有数据
  - 内部类不为同一包的其他类可见，具有很好的封装性
  - 内部类有效实现了 “多重继承”，优化Java单继承缺陷
  - 匿名内部类可以方便的定义回调

- 内部类的应用场景
  
  - 一些多算法场合
  - 解决一些非面向对象的语句块
  - 适当使用内部类，是代码更加灵活和富有扩扩展性
  - 当某个类除了它的外部类，不再被其他类使用时

- 局部内部类和匿名内部类访问局部变量时，为什么变量必须加上 `final` ?
  
  ```java
    public class Outer {
        void outMethod () {
            final int a = 10;
            class Inner {
                void innerMethod() {
                    System.out.println(a);
                }
            }
        }
    }
  ```

  **生命周期不一致**，局部变量直接存储在栈中，当方法执行结束，非 final 的局部变量就被销毁。而局部内部类对局部变量的引用依然存在，如果局部内部类要调用局部变量时，就会出错。加上 final，就可以确保局部内部类使用的变量和外层的局部变量分开。

### 重写、重载

- 构造器不能被继承，因此不能被重写，但可以被重载
- 方法的重载和重写都是实现多态的方式，区别在于前者实现的是编译时的多态，后者实现的是运行时的多态
- **重载**： 发生在同一个类中，方法名相同，参数列表不同（参数类型不同，个数不同，顺序不同），与方法返回值和访问修饰符无关，即重载的方法不能根据返回类型进行区分
- **重写**：发生在父类的子类中，方法名、参数列表必须相同，返回值小于等于父类，抛出的异常小于等于父类，访问的修饰符大于等于父类（里氏替换原则）；如果父类的方法修饰符是 `private` 则子类中不能重写

### 对象相等

#### `==` 和 equals 的区别

- `==`: 作用是判断两个对象的地址是否相等。即，判断两个对象是否是同一个对象；基本数据类型比较的是 **值**，引用数据类型比较的是 **内存地址**
- equals(): 也是判断两个对象是否相等，有两种情况

  - 类没有覆盖 equals() 方法。则通过 equals() 比较该类的两个对象时，等价于 `==` 比较两个对象
  - 类覆盖了 equals*()。一般我们都通过覆盖 equals() 方法来判断内容相等，若他们内容相等则返回 true

  ```java
  public class test1 {
      public static void main(String[] args) {
          String a = new String("ab"); // a 为一个引用
          String b = new String("ab"); // b为另一个引用,对象的内容一样
          String aa = "ab"; // 放在常量池中
          String bb = "ab"; // 从常量池中查找
          if (aa == bb) // true
              System.out.println("aa==bb");
          if (a == b) // false，非同一对象
              System.out.println("a==b");
          if (a.equals(b)) // true
              System.out.println("aEQb");
          if (42 == 42.0) { // true
              System.out.println("true");
          }
      }
  }
  ```
  
  说明：
    - String 中的 equals() 方法是被重写过的，因为 Object 的 equals() 方法比较的对象的内存地址，而 String 的 equals() 方法比较的是对象的值
    - 当创建 String 类型的对象是，虚拟机会在常量池中查找有没有已经存在的值和要创建的值相同的对象，如果有就把它赋值给当前引用，如果没有就在常量池中创建一个 String 对象

#### hashCode 与 equals

hashCode() 作用是获取哈希码，也称为散列码。它实际上是返回一个 int 整数。这个哈希码的作用是确定该对象在哈希表中的索引位置。hashCode() 定义在 JDK 的 Object.java 中，这意味着 Java 中的任何类都包含有 hashCode() 函数

散列表存储的是键值对(key->value)，它的特点是，能根据 “键” 快速的检索出对应的 “值”。这其中就利用到了 **散列码**

- 为什么要有 hashCode
  
  当把对象加入 HashSet 时，HashSet 会先计算对象的 hashCode 值来判断对象的加入位置，同时也会与其他已经加入的对象 hashCode 值作比较，如果没有相符的 hashCode, HashSet 会假设对象没有重复出现。但是如果发现有相同的 hashCode 值，这时会调用 equals() 方法来检查 hashCode 相等的对象是否相同。如果两者相同，HashSet 就不会让其加入成功。如果不同，就会重新散列到其他位置。这样就大大减少了 equals 次数，相应就大大提供了执行速度

- hashCode() 与 equals() 的相关规定
  
  - 如果两个对象相等，则 hashCode 一定也是相同的
  - 两个对象相等，对两个对象分别调用 equals() 方法都返回 true
  - 两个对象有相同的 hashCode 值，它们不一定相等

  因此， equals() 方法被覆盖过， 则 hashCode() 方法也必须被覆盖；hashCode() 的默认行为是对堆上的对象产生独特值，如果没有重写 hashCode()，则该 class 的两个对象无论如何都不会相等（即使两个对象指向相同的数据）

- 对象的相等 和 指向它们的引用相等，两者有什么不同？
  
  对象的相等，比较的是内存中存放的内容是否相等；引用相等比较的是它们指向的内存地址是否相等

### 值传递

当一个对象被当作参数传递到一个方法后，此方法可改变这个对象的属性，并可返回改变后的结果，那么到底是值传递还是引用传递呢？

Java 语言的方法调用，只支持参数的值传递。当一个对象实例被传递到方法中时，参数的值就是对该对象的引用。对象的属性可以在被调用的过程中被改变，但对对象引用的改变是不会影响到调用者的。

#### 为什么Java中只有值传递

这里回顾一下有关参数传递的专业术语。按值调用(Call by Value)表示方法接收的是调用者提供的值；而按引用调用(Call by Reference)表示方法接收的是调用者提供的变量地址。一个方法可以修改传递引用所对应的变量值，而不能修改传递值调用所对应的变量值。

Java程序设计语言总是采用按值调用。也就是说方法得到的是所有参数值的一个拷贝，也就是说方法不能修改任何传递给它的参数变量的内容。

#### 3个例子说明值传递

- example 1

  ```java
  public static void main(String[] args) {
      int num1 = 10;
      int num2 = 20;
  
      swap(num1, num2);
  
      System.out.println("num1 = " + num1);
      System.out.println("num2 = " + num2);
  }
  
  public static void swap(int a, int b) {
      int temp = a;
      a = b;
      b = temp;
  
      System.out.println("a = " + a);
      System.out.println("b = " + b);
  }
  ```

  结果，交换的是 `num1` 和 `num2`的拷贝，这两个变量本身并没有交换。

  ```bash
  a = 20
  b = 10
  num1 = 10
  num2 = 20
  ```

- example 2

  ```java
  public static void main(String[] args) {
      int[] arr = { 1, 2, 3, 4, 5 };
      System.out.println(arr[0]);
      change(arr);
      System.out.println(arr[0]);
  }

  public static void change(int[] array) {
      // 将数组的第一个元素变为0
      array[0] = 0;
  }
  ```

  结果，`array` 是 `arr` 的一个拷贝，它们都是指向同一个数据对象，所以方法中对引用对象的改变反应到了对象上。

  ```bash
  1
  0
  ```

  很多程序设计语言（特别是 C++）提供了两种参数传递的方式：值传递和引用传递。有些程序员认为Java程序设计语言对对象采用的是引用传递，实际上，这种理解是不对的。通过下面一个例子详细说明。

- example 3
  
  ```java
  public class Test {
      public static void main(String[] args) {
          // TODO Auto-generated method stub
          Student s1 = new Student("小张");
          Student s2 = new Student("小李");
          Test.swap(s1, s2);
          System.out.println("s1:" + s1.getName());
          System.out.println("s2:" + s2.getName());
      }

      public static void swap(Student x, Student y) {
          Student temp = x;
          x = y;
          y = temp;
          System.out.println("x:" + x.getName());
          System.out.println("y:" + y.getName());
      }
  }
  ```

  结果，`x` 是 `s1`的拷贝，`y` 是 `s2` 的拷贝，它们都是指向对象的引用，方法交换的是两个拷贝，对原来的引用变量没有影响。

  ```bash
  x:小李
  y:小张
  s1:小张
  s2:小李
  ```

- 总结
  
  Java程序设计语言对对象采用的不是引用调用，实际上，对象引用是按值传递的。

  - 一个方法不能修改基本数据类型的参数
  - 一个方法能够改变一个对象参数的状态
  - 一个方法不能让对象参数引用一个新对象

- 值传递和引用传递的区别
  
  - 值传递： 指在方法调用时，传递的参数是按值的拷贝传递，传递的是值的拷贝。传递后就互不相关
  - 引用传递：值在方法调用时，传递的参数是按引用进行传递，其实传递的是引用地址，也就是变量所对应的内存空间地址。传递的是值的引用，也就是传递前后都是指向同一个引用（同一个内存空间）

## Java包

### JDK 中常用的包

- java.lang 系统的基础类
- java.io 所有输入输出有关的类，比如文件操作
- java.nio 为了晚上IO包中的功能，提高IO包中性能而写的一个新包
- java.net 与网络相关的类
- java.util 这是系统辅助类，特别是集合类
- java.sql 数据库操作的类

### import java 和 javax 区别

刚开始的时候 JavaAPI 所必需的包是 java 开头的包，javax 当时只是扩展 API 包来说使用。然而随着时间的推移，javax 逐渐的扩展成为 Java API 的组成部分。但是，将扩展从 javax 包移动到 java 包将太麻烦了，最终会破坏一堆现有的代码。因此，最终决定 javax 包将成为标准API的一部分。

所以，实际上java和javax没有区别。这都是一个名字。

### IO流

- Java中流分为一下几种
  
  - 按照流的流向，分为输入流和输出流
  - 按照操作单元，分为字节流和字符流
  - 按流的角色，分为节点流和字符流

Java IO流共涉及到40多个类，这些类看上去很杂乱，但实际上很有规则，而且彼此之间存在非常紧密的联系，Java IO流中的40多个类都是从如下4个抽象基类中派生出来的

- InputStream/Reader 所有的输入流基类，前者是字节输入流，后者是字符输入流
- OutputStream/Writer 所有输出类的基类，前者是字节输出流，后者是字符输出流

按操作方式分类

![操作方式分类](img/java-io-action-type.jpg)

按操作对象分类

![操作对象分类](img/java-io-action-obj.jpg)

### BIO,NIO,AIO

- BIO：Block IO 同步阻塞 IO，就是我们平时使用的传统IO，它的特点是模式简单使用方便，并发能力低

  同步阻塞 I/O 模式，数据的读取写入必须阻塞在一个线程内等待其完成。在活动连接数不是特别高（小于单机1000）的情况下，这种模型是比较不错的，可以让每个连接专注于自己的I/O并且模型简单，也不用过多考虑系统的过载、限流等问题。线程池本身就是一个漏斗，可以缓冲一些系统处理不了的连接或请求。但是，当面对十万甚至百万级的连接时，传统的 BIO 模型是无能为力的

- NIO：Non IO 同步非阻塞 IO，是传统IO的升级，客户端和服务端通过 Channel （通道）通讯，实现了多路复用

  在Java 1.4 中引入了 NIO 框架，对应 java.io 包，提供了 `Channel`, `Selector`, `Buffer` 等抽象。NIO 的 `N` 可以理解为Non-blocking，不是单纯的 `New`。它支持面向缓冲的，基于通道的 I/O 操作方法。NIO 提供了与传统 BIO 模型中的 `Socket` 和 `ServerSocket` 向对应的 `SocketChannel` 和 `ServerSocketChannel` 两种不同的套接字通道实现，两种通道都支持阻塞和非阻塞两种模式。阻塞模式使用像传统的 BIO 一样，比较简单，但是性能和可靠性都不好；非阻塞模式正好与之相反。对于低负载、低并发的应用程序，可以使用同步阻塞I/O来提升开发速率和更好的维护性；对于负载高、并发高的网络应用程序，应使用 NIO 的非阻塞模式来开发

- AIO：Asynchronous IO 是 NIO的升级，也叫NIO2，实现了异步非阻塞IO，异步IO的操作基于事件和回调机制
  
  在Java 7中引入了 NIO 的改进版 NIO 2，它是异步非阻塞的I/O模型。异步I/O是基于事件和回调机制实现的，也就是应用操作之后直接返回，不会阻塞在那里，当后台处理完成，操作系统会通知相应的线程进行后续的操作。AIO是异步I/O的缩写，虽然NIO在网络操作中，提供了非阻塞的方法，但是NIO的IO行为还是同步的。对于NIO来说，我们的业务线程是在I/O操作准备好时，得到通知，接着由这个线程自行进行I/O操作，I/O操作本身是同步的。AIO的应用还不算特别广泛，Netty之前考虑过使用 AIO，后来放弃使用了（为什么呢？可以了解下哦）

### Files 常用方法 

```java
Files.exists(); // 检测文件路径是否存在
Files.createFile(); // 创建文件
Files.createDirectory(); // 创建文件夹
Files.delete(); // 删除一个文件或者文件夹
Files.copy(); // 复制文件
Files.move(); // 移动文件
Files.size(); // 查看文件个数
Files.read(); // 读取文件
Files.write(); // 写入人文件
```

## 反射

Java反射机制是在运行状态中，对于任意一个类，都能够知道这个类所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性；这种动态获取的信息以及动态调用对象方法的功能称为Java语言的反射机制

- 静态编译

  在编译时确定类型，绑定对象

- 动态编译
  
  运行时确定类型，绑定对象

### 反射机制的优缺点

- 优点
  
  运行期类型的判断，动态加载类，提高代码灵活度

- 缺点

  性能平静瓶颈，反射相当于一系列的解释操作，通知JVM要做的事，性能比直接的Java代码要慢很多

### 反射机制的应用场景

反射是框架设计的灵魂。在我们平时的项目开发中，基本上很少会直接使用到反射机制，但不能说反射机制没有用，实际上很多设计、开发都与反射机制有关，例如模块化的开发，通过反射去调用对应的字节码；动态代理设计模式也采用了反射机制，还有我们日常使用的 Spring/Hibernate 等框架也大量使用到了反射机制

- 举例
  
  1. 我们在使用JDBC连接数据库时使用 `Class.forName()` 通过反射加载数据库的驱动程序
  2. Spring 框架也用到很多反射机制，最经典的就是 xml 的配置模式。Spring 通过 xml 配置模式装在 Bean 的过程：
     1. 将程序内所有的 xml 和 properties 配置文件加载到内存中
     2. Java类里面解析 xml 或 properties 里面的内容，得到对应实体类的字节码字符串以及相关的属性信息
     3. 使用反射机制，根据这个字符串获取某个类的 `Class` 实例
     4. 动态配置实例的属性

### Java 获取反射的3中方法

1. 通过 `new` 对象实现反射机制
2. 通过路径实现反射机制
3. 通过类名实现反射机制

```java
public class Student {
    private int id;
    String name;
    protected boolean sex;
    public float score;
}

public class Get {
    public static void main(String[] args) throws ClassNotFoundException {
        // 方式 1
        Student stu = new Student();
        Class obj1 = stu.getClass();
        System.out.println(obj1.getName());
        // 方式 2
        Class obj2 = Class.forName("fanshe.Student");
        System.out.println(obj2.getName());
        // 方式 3
        Class obj3 = Student.class
        System.out.println(obj3.getName());
    }
}
```

## 常用 API

### String 相关

- 字符型常量字符串常量的差别
  1. 形式上，字符常量是单引号引起的一个字符；字符串常量是双引号引起的若干个字符
  2. 含义上，字符常量相当于一个整型值(ASCII值)，可以参加表达式运算；字符串常量代表一个地址值（该字符串在内存中存放的位置）
  3. 占内存大小，字符常量只占一个字节；字符串常量占若干个字节（至少一个字符结束标志）

- 什么是字符串常量池
  
  字符串常量池位于堆内存中，专门用来存储字符串常量，可以提高内存的使用率，避免开辟多个空间存储相同的字符串，在创建字符串时 JVM 会首先检查字符串常量池，如果该字符串已经存在池中，则返回它的引用，如果不存在，则实例化一个字符串放在池中，并返回其引用

- String 是基本数据类型吗

  不是，Java中基本数据类型只有8个：byte, short, int, long, float, double, char, boolean；除了基本类型，其他的都是引用类型，Java 5 之后引入的枚举类型也是一种比较特殊的引用类型

- String 有哪些特性
  - 不变性，String是只读字符串，是一个典型的 `immutable` 对象，对它进行任何操作，其实都是创建一个新对象，再把引用指向该对象。不变模式的主要作用是在当一个对象需要被多个线程共享并频繁访问时，可以保证数据一致性
  - 常量池优化，String对象创建之后，会在字符串常量池中进行缓存，如果下次创建同样的对象时，会直接返回缓存的引用
  - final，使用 `final` 来定义 String，表示 String 不能被继承，提高了系统的安全性

- String 类为什么是不可变的
  
  简单来说就是 String 类利用了 final 修饰的 char 类型数组存储字符

  ```java
  /** The value is used for character storage. */
  private final char value[];
  ```

  String 的内容是不可变的，String 变量所指向的内存地址是可变的

  可以通过反射修改所谓的 **不可变** 对象

  ```java
  // 创建字符串"Hello World"， 并赋给引用s
  String s = "Hello World";

  System.out.println("s = " + s); // Hello World

  // 获取String类中的value字段
  Field valueFieldOfString = String.class.getDeclaredField("value");

  // 改变value属性的访问权限
  valueFieldOfString.setAccessible(true);

  // 获取s对象上的value属性的值
  char[] value = (char[]) valueFieldOfString.get(s);

  // 改变value所引用的数组中的第5个字符
  value[5] = '_';

  System.out.println("s = " + s); // Hello_World
  ```

  用反射可以访问私有成员，然后反射出 String 对象的 value 属性，进而通过改变获得的 value 引用改变数组的结构。但是一般不这么做

- String str i = "str" 与 String str = new String("str") 一样吗
  
  不一样，因为内存的分配方式不同。`String str i = "str"` 的方式，Java虚拟机会将变量分配到常量池中；`String str = new String("str")` 的方式，则会被分配到堆内存中

- String s = new String("xyz") 创建了几个字符串对象

  两个对象，一个是静态区 `xyz`，一个是 `new` 创建在堆上的对象

  ```java
  String str1 = "hello"; //str1指向静态区
  String str2 = new String("hello");  //str2指向堆上的对象
  String str3 = "hello";
  String str4 = new String("hello");
  System.out.println(str1.equals(str2)); //true
  System.out.println(str2.equals(str4)); //true
  System.out.println(str1 == str3); //true
  System.out.println(str1 == str2); //false
  System.out.println(str2 == str4); //false
  System.out.println(str2 == "hello"); //false
  str2 = str1;
  System.out.println(str2 == "hello"); //true
  ```

- 如何将字符串反转
  
  使用 `StringBuilder` 或者 `StringBuffer` 的 `reverse()` 方法

  ```java
  // StringBuffer reverse
  StringBuffer stringBuffer = new StringBuffer();
  stringBuffer. append("abcdefg");
  System. out. println(stringBuffer. reverse()); // gfedcba
  // StringBuilder reverse
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder. append("abcdefg");
  System. out. println(stringBuilder. reverse()); // gfedcba
  ```

- 数组没有 `length()` 方法，有 `length` 属性，`String` 有 `length()` 方法

- String 类常用的方法
  
  ```java
  indexOf(); // 返回制定字符的索引
  charAt(); // 返回指定索引处的字符
  replace(); // 字符串替换
  trim(); // 去除字符串两端空白
  split(); // 分割字符，返回一个分割后的字符串数组
  getBytes(); // 返回字符串的 byte 类型数组
  length(); // 返回字符串长度
  toLowerCase(); // 将字符串转成小写字符
  toUpperCase(); // 将字符串转成大写字符
  subString(); // 截取字符串
  equals(); // 字符串比较
  ```
