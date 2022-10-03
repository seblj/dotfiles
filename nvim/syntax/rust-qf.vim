if exists("b:current_syntax")
  finish
endif

syn region qfRegion start="\v^(\|)@!" end="\v^(\|)@!" contains=qfFileName,qfErrorRegion,qfWarningRegion
syn region qfErrorRegion start="error" end="\v^(\|)@!" contains=qfRustError contained
syn region qfWarningRegion start="warning" end="\v^(\|)@!" contains=qfRustWarning contained

syn match	qfFileName	"^[^|]*" contained
syn match	qfSeparator	"|" contained
syn match	qfError		"error" contained
syn match	qfWarning	"warning" contained

syn match	qfRustError	"\^.*" contained
syn match	qfRustWarning	"\^.*" contained

hi def link qfFileName	Directory
hi def link qfLineNr	LineNr
hi def link qfError	Error
hi def link qfWarning	WarningMsg
hi def link qfRustWarning	qfWarning
hi def link qfRustError	qfError
let b:current_syntax = "rust-qf"
