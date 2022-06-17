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
