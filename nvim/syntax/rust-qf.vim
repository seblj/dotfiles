if exists("b:current_syntax")
  finish
endif

syn region qfRegion	    start="\v^(\|)@!" end="\v^(\|)@!" contains=qfFileName,qfErrorRegion,qfWarningRegion,qfInfoRegion
syn region qfErrorRegion    start="error" end="\v^(\|)@!" contains=qfRustHintLines,qfRustHint,qfRustError,qfRustErrorLines,qfRustHintLinesTwo,qfRustErrorStripes,qfRustErrorStripe contained
syn region qfWarningRegion  start="warning" end="\v^(\|)@!" contains=qfRustWarning,qfRustWarningLines,qfRustWarningStripe,qfRustWarningStripes,qfRustWarningSlashes contained
syn region qfInfoRegion     start="info" end="\v^(\|)@!" contains=qfRustInfo contained

syn match	qfFileName         "^[^|]*" contained
syn match	qfSeparator        "|" contained
syn match	qfError            "error" contained
syn match	qfWarning          "warning" contained

syn match       qfRustHint         "\(\(||\s*|\s*|\)\@<=.*\)\&\(.*^\)\@!.*" contained
syn match	qfRustHintLines    "-\{2,}" contained
syn match	qfRustHintLinesTwo "-\{2,}\&\(.*^\)\@!.*" contained

syn match	qfRustError        "\^.*" contained
syn match	qfRustErrorLines   "_\{2,}" contained
syn match	qfRustErrorStripes ".\(||.*|\s*|\)\@<=" contained
syn match	qfRustErrorStripe  "\(||.*\.\.\.\s*\)\@<=.*" contained

syn match	qfRustWarning      "\^.*" contained
syn match	qfRustWarningLines   "_\{2,}" contained
syn match	qfRustWarningStripes ".\(||.*|\s*|\)\@<=" contained
syn match	qfRustWarningStripe  "\(||.*\.\.\.\s*\)\@<=.*" contained
syn match	qfRustWarningSlashes  ".\(||.*|\s*\/\)\@<=" contained

syn match	qfRustInfo        "\^.*" contained

hi def link qfError		Error
hi def link qfWarning		WarningMsg
hi def link qfRustWarning	qfWarning
hi def link qfRustError		qfError
hi def link qfRustErrorLines	qfError
hi def link qfRustErrorStripes	qfError
hi def link qfRustErrorStripe	qfError

hi def link qfRustWarningLines   qfWarning
hi def link qfRustWarningStripes qfWarning
hi def link qfRustWarningStripe  qfWarning
hi def link qfRustWarningSlashes  qfWarning

hi def link qfRustInfo		  Directory

hi def link qfRustHintLines	Tag
hi def link qfRustHintLinesTwo	qfRustHintLines
hi def link qfRustHint		qfRustHintLines
hi def link qfFileName		Directory

let b:current_syntax = "rust-qf"
