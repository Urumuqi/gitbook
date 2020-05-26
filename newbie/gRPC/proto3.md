# Language Guide (proto3)

## Defining A Message Type

```proto3
syntax = "proto3";

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
}
```

- 文件的第一行指明的语法 `proto3`. 如果文件第一行没有指明 `proto3` 语法类型 `protocal buffer compiler` 会默认使用的是 `proto2`. 必须在文件第一行指定语法，文件的第一行不能为空也不能有注释
- `SearchRequest` 消息体定义了3个字段（键值对），每个字段都 `名称` 和 `类型`

### 字段类型

在上面的例子中，所有的字段都是[基础数据类型](https://developers.google.com/protocol-buffers/docs/proto3#scalar)。两个 `整数类型` (page_number, result_per_page) 和 一个 `字符串类型` (query)。并且，我们同样可以在消息中定义 `复合数据类型` 字段，比如 `枚举类型` 或者 其他的 `message` 类型

### 设置字段编码

上面的消息定义中，每个字段都有一个 `唯一的编号`。这个编号字段是用来在二进制格式的消息中区别字段，如果消息已经被使用，这个数字不应该改变。需要注意的是，字段编号的[1-15]这个区间只用一个 `byte`来编码，包括字段编号和字段类型。字段编码区间[16-2047]则使用两个 `byte` 来编码。所以应该把[1-15]的编号尽量留给频繁使用的字段。

字段最小的编号是 `1`, 最大是 `2^29 - 1` 或者 `536,870,911`。并且也不能使用 `19000` 至 `19999` 区间段(`FieldDescriptor::kFirstReservedNumber` 至 `FieldDescriptor::kLastReservedNumber`)，这是 `protocol buffers` 的保留值区间段，如果使用这个区间段的编号，则 `protocol buffer compiler` 会出错。同时也不能使用已经用过的编号。

### 定义字段规则

`message`字段可以遵循以下的约束：

- `singular`: 一个正确定义的 `message` 消息体可以包含`0`或者`1`个 `singular` 字段，这是 `proto3` 语法默认的字段规则
- `repeated`: 一个定义正确的 `message` 消息体中，拥有 `repeated` 约束的字段可以重复任意次，重复值的顺序未知

`proto3` 语法中， `repeated` 约束修饰的简单数值类型字段默认采用 [`packed`](https://developers.google.com/protocol-buffers/docs/encoding#packed) 方式编码。

### 添加更新消息体类型

```proto3
message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
}

message SearchResponse {
 ...
}
```

### 增加备注

使用 `//` 单行注释, `/* */` 多行注释

```proto3
/* SearchRequest represents a search query, with pagination options to
 * indicate which results to include in the response. */

message SearchRequest {
  string query = 1;
  int32 page_number = 2;  // Which page number do we want?
  int32 result_per_page = 3;  // Number of results to return per page.
}
```

### 保留字段

如果修改一个 `message` 字段， 比如删除一个字段，或者注释一个字段，之后的用户可以在之后的修改中继续使用之前的字段编号。如果在之后使用了旧版本的 `.proto` 文件，将出现数据冲突，字段泄漏等问题。一个解决办法就是确保已经删除的字段和编号成为保留值。 `protocol buffer compiler` 在后续的编译中将会出现对应的提示。

```proto3
message Foo {
  reserved 2, 15, 9 to 11;
  reserved "foo", "bar";
}
```

### 从 `.proto` 文件生成什么

- C++: `.h` and `.cc` file from each `.proto`
- Java: `.java` with a class for each message type, as well as a `Builder` for creating `message` intance
- Python: a `module` with static descriptor of each message type
- Go: `.pb.go`
- Ruby: `.rb`
- Objective-C: `pbobjc.h` and `pbobjc.m`
- C#: `.cs`
- Dart: `.pb.dart`

## 基础数据类型

.proto Type | Notes | C++ Type | Java Type | Python Type[2] | Go Type | Ruby Type | C# Type | PHP Type | Dart Type
---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------
double | double | double | float | float64 | Float | double | float | double
float | float | float | float | float32 | Float | float | float | double
int32 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. | int32 | int | int | int32 | Fixnum or Bignum (as required) | int | integer | int
int64 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead. | int64 | long | int/long[3] | int64 | Bignum | long | integer/string[5] | Int64
uint32 | Uses variable-length encoding. | uint32 | int[1] | int/long[3] | uint32 | Fixnum or Bignum (as required) | uint | integer | int
uint64 | Uses variable-length encoding. | uint64 | long[1] | int/long[3] | uint64 | Bignum | ulong | integer/string[5] | Int64
sint32 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s. | int32 | int | int | int32 | Fixnum or Bignum (as required) | int | integer | int
sint64 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s. | int64 | long | int/long[3] | int64 | Bignum | long | integer/string[5] | Int64
fixed32 | Always four bytes. More efficient than uint32 if values are often greater than 228. | uint32 | int[1] | int/long[3] | uint32 | Fixnum or Bignum (as required) | uint | integer | int
fixed64 | Always eight bytes. More efficient than uint64 if values are often greater than 256. | uint64 | long[1] | int/long[3] | uint64 | Bignum | ulong | integer/string[5] | Int64
sfixed32 | Always four bytes. | int32 | int | int | int32 | Fixnum or Bignum (as required) | int | integer | int
sfixed64 | Always eight bytes. | int64 | long | int/long[3] | int64 | Bignum | long | integer/string[5] | Int64
bool | bool | boolean | bool | bool | TrueClass/FalseClass | bool | boolean | bool
string | A string must always contain UTF-8 encoded or 7-bit ASCII text, and cannot be longer than 232. | string | String | str/unicode[4] | string | String (UTF-8) | string | string | String
bytes | May contain any arbitrary sequence of bytes no longer than 232. | string | ByteString | str | []byte | String (ASCII-8BIT) | ByteString | string | List<int>

## 默认值

- For strings, the default value is the empty string.
- For bytes, the default value is empty bytes.
- For bools, the default value is false.
- For numeric types, the default value is zero.
- For enums, the default value is the first defined enum value, which must be 0.
- For message fields, the field is not set. Its exact value is language-dependent. See the [generated code guide](https://developers.google.com/protocol-buffers/docs/reference/overview) for details.

## 枚举类型

```proto3
message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
  enum Corpus {
    UNIVERSAL = 0;
    WEB = 1;
    IMAGES = 2;
    LOCAL = 3;
    NEWS = 4;
    PRODUCTS = 5;
    VIDEO = 6;
  }
  Corpus corpus = 4;
}
```

`Corpus` 第一个值必须是 `0`, 主要有两个原因：
- 必须要有一个 `0` 值，这也是 `数值类型` 的默认值
- 为了和 `proto2` 兼容，第一元素必须是 `0`，第一个值总是默认值

如果定义的不同的 `枚举类型` 包含同样的定义值， 可以使用 `allow_alias = true` 别名， 否则 `protocol compiler` 变异会报错。

```proto3
message MyMessage1 {
  enum EnumAllowingAlias {
    option allow_alias = true;
    UNKNOWN = 0;
    STARTED = 1;
    RUNNING = 1;
  }
}
message MyMessage2 {
  enum EnumNotAllowingAlias {
    UNKNOWN = 0;
    STARTED = 1;
    // RUNNING = 1;  // Uncommenting this line will cause a compile error inside Google and a warning message outside.
  }
}
```

### 保留值

如果修改了枚举类型的定义值，在后续的变更中可能会出现使用上的误会和错误。为了解决这个问题， 可以讲废弃或者删除的枚举值定义为`保留值`。

```proto3
enum Foo {
  reserved 2, 15, 9 to 11, 40 to max;
  reserved "FOO", "BAR";
}
```

## 使用更多的消息体类型

```proto3
message SearchResponse {
  repeated Result results = 1;
}

message Result {
  string url = 1;
  string title = 2;
  repeated string snippets = 3;
}
```

### 导入外部定义

如果现在在消息体中定义一个在其他 `.proto` 文件定义的类型，可以导入`.proto` 文件：

```proto3
import "myproject/other_protos.proto";
```

如果导入的 `.proto` 文件位置发生了变更，但是文件已经被其他 `proto` 文件引用，可以在原来的位置放一个`假的.proto`文件，将新的`.proto`文件引入到原来的位置。原来`.proto`文件的假文件，使用 `import public` 来透明的为外部依赖提供支持:

```proto3
// new.proto
// All definitions are moved here
```

```proto3
/ old.proto
// This is the proto that all clients are importing.
import public "new.proto";
import "other.proto";
```

```proto3
// client.proto
import "old.proto";
// You use definitions from old.proto and new.proto, but not other.proto
```

### 使用`proto2`消息体定义

在使用`proto3`语法时，可以导入`proto2`定义的消息体,反之亦然。但是要注意`proto2`的枚举类型不能直接在`proto3`语法中使用。

## 嵌套类型

```proto3
message SearchResponse {
  message Result {
    string url = 1;
    string title = 2;
    repeated string snippets = 3;
  }
  repeated Result results = 1;
}
```

如果要在消息体外使用嵌套的类型，可以用以下的方式:

```proto3
message SomeOtherMessage {
  SearchResponse.Result result = 1;
}
```

或者是层层嵌套

```proto3
message Outer {                  // Level 0
  message MiddleAA {  // Level 1
    message Inner {   // Level 2
      int64 ival = 1;
      bool  booly = 2;
    }
  }
  message MiddleBB {  // Level 1
    message Inner {   // Level 2
      int32 ival = 1;
      bool  booly = 2;
    }
  }
}
```

## 更新消息体类型

随着业务的迭代，现有的`消息体`不再满足业务需要。需要添加新的字段，但是仍然需要延续以前的格式。以下的几条规则可以帮助我们在不破环现有代码的基础上扩展现有的消息内容：

- 不要改变已经存在的字段的编号
- 如果添加新字段，原来的`消息体`同样可以解析新生成的代码。需要注意的是新增加字段的默认值，新增加的字段只有在默认值存在的情况下，才能够和原来的`消息体`正常解析适配。同理，新生成`消息体`可以和原来的代码通通信，新增加的字段携带了默认值，原来的代码在解析新的`消息体`时会忽略新增加的字段。更多字段默认值查看[Unknown Fields](https://developers.google.com/protocol-buffers/docs/proto3#unknowns)
- 字段可以被删除，只要被删除字段的编号不会再被使用。也可以重命名一个字段，需要添加前缀`OBSOLETE_`，或者将字段编号添加到保留值，确保之后的开发人员不会在意外的重用这个编号
- `int32`,`uint32`,`int64`,`uint64`,and `bool` 都是兼容的。意味这在这几个类型之间切换并不会影响到代码的兼容性。如果通信时解析的类型以一致，也可以得到相同的预期结果，这个转化效果等同于`C++`的类型断言
- `sint32`,`sint64` 彼此兼容，但是和其他的`整型`类型不兼容
- `string`,`bytes`兼容的前提是`bytes`采用`utf-8`编码
- 如果`bytes`包含编码之后`消息体`，那么嵌套的`消息体`和`bytes`兼容
- `fixed32`和`fixed32`兼容，`fixed64`和`sfixed64`兼容
- `enum`和`int32`,`uint32`,`int64`,`uint64`在有序格式的情况下，兼容（？？什么意思？？）
- Changing a single value into a member of a new oneof is safe and binary compatible. Moving multiple fields into a new oneof may be safe if you are sure that no code sets more than one at a time. Moving any fields into an existing oneof is not safe. （这句话有点费解）

## 未知字段

未知的字段表示正常的`protocol buffer`序列化是无法表述的字段。比如一个原始`消息体`解析一个新增字段的新的`消息体`，新增加的字段对旧代码来说旧是`未知字段`

最初，`proto3`在解析`消息体`时会丢弃`未知字段`，但是在`proto 3.5`版本中我们重新保留了`未知字段`保持和`proto2`的兼容性。所以在`proto 3.5`以及以后的版本中，未知字段在解析和序列化过程中将得到保留。

## Any 消息体类型
