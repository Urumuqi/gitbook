# Language Guide (proto3)

## Defining A Message Type

```lolcode
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

```lolcode
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

```lolcode
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

```lolcode
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

```lolcode
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

```lolcode
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

```lolcode
enum Foo {
  reserved 2, 15, 9 to 11, 40 to max;
  reserved "FOO", "BAR";
}
```

## 使用更多的消息体类型

```lolcode
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

```lolcode
import "myproject/other_protos.proto";
```

如果导入的 `.proto` 文件位置发生了变更，但是文件已经被其他 `proto` 文件引用，可以在原来的位置放一个`假的.proto`文件，将新的`.proto`文件引入到原来的位置。原来`.proto`文件的假文件，使用 `import public` 来透明的为外部依赖提供支持:

```lolcode
// new.proto
// All definitions are moved here
```

```lolcode
/ old.proto
// This is the proto that all clients are importing.
import public "new.proto";
import "other.proto";
```

```lolcode
// client.proto
import "old.proto";
// You use definitions from old.proto and new.proto, but not other.proto
```

### 使用`proto2`消息体定义

在使用`proto3`语法时，可以导入`proto2`定义的消息体,反之亦然。但是要注意`proto2`的枚举类型不能直接在`proto3`语法中使用。

## 嵌套类型

```lolcode
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

```lolcode
message SomeOtherMessage {
  SearchResponse.Result result = 1;
}
```

或者是层层嵌套

```lolcode
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
- Changing a single value into a member of a new `oneof` is safe and binary compatible. Moving multiple fields into a new `oneof` may be safe if you are sure that no code sets more than one at a time. Moving any fields into an existing `oneof` is not safe. （这句话有点费解）

## 未知字段

未知的字段表示正常的`protocol buffer`序列化是无法表述的字段。比如一个原始`消息体`解析一个新增字段的新的`消息体`，新增加的字段对旧代码来说旧是`未知字段`

最初，`proto3`在解析`消息体`时会丢弃`未知字段`，但是在`proto 3.5`版本中我们重新保留了`未知字段`保持和`proto2`的兼容性。所以在`proto 3.5`以及以后的版本中，未知字段在解析和序列化过程中将得到保留。

## Any 消息体类型

借助 `Any` 类型，在可以消息体中使用嵌套的字段类型而不用定义。一个`Any`类型的字段可以存储任意序列化的消息`bytes`，必须定义的`Any`字段类型有一个唯一的类型表示符号。使用`Any`类型前，需要导入`google/protobuf/any.proto`。

```lolcode
import "google/protobuf/any.proto";

message ErrorStatus {
  string message = 1;
  repeated google.protobuf.Any details = 2;
}
```

不同的编程语言都需要在运行时在类型安全的情况下对`Any`类型数据进行`装箱`和`拆箱`。比如在`Java`语言中提供了特殊的`pack()`和`unpack()`方法，`C++`语言中也提供了`PackFfrom()`和`UnpackTo()`方法:

```lolcode
// Storing an arbitrary message type in Any.
NetworkErrorDetails details = ...;
ErrorStatus status;
status.add_details()->PackFrom(details);

