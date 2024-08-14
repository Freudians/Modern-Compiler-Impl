(*TODO: add support for control sequences*)
{
    open Errormsg
    let counter = ref 0
    let string_buff = Buffer.create 256
    open Grammar
}
let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let weird_whitespace = [' ''\x0C''\n''\r''\t']
(* Note: because ocaml thinks identifiers starting with capital letters = module or variant, all identifiers
have been replaced from all caps -> identifier ^ "_" *)
rule token = parse
(*whitespace*)
| (' '|'\n'|'\t')+ {token lexbuf}
| "/*" {counter := 1; comments lexbuf}
| "\"" {Buffer.clear string_buff; strings lexbuf; token.STRING (Buffer.contents string_buff, Lexing.lexeme_start lexbuf, (Lexing.lexeme_start lexbuf) + (Buffer.length string_buff))}
| "while" { Tokens.while_ (Lexing.lexeme_start lexbuf, (Lexing.lexeme_start lexbuf)+5)}
| "for" {Tokens.for_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_start lexbuf + 3)}
| "to" {Tokens.to_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_start lexbuf + 2)}
| "break" {Tokens.break_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_start lexbuf + 5)}
| "let" {Tokens.let_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "in" {Tokens.in_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "end" {Tokens.end_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "function" {Tokens.function_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "var" {Tokens.var_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "type" {Tokens.type_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "array" {Tokens.array_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "if" { Tokens.if_ (Lexing.lexeme_start lexbuf, (Lexing.lexeme_start lexbuf)+2)}
| "then" {Tokens.then_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "else" {Tokens.else_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "do" {Tokens.do_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "of" {Tokens.of_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "nil" {Tokens.nil_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ":=" {Tokens.assign_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "," {Tokens.comma_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ":" {Tokens.colon_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ";" {Tokens.semicolon_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "." {Tokens.dot_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "(" {Tokens.lparen_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ")" {Tokens.rparen_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "{" {Tokens.lbrace_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "}" {Tokens.rbrace_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "[" {Tokens.lbrack_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "]" {Tokens.rbrack_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "&" {Tokens.and_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "|" {Tokens.or_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "*/" {ErrorMsg.error (Lexing.lexeme_start lexbuf) "Unclosed comment from back"; "ERROR"}
| "/" {Tokens.divide_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "*" {Tokens.times_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "+" {Tokens.plus_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "-" {Tokens.minus_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "<>" {Tokens.neq_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "<=" {Tokens.le_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ">=" {Tokens.ge_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| ">" {Tokens.gt_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "<" {Tokens.lt_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| "=" {Tokens.eq_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
(*identifiers*)
| upper|lower (digit|upper|lower|'_')* {Tokens.id_ (Lexing.lexeme lexbuf, Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
(*Integer literals*)
| digit+ {Tokens.int_ (int_of_string (Lexing.lexeme lexbuf), Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf)}
| eof {Tokens.eof_ (Lexing.lexeme_start lexbuf, Lexing.lexeme_start lexbuf)}
| _ {ErrorMsg.impossible "Unrecognized sequence"; "ERROR"}
and comments = parse
| "/*" {counter := !counter + 1; comments lexbuf}
| "*/" {counter := !counter -1; if !counter > 0 then comments lexbuf else if !counter = 0 then token lexbuf else 
        (ErrorMsg.error (Lexing.lexeme_start lexbuf) "unclosed comment from back"; "ERROR")}
| _ {comments lexbuf}
| eof {ErrorMsg.error (Lexing.lexeme_start lexbuf) "unclosed comment"; "ERROR"}
and strings = parse 
| "\\t" {Buffer.add_char string_buff '\t'; strings lexbuf}
| "\\n" {Buffer.add_char string_buff '\n'; strings lexbuf}
| "\\\"" {Buffer.add_char string_buff '\"'; strings lexbuf}
| "\\\\" {Buffer.add_char string_buff '\\'; strings lexbuf}
| "\\" digit digit digit {Buffer.add_char string_buff ((Lexing.lexeme lexbuf) |> (fun s -> String.sub s 1 3) |> int_of_string |> Char.chr); strings lexbuf}
| "\\" weird_whitespace {ignore_string lexbuf}
| "\"" {()}
| [^'\\'] as c {Buffer.add_char string_buff c; strings lexbuf}
| eof {ErrorMsg.error (Lexing.lexeme_start lexbuf) "unclosed string"; "ERROR"}
| _ {ErrorMsg.error (Lexing.lexeme_start lexbuf) "illegal character in string"; "ERROR"}
and ignore_string = parse
| weird_whitespace "\\" {strings lexbuf}
| _ {ignore_string lexbuf}
| eof {ErrorMsg.error (Lexing.lexeme_start lexbuf) "unclosed string ignore"; "ERROR"}