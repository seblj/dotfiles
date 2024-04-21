; extends

(macro_invocation
    (scoped_identifier
        path: (identifier) @_path (#eq? @_path "sqlx")
        name: (identifier) @_name (#any-of? @_name "query" "query_as")
    )
    (token_tree
        (raw_string_literal) @injection.content
    )
    (#offset! @injection.content 0 3 0 -2)
    (#set! injection.language "sql")
)

(macro_invocation
    macro: (identifier) @_macro (#any-of? @_macro "fetch_optional" "fetch_all" "insert" "execute")
    (token_tree
      (raw_string_literal) @injection.content
    )
    (#offset! @injection.content 0 3 0 -2)
    (#set! injection.language "sql")
)

(call_expression
    (field_expression
        field: (field_identifier) @_field (#any-of? @_field "query" "execute")
    )
    (arguments
        (raw_string_literal) @injection.content
    )
    (#offset! @injection.content 0 3 0 -2)
    (#set! injection.language "sql")
)

; (macro_invocation
;     macro: (identifier) @_macro (#eq? @_macro "view")
;     (token_tree) @injection.content
;     (#set! injection.language "rust_with_rstml")
;     (#set! injection.include-children)
; )
