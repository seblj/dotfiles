" =============================================================================
" My colorscheme
" =============================================================================

let s:yellow = [ '#e5cd52' , 221 ]
let s:blue = [ '#4fb4d8' , 68 ]
let s:red = [ '#f92672' , 132 ]
let s:green = [ '#78bd65' , 64 ]
let s:orange = [ '#ef7c2a' , 202 ]
let s:white = [ '#ffffff' , 15 ]
let s:lightGray = [ '#848794' , 245 ]
let s:gray = [ '#686b78' , 236 ]
let s:darkGray = [ '#45474f' , 235 ]
let s:veryDarkGray = [ '#1c1d21' , 0 ]
let s:purple = [ '#d787ff' , 183 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:veryDarkGray, s:red ], [ s:white, s:gray ] ]
let s:p.insert.left = [ [ s:veryDarkGray, s:blue ], [ s:white, s:gray ] ]
let s:p.visual.left = [ [ s:veryDarkGray, s:green ], [ s:white, s:gray ] ]
let s:p.replace.left = [ [ s:veryDarkGray, s:purple ], [ s:white, s:gray ] ]

let s:p.inactive.right = [ [ s:darkGray, s:gray ], [ s:darkGray, s:gray ] ]
let s:p.inactive.left = [ [ s:lightGray, s:darkGray ], [ s:white, s:darkGray ] ]
let s:p.inactive.middle = [ [ s:white, s:darkGray ] ]

let s:p.normal.middle = [ [ s:white, s:darkGray ] ]
let s:p.normal.error = [ [ s:red, s:darkGray ] ]
let s:p.normal.warning = [ [ s:orange, s:darkGray ] ]

let s:p.tabline.left = [ [ s:lightGray, s:darkGray ] ]
let s:p.tabline.tabsel = [ [ s:white, s:gray ] ]
let s:p.tabline.middle = [ [ s:yellow, s:veryDarkGray ] ]

let s:p.normal.right = copy(s:p.normal.left)
let s:p.insert.right = copy(s:p.insert.left)
let s:p.visual.right = copy(s:p.visual.left)
let s:p.replace.right = copy(s:p.replace.left)
let s:p.tabline.right = copy(s:p.tabline.left)

let g:lightline#colorscheme#custom#palette = lightline#colorscheme#flatten(s:p)
