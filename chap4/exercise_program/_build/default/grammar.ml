
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | TIMES
    | SEMICOLON
    | RPAREN
    | PRINT
    | PLUS
    | MINUS
    | LPAREN
    | INT of (
# 4 "grammar.mly"
      (int)
# 22 "grammar.ml"
  )
    | ID of (
# 5 "grammar.mly"
      (string)
# 27 "grammar.ml"
  )
    | EOF
    | DIV
    | COMMA
    | ASSIGN
  
end

include MenhirBasics

# 1 "grammar.mly"
  
open Table_helper
# 41 "grammar.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_prog) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: prog. *)

  | MenhirState02 : (('s, _menhir_box_prog) _menhir_cell1_PRINT, _menhir_box_prog) _menhir_state
    (** State 02.
        Stack shape : PRINT.
        Start symbol: prog. *)

  | MenhirState03 : (('s, _menhir_box_prog) _menhir_cell1_LPAREN, _menhir_box_prog) _menhir_state
    (** State 03.
        Stack shape : LPAREN.
        Start symbol: prog. *)

  | MenhirState06 : (('s, _menhir_box_prog) _menhir_cell1_ID, _menhir_box_prog) _menhir_state
    (** State 06.
        Stack shape : ID.
        Start symbol: prog. *)

  | MenhirState08 : (('s, _menhir_box_prog) _menhir_cell1_stm, _menhir_box_prog) _menhir_state
    (** State 08.
        Stack shape : stm.
        Start symbol: prog. *)

  | MenhirState11 : (('s, _menhir_box_prog) _menhir_cell1_stm, _menhir_box_prog) _menhir_state
    (** State 11.
        Stack shape : stm.
        Start symbol: prog. *)

  | MenhirState13 : (('s, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 13.
        Stack shape : exp.
        Start symbol: prog. *)

  | MenhirState15 : (('s, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 15.
        Stack shape : exp.
        Start symbol: prog. *)

  | MenhirState17 : (('s, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 17.
        Stack shape : exp.
        Start symbol: prog. *)

  | MenhirState19 : (('s, _menhir_box_prog) _menhir_cell1_exp, _menhir_box_prog) _menhir_state
    (** State 19.
        Stack shape : exp.
        Start symbol: prog. *)

  | MenhirState26 : ((('s, _menhir_box_prog) _menhir_cell1_PRINT, _menhir_box_prog) _menhir_cell1_exps, _menhir_box_prog) _menhir_state
    (** State 26.
        Stack shape : PRINT exps.
        Start symbol: prog. *)


and ('s, 'r) _menhir_cell1_exp = 
  | MenhirCell1_exp of 's * ('s, 'r) _menhir_state * (Table_helper.table -> Table_helper.table * int)

and ('s, 'r) _menhir_cell1_exps = 
  | MenhirCell1_exps of 's * ('s, 'r) _menhir_state * (Table_helper.table -> Table_helper.table)

and ('s, 'r) _menhir_cell1_stm = 
  | MenhirCell1_stm of 's * ('s, 'r) _menhir_state * (Table_helper.table -> Table_helper.table)

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state * (
# 5 "grammar.mly"
      (string)
# 113 "grammar.ml"
)

and ('s, 'r) _menhir_cell1_LPAREN = 
  | MenhirCell1_LPAREN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PRINT = 
  | MenhirCell1_PRINT of 's * ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (Table_helper.table) [@@unboxed]

let _menhir_action_01 =
  fun _1 ->
    (
# 32 "grammar.mly"
      (fun t -> (t, _1))
# 130 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_02 =
  fun _1 ->
    (
# 33 "grammar.mly"
     (fun t -> (t, t _1))
# 138 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_03 =
  fun _1 _3 ->
    (
# 35 "grammar.mly"
(unpack _1 ( + ) _3)
# 146 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_04 =
  fun _1 _3 ->
    (
# 36 "grammar.mly"
                (unpack _1 ( - ) _3)
# 154 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_05 =
  fun _1 _3 ->
    (
# 37 "grammar.mly"
                (unpack _1 ( * ) _3)
# 162 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_06 =
  fun _1 _3 ->
    (
# 38 "grammar.mly"
              (unpack _1 ( / ) _3)
# 170 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_07 =
  fun _1 _3 ->
    (
# 39 "grammar.mly"
                (fun t -> _3(_1 t))
# 178 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_08 =
  fun _2 ->
    (
# 40 "grammar.mly"
                    ( _2 )
# 186 "grammar.ml"
     : (Table_helper.table -> Table_helper.table * int))

let _menhir_action_09 =
  fun _1 ->
    (
# 28 "grammar.mly"
      ((fun t -> let (ta, v) = _1 t in print_int v; ta))
# 194 "grammar.ml"
     : (Table_helper.table -> Table_helper.table))

let _menhir_action_10 =
  fun _1 _3 ->
    (
# 29 "grammar.mly"
                 (fun t -> ( let (ta, v) = _3(_1 t) in print_int v; ta))
# 202 "grammar.ml"
     : (Table_helper.table -> Table_helper.table))

let _menhir_action_11 =
  fun _1 ->
    (
# 19 "grammar.mly"
          (_1(emptytable))
# 210 "grammar.ml"
     : (Table_helper.table))

let _menhir_action_12 =
  fun _1 _3 ->
    (
# 23 "grammar.mly"
                    (fun t -> _3(_1(t)))
# 218 "grammar.ml"
     : (Table_helper.table -> Table_helper.table))

let _menhir_action_13 =
  fun _1 _3 ->
    (
# 24 "grammar.mly"
                (fun t -> update t _1 (let (_, v) = _3 t in v))
# 226 "grammar.ml"
     : (Table_helper.table -> Table_helper.table))

let _menhir_action_14 =
  fun _3 ->
    (
# 25 "grammar.mly"
                           (fun t -> _3 t)
# 234 "grammar.ml"
     : (Table_helper.table -> Table_helper.table))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ASSIGN ->
        "ASSIGN"
    | COMMA ->
        "COMMA"
    | DIV ->
        "DIV"
    | EOF ->
        "EOF"
    | ID _ ->
        "ID"
    | INT _ ->
        "INT"
    | LPAREN ->
        "LPAREN"
    | MINUS ->
        "MINUS"
    | PLUS ->
        "PLUS"
    | PRINT ->
        "PRINT"
    | RPAREN ->
        "RPAREN"
    | SEMICOLON ->
        "SEMICOLON"
    | TIMES ->
        "TIMES"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PRINT (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | PRINT ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState02
          | LPAREN ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState02
          | INT _v ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _1 = _v in
              let _v = _menhir_action_01 _1 in
              _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState02 _tok
          | ID _v ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState02
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState03 _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState03
      | _ ->
          _eRR ()
  
  and _menhir_run_22 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_08 _2 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_13 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState13
      | _ ->
          _eRR ()
  
  and _menhir_run_14 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_exp (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_05 _1 _3 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_exp : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState02 ->
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState26 ->
          _menhir_run_27 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState03 ->
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState19 ->
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState15 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState13 ->
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState11 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_28 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_PRINT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | RPAREN ->
          let _1 = _v in
          let _v = _menhir_action_09 _1 in
          _menhir_goto_exps _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState15
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState15
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState15 _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState15
      | _ ->
          _eRR ()
  
  and _menhir_run_16 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_exp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF | MINUS | PLUS | RPAREN | SEMICOLON ->
          let MenhirCell1_exp (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_03 _1 _3 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_17 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState17
      | _ ->
          _eRR ()
  
  and _menhir_run_18 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_exp (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _3 = _v in
      let _v = _menhir_action_06 _1 _3 in
      _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_05 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ASSIGN ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | DIV | EOF | MINUS | PLUS | RPAREN | SEMICOLON | TIMES ->
          let _1 = _v in
          let _v = _menhir_action_02 _1 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_06 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_ID -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06
      | _ ->
          _eRR ()
  
  and _menhir_run_21 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF | SEMICOLON ->
          let MenhirCell1_ID (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_13 _1 _3 in
          _menhir_goto_stm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_19 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_exp -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState19
      | LPAREN ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState19
      | INT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _1 = _v in
          let _v = _menhir_action_01 _1 in
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState19 _tok
      | ID _v ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState19
      | _ ->
          _eRR ()
  
  and _menhir_run_20 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_exp as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF | MINUS | PLUS | RPAREN | SEMICOLON ->
          let MenhirCell1_exp (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_04 _1 _3 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_stm : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState26 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState02 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState03 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState19 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState15 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState13 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState11 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_29 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _menhir_stack = MenhirCell1_stm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOF ->
          let _1 = _v in
          let _v = _menhir_action_11 _1 in
          MenhirBox_prog _v
      | _ ->
          _eRR ()
  
  and _menhir_run_08 : type  ttv_stack. (ttv_stack, _menhir_box_prog) _menhir_cell1_stm -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState08
      | ID _v ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState08
      | _ ->
          _eRR ()
  
  and _menhir_run_09 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ASSIGN ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_10 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_stm as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _menhir_stack = MenhirCell1_stm (_menhir_stack, _menhir_s, _v) in
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF ->
          let MenhirCell1_stm (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_12 _1 _3 in
          _menhir_goto_stm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_stm (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | PRINT ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
          | LPAREN ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
          | INT _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _1 = _v_0 in
              let _v = _menhir_action_01 _1 in
              _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState11 _tok
          | ID _v_2 ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState11
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_12 : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_stm as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF | RPAREN | SEMICOLON ->
          let MenhirCell1_stm (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_07 _1 _3 in
          _menhir_goto_exp _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_exps : type  ttv_stack. ((ttv_stack, _menhir_box_prog) _menhir_cell1_PRINT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_PRINT (_menhir_stack, _menhir_s) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_14 _3 in
          _menhir_goto_stm _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | COMMA ->
          let _menhir_stack = MenhirCell1_exps (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | PRINT ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState26
          | LPAREN ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState26
          | INT _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _1 = _v_0 in
              let _v = _menhir_action_01 _1 in
              _menhir_run_27 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState26 _tok
          | ID _v_2 ->
              _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState26
          | _ ->
              _eRR ())
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_27 : type  ttv_stack. (((ttv_stack, _menhir_box_prog) _menhir_cell1_PRINT, _menhir_box_prog) _menhir_cell1_exps as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_prog) _menhir_state -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_exp (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | RPAREN ->
          let MenhirCell1_exps (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_10 _1 _3 in
          _menhir_goto_exps _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  let rec _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | PRINT ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | ID _v ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState00
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
