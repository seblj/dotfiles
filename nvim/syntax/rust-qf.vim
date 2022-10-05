if exists("b:current_syntax")
  finish
endif

syn region qfRegion start="\v^(\|)@!" end="\v^(\|)@!" contains=qfFileName,qfErrorRegion,qfWarningRegion
syn region qfErrorRegion start="error" end="\v^(\|)@!" contains=qfRustHintLines,qfRustHint,qfRustError,qfRustErrorLines contained
syn region qfWarningRegion start="warning" end="\v^(\|)@!" contains=qfRustWarning contained

syn match	qfFileName	"^[^|]*" contained
syn match	qfSeparator	"|" contained
syn match	qfError		"error" contained
syn match	qfWarning	"warning" contained

syn match	qfRustHint "\(||\s*|.*\)\&^.*\(\^.*\)\@<!$" contained
syn match	qfRustHintLines	"\-.*" contained

syn match	qfRustErrorLines	"_.*\^$" contained
syn match	qfRustError	"\^.*" contained
" syn match	qfRustErrorUnderlines	"_\&\(.*\^\)\&" contained
syn match	qfRustWarning	"\^.*" contained

hi def link qfError	Error
hi def link qfWarning	WarningMsg
hi def link qfRustWarning	qfWarning
hi def link qfRustError	qfError
hi def link qfRustErrorLines	qfError

hi def link qfRustHintLines Tag
hi def link qfRustHint qfRustHintLines
hi def link qfFileName	Directory
hi def link qfLineNr	LineNr

let b:current_syntax = "rust-qf"
