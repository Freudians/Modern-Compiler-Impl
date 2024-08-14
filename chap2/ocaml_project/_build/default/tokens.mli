type linenum = int
type token = string
val type_ : linenum * linenum -> token
val var_ : linenum * linenum -> token
val function_ : linenum * linenum -> token
val break_ : linenum * linenum -> token
val of_ : linenum * linenum -> token
val end_ : linenum * linenum -> token
val in_ : linenum * linenum -> token
val nil_ : linenum * linenum -> token
val let_ : linenum * linenum -> token
val do_ : linenum * linenum -> token
val to_ : linenum * linenum -> token
val for_ : linenum * linenum -> token
val while_ : linenum * linenum -> token
val else_ : linenum * linenum -> token
val then_ : linenum * linenum -> token
val if_ : linenum * linenum -> token
val array_ : linenum * linenum -> token
val assign_ : linenum * linenum -> token
val or_ : linenum * linenum -> token
val and_ : linenum * linenum -> token
val ge_ : linenum * linenum -> token
val gt_ : linenum * linenum -> token
val le_ : linenum * linenum -> token
val lt_ : linenum * linenum -> token
val neq_ : linenum * linenum -> token
val eq_ : linenum * linenum -> token
val divide_ : linenum * linenum -> token
val times_ : linenum * linenum -> token
val minus_ : linenum * linenum -> token
val plus_ : linenum * linenum -> token
val dot_ : linenum * linenum -> token
val rbrace_ : linenum * linenum -> token
val lbrace_ : linenum * linenum -> token
val rbrack_ : linenum * linenum -> token
val lbrack_ : linenum * linenum -> token
val rparen_ : linenum * linenum -> token
val lparen_ : linenum * linenum -> token
val semicolon_ : linenum * linenum -> token
val colon_ : linenum * linenum -> token
val comma_ : linenum * linenum -> token
val string_ : string * linenum * linenum -> token
val int_ : int * linenum * linenum -> token
val id_ : string * linenum * linenum -> token
val eof_ : linenum * linenum -> token
