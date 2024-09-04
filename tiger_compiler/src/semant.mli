type venv = Env.enventry Symbol.table
type tenv = Types.ty Symbol.table
type expty = Translate.exp * Types.ty

val transVar: venv -> tenv -> Absyn.var -> expty
val transExp: venv -> tenv -> Absyn.exp -> expty

val transDec: venv -> tenv -> Absyn.dec -> venv * tenv
val transTY: tenv -> Absyn.ty -> Types.ty