// Reading an arbitrary message from Any.
ErrorStatus status = ...;
for (const Any& detail : status.details()) {
  if (detail.Is<NetworkErrorDetails>()) {
    NetworkErrorDetails network_error;
    detail.UnpackTo(&network_error);
    ... processing network_error ...
  }
}
```

**目前`Any`类型的所有运行时正在持续完善中**

如果已经熟悉了`proto2`的语法，可以查看`Any`类型的替代[插件](https://developers.google.com/protocol-buffers/docs/proto#extensions).

## Oneof

如果一个`消息体`有多个字段，同时一次最多设置一个字段，这时可以指定`oneof`特征来完成这种特性，并且可以节省内存。

`oneof`字段类型除了是共享内存以外和普通的字段几乎没有区别，且`oneof`字段一次只能最多只能设置一个字段值。设置`oneof`成员的一个值，其他的`oneof`成员的值将被清空。可以使用`case()`或者`WhichOneOf()`方法检查字段是否是`oneof`字段并且检查是否有值，不用的语言实现，对应的方法有所不同。

### 使用`oneof`

```lolcode
message SampleMessage {
  oneof test_oneof {
    string name = 4;
    SubMessage sub_message = 9;
  }
}
```

可以为`oneof`设置除了`repeated`以外的所有的字段类型。在`.proto`生成的代码中，`oneof`字段同样和普通字段一样有`getter`,`setter`方法，同时也会有一个特殊的方法用来检查哪个字段是否是`oneof`设值的字段。可以在对应语言的[`API文档`](https://developers.google.com/protocol-buffers/docs/reference/overview)查看细节。

### `oneof`特点

- 设置`oneof`字段成员的一个字段，其他的字段的值将被清空。所有在顺序设置了多个`oneof`字段的情况下，只有最后一个字段持有被赋予的值

  ```cpp
    SampleMessage message;
    message.set_name("name");
    CHECK(message.has_name());
    message.mutable_sub_message();   // Will clear name field.
    CHECK(!message.has_name());
  ```

- 解析器在顺序解析多个`oneof`成员变量时只有最后一个被解析的成员变量被赋予了解析的结果
- `oneof`和`repeated`不能同时出现
- `oneof`字段和反射兼容
- 设置了一个`oneof`字段的默认值，该字段默认的`case`会被触发，同时默认值会按照顺序被序列化
- 如果使用`C++`一定要确保不会导致内存崩溃。下列的代码将会崩溃，因为使用一个被删除的字段

  ```cpp
    SampleMessage message;
    SubMessage* sub_message = message.mutable_sub_message();
    message.set_name("name");      // Will delete sub_message
    sub_message->set_...            // Crashes here
  ```

- `C++`中使用`Swap()`来操作两个`oneof`消息类型，结果会让这两个`oneof`类型发生交换：下面的列子中，`msg1`会拥有`sub_message`并且`msg2`会拥有`name`:

  ```cpp
    SampleMessage msg1;
    msg1.set_name("name");
    SampleMessage msg2;
    msg2.mutable_sub_message();
    msg1.swap(&msg2);
    CHECK(msg1.has_sub_message());
    CHECK(msg2.has_name());
  ```

### 向后兼容性问题

谨慎添加或者删除一个`oneof`类型的字段。如果检查一个`oneof`字段的值返回`None/NOT_SET`，可能是`oneof`字段没有被赋值，也可能是被设置成为了不同版本的`oneof`字段。所以没有办法区别在一个序列中的字段是否是`oneof`类型成员。

## `Map`类型

`proto`同时也支持定义`map`类型字段

```lolcode
map<key_type, value_type> map_field = N;
```

`key_type`可以整型或者字符串类型（可以是任何的基础类型和字符数组）。枚举类型不能做`key_type`。`value_type`可以是除了`map`以外的所有类型。示例如下:

```lolcode
map<string, Project> projects = 3;
```

- `map`类型不能用`repeated`约束
- `map`类型的迭代顺序是未知的，所以对`map`的遍历顺序是未知的
- `.proto`生成文本代码时，`map`类型的变量是按照`key`来排序的。数值类型的`key`按照数值来排序
- 顺序解析或者合并`map`类型是，如果`map`中有重复的`key`。当将一个文本格式解析成`map`时，如果存在重复的`key`则会导致解析失败
- 如果`map`中设置了`key`而没有设置`value`，具体的序列化操作更具不同的语言有所不同。在`C++`,`Java`和`Python`中，默认值也会被序列化，在其他语言中则不会被序列化

### 向后的兼容性

`map`类型的定义等同于以下消息体定义

```lolcode
message MapFieldEntry {
  key_type key = 1;
  value_type value = 2;
}

repeated MapFieldEntry map_field = N;
```

所有`protocol buffer`的实现中对于支持`map`的实现，应该都会支持上面的消息定义

## Packages包

在`.proto`文件中添加`package`标识符，可以避免`.proto`文件中的`消息体`类型冲突

```lolcode
package foo.bar;
message Open { ... }
```

然后可以在定义`消息体`类型是使用带`package`表示的类型

```lolcode
message Foo {
  ...
  foo.bar.Open open = 1;
  ...
}
```

`package`对生成代码的影响和选择的语言有关系：

- `C++`生成的类会包含在名称空间中。比如`Open`会在名称空间`foo::bar`中
- `Java`中就是表示`Java`包，除非你明确的在`.proto`文件中设置了`option java_package`
- `Python`中会忽略`package`，因为`Python`中的`module`是更具文件路径来管理的
- `Go`语言将`package`编译为对应的包，除非在`.proto`文件中明确指定了`option go_package`
- In Ruby, the generated classes are wrapped inside nested Ruby namespaces, converted to the required Ruby capitalization style (first letter capitalized; if the first character is not a letter, PB_ is prepended). For example, Open would be in the namespace Foo::Bar.
- `C#`会将`package`编译为`PascalCase`风格的名称空间，除非在`.proto`文件中指定了`option csharp_namespace`。比如`Open`会在名称空间`Foo.Bar`中

### 包和名称的映射关系

`protocol buffer`的名称映射关系是最里层一次向最外层查找的，每个包都隶属于它的父包。从`.`起始意味着从最外层的作用域开始。

