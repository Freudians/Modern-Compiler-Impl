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
(* Formally: the expression type monad! *)
(* The box: 't is the expression*)
(* functions: type -> b 't*)

let rec transExp ve te aexp = 
          (*gets the type of an expression *)
          let rec exp_type exp = 
            let (_, typ) = trexp exp in typ
          (*checks if exp is of type ref_typ*) 
          and is_type exp ref_typ = 
                if (exp_type exp) = ref_typ then true else false
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
                if List.equal (=) formals (List.map exp_type args) then 
			        ((), result)
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
                    if List.equal (=) (List.map (fun (_, ex, _) -> (exp_type ex)) fields) 
                        (List.map (fun (_, ty2) -> ty2 ) lst)
                    then
                        ((), real_ty)
                    else
                        ErrorMsg.error_no_recover pos "Type mismatch with record"
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
          | AssignExp {var; exp; pos} ->
            (*TODO: check if var can actually be assigned-to*)
              let (_, vartyp) = transVar ve te var in
                if is_type exp vartyp then 
                  ((), NIL)
                else
                  ErrorMsg.error_no_recover pos "Type mismatch in assignment"
          | IfExp {test; then_; else_; pos} ->
            begin
            let (_, ty) = trexp test in
            match ty with
            | INT -> 
              begin
                match else_ with
                | None -> 
                    if is_type then_ NIL then
                      ((), NIL)
                    else
                      ErrorMsg.error_no_recover pos "Body of if loop returns type"
                | Some e2 -> 
                if is_type then_ NIL then 
                  if exp_type then_ <> exp_type e2 then
                      ErrorMsg.error_no_recover pos "Mismatching types in else and then expression"
                    else
                      ((), Types.NIL)
                else
                    ErrorMsg.error_no_recover pos "Body of if loop returns type"
                    end
            (*this is an error state*)
            | _ -> ErrorMsg.error_no_recover pos "Non-integer expression used in if test"
            end
          | WhileExp {test; body; pos} -> 
            begin
            if is_type test INT then
              if is_type body NIL then
                ((), Types.NIL)
              else
                ErrorMsg.error_no_recover pos
                "Body of while expression returns a value"
            else
              ErrorMsg.error_no_recover pos 
              "Non-integer expression used in while test"
            end
          | ForExp {var=_; escape=_; lo; hi; body; pos} ->
            if is_type lo INT then
              if is_type hi INT then
                if is_type body NIL then
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
          | LetExp {decs; body; pos=_} ->
            let (ve_, te_) = List.fold_left (fun (ve__, te__) d -> transDec ve__ te__ d) (ve, te) decs 
              in
            transExp ve_ te_ body
          | ArrayExp {typ; size; init; pos} ->
            if is_type size INT then
              begin
              match Symbol.look te typ with
                | Some sym -> 
                  begin
                  match sym with
                    | Types.ARRAY (elemty, _) ->
                      if is_type init elemty then
                        ((), sym)
                      else
                        ErrorMsg.error_no_recover pos "Type-initializer mismatch"
                    | _ -> 
                      ErrorMsg.error_no_recover pos "Type isn't an array"
                  end
                | None -> ErrorMsg.error_no_recover pos "ArrayExp: Undefined type"
                  end
                else
                  ErrorMsg.error_no_recover pos "Size expression isn't an int"
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
  | Absyn.VarDec {name; escape=_; typ; init; _} ->
    begin
    match typ with
    | Some (sy, sympos) -> 
        begin
          match Symbol.look te sy with
          | Some ref_ty -> 
            begin
            if check_res (transExp ve te init) ref_ty then
              (Symbol.enter ve name (Env.VarEntry{ty=ref_ty}), te)
            else
              ErrorMsg.error_no_recover sympos
              "Expression doesn't match type"
            end
          | None -> ErrorMsg.error_no_recover sympos
          "VarDec: Undefined type"
          end
    | None -> 
      (Symbol.enter ve name (Env.VarEntry{ty= (let (_, ty_) = transExp ve te init in ty_)}), te)
    end
  | TypeDec (tylst) -> 
    
    let enter_ty te_ Absyn.{name; ty; _} =
      Symbol.enter te_ name (transTy te_ ty) 
    in
    (ve, List.fold_left enter_ty te tylst)
  | FunctionDec (funlst) ->
    (*TODO: finish up function dec checker*)
    let field_to_sym Absyn.{name=_; escape=_; typ; pos}  = 
      match Symbol.look te typ with
      | Some typ_ -> typ_
      | None -> ErrorMsg.error_no_recover pos 
        "Undefined type"
    in
    let enter_func ve_ Absyn.{name; params; result=res; body; pos} =
      begin
      match res with
      | Some (sym, sympos) -> 
        begin
          match Symbol.look te sym with
          | Some typ_ -> 
            if (check_res (transExp ve te body) typ_) then
              Symbol.enter ve_ name 
              (Env.FunEntry {formals = List.map field_to_sym params; result=typ_})
            else
              ErrorMsg.error_no_recover pos "Type annotation doesn't match function body"
          | None -> ErrorMsg.error_no_recover sympos "Undefined type"
        end
      | None -> 
        begin
          Symbol.enter ve_ name 
          (Env.FunEntry{formals = List.map field_to_sym params; result = let (_, typ_) = (transExp ve te body) in typ_})
        end
      end
    in 
    (List.fold_left enter_func ve funlst, te)
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
  | ArrayTy (sym, pos) ->
    match Symbol.look te sym with
    | Some typ -> Types.ARRAY (typ, ref ())
    | None -> ErrorMsg.error_no_recover pos
    "Undefined type"
