# Code

This library an experimental ongoing (and mostly broken) effort to implement a
staged execution envorinment for OCaml.

The works was insipired by [MetaOCaml](http://okmij.org/ftp/ML/MetaOCaml.html)
and [ppx_stage](https://github.com/stedolan/ppx_stage).


## Examples

See the `examples/Basic.ml` file for basic usage examples. You can run the ppx
to see the generated code. Running the produced binary will show the code at it's
final stage, ready for compiling.

```
$ jbuilder build
$ ./_build/default/.ppx/Ppx_code/ppx.exe examples/Basic.ml
...
$ ./_build/default/examples/Basic.exe
# Literals
42 ==> 42
"hello" ==> "hello"

# Env_capture
max_int ==> 4611686018427387903


# Simple_expression
2 + 2 ==> 4


# Nested_expression
code 42 ==> 42


# Shadowed_def
let a = 40  in 2 + a ==> 42


# Expression_unquote
2 + a ==> 44

# Rec_def
(Code.run x) * (Code.run (power (n - 1) x)) ==> 32
```
