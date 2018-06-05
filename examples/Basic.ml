
let log format =
  Fmt.(kpf (fun formatter -> Format.pp_print_newline formatter ())
         stderr format)


module Literals = struct
  let num = code 42 in
  let str = code "hello" in
  log "@.# Literals";
  log "%a ==> %d" Code.pp num (Code.run num);
  log "%a ==> %S" Code.pp str (Code.run str)
end


module Env_capture = struct
  let e1 = code max_int in
  log "@.# Env_capture";
  log "%a ==> %d@." Code.pp e1 (Code.run e1)
end


module Simple_expression = struct
  let e1 = code (2 + 2) in
  log "@.# Simple_expression";
  log "%a ==> %d@." Code.pp e1 (Code.run e1)
end


module Nested_expression = struct
  let q = code (code 42) in
  log "@.# Nested_expression";
  log "%a ==> %d@." Code.pp q (Code.run (Code.run q))
end


module Shadowed_def = struct
  let a = 100 in
  let b = code (let a = 40 in 2 + a) in
  log "@.# Shadowed_def";
  log "%a ==> %d@." Code.pp b (Code.run b)
end


module Expression_unquote = struct
  let a = 42 in
  let b = code (2 + a) in
  log "@.# Expression_unquote";
  log "%a ==> %d" Code.pp b (Code.run b)
end

module Code_unquote = struct
  (*
     TODO: Implement expansion

     Current:
     2 + !!a ==> 42

     Should be:
     2 + 40 ==> 42

  *)

  let a = code 40 in
  let b = code (2 + !!a) in
  log "@.# Code_unquote";
  log "%a ==> %d@." Code.pp b (Code.run b)
end


module Rec_def = struct
  let rec power n x =
    if n = 0 then code 1
    else code (!!x * !!(power (n - 1) x))

  let power' = power 5 (code 2)

  let () =
  log "@.# Rec_def";
    log "%a ==> %d@." Code.pp power' (Code.run power')
end


(*

def power n, x =
  if (n == 0)
    `1
  else
    `($x * $(power (n - 1) x))

*)

