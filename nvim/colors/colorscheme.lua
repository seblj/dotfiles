local highlight = require('seblj.utils').highlight

vim.g.colors_name = 'colorscheme'

---------- COLORS ----------

-- Delta colors
-- diff_red = '#3f0002',
-- diff_red_hard = '#901111',
-- diff_green = '#002800',
-- diff_green_hard = '#026000',

local c = {
    bg = '#1c1c1c',
    bg2 = '#363944',
    bg3 = '#121212',
    fg = '#eeeeee',
    error = '#ff0033',
    diff_red = '#55393d',
    diff_green = '#394634',
    diff_blue = '#354157',
    border = '#80A0C2',
    red = '#fc5d7c',
    orange = '#fea24f',
    yellow = '#e7c664',
    green = '#9ed072',
    blue = '#76cce0',
    purple = '#b39df3',
    grey = '#7f8490',
}

---------- GROUPS ----------

highlight({
    Normal = { guifg = c.fg, guibg = c.bg },
    NormalFloat = { guifg = c.fg, guibg = c.bg },
    FloatBorder = { guifg = c.border },
    Folded = { guifg = c.grey, guibg = c.bg },
    SignColumn = { guifg = c.fg, guibg = 'NONE' },
    FoldColumn = { guifg = c.grey, guibg = 'NONE' },
    ColorColumn = { guifg = 'NONE', guibg = c.bg },
    Search = { guifg = c.bg, guibg = c.green },
    IncSearch = { guifg = c.bg, guibg = c.red },
    Conceal = { guifg = c.grey, guibg = 'NONE' },
    Whitespace = { guifg = c.bg2, guibg = 'NONE' },

    Cursor = { guifg = 'NONE', guibg = 'NONE', gui = 'reverse' },
    vCursor = { link = 'Cursor' },
    iCursor = { link = 'Cursor' },
    lCursor = { link = 'Cursor' },
    TransparentCursor = { gui = 'strikethrough', blend = 100 },

    CursorLine = { guifg = c.red, guibg = c.bg },
    CursorColumn = { guifg = 'NONE', guibg = c.bg },
    LineNr = { guifg = c.grey, guibg = 'NONE' },
    CursorLineNr = { guifg = c.fg, guibg = 'NONE' },

    DiffAdd = { guifg = 'NONE', guibg = c.diff_green },
    DiffChange = { guifg = 'NONE', guibg = c.diff_blue },
    DiffDelete = { guifg = 'NONE', guibg = c.diff_red },
    DiffText = { guifg = c.bg, guibg = c.fg },
    Directory = { guifg = c.green, guibg = 'NONE' },

    ErrorMsg = { guifg = c.red, guibg = 'NONE' },
    WarningMsg = { guifg = c.yellow, guibg = 'NONE', gui = 'bold' },
    ModeMsg = { guifg = c.fg, guibg = 'NONE', gui = 'bold' },
    MoreMsg = { guifg = c.blue, guibg = 'NONE', gui = 'bold' },
    Question = { guifg = c.yellow, guibg = 'NONE' },

    Pmenu = { guifg = c.fg, guibg = c.bg2 },
    PmenuSbar = { guifg = 'NONE', guibg = c.bg2 },
    PmenuSel = { guifg = c.bg, guibg = c.green },
    PmenuThumb = { guifg = 'NONE', guibg = c.grey },
    WildMenu = { link = 'PmenuSel' },

    MatchParen = { guifg = 'NONE', guibg = c.bg2 },
    NonText = { guifg = c.bg2, guibg = 'NONE' },
    SpecialKey = { guifg = c.bg2, guibg = 'NONE' },

    SpellBad = { guifg = c.red, guibg = 'NONE', gui = 'undercurl', guisp = c.red },
    SpellCap = { guifg = c.yellow, guibg = 'NONE', gui = 'undercurl', guisp = c.yellow },
    SpellLocal = { guifg = c.blue, guibg = 'NONE', gui = 'undercurl', guisp = c.blue },
    SpellRare = { guifg = c.purple, guibg = 'NONE', gui = 'undercurl', guisp = c.purple },

    StatusLine = { guifg = c.fg, guibg = 'NONE' },
    StatusLineTerm = { guifg = c.fg, guibg = c.bg2 },
    StatusLineNC = { guifg = c.grey, guibg = c.bg },
    StatusLineTermNC = { guifg = c.grey, guibg = c.bg },

    TabLine = { guifg = c.grey, guibg = c.bg3 },
    TabLineFill = { guifg = c.grey, guibg = c.bg3 },
    TabLineSel = { guifg = c.fg, guibg = c.bg, gui = 'italic,bold' },

    VertSplit = { guifg = c.grey, guibg = 'NONE' },
    Visual = { guifg = 'NONE', guibg = c.bg2 },
    VisualNOS = { guifg = 'NONE', guibg = c.bg2, gui = 'underline' },
    QuickFixLine = { guifg = c.blue, guibg = 'NONE', gui = 'bold' },

    RedSign = { guifg = c.red, guibg = c.bg },
    OrangeSign = { guifg = c.orange, guibg = c.bg },
    YellowSign = { guifg = c.yellow, guibg = c.bg },
    GreenSign = { guifg = c.green, guibg = c.bg },
    BlueSign = { guifg = c.blue, guibg = c.bg },
    PurpleSign = { guifg = c.purple, guibg = c.bg },

    Type = { guifg = c.blue, guibg = 'NONE' },
    Structure = { guifg = c.blue, guibg = 'NONE' },
    StorageClass = { guifg = c.blue, guibg = 'NONE' },
    Identifier = { guifg = c.orange, guibg = 'NONE' },
    Constant = { guifg = c.orange, guibg = 'NONE' },
    PreProc = { guifg = c.red, guibg = 'NONE' },
    PreCondit = { guifg = c.red, guibg = 'NONE' },
    Include = { guifg = c.red, guibg = 'NONE' },
    Keyword = { guifg = c.red, guibg = 'NONE' },
    Define = { guifg = c.red, guibg = 'NONE' },
    Typedef = { guifg = c.red, guibg = 'NONE' },
    Exception = { guifg = c.red, guibg = 'NONE' },
    Conditional = { guifg = c.red, guibg = 'NONE' },
    Repeat = { guifg = c.red, guibg = 'NONE' },
    Statement = { guifg = c.red, guibg = 'NONE' },
    Macro = { guifg = c.purple, guibg = 'NONE' },
    Error = { guifg = c.red, guibg = 'NONE' },
    Label = { guifg = c.purple, guibg = 'NONE' },
    Special = { guifg = c.purple, guibg = 'NONE' },
    SpecialChar = { guifg = c.purple, guibg = 'NONE' },
    Boolean = { guifg = c.purple, guibg = 'NONE' },
    String = { guifg = c.yellow, guibg = 'NONE' },
    Character = { guifg = c.yellow, guibg = 'NONE' },
    Number = { guifg = c.purple, guibg = 'NONE' },
    Float = { guifg = c.purple, guibg = 'NONE' },
    Function = { guifg = c.green, guibg = 'NONE' },
    Operator = { guifg = c.red, guibg = 'NONE' },
    Title = { guifg = c.red, guibg = 'NONE', gui = 'bold' },
    Tag = { guifg = c.orange, guibg = 'NONE' },
    Delimiter = { guifg = c.fg, guibg = 'NONE' },
    Comment = { guifg = c.grey, guibg = 'NONE', gui = 'italic' },
    SpecialComment = { guifg = c.grey, guibg = 'NONE', gui = 'italic' },
    Todo = { guifg = c.blue, guibg = 'NONE', gui = 'italic' },
    Ignore = { guifg = c.grey, guibg = 'NONE' },
    Underlined = { guifg = 'NONE', guibg = 'NONE', gui = 'underline' },

    ---------- TREESITTER ----------

    TSAnnotation = { guifg = c.blue },
    TSAttribute = { guifg = c.blue },
    TSBoolean = { guifg = c.purple },
    TSCharacter = { guifg = c.yellow },
    TSComment = { guifg = c.grey },
    TSConditional = { guifg = c.red },
    TSConstBuiltin = { guifg = c.orange },
    TSConstMacro = { guifg = c.orange },
    TSConstant = { guifg = c.orange },
    TSConstructor = { guifg = c.fg },
    TSCustomType = { guifg = c.purple },
    TSDanger = { guifg = c.red, gui = 'bold' },
    TSEmphasis = { guifg = 'NONE', guibg = 'NONE', gui = 'bold' },
    TSError = { link = 'Normal' },
    TSException = { guifg = c.red },
    TSField = { guifg = c.green },
    TSFloat = { guifg = c.purple },
    TSFuncBuiltin = { guifg = c.green },
    TSFuncMacro = { guifg = c.green },
    TSFunction = { guifg = c.green },
    TSInclude = { guifg = c.red },
    TSKeyword = { guifg = c.red },
    TSKeywordFunction = { guifg = c.red },
    TSKeywordOperator = { guifg = c.red },
    TSLabel = { guifg = c.red },
    TSMath = { guifg = c.yellow },
    TSMethod = { guifg = c.green },
    TSNamespace = { guifg = c.blue },
    TSNone = { guifg = c.fg },
    TSNote = { guifg = c.blue, gui = 'bold' },
    TSNumber = { guifg = c.purple },
    TSOperator = { guifg = c.red },
    TSParameter = { guifg = c.fg },
    TSParameterReference = { guifg = c.fg },
    TSProperty = { guifg = c.green },
    TSPunctBracket = { guifg = c.fg },
    TSPunctDelimiter = { guifg = c.grey },
    TSPunctSpecial = { guifg = c.red },
    TSRepeat = { guifg = c.red },
    TSStrike = { guifg = c.grey },
    TSString = { guifg = c.yellow },
    TSStringEscape = { guifg = c.yellow },
    TSStringRegex = { guifg = c.green },
    TSStrong = { guifg = 'NONE', guibg = 'NONE', gui = 'bold' },
    TSStructure = { guifg = c.orange },
    TSSymbol = { guifg = c.fg },
    TSTag = { guifg = c.blue },
    TSTagDelimiter = { guifg = c.red },
    TSText = { guifg = c.green },
    TSType = { guifg = c.blue },
    TSTypeBuiltin = { guifg = c.blue },
    TSURI = { guifg = c.blue, guibg = 'NONE', gui = 'underline' },
    TSUnderline = { guifg = 'NONE', guibg = 'NONE', gui = 'underline' },
    TSVariable = { guifg = c.fg },
    TSVariableBuiltin = { guifg = c.orange },
    TSWarning = { guifg = c.orange, gui = 'bold' },

    ---------- LANGUAGE SPECIFIC ----------

    ---------- C ----------

    cTSProperty = { link = 'NONE' },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticFloatingError = { guifg = c.red, guibg = 'NONE' },
    DiagnosticFloatingWarn = { guifg = c.orange, guibg = 'NONE' },
    DiagnosticFloatingInfo = { guifg = c.yellow, guibg = 'NONE' },
    DiagnosticFloatingHint = { guifg = c.fg, guibg = 'NONE' },
    DiagnosticError = { guifg = c.error },
    DiagnosticWarn = { guifg = c.orange },
    DiagnosticInfo = { guifg = c.yellow },
    DiagnosticHint = { guifg = c.yellow },
    DiagnosticVirtualTextError = { guifg = c.red },
    DiagnosticVirtualTextWarn = { guifg = c.orange },
    DiagnosticVirtualTextInfo = { guifg = c.yellow },
    DiagnosticVirtualTextHint = { guifg = c.yellow },
    DiagnosticUnderlineError = { guisp = c.red, gui = 'undercurl' },
    DiagnosticUnderlineWarn = { guisp = c.orange, gui = 'undercurl' },
    DiagnosticUnderlineInfo = { guisp = c.yellow, gui = 'undercurl' },
    DiagnosticUnderlineHint = { guisp = c.fg, gui = 'undercurl' },
    DiagnosticSignError = { link = 'RedSign' },
    DiagnosticSignWarn = { link = 'OrangeSign' },
    DiagnosticSignInfo = { link = 'BlueSign' },
    DiagnosticSignHint = { link = 'YellowSign' },
    LspReferenceText = { guifg = c.bg, guibg = c.green },
    LspReferenceRead = { guifg = c.bg, guibg = c.green },
    LspReferenceWrite = { guifg = c.bg, guibg = c.green },
    LspRenamePrompt = { guifg = c.red },
    LspSignatureActiveParameter = { guifg = c.red },

    ---------- TEX ----------

    texStatement = { guifg = c.blue },
    texOnlyMath = { guifg = c.grey },
    texDefName = { guifg = c.yellow },
    texNewCmd = { guifg = c.orange },
    texCmdName = { guifg = c.blue },
    texBeginEnd = { guifg = c.red },
    texBeginEndName = { guifg = c.green },
    texDocType = { guifg = c.red },
    texDocTypeArgs = { guifg = c.orange },
    texInputFile = { guifg = c.green },
    texFileArg = { guifg = c.green },
    texCmd = { guifg = c.blue },
    texCmdPackage = { guifg = c.blue },
    texCmdDef = { guifg = c.red },
    texDefArgName = { guifg = c.yellow },
    texCmdNewcmd = { guifg = c.red },
    texCmdClass = { guifg = c.red },
    texCmdTitle = { guifg = c.red },
    texCmdAuthor = { guifg = c.red },
    texCmdEnv = { guifg = c.red },
    texCmdPart = { guifg = c.red },
    texEnvArgName = { guifg = c.green },

    ---------- GIT ----------

    GitGutterAdd = { link = 'GreenSign' },
    GitGutterChange = { link = 'BlueSign' },
    GitGutterDelete = { link = 'RedSign' },
    GitGutterChangeDelete = { link = 'PurpleSign' },

    diffAdded = { guifg = c.green },
    diffRemoved = { guifg = c.red },
    diffChanged = { guifg = c.blue },
    diffOldFile = { guifg = c.yellow },
    diffNewFile = { guifg = c.orange },
    diffFile = { guifg = c.purple },
    diffLine = { guifg = c.grey },
    diffIndexLine = { guifg = c.purple },

    gitcommitSummary = { guifg = c.red },
    gitcommitUntracked = { guifg = c.grey },
    gitcommitDiscarded = { guifg = c.grey },
    gitcommitSelected = { guifg = c.grey },
    gitcommitUnmerged = { guifg = c.grey },
    gitcommitOnBranch = { guifg = c.grey },
    gitcommitArrow = { guifg = c.grey },
    gitcommitFile = { guifg = c.green },

    ConflictMarkerBegin = { guifg = c.red, guibg = 'NONE' },
    ConflictMarkerSeparator = { guifg = c.red, guibg = 'NONE' },
    ConflictMarkerOurs = { guifg = 'NONE', guibg = c.diff_green },
    ConflictMarkerTheirs = { guifg = 'NONE', guibg = c.diff_blue },
    ConflictMarkerEnd = { guifg = c.red, guibg = 'NONE' },

    ---------- HELP ----------

    helpNote = { guifg = c.purple, guibg = 'NONE', gui = 'bold' },
    helpHeadline = { guifg = c.red, guibg = 'NONE', gui = 'bold' },
    helpHeader = { guifg = c.orange, guibg = 'NONE', gui = 'bold' },
    helpURL = { guifg = c.green, guibg = 'NONE', gui = 'underline' },
    helpHyperTextEntry = { guifg = c.blue, guibg = 'NONE', gui = 'bold' },
    helpHyperTextJump = { guifg = c.blue },
    helpCommand = { guifg = c.yellow },
    helpExample = { guifg = c.green },
    helpSpecial = { guifg = c.purple },
    helpSectionDelim = { guifg = c.grey },

    ---------- STARTSCREEN ----------

    StartifyBracket = { guifg = c.grey },
    StartifyFile = { guifg = c.green },
    StartifyNumber = { guifg = c.orange },
    StartifyPath = { guifg = c.grey },
    StartifySlash = { guifg = c.grey },
    StartifySection = { guifg = c.blue },
    StartifyHeader = { guifg = c.red },
    StartifySpecial = { guifg = c.grey },

    ---------- NVIM TREE ----------

    NvimTreeFolderName = { guifg = c.blue },
    NvimTreeOpenedFolderName = { link = 'NvimTreeFolderName' },
    NvimTreeEmptyFolderName = { link = 'NvimTreeFolderName' },

    ---------- TELESCOPE ----------

    TelescopePromptPrefix = { guifg = c.red },

    ---------- CMP ----------

    CmpCompletionWindow = { guibg = c.bg },
    CmpCompletionWindowBorder = { link = 'FloatBorder' },
    CmpDocumentationWindowBorder = { link = 'FloatBorder' },
    CmpItemAbbrMatch = { guifg = c.purple },
    CmpItemKind = { guifg = c.blue },
    CmpItemKindClass = { guifg = c.blue },
    CmpItemKindColor = { guifg = c.yellow },
    CmpItemKindConstant = 'TSConstant',
    CmpItemKindConstructor = 'TSConstructor',
    CmpItemKindEnum = { guifg = c.blue },
    CmpItemKindEnumMember = { guifg = c.purple },
    CmpItemKindEvent = { guifg = c.red },
    CmpItemKindField = 'TSField',
    CmpItemKindFile = { guifg = c.yellow },
    CmpItemKindFolder = { guifg = c.yellow },
    CmpItemKindFunction = 'TSFunction',
    CmpItemKindInterface = { guifg = c.blue },
    CmpItemKindKeyword = 'TSKeyword',
    CmpItemKindMethod = 'TSMethod',
    CmpItemKindModule = { guifg = c.blue },
    CmpItemKindOperator = 'TSOperator',
    CmpItemKindProperty = 'TSProperty',
    CmpItemKindReference = { guifg = c.yellow },
    CmpItemKindSnippet = { guifg = c.yellow },
    CmpItemKindStruct = 'TSType',
    CmpItemKindText = { guifg = c.fg },
    CmpItemKindTypeParameter = 'TSType',
    CmpItemKindUnit = { guifg = c.purple },
    CmpItemKindValue = { guifg = c.purple },
    CmpItemKindVariable = 'TSVariable',

    UltestBorder = 'FloatBorder',
})

---------- TERM COLORS ----------

vim.g.terminal_color_0 = '#1d1f21'
vim.g.terminal_color_1 = '#ff2200'
vim.g.terminal_color_2 = '#198844'
vim.g.terminal_color_3 = '#bbbb00'
vim.g.terminal_color_4 = '#00bbbb'
vim.g.terminal_color_5 = '#bb00bb'
vim.g.terminal_color_6 = '#00bbbb'
vim.g.terminal_color_7 = '#f5f5f5'
vim.g.terminal_color_8 = '#989698'
vim.g.terminal_color_9 = '#ff2200'
vim.g.terminal_color_10 = '#198844'
vim.g.terminal_color_11 = '#d8865f'
vim.g.terminal_color_12 = '#00bbbb'
vim.g.terminal_color_13 = '#bb00bb'
vim.g.terminal_color_14 = '#00bbbb'
vim.g.terminal_color_15 = '#ffffff'
