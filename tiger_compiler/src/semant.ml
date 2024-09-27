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

let unwrap_name typ =
  match typ with
  | Types.NAME (_, real_t) ->
    begin
    match !real_t with
    | Some real_typ_ -> real_typ_
    | None -> typ
    end
  | _ -> typ
let type_eq t1 t2 =
  match (unwrap_name t1), (unwrap_name t2) with
  | Types.RECORD _, Types.NIL -> true
  | Types.NIL, Types.RECORD _ -> true
  | _, _ -> (unwrap_name t1) = (unwrap_name t2)
(* checks if the result of an expression is [ref_typ] *)
let check_res ((_, ty) : expty) ref_typ = 
  type_eq ty ref_typ
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
          and type_lookup sym pos =
              match Symbol.look te sym with
              | Some typ ->
                  begin
                  match typ with
                  | Types.NAME (_, typ_body) -> 
                    begin
                    match !typ_body with
                    | Some real_typ -> real_typ
                    | None -> typ
                    end
                  | _ -> typ
                  end
              | None -> ErrorMsg.error_no_recover pos "Undefined type"
            and type_eq t1 t2 =
              match t1, t2 with
              | Types.RECORD _, Types.NIL -> true
              | Types.NIL, Types.RECORD _ -> true
              | _, _ -> t1 = t2
          and trexp : Absyn.exp -> expty = function
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
            match type_lookup typ pos with
            | Types.RECORD (lst, _)-> 
              if List.equal (type_eq) (List.map (fun (_, ex, _) -> (
                  let ex_typ = exp_type ex in
                  match ex_typ with
                  | Types.NAME (_, type_body) ->
                    begin
                    match !type_body with
                    | Some real_type -> real_type
                    | None -> ex_typ
                    end
                  | _ -> ex_typ
                )) fields) 
                (List.map (fun (_, ty2) -> match ty2 with
                  | Types.NAME (_, type_body) ->
                    begin
                      match !type_body with
                      | Some real_type -> real_type
                      | None -> ty2
                    end
                  | _ -> ty2
                 ) lst)
              then
                ((), type_lookup typ pos)
              else
                ErrorMsg.error_no_recover pos "Type mismatch with record"
            | _ -> ErrorMsg.error_no_recover pos "Type isn't a record"
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
    (*First builds a modified symbol table containing all of the names,
      then fills in the symbol table with their actual types*)
    let te_rec = 
      List.fold_left 
      (fun tab Absyn.{name; ty=_; pos=_} -> 
        Symbol.enter tab name (Types.NAME (name, ref None)))
      te tylst
    in
    let enter_ty te_ Absyn.{name; ty; _} =
      match Symbol.look te_ name with
      | Some typ_ ->
          begin
          match typ_ with
          | Types.NAME (_, type_body) ->
              type_body := Some (transTy te_ ty); te_
          | _ -> Symbol.enter te_ name (transTy te_ ty)
          end
      | None -> Symbol.enter te_ name (transTy te_ ty)
    in
    (ve, List.fold_left enter_ty te_rec tylst)
  | FunctionDec (funlst) ->
    (*TODO: finish up function dec checker*)
    let field_to_sym Absyn.{name=_; escape=_; typ; pos}  = 
      match Symbol.look te typ with
      | Some typ_ -> typ_
      | None -> ErrorMsg.error_no_recover pos 
        "Undefined type"
    in
    (*Get the headers of all the funcs*)
    let ve_rec = 
      List.fold_left 
      (fun tab Absyn.{name; params; result=_; body=_; pos=_} -> 
      Symbol.enter tab name 
      (Env.FunEntry{formals= List.map field_to_sym params; result = Types.NAME (name, ref None)})) 
      ve funlst
    in
    let enter_func ve_ Absyn.{name; params; result=res; body; pos} =
      begin
      match res with
      | Some (sym, sympos) -> 
        begin
          match Symbol.look te sym with
          | Some typ_ -> 
            if (check_res (transExp ve te body) typ_) then
              begin
              match Symbol.look ve_ name with
              | Some unparsedF -> 
                begin
                match unparsedF with
                | Env.FunEntry{formals=_; result=existingResult} ->
                  begin
                  match existingResult with
                  | Types.NAME (_, actualExistingResult) -> actualExistingResult := Some typ_; ve_
                  | _ -> ve_
                  end
                | _ -> ErrorMsg.error_no_recover pos "Previously entered type not a function"
                end
              | None ->  Symbol.enter ve_ name  (Env.FunEntry {formals = List.map field_to_sym params; result=typ_})
              end
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
    (List.fold_left enter_func ve_rec funlst, te)
  in trdec adec
and transTy te aty =
(*TODO: update to handle recursive types/instances of NAME*)
  let type_lookup sym pos = 
    match Symbol.look te sym with
    | Some typ -> 
      begin
      (*We have mutual recursion now....*)
      match typ with
      | Types.NAME (_, type_wrapper) ->
        begin
        match !type_wrapper with
        | Some real_typ -> real_typ
        | None -> typ (*type hasn't been filled-in, return wrapper*)
        end
      | _ -> typ
      end
    | None -> ErrorMsg.error_no_recover pos "Undefined type"
  in
  match aty with
  | NameTy (sym, pos) -> type_lookup sym pos
  | RecordTy (flst) ->
    let field_to_sym Absyn.{name; escape=_; typ; pos}  = 
      (name, type_lookup typ pos)
    in
      Types.RECORD (List.map (fun f -> field_to_sym f) flst, ref ())
  | ArrayTy (sym, pos) -> Types.ARRAY((type_lookup sym pos), ref ())
