
open Parsetree
open Ast_helper

let string x =
  Exp.constant (Pconst_string (x, None))

