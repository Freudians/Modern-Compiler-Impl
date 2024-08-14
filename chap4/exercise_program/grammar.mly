%{
open Table_helper
(*[transform_to_list f] converts a function f which is the form [table -> (table * int)] into a function f 
of the form [table -> (table * int * int list)]. *)
let transform_to_list f = let ()
%}

%token<int> INT
%token<string> ID
%token PLUS MINUS TIMES DIV ASSIGN PRINT LPAREN RPAREN COMMA SEMICOLON EOF

(*TODO: statements also need to take int lists as arguments now *)
%type<(table * int list) -> (table * int * int list)> exp
%type<table -> (table * int list)> stm
%type <(table * int list) -> (table * int list)> exps
%type <table> prog
%right SEMICOLON
%left PLUS MINUS
%left TIMES DIV

%start prog
%%
prog:
| stm EOF {$1(emptytable)} 


stm :
| stm SEMICOLON stm {fun t -> let (ti, int1) = $1 t in let (tf, int2) = $3 ti in (tf, int1 @ int2)}
| ID ASSIGN exp {fun t -> update t $1 (let (_, v) = $3 t in v)}
| PRINT LPAREN exps RPAREN {fun t -> $3 t}

exps:
| exp {fun (t,lst) -> let (ta, v, flst) = $1 (t,lst) in (ta, flst)}
| exps COMMA exp {fun (t,lst) -> ( let (tn, i_list) = $1 (t,lst) in let (ta, v, other_lst) = $3 (tn, i_lst) in  (ta, v :: other_lst))}

exp:
| INT {fun (t, lst) -> (t, $1, lst)}
| ID {fun (t, lst) -> (t, t $1, lst)}
| exp PLUS exp  
{unpack $1 ( + ) $3}
| exp MINUS exp {unpack $1 ( - ) $3}
| exp TIMES exp {unpack $1 ( * ) $3}
| exp DIV exp {unpack $1 ( / ) $3}
| stm COMMA exp {fun t lst -> let (tf, l) = $1 t in $3(tf, l)}
| LPAREN exp RPAREN { $2 }