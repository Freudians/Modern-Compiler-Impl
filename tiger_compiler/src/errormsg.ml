module type ERRORMSG = sig
  val anyErrors : bool ref
  val fileName : string ref
  val lineNum : int ref
  val linePos : int list ref
  val sourceStream : in_channel ref
  val error : int -> string -> unit
  exception Error
  val impossible : string -> 'a   (* raises Error *)
  val reset : unit -> unit
end

module ErrorMsg : ERRORMSG = struct
  let anyErrors = ref false
  let fileName = ref ""
  let lineNum = ref 1
  let linePos = ref [1]
  let sourceStream = ref stdin

  let reset () =
    anyErrors := false;
    fileName := "";
    lineNum := 1;
    linePos := [1];
    sourceStream := stdin

  exception Error

  let error pos msg =
    let rec look = function
      | a :: rest, n ->
          if a < pos then
            Printf.printf ":%d.%d" n (pos - a)
          else
            look (rest, n - 1)
      | _ -> print_string "0.0"
    in
    anyErrors := true;
    print_string !fileName;
    look (!linePos, !lineNum);
    print_string ":";
    print_string msg;
    print_newline ()

  let impossible msg =
    Printf.printf "Error: Compiler bug: %s\n" msg;
    flush stdout;
    raise Error
end