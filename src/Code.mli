type 'a t

val make : 'a -> Parsetree.expression -> 'a t

val source : 'a t -> Parsetree.expression

val run : 'a t -> 'a

val pp : Format.formatter -> 'a t -> unit

