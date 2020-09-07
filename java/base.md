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