`protocol buffer`不同语言的实现都能处理怎么逐层找到定义的`消息体`，即使是有不同的作用域规则（不太明白这里，有点罗嗦）

## 定义`service`

在`.proto`文件中定义`service`接口，并使用定义的`消息体`来完成整个`RPC`系统。`protocol buffer compiler`会生成对应语言的服务接口和类的存根。比如下面的例子，定义了一个`SearchRequest`作为访问参数`SearchResponse`作为返回参数的`RPC`

```lolcode
service SearchService {
  rpc Search (SearchRequest) returns (SearchResponse);
}
```

最直接使用`protocol buffer`的`RPC`系统是 [`gRPC`](index.md)，这是一个编程语言和平台无关的中立的`RPC`系统。`gRPC`由`Google`开发，目前由`Google`和社区已经适配了大多数的主流的开发语言的代码生成。

## `JSON`映射

`proto3`支持了经典的`json`编码，这给系统之间的数据通信带来了很大的便利。下面的表格逐类型的描述了编码方式。

如果一个值在`json`编码之后的数据中丢失或者值是`null`,`protocol buffer compiler`在解析的时候会为其填充类型的默认值。如果某个字段是默认值，在`json`编码是会被忽略从而节省存储空间。

proto3 | JSON | JSON example | Notes
----- | ------ | ----- | -----
message | object | {"fooBar": v, "g": null, …}  | Generates JSON objects. Message field names are mapped to lowerCamelCase and become JSON object keys. If the json_name field option is specified, the specified value will be used as the key instead. Parsers accept both the lowerCamelCase name (or the one specified by the json_name option) and the original proto field name. null is an accepted value for all field types and treated as the default value of the corresponding field type.
enum | string | "FOO_BAR" | The name of the enum value as specified in proto is used. Parsers accept both enum names and integer values.
map<K,V> | object | {"k": v, …} | All keys are converted to strings.
repeated V | array | [v, …] | null is accepted as the empty list [].
bool | true, false | true, false
string | string | "Hello World!"
bytes | base64 string | "YWJjMTIzIT8kKiYoKSctPUB+" | JSON value will be the data encoded as a string using standard base64 encoding with paddings. Either standard or URL-safe base64 encoding with/without paddings are accepted.
int32, fixed32, uint32 | number | 1, -10, 0 | JSON value will be a decimal number. Either numbers or strings are accepted.
int64, fixed64, uint64 | string | "1", "-10" | JSON value will be a decimal string. Either numbers or strings are accepted.
float, double | number | 1.1, -10.0, 0, "NaN", "Infinity" | JSON value will be a number or one of the special string values "NaN", "Infinity", and "-Infinity". Either numbers or strings are accepted. Exponent notation is also accepted.
Any | object | {"@type": "url", "f": v, … } | If the Any contains a value that has a special JSON mapping, it will be converted as follows: {"@type": xxx, "value": yyy}. Otherwise, the value will be converted into a JSON object, and the "@type" field will be inserted to indicate the actual data type.
Timestamp | string | "1972-01-01T10:00:20.021Z" | Uses RFC 3339, where generated output will always be Z-normalized and uses 0, 3, 6 or 9 fractional digits. Offsets other than "Z" are also accepted.
Duration | string | "1.000340012s", "1s" | Generated output always contains 0, 3, 6, or 9 fractional digits, depending on required precision, followed by the suffix "s". Accepted are any fractional digits (also none) as long as they fit into nano-seconds precision and the suffix "s" is required.
Struct | object | { … } | Any JSON object. See struct.proto.
Wrapper types | various types | 2, "2", "foo", true, "true", null, 0, … | Wrappers use the same representation in JSON as the wrapped primitive type, except that null is allowed and preserved during data conversion and transfer.
FieldMask | string | "f.fooBar,h" | See field_mask.proto.
ListValue | array | [foo, bar, …]
Value | value |  | Any JSON value
NullValue | null |  | JSON null
Empty | object | {} | An empty JSON object

### `JSON`可选项

- 不忽略字段的默认值：`proto3` `json`编码是会忽略字段的默认值以减少空间。可以重写这个这个操作以不忽略字段的默认值
- 忽略未知字段：`proto3 json`解析默认会丢弃未知字段，可以提供一个选项忽略未知字段的解析
- 使用`proto`字段名称替代`小写驼峰`命名：可以提供一个选项让`proto json`在解析的时候将字段名解析为`proto`文件中定义的字段名，而不是默认的`小写驼峰`命名。两个名称规则都是支持的
- 指明枚举类型值为整型而非字符串类型：`json`编码输出枚举值是默认是枚举值的名称，可以提供配置将将枚举值编译为对应的数值

## 配置项 `option`

