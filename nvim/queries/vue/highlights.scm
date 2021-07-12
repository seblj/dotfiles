; html-tags
(tag_name) @tag
(erroneous_end_tag_name) @error
(comment) @comment
(attribute_name) @property
(attribute_value) @string
(quoted_attribute_value) @string
(text) @none

(element (start_tag (tag_name) @_tag)
(#match? @_tag "^(h[0-9]|title)$"))

(element (start_tag (tag_name) @_tag)
(#match? @_tag "^(strong|b)$"))

(element (start_tag (tag_name) @_tag)
(#match? @_tag "^(em|i)$"))

(element (start_tag (tag_name) @_tag)
(#match? @_tag "^(s|del)$"))

(element (start_tag (tag_name) @_tag)
(#eq? @_tag "u"))

(element (start_tag (tag_name) @_tag)
(#match? @_tag "^(code|kbd)$"))

(element (start_tag (tag_name) @_tag)
 (#eq? @_tag "a"))

((attribute
   (attribute_name) @_attr
   (quoted_attribute_value (attribute_value) @text.uri))
 (#match? @_attr "^(href|src)$"))

[
 "<"
 ">"
 "</"
 "/>"
] @tag.delimiter

"=" @operator



;vue

[
  (template_element)
  (directive_attribute)
  (directive_dynamic_argument)
  (directive_dynamic_argument_value)
  (component)
] @tag

(element) @string
(interpolation) @punctuation.special
(interpolation
  (raw_text) @none)

[
  (directive_modifier)
  (directive_name)
  (directive_argument)
] @method
