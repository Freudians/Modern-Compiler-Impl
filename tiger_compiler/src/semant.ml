type venv = Env.enventry Symbol.table
type tenv = Types.ty Symbol.table
type expty = Translate.exp * Types.ty

(* evaluates an operand expression *)
let eval_op_exp (_, l) (_, r)  = function
  | Absyn.EqOp | Absyn.NeqOp ->
    begin
    match (l, r) with
    | (Types.INT, Types.INT)
    | (Types.ARRAY _, Types.ARRAY _) ->
      ((), Types.INT)
    | _ -> print_endline("Error: equals/not-equals
    invoked with non-integer or non-array args"); ((), NIL)
    end
  | _ ->
    if l <> Types.INT || r <> Types.INT 
    then
    begin
      print_endline("error: arithmatic operation
    invoked with non-intger args"); 
    ((), Types.NIL)
    end
    else
      ((), INT)

let transVar ve te avar =
    let rec trvar = function
      | Absyn.SimpleVar (sy, _)-> 
        match Symbol.look ve sy with
        | Some Env.VarEntry{ty} -> ((), ty)
        | _ -> print_endline "error: undefined variable"; ((), NIL)
      (*| Absyn.FieldVar (v, sy, _) ->
        TODO*)
      | _ -> ((), NIL)
    in trvar avar
let transexp ve te aexp = 
  let rec trexp = function
  (*TODO: add handling for varexp*)
    | Absyn.NilExp -> (((), Types.NIL) : expty)
    | IntExp i -> ((), INT)
    | StringExp (s, _) -> ((), STRING)
    | CallExp {func; args; _} -> 
      begin 
        match Symbol.look ve func with
        | Some Env.FunEntry{formals; result} -> 
          if List.equal (fun x y -> x = y)
              formals
            (List.map (fun x -> let (_, t) = trexp x in t) args)
          then ((), result)
          else 
            begin
            print_endline "Error: function called with invalid types";
            ((), Types.NIL)
            end
        | Some Env.VarEntry {ty=_} -> print_endline "Error: variable
        used as function"; ((), Types.NIL)
        | None -> print_endline "Error: undefined function"; 
        ((), Types.NIL)
        end
    | OpExp {left; oper; right; _} -> 
      eval_op_exp (trexp left) (trexp right) oper
    | _ -> print_endline "Error: unexpected"; ((), Types.NIL)
  in trexp aexp