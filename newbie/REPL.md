# REPL

A read–eval–print loop (REPL), also termed an interactive toplevel or language shell, is a simple interactive computer programming environment that takes single user inputs, executes them, and returns the result to the user; a program written in a REPL environment is executed piecewise. The term is usually used to refer to programming interfaces similar to the classic Lisp machine interactive environment. Common examples include command line shells and similar environments for programming languages, and the technique is very characteristic of scripting languages.

## Overview

In a REPL, the user enters one or more expressions (rather than an entire compilation unit) and the REPL evaluates them and displays the results. The name read–eval–print loop comes from the names of the Lisp primitive functions which implement this functionality:

- The read function accepts an expression from the user, and parses it into a data structure in memory. For instance, the user may enter the s-expression (+ 1 2 3), which is parsed into a linked list containing four data elements.

- The eval function takes this internal data structure and evaluates it. In Lisp, evaluating an s-expression beginning with the name of a function means calling that function on the arguments that make up the rest of the expression. So the function + is called on the arguments 1 2 3, yielding the result 6.

- The print function takes the result yielded by eval, and prints it out to the user. If it is a complex expression, it may be pretty-printed to make it easier to understand.
The development environment then returns to the read state, creating a loop, which terminates when the program is closed.

REPLs facilitate exploratory programming and debugging because the programmer can inspect the printed result before deciding what expression to provide for the next read. The read–eval–print loop involves the programmer more frequently than the classic edit-compile-run-debug cycle.

Because the print function outputs in the same textual format that the read function uses for input, most results are printed in a form that could be copied and pasted back into the REPL. However, it is sometimes necessary to print representations of elements that cannot sensibly be read back in, such as a socket handle or a complex class instance. In these cases, there must exist a syntax for unreadable objects. In Python, it is the <__module__.class instance> notation, and in Common Lisp, the #<whatever> form. The REPL of CLIM, SLIME, and the Symbolics Lisp Machine can also read back unreadable objects. They record for each output which object was printed. Later when the code is read back, the object will be retrieved from the printed output.

REPLs can be created to support any text-based language. REPL support for compiled languages is usually achieved by implementing an interpreter on top of a virtual machine which provides an interface to the compiler. For example, starting with JDK 9, Java included JShell as a command line interface to the language. Various other languages have third party tools available for download that provide similar shell interaction with the language.
