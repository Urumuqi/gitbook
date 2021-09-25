# Java 字符串

## String & StringBuffer & StringBuilder

`StringBuffer` 和 `StringBuilder` 都继承自 `AbstractStringBuilder`，而 `AbstractStringBuilder` 又实现了 `CharSequence` 接口，两个类都是用来做字符串操作。在做字符串拼接、修改、删除、替换时，效率比 `String` 更高。

`StringBuffer` 是线程安全，`StringBuffer` 的方法大多都加了 `synchronized` 关键字。

`StringBuilder` 是非线程安全。

## String 类常用方法

```Java
String.charAt();
String.indexOf();
String.replace();
String.trim();
String.split();
String.getBytes();
String.length();
String.toLowerCase();
String.toUpperCase();
String.substring();
String.format();
String.equals(); // 字符串比较
```

