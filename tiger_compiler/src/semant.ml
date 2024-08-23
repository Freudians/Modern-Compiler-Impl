type venv = Env.enventry Symbol.table
type tenv = Types.ty Symbol.table
type expty = Translate.exp * Types.ty

(* evaluates an operand expression *)
let eval_op_exp (_, l) (_, r) pos = function
  | Absyn.EqOp | Absyn.NeqOp ->
    begin
    match (l, r) with
    | (Types.INT, Types.INT)
    | (Types.ARRAY _, Types.ARRAY _) ->
      ((), Types.INT)
    | _ -> ErrorMsg.error_no_recover pos 
    "equals/not-equals invoked with non-integer or non-array arguments"
    end
  | _ ->
    if l <> Types.INT || r <> Types.INT 
    then
      ErrorMsg.error_no_recover pos 
      "Arithematic operation invoked with non-integer arguments" 
    else
      ((), INT)

let rec transExp ve te aexp = 
          let rec trexp : Absyn.exp -> expty = function
        (*TODO: add handling for varexp*)
          | Absyn.VarExp v -> transVar ve te v
          | Absyn.NilExp -> (((), Types.NIL) : expty)
          | IntExp _ -> ((), INT)
          | StringExp (_, _) -> ((), STRING)
          | CallExp {func; args; pos} -> 
            begin 
              match Symbol.look ve func with
              | Some Env.FunEntry{formals; result} -> 
                if List.equal (fun x y -> x = y)
                    formals
                  (List.map (fun x -> let (_, t) = trexp x in t) args)
                then ((), result)
                else 
                  ErrorMsg.error_no_recover pos "Function arguments have invalid types"
              | Some Env.VarEntry {ty=_} ->
                ErrorMsg.error_no_recover pos "Variable invoked as function"
              | None -> 
                ErrorMsg.error_no_recover pos "Undefined function"
              end
          (*TODO: have eval_op_exp raise its own error*)
          | OpExp {left; oper; right; pos} -> 
            eval_op_exp (trexp left) (trexp right) pos oper
          | RecordExp {fields; typ; pos} ->
            begin
            match Symbol.look te typ with
              | Some real_ty -> 
                begin
                match real_ty with
                  | Types.RECORD (lst, _) ->
                    if List.equal
                (fun x y -> x = y)
                (List.fold_right (fun (_, ex, _) l -> 
                  let (_, ty) = trexp ex in
                  ty :: l) fields [])
                (List.fold_right (fun (_, ty2) l2 -> ty2 :: l2)
                lst [])
              then
                ((), real_ty)
              else
                ((), NIL)
            | _ -> ErrorMsg.error_no_recover pos "Type not record"
              end
            | None -> ErrorMsg.error_no_recover pos "Error: undefined type"
            end
          | SeqExp lst -> 
              (*ugly hack*)
              begin
              match lst with
              | [] -> ((), NIL)
              | [(e, _)] -> (trexp e)
              | (e, _) :: rest -> let _ = ((trexp e) : expty) in trexp (SeqExp rest)
              end
          | AssignExp {var=_; exp=_; pos=_} ->
            ((), NIL)
          | IfExp {test; then_; else_; pos} ->
            begin
            let (_, ty) = trexp test in
            match ty with
            | INT -> 
              begin
                match else_ with
                | None -> ((), NIL)
                | Some e2 -> 
                  let (_, ty2) = trexp then_ in
                  let (_, ty3) = trexp e2 in
                    if ty2 <> ty3 then
                      (*this is also an error state*)
                      ErrorMsg.error_no_recover pos "Mismatching types in else and then expression"
                    else
                      ((), Types.NIL)
                    end
            (*this is an error state*)
            | _ -> ErrorMsg.error_no_recover pos "Non-integer expression used in if test"
                  end
          | _ -> print_endline "Error: unexpected"; ((), Types.NIL)
        in trexp aexp

and transVar ve te avar =
    let rec trvar = function
      | Absyn.SimpleVar (sy, pos)-> 
        begin
        match Symbol.look ve sy with
        | Some Env.VarEntry{ty} -> ((), ty)
        | _ -> ErrorMsg.error_no_recover pos "Undefined variable" 
        end
      | Absyn.FieldVar (v, sy, pos) ->
        let (_, t) = trvar v in
        begin
          match t with
          | RECORD (lst, _) -> 
            let (_, rt) = 
             try List.find (fun (s, _) -> s = sy) lst with
             | Not_found -> ErrorMsg.error_no_recover pos ("Variable not found in record"); 
          in
            ((), rt)
          | _ -> ErrorMsg.error_no_recover pos "Variable isn't a record"; 
        end
      | SubscriptVar (v, ex, pos) ->
        let (_, t) = trvar v in 
        begin
          match t with
          | ARRAY (t2, _) -> 
            let (_, t3) = transExp ve te ex in
            begin
              match t3 with
              | Types.INT -> ((), t2)
              | _ -> ErrorMsg.error_no_recover pos "Bad array index"
            end
          | _ -> ErrorMsg.error_no_recover pos "Variable isn't an array; integer subscript can't be used"
          end
    in trvar avar
