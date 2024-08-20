(** Abstraction function: a symbol with name s will
be represented as (s, i), where i is a unique integer.
Two symbols (s1, i1) and (s2, i2) where s1 = s2 will also have
i1 = i2. *)
type t

(**[symbol s] is a symbol that represents things with name
[s]*)
val symbol : string -> t

(**[name sy] is the name of [sy]*)
val name : t -> string

(**Hash table that maps symbols to types. The types of the type
may vary*)
type 'a table

(**[empty] is a symbol table with no entries*)
val empty: 'a table


val enter : 'a table -> t -> 'a -> 'a table
val look : 'a table -> t -> 'a option
