%{
  open Absyn
%}

%token EOF
%token <string> ID
%token <int> INT
%token <string> STRING
%token COMMA COLON SEMICOLON LPAREN RPAREN LBRACK RBRACK
%token LBRACE RBRACE DOT
%token PLUS MINUS TIMES DIVIDE EQ NEQ LT LE GT GE
%token AND OR ASSIGN
%token ARRAY IF THEN ELSE WHILE FOR TO DO LET IN END OF
%token BREAK NIL
%token FUNCTION VAR TYPE

%start program
%type <Absyn.exp> program

%nonassoc THEN
%nonassoc ELSE
%nonassoc LPAREN

%right OF
%nonassoc DO

%left SEMICOLON
%left ASSIGN
%left OR
%left AND
%nonassoc EQ NEQ LT LE GT GE
%left PLUS MINUS
%left TIMES DIVIDE

%nonassoc UMINUS

%%

program:
  | exp EOF { $1 }

exp:
  | NIL 
  { NilExp }
  | LPAREN expseq RPAREN 
  { SeqExp($2) }
  | ID LPAREN funcexpseq RPAREN 
  { CallExp {func=Symbol.symbol $1; 
            args = $3;
            pos = $startpos}}
  | ID LPAREN RPAREN 
  { 
    CallExp {func = Symbol.symbol $1;
            args = [];
            pos = $startpos}
  }
  | arith { 
    $1
  }
  | comp { 
    $1
  }
  | bool { 
    $1
  }
  | ID LBRACE idexpseq RBRACE { 
    RecordExp {fields = $3; typ = Symbol.symbol $1; pos = $startpos}
  }
  | ID LBRACE RBRACE { 
    RecordExp {fields = []; typ = Symbol.symbol $1; pos = $startpos}
  }
  | ID LBRACK exp RBRACK OF exp { 
      ArrayExp {typ = Symbol.symbol $1; 
      size = $3;
      init = $6;
      pos = $startpos}
  }
  | IF exp THEN exp ELSE exp { 
    IfExp {
      test = $2;
      then' = $4;
      else' = Some $6;
      pos = $startpos
    }
  }
  | IF exp THEN exp { 
    IfExp {
      test = $2;
      then' = $4;
      else' = None;
      pos = $startpos
    }
  }
  | WHILE exp DO exp { 
    WhileExp {
      test = $2;
      body = $4;
      pos = $startpos
    }
  }
  | FOR ID ASSIGN exp TO exp DO exp { 
    ForExp {
      var = Symbol.symbol $2;
      escape = ref true;
      lo = $4;
      hi = $6;
      body = $8;
      pos = $startpos
    }
  }
  | BREAK { 
    BreakExp ($startpos)
  }
  | LET decs IN expseq END { 
    LetExp {
      decs = $2;
      body = SeqExp($4);
      pos = $startpos
    }
  } 
  | ID { 
    VarExp (SimpleVar (Symbol.symbol $1, $startpos))
  }
  | INT { 
    IntExp ($1)
  }
  | STRING { 
    StringExp ($1, $startpos)
  }
  | lvalue { 
    VarExp($1)
  }
  | stmt { 
    $1
  }
  | LPAREN RPAREN { 
    NilExp
  }
stmt:
  | ID ASSIGN exp { 
    AssignExp {
      var = Symbol.symbol $1;
      exp = $3;
      pos = $startpos;
    }
  }
  | lvalue ASSIGN exp { 
    AssignExp {
      var = $1;
      exp = $3;
      pos = $startpos;
    }
  }
funcexpseq:
  | exp { 
    [$1]
  }
  | exp COMMA funcexpseq { $1 :: $3 }
idexpseq: 
  | ID EQ exp { 
    [(Symbol.symbol $1, $3, $startpos)]
  }
  | ID EQ exp COMMA idexpseq { 
    (Symbol.symbol $1, $3, $startpos) :: $5
  }
arith:
  | exp PLUS exp { 
    OpExp {
      left = $1;
      oper = PlusOp;
      right = $3;
      pos = $startpos;
    }
  }
  | exp MINUS exp { 
    OpExp {
      left = $1;
      oper = MinusOp;
      right = $3;
      pos = $startpos
    }
  }
  | exp TIMES exp {   
    OpExp {
      left = $1;
      oper = TimesOp;
      right = $3;
      pos = $startpos
    }
  }
  | exp DIVIDE exp { 
    OpExp {
      left = $1;
      oper = DivideOp;
      right = $3;
      pos = $startpos
    }
  }
  | MINUS exp  %prec UMINUS { 
    OpExp {
      left = IntExp (0);
      oper = MinusOp;
      right = $2;
      pos = $startpos
    }
  }

comp:
  | exp EQ exp { 
    OpExp {
      left = $1;
      oper = EqOp;
      right = $3;
      pos = $startpos
    }
  }
  | exp LE exp { 
    left = $1;
    oper = LeOp;
    right = $3;
    pos = $startpos
  }
  | exp GE exp { 
    left = $1;
    oper = GeOp;
    right = $3;
    pos = $startpos
  }
  | exp GT exp { 
    left = $1;
    oper = GtOp;
    right = $3;
    pos = $startpos
  }
  | exp LT exp { 
    left = $1;
    oper = LtOp;
    right = $3;
    pos = $startpos
  }
  | exp NEQ exp { 
    left = $1;
    oper = NeqOp;
    right = $3;
    pos = $startpos
  }
bool:
  | exp AND exp { 
    IfExp
    {
      test = $1;
      then' = $3;
      else' = Some (IntExp 0)
    }
  }
  | exp OR exp { 
    IfExp
    {
      test = $1;
      then' = Some (IntExp 1);
      else' = $3
    }
  }
expseq:
  | exp { 
    [($1, $startpos)]
  }
  | exp SEMICOLON expseq { 
    ($1, $startpos) :: $3
  }
decs :
  | dec decs { $1 :: $2}
  | { [] }

dec :
  | tydec { TypeDec($1) }
  | vardec { $1 }
  | fundec { $1 }
tydecs:
  | tydec tydecs { 
    $1 :: $2
  }
  | tydec { [$1] }
tydec :
  | TYPE type_id EQ ty { 
    {name= $2; ty = $4; pos = $startpos}
  }
ty :
  | type_id { 
    NameTy ($1 , $startpos)
  }
  | LBRACE tyfields RBRACE { 
    RecordTy ($2)
  }
  | ARRAY OF type_id { 
    ArrayTy ($3 , $startpos)
  }

tyfields :
  | ID COLON type_id { }
  | ID COLON type_id COMMA tyfields { }
  | { }

vardec :
  | VAR ID ASSIGN exp { }
  | VAR ID COLON type_id ASSIGN exp { }

fundec : 
  | FUNCTION ID LPAREN tyfields RPAREN EQ exp { }
  | FUNCTION ID LPAREN tyfields RPAREN COLON type_id EQ exp { }

lvalue :
  | ID DOT ID dot_id_helper{ }
  | lvalue LBRACK exp RBRACK { }
  | ID LBRACK exp RBRACK { }
dot_id_helper:
  | { }
  | DOT ID { }
type_id :
  | ID { }
%%