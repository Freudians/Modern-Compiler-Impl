module Parse = struct
  let parse filename =
    let file = open_in filename in
    let lexbuf = Lexing.from_channel file in
    let rec do_it () =
      let t = Lexer.token lexbuf in
      print_endline t;
      if String.sub t 0 3 = "EOF" then
        ()
      else
        do_it ()
    in
    do_it ();
    close_in file
end
