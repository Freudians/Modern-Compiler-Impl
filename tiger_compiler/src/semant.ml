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
(* checks if the result of an expression is [ref_typ] *)
let check_res ((_, ty) : expty) ref_typ = 
  if ty = ref_typ then true else false


let rec transExp ve te aexp = 
          (*gets the type of an expression *)
          let rec exp_type exp = 
            let (_, typ) = trexp exp in typ
          (*evaluates an expression*)
          and trexp : Absyn.exp -> expty = function
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
                  (List.map exp_type args)
                then ((), result)
                else 
                  ErrorMsg.error_no_recover pos "Function arguments have invalid types"
              | Some Env.VarEntry {ty=_} ->
                ErrorMsg.error_no_recover pos "Variable invoked as function"
              | None -> 
                ErrorMsg.error_no_recover pos "Undefined function"
              end
          | OpExp {left; oper; right; pos} -> 
            eval_op_exp (trexp left) (trexp right) pos oper
          | RecordExp {fields; typ; pos} ->
            begin
            match Symbol.look te typ with
              | Some real_ty -> 
                begin
                match real_ty with
                  | Types.RECORD (lst, _) ->
                (*Algo: Fold is used to construct a list of types
                out of both the fields and the list in the record. List
                is then compared to ensure equality*)
                    if List.equal
                (fun x y -> x = y)
                (List.fold_right (fun (_, ex, _) l -> 
                  (exp_type ex) :: l) fields [])
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
                  if exp_type then_ <> exp_type e2 then
                      ErrorMsg.error_no_recover pos "Mismatching types in else and then expression"
                    else
                      ((), Types.NIL)
                    end
            (*this is an error state*)
            | _ -> ErrorMsg.error_no_recover pos "Non-integer expression used in if test"
            end
          | WhileExp {test; body; pos} -> 
            begin
            if check_res (trexp test) INT then
              if check_res (trexp body) NIL then
                ((), Types.NIL)
              else
                ErrorMsg.error_no_recover pos
                "Body of while expression returns a value"
            else
              ErrorMsg.error_no_recover pos 
              "Non-integer expression used in while test"
            end
          | ForExp {var=_; escape=_; lo; hi; body; pos} ->
            if check_res (trexp lo) INT then
              if check_res (trexp hi) INT then
                if check_res (trexp body) NIL then
                  ((), NIL)
                else
                  ErrorMsg.error_no_recover pos
                  "Body of for statement returns value"
              else
                ErrorMsg.error_no_recover pos
                "High of for statement is not an integer"
            else
              ErrorMsg.error_no_recover pos
              "Low of for statement is not an integer"
          | BreakExp (_) ->
            ((), NIL)
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
and transDec ve te (adec : Absyn.dec) = 
  let trdec = function
  | Absyn.VarDec {name; escape=_; typ; init; pos} ->
    begin
    match typ with
    | Some (sy, pos) -> 
        begin
          match Symbol.look te sy with
          | Some ref_ty -> 
            begin
            if check_res (transExp ve te init) ref_ty then
              (Symbol.enter ve name (Env.VarEntry{ty=ref_ty}), te)
            else
              ErrorMsg.error_no_recover pos
              "Expression doesn't match type"
            end
          | None -> ErrorMsg.error_no_recover pos
          "Undefined type"
          end
    | None -> 
      (Symbol.enter ve name (Env.VarEntry{ty= (let (_, ty_) = transExp ve te init in ty_)}), te)
    end
  | TypeDec (tylst) -> 
    let enter_ty Absyn.{name; ty; _} te_ =
      Symbol.enter te_ name (transTy te_ ty) 
    in
    (ve, List.fold_right enter_ty tylst te)
  | _ -> (ve, te)
  in trdec adec
and transTy te aty =
  match aty with
  | NameTy (sym, pos) ->
    begin
    match Symbol.look te sym with
    | Some typ -> typ
    | None -> 
      ErrorMsg.error_no_recover pos
      "Undefined type"
    end
  | RecordTy (flst) ->
    let field_to_sym Absyn.{name; escape=_; typ; pos}  = 
      match Symbol.look te typ with
      | Some typ_ -> (name, typ_)
      | None -> ErrorMsg.error_no_recover pos 
        "Undefined type"
    in
      Types.RECORD (List.map (fun f -> field_to_sym f) flst, ref ())
  | _ -> Types.NIL
