
let log format =
  Fmt.(kpf (fun formatter -> Format.pp_print_newline formatter ())
         stderr format)

let make_code_expr expr =
  let source = Ast.string (Marshal.to_string expr []) in
  [%expr Code.make [%e expr] (Marshal.from_string [%e source] 0)]



let rec quasiquote expr =
  let open Parsetree in
  match expr.pexp_desc with
  (* Apply: [!! code] *)
  | Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "!!"}},
                [(Nolabel, ({pexp_desc = Pexp_ident {txt = Lident name}} as code))]) ->
    log "-- Will lookup name [%s]" name;
    [%expr Code.run [%e code]]

  | Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "!!"}}, [(Nolabel, code)]) ->
    [%expr Code.run [%e code]]

  | Pexp_apply (f, xs) ->
    let f' = quasiquote f in
    let xs' = List.map (fun (label, x) -> (label, quasiquote x)) xs in
    { expr with pexp_desc = Pexp_apply (f', xs') }

  | _ -> expr


let rec expr_mapper mapper expr =
  let open Parsetree in
  match expr.pexp_desc with
  (* Apply: [code expr] *)
  | Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "code"}}, [(Nolabel, expr)]) ->
    expr
    |> quasiquote
    |> make_code_expr
    |> expr_mapper mapper

  | _ ->
    Ast_mapper.default_mapper.expr mapper expr


let () =
  let rewriter config cookies =
    Ast_mapper.{ default_mapper with expr = expr_mapper } in
  let open Migrate_parsetree in
  Driver.register ~name:"ppx_code" Versions.ocaml_406 rewriter


