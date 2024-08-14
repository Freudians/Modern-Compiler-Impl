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
let prog = 
	CompoundStm (AssignStm ("a", OpExp(NumExp 5, Plus, NumExp 3)),
		CompoundStm(AssignStm("b", 
			EseqExp(PrintStm [IdExp "a"; OpExp(IdExp "a", Minus, NumExp 1)]) 
		OpExp(NumExp 10, Times, IdExp "a")),
	PrintStm[IdExp "b"]))
let _ = print_endline (string_of_int (maxargs prog))
