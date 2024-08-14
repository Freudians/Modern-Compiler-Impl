    type table = string -> int
    let update t id n = fun i -> if i = id then n else t i
    let emptytable = fun _ -> raise Not_found
    let unpack (e1 : table * int list -> (table * int * int list)) op (e2 : table * int list -> (table * int * int list)) = 
        fun t lst -> let (nt, v1, l1) = (e1 (t, lst)) in
                                    let (ft, v2, l2) = (e2 (nt, l1)) in
                                        (ft, op v1 v2, l2)
