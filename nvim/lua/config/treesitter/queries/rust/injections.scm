(
  (macro_invocation
    macro: ((identifier) @_html_def)
    (token_tree) @rsx)

    (#eq? @_html_def "html")
)

(
  (macro_invocation
    macro: ((identifier) @_html_def)
    (token_tree) @rust)

    (#not-eq? @_html_def "html")
)

(
  (macro_invocation
    macro: ((identifier) @_style_def)
    (token_tree
        (raw_string_literal) @css))

    (#offset! @css 1 0 0 -1)
    (#eq? @_style_def "style")
)

(macro_invocation
    (scoped_identifier
        path: (identifier) @_path (#eq? @_path "sqlx")
        name: (identifier) @_name (#match? @_name "query")
    )
    (token_tree
        (raw_string_literal) @sql
    )
    (#offset! @sql 0 3 0 -2)
)

(macro_invocation
    macro: (identifier) @_macro (#any-of? @_macro "fetch_optional" "fetch_all" "insert" "execute")
    (token_tree
        (raw_string_literal) @sql
    )
    (#offset! @sql 0 3 0 -2)
)

(call_expression
    (field_expression
        field: (field_identifier) @_field (#any-of? @_field "query" "execute")
    )
    (arguments
        (raw_string_literal) @sql
    )
    (#offset! @sql 0 3 0 -2)
)

; Nested injections doesn't work, but just leave this
; in in case I don't use it inline inside the html macro
(
  (macro_invocation
    macro: ((identifier) @_css_def)
    (token_tree
     (string_literal) @css))

    (#offset! @css 0 1 0 -1)
    (#eq? @_css_def "css")
)

(macro_definition
  (macro_rule
    left: (token_tree_pattern) @rust
    right: (token_tree) @rust))

[
  (line_comment)
  (block_comment)
] @comment

(call_expression
  function: (scoped_identifier
    path: (identifier) @_regex (#eq? @_regex "Regex")
    name: (identifier) @_new (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @regex))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier (identifier) @_regex (#eq? @_regex "Regex").)
    name: (identifier) @_new (#eq? @_new "new"))
  arguments: (arguments
    (raw_string_literal) @regex))
