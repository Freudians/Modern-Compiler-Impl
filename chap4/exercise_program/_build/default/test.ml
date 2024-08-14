let lexbuf = Lexing.from_channel stdin
let wrapper = Grammar.prog Lexer.tok lexbuf