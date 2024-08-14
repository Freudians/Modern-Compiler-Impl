%{
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
%type <unit> program

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
  | exp EOF { () }

exp:
  | NIL { }
  | LPAREN expseq RPAREN { }
  | ID LPAREN funcexpseq RPAREN { }
  | ID LPAREN RPAREN { }
  | arith { }
  | comp { }
  | bool { }
  | ID LBRACE idexpseq RBRACE { }
  | ID LBRACE RBRACE { }
  | ID LBRACK exp RBRACK OF exp { }
  | IF exp THEN exp ELSE exp { }
  | IF exp THEN exp { }
  | WHILE exp DO exp { }
  | FOR stmt TO exp DO exp { }
  | BREAK { }
  | LET decs IN expseq END { } 
  | ID { }
  | INT { }
  | STRING { }
  | lvalue { }
  | stmt { }
  | LPAREN RPAREN { }
stmt:
  | ID ASSIGN exp { }
  | lvalue ASSIGN exp { }
funcexpseq:
  | exp { }
  | exp COMMA funcexpseq { }
idexpseq: 
  | ID EQ exp { }
  | ID EQ exp COMMA idexpseq { }
arith:
  | exp PLUS exp { }
  | exp MINUS exp { }
  | exp TIMES exp {   }
  | exp DIVIDE exp { }
  | MINUS exp  %prec UMINUS { }

comp:
  | exp EQ exp { }
  | exp LE exp { }
  | exp GE exp { }
  | exp GT exp { }
  | exp LT exp { }
  | exp NEQ exp { }
bool:
  | exp AND exp { }
  | exp OR exp { }
expseq:
  | exp { }
  | exp SEMICOLON expseq { }
decs :
  | dec decs { }
  | { }

dec :
  | tydec { }
  | vardec { }
  | fundec { }
tydec :
  | TYPE type_id EQ ty { }
ty :
  | type_id { }
  | LBRACE tyfields RBRACE { }
  | ARRAY OF type_id { }

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