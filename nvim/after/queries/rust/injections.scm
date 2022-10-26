; extends

(macro_invocation
 (scoped_identifier
    path: (identifier) @_path (#eq? @_path "sqlx")
    name: (identifier) @_name (#match? @_name "query"))

 (token_tree
   (raw_string_literal) @sql) 
   (#offset! @sql 0 3 0 -2))
