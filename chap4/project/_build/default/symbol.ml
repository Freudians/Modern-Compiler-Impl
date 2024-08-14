  type t = string * int
  module H = Hashtbl

  (*exception Symbol*)
  let nextsym = ref 0
  let size_hint = 128
  let hashtable = H.create size_hint
  let symbol name = 
    let count = 
    try H.find hashtable name with
    | Not_found -> 
      let i = !nextsym in
        nextsym := i + 1;
        H.add hashtable name i; 
        i
    in
      (name, count)
  let name (n, _) = n
  
