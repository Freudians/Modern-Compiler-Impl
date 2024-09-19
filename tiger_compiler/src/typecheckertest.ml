let typecheck filename =
  let ic = open_in filename in
    let lexbuf = Lexing.from_channel ic in
    let result = lexbuf |> (Grammar.program TigerLexer.token) |> 
    Semant.transExp Env.base_venv Env.base_tenv
    in
    close_in ic;
    result
let%test "typecheck_1" = 
  typecheck "/home/anthonydu/appel/tiger_compiler/sample_programs/test1.tig"
  = ((), Types.ARRAY (Types.INT, ref ()))
