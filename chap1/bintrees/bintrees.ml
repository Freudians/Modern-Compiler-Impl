type key = string
type tree = LEAF | TREE of tree * key * tree
let empty = LEAF

let rec insert k root = match root with
	| LEAF -> TREE(LEAF, k, LEAF)
	| TREE (l, ke, r) ->
		if k > ke then
			TREE(l, ke, (insert k r))
		else if ke > k then
			TREE((insert k l), ke, r)
		else 
			TREE(l,ke, r)


let rec member k root = 
	match root with
	| LEAF -> false
	| TREE (l, cur_k, r) ->
		if cur_k = k then true
		else if cur_k < k then
			member k r
		else 
			member k l
let tr = insert "t" LEAF
let tr = insert "s" tr
let tr = insert "p" tr
let tr = insert "i" tr
let tr = insert "p" tr
let tr = insert "f" tr
let tr = insert "b" tr
let tr = insert "s" tr
let tr = insert "t" tr

let sec_tr = insert "a" LEAF
let sec_tr = insert "b" sec_tr
let sec_tr = insert "c" sec_tr
let sec_tr = insert "d" sec_tr
let sec_tr = insert "e" sec_tr
let sec_tr = insert "f" sec_tr
let sec_tr = insert "g" sec_tr
let sec_tr = insert "h" sec_tr
let sec_tr = insert "i" sec_tr

(*algo: balanced red-black trees?*)
