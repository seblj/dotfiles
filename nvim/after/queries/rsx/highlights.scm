[
  (line_comment)
  (block_comment)
] @comment

(tag_name) @tag
(erroneous_end_tag_name) @error

(attribute_name) @tag.attribute
(attribute
  (quoted_attribute_value) @string)

[
 "<"
 ">"
 "</"
 "/>"
] @tag.delimiter

"=" @operator
