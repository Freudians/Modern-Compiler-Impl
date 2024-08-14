type id = string
type binop = Plus | Minus | Times 
type stm = CompoundStm of stm * stm
	| AssignStm of id * exp
	| PrintStm of exp list
	and exp = IdExp of id
		| NumExp of int
		| OpExp of exp * binop * exp
		| EseqExp of stm * exp

let rec maxargs : stm -> int = function
	| CompoundStm (stm1, stm2) -> 
		let x = maxargs stm1 in
		let y = maxargs stm2 in
		if x > y then x else y
	| AssignStm (_, ex) ->
		begin
		match ex with
		| EseqExp (stm1, _) -> maxargs stm1
		| _ -> 0
		end
	| PrintStm (expl) ->
		let x = List.length expl in
		(*what the fuck*)
		let y = (List.fold_left (fun num ex ->
			match ex with
			| EseqExp (st, _) -> let z = (maxargs st) in 
				if num > z then num else z
			| _ -> num) 0 expl) in
		if x > y then x else y

type var_mapping = id * int
let update table name value =
	(name, value) :: table
let rec lookup table name =
	match table with
	| (maybe_id, v) :: rest -> if maybe_id = name then v else lookup rest name
	| [] -> -1
 	
let rec interpStm statement table =
begin
	match statement with
	| CompoundStm(stm1, stm2) ->
		interpStm stm1 table |> interpStm stm2
	| AssignStm(name, ex) ->
		let (new_val, new_table) = interpExp ex table in
		update new_table name new_val
	| PrintStm(exps) ->
		match exps with 
		curr_exp :: rest ->
		begin
		let (new_val, new_table) = interpExp curr_exp table in
		print_int new_val ; print_char ' '; interpStm (PrintStm(rest)) new_table
		end
		| [] -> print_endline ""; table
end
and interpExp ex table =
	match ex with
	| IdExp name -> (lookup table name, table)
	| NumExp num -> (num, table)
	| OpExp (lexp, op, rexp) -> 
		let (lx, newl_table) = interpExp lexp table in
		let (rx, newr_table) = interpExp rexp newl_table in
		begin 
		match op with
			| Plus -> (lx + rx, newr_table)
			| Minus -> (lx - rx, newr_table)
			| Times -> (lx * rx, newr_table)
		end
	| EseqExp (stm1, exp1) ->
		interpStm stm1 table |> interpExp exp1 

let interp statement =
	interpStm statement []; ()

let prog = 
	CompoundStm(AssignStm("a", OpExp(NumExp 5, Plus, NumExp 3)), 
		CompoundStm(AssignStm("b",
			EseqExp(PrintStm[IdExp"a"; OpExp(IdExp"a", Minus, NumExp 1)],
			OpExp(NumExp 10, Times, IdExp"a"))),
		PrintStm[IdExp"b"]))

