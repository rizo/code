
type 'a t = ('a * Parsetree.expression)

let source (_, b) = b

let run (a, _) = a

let make a s = (a, s)

let pp formatter self =
  Pprintast.expression formatter (source self)

