
(* The type of tokens. *)

type token = 
  | TIMES
  | SEMICOLON
  | RPAREN
  | PRINT
  | PLUS
  | MINUS
  | LPAREN
  | INT of (int)
  | ID of (string)
  | EOF
  | DIV
  | COMMA
  | ASSIGN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Table_helper.table)
