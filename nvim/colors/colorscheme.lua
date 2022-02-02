local highlight = function(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

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
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg },
    FloatBorder = { fg = c.border },
    Folded = { fg = c.grey, bg = c.bg },
    SignColumn = { fg = c.fg },
    FoldColumn = { fg = c.grey },
    ColorColumn = { bg = c.bg },
    Search = { fg = c.bg, bg = c.green },
    IncSearch = { fg = c.bg, bg = c.red },
    Conceal = { fg = c.grey },
    Whitespace = { fg = c.bg2 },

    Cursor = { fg = '', bg = '', reverse = true },
    vCursor = { link = 'Cursor' },
    iCursor = { link = 'Cursor' },
    lCursor = { link = 'Cursor' },
    TransparentCursor = { fg = c.bg, bg = c.bg },

    CursorLine = { fg = c.red, bg = c.bg },
    CursorColumn = { bg = c.bg },
    LineNr = { fg = c.grey },
    CursorLineNr = { fg = c.fg },

    DiffAdd = { bg = c.diff_green },
    DiffChange = { bg = c.diff_blue },
    DiffDelete = { bg = c.diff_red },
    DiffText = { fg = c.bg, bg = c.fg },
    Directory = { fg = c.green },

    ErrorMsg = { fg = c.red },
    WarningMsg = { fg = c.yellow, bold = true },
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.blue, bold = true },
    Question = { fg = c.yellow },

    Pmenu = { fg = c.fg, bg = c.bg2 },
    PmenuSbar = { bg = c.bg2 },
    PmenuSel = { fg = c.bg, bg = c.green },
    PmenuThumb = { bg = c.grey },
    WildMenu = { link = 'PmenuSel' },

    MatchParen = { bg = c.bg2 },
    NonText = { fg = c.bg2 },
    SpecialKey = { fg = c.bg2 },

    SpellBad = { fg = c.red, undercurl = true, sp = c.red },
    SpellCap = { fg = c.yellow, undercurl = true, sp = c.yellow },
    SpellLocal = { fg = c.blue, undercurl = true, sp = c.blue },
    SpellRare = { fg = c.purple, undercurl = true, sp = c.purple },

    StatusLine = { fg = c.fg },
    StatusLineTerm = { fg = c.fg, bg = c.bg2 },
    StatusLineNC = { fg = c.grey, bg = c.bg },
    StatusLineTermNC = { fg = c.grey, bg = c.bg },

    TabLine = { fg = c.grey, bg = c.bg3 },
    TabLineFill = { fg = c.grey, bg = c.bg3 },
    TabLineSel = { fg = c.fg, bg = c.bg, italic = true, bold = true },

    VertSplit = { fg = c.grey },
    Visual = { bg = c.bg2 },
    VisualNOS = { bg = c.bg2, underline = true },
    QuickFixLine = { fg = c.blue, bold = true },

    RedSign = { fg = c.red, bg = c.bg },
    OrangeSign = { fg = c.orange, bg = c.bg },
    YellowSign = { fg = c.yellow, bg = c.bg },
    GreenSign = { fg = c.green, bg = c.bg },
    BlueSign = { fg = c.blue, bg = c.bg },
    PurpleSign = { fg = c.purple, bg = c.bg },

    Type = { fg = c.blue },
    Structure = { fg = c.blue },
    StorageClass = { fg = c.blue },
    Identifier = { fg = c.orange },
    Constant = { fg = c.orange },
    PreProc = { fg = c.red },
    PreCondit = { fg = c.red },
    Include = { fg = c.red },
    Keyword = { fg = c.red },
    Define = { fg = c.red },
    Typedef = { fg = c.red },
    Exception = { fg = c.red },
    Conditional = { fg = c.red },
    Repeat = { fg = c.red },
    Statement = { fg = c.red },
    Macro = { fg = c.purple },
    Error = { fg = c.red },
    Label = { fg = c.purple },
    Special = { fg = c.purple },
    SpecialChar = { fg = c.purple },
    Boolean = { fg = c.purple },
    String = { fg = c.yellow },
    Character = { fg = c.yellow },
    Number = { fg = c.purple },
    Float = { fg = c.purple },
    Function = { fg = c.green },
    Operator = { fg = c.red },
    Title = { fg = c.red, bold = true },
    Tag = { fg = c.orange },
    Delimiter = { fg = c.fg },
    Comment = { fg = c.grey, italic = true },
    SpecialComment = { fg = c.grey, italic = true },
    Todo = { fg = c.blue, italic = true },
    Ignore = { fg = c.grey },
    Underlined = { underline = true },

    ---------- TREESITTER ----------

    TSAnnotation = { fg = c.blue },
    TSAttribute = { fg = c.blue },
    TSBoolean = { fg = c.purple },
    TSCharacter = { fg = c.yellow },
    TSComment = { fg = c.grey },
    TSConditional = { fg = c.red },
    TSConstBuiltin = { fg = c.orange },
    TSConstMacro = { fg = c.orange },
    TSConstant = { fg = c.orange },
    TSConstructor = { fg = c.fg },
    TSCustomType = { fg = c.purple },
    TSDanger = { fg = c.red, bold = true },
    TSEmphasis = { bold = true },
    TSError = { link = 'Normal' },
    TSException = { fg = c.red },
    TSField = { fg = c.green },
    TSFloat = { fg = c.purple },
    TSFuncBuiltin = { fg = c.green },
    TSFuncMacro = { fg = c.green },
    TSFunction = { fg = c.green },
    TSInclude = { fg = c.red },
    TSKeyword = { fg = c.red },
    TSKeywordFunction = { fg = c.red },
    TSKeywordOperator = { fg = c.red },
    TSLabel = { fg = c.red },
    TSMath = { fg = c.yellow },
    TSMethod = { fg = c.green },
    TSNamespace = { fg = c.blue },
    TSNone = { fg = c.fg },
    TSNote = { fg = c.blue, bold = true },
    TSNumber = { fg = c.purple },
    TSOperator = { fg = c.red },
    TSParameter = { fg = c.fg },
    TSParameterReference = { fg = c.fg },
    TSProperty = { fg = c.green },
    TSPunctBracket = { fg = c.fg },
    TSPunctDelimiter = { fg = c.grey },
    TSPunctSpecial = { fg = c.red },
    TSRepeat = { fg = c.red },
    TSStrike = { fg = c.grey },
    TSString = { fg = c.yellow },
    TSStringEscape = { fg = c.yellow },
    TSStringRegex = { fg = c.green },
    TSStrong = { bold = true },
    TSStructure = { fg = c.orange },
    TSSymbol = { fg = c.fg },
    TSTag = { fg = c.blue },
    TSTagDelimiter = { fg = c.red },
    TSText = { fg = c.green },
    TSType = { fg = c.blue },
    TSTypeBuiltin = { fg = c.blue },
    TSURI = { fg = c.blue, underline = true },
    TSUnderline = { underline = true },
    TSVariable = { fg = c.fg },
    TSVariableBuiltin = { fg = c.orange },
    TSWarning = { fg = c.orange, bold = true },

    ---------- LANGUAGE SPECIFIC ----------

    ---------- C ----------

    cTSProperty = { link = 'NONE' },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticFloatingError = { fg = c.red },
    DiagnosticFloatingWarn = { fg = c.orange },
    DiagnosticFloatingInfo = { fg = c.yellow },
    DiagnosticFloatingHint = { fg = c.fg },
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.yellow },
    DiagnosticHint = { fg = c.yellow },
    DiagnosticVirtualTextError = { fg = c.red },
    DiagnosticVirtualTextWarn = { fg = c.orange },
    DiagnosticVirtualTextInfo = { fg = c.yellow },
    DiagnosticVirtualTextHint = { fg = c.yellow },
    DiagnosticUnderlineError = { undercurl = true },
    DiagnosticUnderlineWarn = { undercurl = true },
    DiagnosticUnderlineInfo = { undercurl = true },
    DiagnosticUnderlineHint = { undercurl = true },
    DiagnosticSignError = { link = 'RedSign' },
    DiagnosticSignWarn = { link = 'OrangeSign' },
    DiagnosticSignInfo = { link = 'BlueSign' },
    DiagnosticSignHint = { link = 'YellowSign' },
    LspReferenceText = { fg = c.bg, bg = c.green },
    LspReferenceRead = { fg = c.bg, bg = c.green },
    LspReferenceWrite = { fg = c.bg, bg = c.green },
    LspRenamePrompt = { fg = c.red },
    LspSignatureActiveParameter = { fg = c.red },

    ---------- TEX ----------

    texStatement = { fg = c.blue },
    texOnlyMath = { fg = c.grey },
    texDefName = { fg = c.yellow },
    texNewCmd = { fg = c.orange },
    texCmdName = { fg = c.blue },
    texBeginEnd = { fg = c.red },
    texBeginEndName = { fg = c.green },
    texDocType = { fg = c.red },
    texDocTypeArgs = { fg = c.orange },
    texInputFile = { fg = c.green },
    texFileArg = { fg = c.green },
    texCmd = { fg = c.blue },
    texCmdPackage = { fg = c.blue },
    texCmdDef = { fg = c.red },
    texDefArgName = { fg = c.yellow },
    texCmdNewcmd = { fg = c.red },
    texCmdClass = { fg = c.red },
    texCmdTitle = { fg = c.red },
    texCmdAuthor = { fg = c.red },
    texCmdEnv = { fg = c.red },
    texCmdPart = { fg = c.red },
    texEnvArgName = { fg = c.green },

    ---------- GIT ----------

    GitGutterAdd = { link = 'GreenSign' },
    GitGutterChange = { link = 'BlueSign' },
    GitGutterDelete = { link = 'RedSign' },
    GitGutterChangeDelete = { link = 'PurpleSign' },

    diffAdded = { fg = c.green },
    diffRemoved = { fg = c.red },
    diffChanged = { fg = c.blue },
    diffOldFile = { fg = c.yellow },
    diffNewFile = { fg = c.orange },
    diffFile = { fg = c.purple },
    diffLine = { fg = c.grey },
    diffIndexLine = { fg = c.purple },

    gitcommitSummary = { fg = c.red },
    gitcommitUntracked = { fg = c.grey },
    gitcommitDiscarded = { fg = c.grey },
    gitcommitSelected = { fg = c.grey },
    gitcommitUnmerged = { fg = c.grey },
    gitcommitOnBranch = { fg = c.grey },
    gitcommitArrow = { fg = c.grey },
    gitcommitFile = { fg = c.green },

    ConflictMarkerBegin = { fg = c.red },
    ConflictMarkerSeparator = { fg = c.red },
    ConflictMarkerOurs = { bg = c.diff_green },
    ConflictMarkerTheirs = { bg = c.diff_blue },
    ConflictMarkerEnd = { fg = c.red },

    ---------- HELP ----------

    helpNote = { fg = c.purple, bold = true },
    helpHeadline = { fg = c.red, bold = true },
    helpHeader = { fg = c.orange, bold = true },
    helpURL = { fg = c.green, underline = true },
    helpHyperTextEntry = { fg = c.blue, bold = true },
    helpHyperTextJump = { fg = c.blue },
    helpCommand = { fg = c.yellow },
    helpExample = { fg = c.green },
    helpSpecial = { fg = c.purple },
    helpSectionDelim = { fg = c.grey },

    ---------- STARTSCREEN ----------

    StartifyBracket = { fg = c.grey },
    StartifyFile = { fg = c.green },
    StartifyNumber = { fg = c.orange },
    StartifyPath = { fg = c.grey },
    StartifySlash = { fg = c.grey },
    StartifySection = { fg = c.blue },
    StartifyHeader = { fg = c.red },
    StartifySpecial = { fg = c.grey },

    ---------- NVIM TREE ----------

    NvimTreeFolderName = { fg = c.blue },
    NvimTreeOpenedFolderName = { link = 'NvimTreeFolderName' },
    NvimTreeEmptyFolderName = { link = 'NvimTreeFolderName' },

    ---------- TELESCOPE ----------

    TelescopePromptPrefix = { fg = c.red },

    ---------- CMP ----------

    CmpCompletionWindow = { bg = c.bg },
    CmpCompletionWindowBorder = { link = 'FloatBorder' },
    CmpDocumentationWindowBorder = { link = 'FloatBorder' },
    CmpItemAbbrMatch = { fg = c.purple },
    CmpItemKind = { fg = c.blue },
    CmpItemKindClass = { fg = c.blue },
    CmpItemKindColor = { fg = c.yellow },
    CmpItemKindConstant = { link = 'TSConstant' },
    CmpItemKindConstructor = { link = 'TSConstructor' },
    CmpItemKindEnum = { fg = c.blue },
    CmpItemKindEnumMember = { fg = c.purple },
    CmpItemKindEvent = { fg = c.red },
    CmpItemKindField = { link = 'TSField' },
    CmpItemKindFile = { fg = c.yellow },
    CmpItemKindFolder = { fg = c.yellow },
    CmpItemKindFunction = { link = 'TSFunction' },
    CmpItemKindInterface = { fg = c.blue },
    CmpItemKindKeyword = { link = 'TSKeyword' },
    CmpItemKindMethod = { link = 'TSMethod' },
    CmpItemKindModule = { fg = c.blue },
    CmpItemKindOperator = { link = 'TSOperator' },
    CmpItemKindProperty = { link = 'TSProperty' },
    CmpItemKindReference = { fg = c.yellow },
    CmpItemKindSnippet = { fg = c.yellow },
    CmpItemKindStruct = { link = 'TSType' },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindTypeParameter = { link = 'TSType' },
    CmpItemKindUnit = { fg = c.purple },
    CmpItemKindValue = { fg = c.purple },
    CmpItemKindVariable = { link = 'TSVariable' },

    UltestBorder = { link = 'FloatBorder' },
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
