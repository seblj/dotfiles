local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local highlight = function(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

---------- COLORS ----------

local c = {
    bg = '#1c1c1c',
    bg2 = '#3f424f',
    bg3 = '#121212',
    bg4 = '#2f2f2f',
    fg = '#eeeeee',
    diff_red = '#55393d',
    diff_green = '#394634',
    diff_red_bright = '#71394a',
    diff_green_bright = '#5d7255',
    diff_blue = '#354157',
    changed_text = '#4b5c7c',
    border = '#80A0C2',
    red = '#fc5d7c',
    orange = '#fea24f',
    yellow = '#e7c664',
    green = '#9ed072',
    blue = '#76cce0',
    purple = '#b39df3',
    grey = '#7f8490',
}

highlight({
    ---------- HIGHLIGHTING GROUPS ----------

    ColorColumn = { bg = c.bg },
    Conceal = { fg = c.grey },
    Cursor = { reverse = true },
    CursorColumn = { bg = c.bg },
    CursorLine = { fg = c.red },
    CursorLineNr = { fg = c.fg },
    CursorTransparent = { strikethrough = true, blend = 100 },
    DiffAdd = { bg = c.diff_green },
    DiffChange = { bg = c.diff_blue },
    DiffDelete = { bg = c.diff_red },
    DiffText = { bg = c.changed_text },
    Directory = { fg = c.green },
    ErrorMsg = { fg = c.red },
    FloatBorder = { fg = c.bg4 },
    FoldColumn = { fg = c.grey },
    Folded = { fg = c.grey, bg = c.bg },
    IncSearch = { fg = c.bg, bg = c.red },
    LineNr = { fg = c.grey },
    MatchParen = { bg = c.bg2 },
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.blue, bold = true },
    NonText = { fg = c.bg2 },
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg4 },
    Pmenu = { fg = c.fg, bg = c.bg2 },
    PmenuSbar = { bg = c.bg2 },
    PmenuSel = { fg = c.bg, bg = c.green },
    PmenuThumb = { bg = c.grey },
    Question = { fg = c.yellow },
    QuickFixLine = { fg = c.blue, bold = true },
    Search = { fg = c.bg, bg = c.green },
    SignColumn = { fg = c.fg },
    SpecialKey = { fg = c.bg2 },
    SpellBad = { fg = c.red, undercurl = true, sp = c.red },
    SpellCap = { fg = c.yellow, undercurl = true, sp = c.yellow },
    SpellLocal = { fg = c.blue, undercurl = true, sp = c.blue },
    SpellRare = { fg = c.purple, undercurl = true, sp = c.purple },
    StatusLine = { fg = c.fg },
    StatusLineNC = { fg = c.grey, bg = c.bg },
    StatusLineTerm = { fg = c.fg, bg = c.bg2 },
    StatusLineTermNC = { fg = c.grey, bg = c.bg },
    TabLine = { fg = c.grey, bg = c.bg3 },
    TabLineFill = { fg = c.grey, bg = c.bg3 },
    TabLineSel = { fg = c.fg, bg = c.bg, italic = true, bold = true },
    VertSplit = { fg = c.grey },
    Visual = { bg = c.bg2 },
    VisualNOS = { bg = c.bg2, underline = true },
    WarningMsg = { fg = c.yellow, bold = true },
    Whitespace = { fg = c.bg2 },
    WildMenu = { link = 'PmenuSel' },
    iCursor = { link = 'Cursor' },
    lCursor = { link = 'Cursor' },
    vCursor = { link = 'Cursor' },

    ---------- SYNTAX GROUP NAMES ----------

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
    TSField = { fg = c.green },
    TSFuncBuiltin = { link = 'Function' },
    TSFuncMacro = { link = 'Function' },
    -- TSMath = { fg = c.yellow },
    TSNamespace = { fg = c.blue },
    TSNote = { fg = c.blue, bold = true },
    TSParameter = { fg = c.fg },
    TSParameterReference = { link = 'TSParameter' },
    TSProperty = { fg = c.green },
    TSPunctSpecial = { fg = c.red },
    TSStringEscape = { link = 'String' },
    TSTag = { link = 'Tag' },
    TSTagAttribute = { fg = c.green },
    TSTagDelimiter = { fg = c.red },
    TSVariableBuiltin = { fg = c.orange },

    ---------- LANGUGE SPECIFIC ----------

    typescriptParenExp = { link = 'TSPunctBracket' },
    typescript1 = { link = 'TSPunctBracket' },
    typescriptParens = { link = 'TSPunctBracket' },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.yellow },
    DiagnosticHint = { fg = c.fg },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orange },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.fg },
    LspSignatureActiveParameter = { fg = c.red },
    LspReferenceText = { bg = c.bg2 },
    LspReferenceRead = { bg = c.bg2 },
    LspReferenceWrite = { bg = c.bg2 },

    ---------- GIT ----------

    diffAdded = { fg = c.green },
    diffRemoved = { fg = c.red },
    diffChanged = { fg = c.blue },
    diffOldFile = { fg = c.yellow },
    diffNewFile = { fg = c.orange },
    diffFile = { fg = c.purple },
    diffLine = { fg = c.grey },
    diffIndexLine = { fg = c.purple },

    GitSignsAddInline = { bg = c.diff_green_bright },
    GitSignsDeleteInline = { bg = c.diff_red_bright },
    GitSignsAddLn = { bg = c.diff_green },
    GitSignsDeleteLn = { bg = c.diff_red },

    ---------- HELP ----------

    helpCommand = { fg = c.yellow },
    helpExample = { fg = c.green },

    ---------- TELESCOPE ----------

    TelescopePromptPrefix = { fg = c.red },

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

    ---------- CMP ----------

    CmpCompletionWindow = { bg = c.bg },
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
})

-- When using ':Messages', the text is highlighted with
-- 'NonText' for some reason Fix this to actually be readable
-- without changing hl group for everything it's used for
local group = augroup('FixQFColorscheme', {})
autocmd('FileType', {
    group = group,
    pattern = 'qf',
    callback = function()
        vim.opt.winhighlight = 'NonText:Normal'
    end,
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
