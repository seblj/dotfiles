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

    Cursor = { reverse = true },
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

    Boolean = { fg = c.purple },
    Character = { fg = c.yellow },
    Comment = { fg = c.grey, italic = true },
    Conditional = { fg = c.red },
    Constant = { fg = c.orange },
    Define = { fg = c.red },
    Delimiter = { fg = c.fg },
    Error = { fg = c.red },
    Exception = { fg = c.red },
    Float = { fg = c.purple },
    Function = { fg = c.green },
    Identifier = { fg = c.orange },
    Ignore = { fg = c.grey },
    Include = { fg = c.red },
    Keyword = { fg = c.red },
    Label = { fg = c.red },
    Macro = { fg = c.purple },
    Number = { fg = c.purple },
    Operator = { fg = c.red },
    PreCondit = { fg = c.red },
    PreProc = { fg = c.blue },
    Repeat = { fg = c.red },
    Special = { fg = c.purple },
    SpecialChar = { fg = c.purple },
    SpecialComment = { fg = c.grey, italic = true },
    Statement = { fg = c.red },
    StorageClass = { fg = c.blue },
    String = { fg = c.yellow },
    Structure = { fg = c.orange },
    Tag = { fg = c.blue },
    Title = { fg = c.red, bold = true },
    Todo = { fg = c.blue, italic = true },
    Type = { fg = c.blue },
    Typedef = { fg = c.red },
    Underlined = { underline = true },

    ---------- TREESITTER ----------

    TSConstructor = { fg = c.fg },
    TSConstBuiltin = { fg = c.orange },
    TSCustomType = { fg = c.purple },
    -- TSError = { link = 'Normal' },
    TSField = { fg = c.green },
    TSFuncBuiltin = { link = 'Function' },
    TSFuncMacro = { link = 'Function' },
    TSMath = { fg = c.yellow },
    TSNamespace = { fg = c.blue },
    TSNote = { fg = c.blue, bold = true },
    TSParameter = { fg = c.fg },
    TSParameterReference = { link = 'TSParameter' },
    TSProperty = { fg = c.green },
    TSPunctSpecial = { fg = c.red },
    TSStringEscape = { link = 'String' },
    TSTag = { link = 'Tag' },
    TSTagDelimiter = { fg = c.red },
    TSVariableBuiltin = { fg = c.orange },

    ---------- LANGUAGE SPECIFIC ----------

    ---------- C ----------

    cTSProperty = { link = 'NONE' },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.yellow },
    DiagnosticHint = { fg = c.fg },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orange },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.fg },
    LspRenamePrompt = { fg = c.red },
    LspSignatureActiveParameter = { fg = c.red },
    LspReferenceText = { bg = c.bg2 },
    LspReferenceRead = { bg = c.bg2 },
    LspReferenceWrite = { bg = c.bg2 },

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

    diffAdded = { fg = c.green },
    diffRemoved = { fg = c.red },
    diffChanged = { fg = c.blue },
    diffOldFile = { fg = c.yellow },
    diffNewFile = { fg = c.orange },
    diffFile = { fg = c.purple },
    diffLine = { fg = c.grey },
    diffIndexLine = { fg = c.purple },

    ConflictMarkerBegin = { fg = c.red },
    ConflictMarkerSeparator = { fg = c.red },
    ConflictMarkerOurs = { bg = c.diff_green },
    ConflictMarkerTheirs = { bg = c.diff_blue },
    ConflictMarkerEnd = { fg = c.red },

    ---------- HELP ----------

    helpCommand = { fg = c.yellow },
    helpExample = { fg = c.green },

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
