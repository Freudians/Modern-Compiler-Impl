{
    open Grammar
}

let digits = ['0'-'9']
let charac = ['a'-'z''A'-'Z']
let whitespace = [' ''\n''\t']

rule tok =
parse whitespace {tok lexbuf}
| "print" {PRINT}
| charac (charac|'_'|digits)* {ID (Lexing.lexeme lexbuf)}
| digits* {INT (int_of_string (Lexing.lexeme lexbuf))}
| '+' {PLUS}
| '-' {MINUS}
| '*' {TIMES}
| '/' {DIV}
| ":=" {ASSIGN}
| '(' {LPAREN}
| ')' {RPAREN}
| ',' {COMMA}
| ';' {SEMICOLON}
| eof {EOF}